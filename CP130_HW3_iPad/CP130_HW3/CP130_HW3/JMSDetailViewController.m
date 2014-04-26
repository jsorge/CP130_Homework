//
//  JMSDetailViewController.m
//  CP130_HW3
//
//  Created by Jared Sorge on 4/25/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSDetailViewController.h"
#import "JMSModel.h"

@interface JMSDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleTextLabel;
@property (strong, nonatomic)UIPopoverController *masterPopoverController;
@end

@implementation JMSDetailViewController


#pragma mark - JMSMasterDelegate
- (void)master:(JMSMasterTableViewController *)master didSelectObject:(id)model
{
    self.modelObject = model;
    
    self.titleTextLabel.text = self.modelObject.title;
    self.subtitleTextLabel.text = self.modelObject.subtitle;
}

#pragma mark - IBActions
- (IBAction)modalPopupButtonTapped:(id)sender
{
    
}

#pragma mark - UISplitViewControllerDelegate
- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc;
{
    barButtonItem.title = NSLocalizedString(@"List", @"List");
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    self.masterPopoverController = pc;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem;
{
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
