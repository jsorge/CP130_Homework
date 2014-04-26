//
//  JMSDetailViewController.m
//  CP130_HW3
//
//  Created by Jared Sorge on 4/25/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSDetailViewController.h"
#import "JMSModel.h"
#import "JMSEditModelViewController.h"

@interface JMSDetailViewController () <JMSEditModelDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleTextLabel;
@property (strong, nonatomic)UIPopoverController *masterPopoverController;
@end

@implementation JMSDetailViewController

#pragma mark - View Lifecycle
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"seg_popover"]) {
        
    } else if ([segue.identifier isEqualToString:@"seg_modal"]) {
        JMSEditModelViewController *destination = segue.destinationViewController;
        destination.model = self.modelObject;
        destination.delegate = self;
    }
}

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
    [self performSegueWithIdentifier:@"seg_modal" sender:nil];
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

#pragma mark - JMSEditModelDelegate
- (void)modelDidFinishEditing:(JMSModel *)model
{
    self.modelObject = model;
    
    [self dismissViewControllerAnimated:YES completion:^{
        self.titleTextLabel.text = model.title;
        self.subtitleTextLabel.text = model.subtitle;
    }];
}

@end
