//
//  JMSDetailViewController.m
//  CP130_HW6
//
//  Created by Jared Sorge on 5/11/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSDetailViewController.h"

@interface JMSDetailViewController ()
@property (nonatomic, weak)IBOutlet UIImageView *downloadedImageView;
@end

@implementation JMSDetailViewController
#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.downloadedImageView.image = self.image;
}

#pragma mark - IBActions
- (IBAction)doneButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
