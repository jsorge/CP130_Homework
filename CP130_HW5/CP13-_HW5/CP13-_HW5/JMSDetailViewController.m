//
//  JMSDetailViewController.m
//  CP13-_HW5
//
//  Created by Jared Sorge on 4/30/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSDetailViewController.h"

@interface JMSDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end

@implementation JMSDetailViewController
#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

#pragma mark - Properties
- (void)setDetailItem:(id)newDetailItem
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
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

@end
