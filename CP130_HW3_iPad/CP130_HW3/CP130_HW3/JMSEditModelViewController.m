//
//  JMSEditModelViewController.m
//  CP130_HW3
//
//  Created by Jared Sorge on 4/25/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSEditModelViewController.h"
#import "JMSModel.h"

@interface JMSEditModelViewController ()
@property (weak, nonatomic)IBOutlet UITextField *titleTextField;
@property (weak, nonatomic)IBOutlet UITextField *subtitleTextField;
@end

@implementation JMSEditModelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.titleTextField.text = self.model.title;
    self.subtitleTextField.text = self.model.subtitle;
}

#pragma mark - IBActions
- (IBAction)doneButtonTapped:(id)sender
{
    self.model.title = self.titleTextField.text;
    self.model.subtitle = self.subtitleTextField.text;
    
    [self.delegate modelDidFinishEditing:self.model];
}
@end
