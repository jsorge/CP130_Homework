//
//  JMSProfileViewController.m
//  ImHereStudent
//
//  Created by Jared Sorge on 5/29/14.
//  Copyright (c) 2014 net.jsorge. All rights reserved.
//

#import "JMSProfileViewController.h"

@interface JMSProfileViewController () <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
@property (nonatomic, weak)IBOutlet UITextField *nameField;
@property (nonatomic, weak)IBOutlet UITextField *studentIDField;
@property (nonatomic, weak)IBOutlet UIImageView *avatarImageView;
@property (nonatomic, weak)IBOutlet UIScrollView *scrollview;
@property (nonatomic, weak)IBOutlet UILabel *noAvatarLabel;

@property (nonatomic, strong)UIToolbar *accessoryView;
@property (nonatomic, weak)UITextField *activeTextField;
@property (nonatomic)BOOL hasCamera;
@property (strong, nonatomic)UIImagePickerController *imagePicker;
@property (strong, nonatomic)UIActionSheet *imagePickerSheet;
@end

@implementation JMSProfileViewController

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nameField.text = self.student.name;
    self.studentIDField.text = self.student.id;
    
    if (self.student.picture != nil) {
        [self updateNoAvatarLabelVisibility:NO];
        self.avatarImageView.image = [UIImage imageWithData:self.student.picture];
    } else {
        [self updateNoAvatarLabelVisibility:YES];
    }
    
    self.nameField.delegate = self;
    self.nameField.inputAccessoryView = self.accessoryView;
    self.studentIDField.delegate = self;
    self.studentIDField.inputAccessoryView = self.accessoryView;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Properties
- (UIToolbar *)accessoryView
{
    if (!_accessoryView) {
        _accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        _accessoryView.translucent = NO;
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(keyboardDoneButton)];
        UIBarButtonItem *previousButton = [[UIBarButtonItem alloc] initWithTitle:@"<"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(selectPreviousTextField)];
        UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@">"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(selectNextTextField)];
        UIBarButtonItem *flexiSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                    target:nil
                                                                                    action:nil];
        UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                    target:nil
                                                                                    action:nil];
        fixedSpace.width = 10;
        _accessoryView.items = @[fixedSpace, previousButton, fixedSpace, nextButton, flexiSpace, doneButton];
    }
    return _accessoryView;
}


- (UIImagePickerController *)imagePicker
{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    return _imagePicker;
}
- (UIActionSheet *)imagePickerSheet
{
    if (!_imagePickerSheet) {
        _imagePickerSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"Cancel"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"Take Photo", @"Use Existing", nil];
    }
    return _imagePickerSheet;
}

#pragma mark - IBActions
- (IBAction)doneButtonTapped:(id)sender
{
    self.student.name = self.nameField.text;
    self.student.id = self.studentIDField.text;
    
    if (self.avatarImageView.image != nil) {
        self.student.picture = UIImageJPEGRepresentation(self.avatarImageView.image, 1);
    }
    
    NSError *saveError;
    if (![self.student.managedObjectContext save:&saveError]) {
        NSLog(@"Failed to save: %@", saveError);
    }
    
    [self.delegate profileViewDismissed:self];
}

- (IBAction)cancelButtonTapped:(id)sender
{
    [self.delegate profileViewDismissed:self];
}

#pragma mark - Keyboard Notifications
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    self.scrollview.scrollEnabled = YES;
    
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    kbSize.height += self.accessoryView.bounds.size.height;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollview.contentInset = contentInsets;
    self.scrollview.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeTextField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, aRect.size.height - 60);
        [self.scrollview setContentOffset:scrollPoint animated:YES];
    }
    
    self.scrollview.scrollEnabled = NO;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollview.contentInset = contentInsets;
    self.scrollview.scrollIndicatorInsets = contentInsets;
}

#pragma  mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeTextField = nil;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickedImage = info[UIImagePickerControllerEditedImage];
    if (!pickedImage) {
        pickedImage = info[UIImagePickerControllerOriginalImage];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        self.avatarImageView.image = pickedImage;
        [self updateNoAvatarLabelVisibility:NO];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == self.imagePickerSheet) {
        if (buttonIndex == 0) {
            //Camera
            [self showImagePickerViewWithType:UIImagePickerControllerSourceTypeCamera];
        } else if (buttonIndex == 1) {
            //Photo Library
            [self showImagePickerViewWithType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
    }
}


#pragma mark - Private
- (void)keyboardDoneButton
{
    [self.activeTextField resignFirstResponder];
}

- (void)selectPreviousTextField
{
    if (self.activeTextField == self.nameField) {
        [self.studentIDField becomeFirstResponder];
    } else if (self.activeTextField == self.studentIDField) {
        [self.nameField becomeFirstResponder];
    }
}

- (void)selectNextTextField
{
    if (self.activeTextField == self.nameField) {
        [self.studentIDField becomeFirstResponder];
    } else if (self.activeTextField == self.studentIDField) {
        [self.nameField becomeFirstResponder];
    }
}

- (void)addOrReplaceImage:(id)sender
{
    if (self.hasCamera) {
        [self.imagePickerSheet showInView:self.view];
    } else {
        [self showImagePickerViewWithType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

- (void)updateNoAvatarLabelVisibility:(BOOL)visible
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                               action:@selector(addOrReplaceImage:)];
    if (!visible) {
        self.noAvatarLabel.hidden = YES;
        
        [self.avatarImageView setUserInteractionEnabled:YES];
        [self.avatarImageView addGestureRecognizer:tapGesture];
        
        self.avatarImageView.hidden = NO;
        [self.noAvatarLabel setUserInteractionEnabled:NO];
        self.noAvatarLabel.hidden = YES;
    } else {
        [self.avatarImageView setGestureRecognizers:NO];
        self.avatarImageView.hidden = YES;
        self.noAvatarLabel.hidden = NO;
        
        [self.noAvatarLabel setUserInteractionEnabled:YES];
        [self.noAvatarLabel addGestureRecognizer:tapGesture];
    }
}

- (void)showImagePickerViewWithType:(UIImagePickerControllerSourceType)sourceType
{
    self.imagePicker.sourceType = sourceType;
    [self presentViewController:self.imagePicker animated:YES completion:nil];
}

@end
