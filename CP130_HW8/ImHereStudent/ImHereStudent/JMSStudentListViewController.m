//
//  JMSStudentListViewController.m
//  ImHereStudent
//
//  Created by Jared Sorge on 5/29/14.
//  Copyright (c) 2014 net.jsorge. All rights reserved.
//

#import "JMSStudentListViewController.h"
#import "JMSStudent.h"
#import "JMSImHeereManagedObjectContext.h"
#import "JMSFRCDelegate.h"
#import "JMSProfileViewController.h"
#import "JMSMasterViewController.h"

@import CoreData;

static NSString *const seg_showAttendance = @"seg_studentAttendance";
static NSString *const seg_showProfile = @"seg_showProfile";

@interface JMSStudentListViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, JMSProfileDelegate>
@property (nonatomic, weak)IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong)JMSImHeereManagedObjectContext *managedObjectContext;
@property (nonatomic, strong)JMSFRCDelegate *frcDelegate;
@end

@implementation JMSStudentListViewController
#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.fetchedResultsController performFetch:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSAssert([sender isKindOfClass:[JMSStudent class]], @"The segue %@ must have a student sent in.", segue.identifier);
    
    if ([segue.identifier isEqualToString:seg_showAttendance]) {
        JMSMasterViewController *dest = (JMSMasterViewController *)segue.destinationViewController;
        dest.student = sender;
    } else if ([segue.identifier isEqualToString:seg_showProfile]) {
        UINavigationController *nav = segue.destinationViewController;
        JMSProfileViewController *dest = (JMSProfileViewController *)nav.topViewController;
        
        dest.student = sender;
        dest.delegate = self;
    }
}

#pragma mark - Properties
- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController) {
        NSFetchRequest *allObjectsFech = [JMSStudent fetchRequest];
        allObjectsFech.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:JMSStudentNameKEY ascending:YES]];
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:allObjectsFech
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
        _fetchedResultsController.delegate = self.frcDelegate;
    }
    return _fetchedResultsController;
}

- (JMSImHeereManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext) {
        _managedObjectContext = [JMSImHeereManagedObjectContext createContextWithStoreURL:[JMSImHeereManagedObjectContext storeURL]
                                                                        ubiquityStoreName:nil
                                                                            modelName:imHereModelName];
    }
    return _managedObjectContext;
}

- (JMSFRCDelegate *)frcDelegate
{
    if (!_frcDelegate) {
        _frcDelegate = [[JMSFRCDelegate alloc] initWithTableView:self.tableView];
    }
    return _frcDelegate;
}

#pragma mark - IBActions
- (IBAction)addButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:seg_showProfile sender:[JMSStudent newInstanceInManagedObjectContext:self.managedObjectContext]];

}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchedResultsController.fetchedObjects count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const cellId = @"studentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    JMSStudent *student = self.fetchedResultsController.fetchedObjects[indexPath.row];
    
    cell.textLabel.text = student.name;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMSStudent *selectedStudent = self.fetchedResultsController.fetchedObjects[indexPath.row];
    [self performSegueWithIdentifier:seg_showAttendance sender:selectedStudent];;
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - JMSProfileDelegate
- (void)profileViewDismissed:(JMSProfileViewController *)profileVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
