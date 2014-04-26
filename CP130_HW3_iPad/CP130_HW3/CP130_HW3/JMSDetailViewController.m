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
#import "JMSPopoverViewController.h"

@interface JMSDetailViewController () <JMSEditModelDelegate, JMSPopoverDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleTextLabel;
@property (strong, nonatomic)UIPopoverController *masterPopoverController;
@property (weak, nonatomic)UIPopoverController *topRightPopoverController;
@end

@implementation JMSDetailViewController

#pragma mark - View Lifecycle
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"seg_popover"]) {
        self.topRightPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
        JMSPopoverViewController *destination = (JMSPopoverViewController *)self.topRightPopoverController.contentViewController;
        destination.delegate = self;
    } else if ([segue.identifier isEqualToString:@"seg_modal"]) {
        JMSEditModelViewController *destination = segue.destinationViewController;
        destination.model = self.modelObject;
        destination.delegate = self;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"seg_popover"]) {
        if (self.topRightPopoverController) {
            [self.topRightPopoverController dismissPopoverAnimated:YES];
            return NO;
        } else {
            return YES;
        }
    }
    return YES;
}

- (void)viewDidLoad
{
    [self applyTextFields];
}

#pragma mark - JMSMasterDelegate
- (void)master:(JMSMasterTableViewController *)master didSelectObject:(id)model
{
    self.modelObject = model;
    
    [self applyTextFields];
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
    self.titleTextLabel.text = model.title;
    self.subtitleTextLabel.text = model.subtitle;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - JMSPopoverDelegate
- (void)jmsPopoverDidDismiss:(JMSPopoverViewController *)popover
{
    [self.topRightPopoverController dismissPopoverAnimated:YES];
}

#pragma mark - Private
- (void)applyTextFields
{
    self.titleTextLabel.text = self.modelObject.title;
    self.subtitleTextLabel.text = self.modelObject.subtitle;
}
@end
