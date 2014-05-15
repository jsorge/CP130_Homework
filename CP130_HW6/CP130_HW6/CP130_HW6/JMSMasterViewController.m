//
//  JMSMasterViewController.m
//  CP130_HW6
//
//  Created by Jared Sorge on 5/11/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSMasterViewController.h"
#import "JMSDetailViewController.h"
#import "JMSAmazonHandler.h"
#import "JMSModel.h"
#import "JMSFadeTransitionAnimator.h"

@import MobileCoreServices;

static NSString *bucketName = @"picture-class1";
static NSString *simpleDBTable = @"homework";
static NSString *seg_showDetail = @"showDetail";

@interface JMSMasterViewController () <JMSAmazonDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>
@property (nonatomic, strong)NSMutableArray *objects;
@property (nonatomic, strong)JMSAmazonHandler *amazonHandler;
@end

@implementation JMSMasterViewController
#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonTapped)];
    self.navigationItem.rightBarButtonItem = addButton;
    [self.amazonHandler allObjectsInBucket:bucketName];
    
    self.navigationController.delegate = self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIImage *)sender
{
    if ([segue.identifier isEqualToString:seg_showDetail]) {
        JMSDetailViewController *destination = segue.destinationViewController;
        destination.image = sender;
        destination.transitioningDelegate = self;
    }
}

#pragma mark - Properties
- (JMSAmazonHandler *)amazonHandler
{
    if (!_amazonHandler) {
        _amazonHandler = [JMSAmazonHandler sharedHandler];
        _amazonHandler.delegate = self;
    }
    return _amazonHandler;
}

- (NSMutableArray *)objects
{
    if (!_objects) {
        _objects = [self.amazonHandler allObjectsInHomeworkTable];
    }
    
    return _objects;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    JMSModel *model = (JMSModel *)self.objects[indexPath.row];
    cell.textLabel.text = model.dataitem;
    cell.detailTextLabel.text = model.student;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //TODO: Delete from Amazon, then when confirmed delete from the array.
        
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMSModel *selectedModel = self.objects[indexPath.row];
    NSString *imageKey = selectedModel.dataitem;
    NSURL *imageURL = [self.amazonHandler s3UrltForKey:imageKey InBucket:bucketName];
    
    UIImage *s3Image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    
    if (s3Image == nil) {
        UIAlertView *noImageAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                               message:@"The operation failed because no image could be loaded."
                                                              delegate:nil
                                                     cancelButtonTitle:@"Ok"
                                                     otherButtonTitles:nil];
        [noImageAlert show];
        return;
    }
    
    [self performSegueWithIdentifier:seg_showDetail sender:s3Image];
}

#pragma mark - JMSAmazonDelegate
- (void)amazonHandlerDidFinishUpload:(JMSAmazonHandler *)handler WithFilename:(NSString *)filename
{
    JMSModel *savedImage = [[JMSModel alloc] init];
    savedImage.dataitem = filename;
    savedImage.student = @"jsorge";
    
    [self.amazonHandler insertRow:savedImage inTable:simpleDBTable];
}

- (void)amazonHandler:(JMSAmazonHandler *)handler DatabaseInsertSucceeded:(JMSModel *)model
{
    [self.objects insertObject:model atIndex:0];
}

- (void)amazonHandler:(JMSAmazonHandler *)handler DataBaseInsertFailedWithException:(NSException *)exception
{
    UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                           message:exception.reason
                                                          delegate:nil
                                                 cancelButtonTitle:@"Ok"
                                                 otherButtonTitles:nil];
    [failureAlert show];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%@", info);
    [self dismissViewControllerAnimated:YES completion:^{
        NSURL *urlString = info[UIImagePickerControllerReferenceURL];
        NSString *query = [urlString query];
        NSArray *fileComponents = [query componentsSeparatedByString:@"&"];
        NSString *file = [[fileComponents[0] componentsSeparatedByString:@"="] lastObject];
        NSString *ext = [[[fileComponents[1] componentsSeparatedByString:@"="] lastObject] lowercaseString];
        NSString *filename = [NSString stringWithFormat:@"jsorge-%@.%@", file, ext];
        
        UIImage *pickedImage = info[UIImagePickerControllerOriginalImage];
        NSData *imageData;
        if ([ext isEqualToString:@"jpg"]) {
            imageData = UIImageJPEGRepresentation(pickedImage, 1.0);
        } else if ([ext isEqualToString:@"png"]) {
            imageData = UIImagePNGRepresentation(pickedImage);
        }
        
        [self.amazonHandler putObject:imageData
                           InS3Bucket:bucketName
                         WithFilename:filename];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [JMSFadeTransitionAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [JMSFadeTransitionAnimator new];
}

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    return [JMSFadeTransitionAnimator new];
}

#pragma mark - Private
- (void)addButtonTapped
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

@end
