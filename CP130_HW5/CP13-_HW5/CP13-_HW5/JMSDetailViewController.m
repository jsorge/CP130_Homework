//
//  JMSDetailViewController.m
//  CP13-_HW5
//
//  Created by Jared Sorge on 4/30/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSDetailViewController.h"
#import "JMSModel.h"
#import "JMSAzureHandler.h"

@interface JMSDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *studentIdLabel;
@end

@implementation JMSDetailViewController
#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self configureView];
}

#pragma mark - Properties
- (void)setDetailItem:(JMSModel *)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

#pragma mark - Private
- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = self.detailItem.dataitem;
        self.studentIdLabel.text = self.detailItem.studentid;
    }
}

#pragma mark - IBActions
- (IBAction)logoutButtonTapped:(id)sender
{
    [[JMSAzureHandler sharedAzureInstance] logout];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
