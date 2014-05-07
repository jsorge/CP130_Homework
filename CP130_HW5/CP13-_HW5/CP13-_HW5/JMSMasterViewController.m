//
//  JMSMasterViewController.m
//  CP13-_HW5
//
//  Created by Jared Sorge on 4/30/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSMasterViewController.h"
#import "JMSDetailViewController.h"
#import "JMSAzureHandler.h"
#import "JMSModel.h"

@interface JMSMasterViewController () <UITextFieldDelegate, UIAlertViewDelegate>
@property (nonatomic)JMSAzureHandler *azure;
@property (nonatomic, copy)NSString *studentIdToFilter;
@end

@implementation JMSMasterViewController
#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(reloadAllTableData:)
                               name:kLoadedDataNotification
                             object:self.azure];
    [notificationCenter addObserver:self
                           selector:@selector(reloadAllTableData:)
                               name:kSuccessfulInsertNotification
                             object:self.azure];
    [notificationCenter addObserver:self
                           selector:@selector(reloadAllTableData:)
                               name:kSuccessfulDeletionNotification
                             object:self.azure];
    [notificationCenter addObserver:self
                           selector:@selector(reloadAllTableData:)
                               name:kDeletedAllRowsNotification
                             object:self.azure];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    UIBarButtonItem *flexibleSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *filterButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(showFilterByStudentBox)];
    [self setToolbarItems:@[flexibleSpacer, filterButton]];
    [self.navigationController setToolbarHidden:NO animated:YES];

    [self updateTitle];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.azure.azureClient != nil && self.azure.loggedIn == NO && self.azure.loggingIn == NO) {
        self.azure.loggingIn = YES;
        [self.azure.azureClient loginWithProvider:@"google"
                                       controller:self
                                         animated:YES
                                       completion:^(MSUser *user, NSError *error) {
                                           [self loadAzureData];
                                           self.azure.loggedIn = YES;
                                           self.azure.loggingIn = NO;
                                       }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        JMSModel *object = self.azure.allAzureObjects[indexPath.row];
        JMSDetailViewController *destination = segue.destinationViewController;
        destination.detailItem = object;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Properties
- (JMSAzureHandler *)azure
{
    if (!_azure) {
        _azure = [JMSAzureHandler sharedAzureInstance];
    }
    return _azure;
}

#pragma mark - UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.azure.allAzureObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    JMSModel *model = self.azure.allAzureObjects[indexPath.row];
    cell.textLabel.text = model.dataitem;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.azure deleteAzureObject:self.azure.allAzureObjects[indexPath.row]];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        [self filterByStudentId:textField.text];
    }
}

#pragma mark - Private
- (void)insertNewObject:(id)sender
{
    if (self.studentIdToFilter == nil) {
        NSString *alertMessage = @"There needs to be a student ID specified by tapping the Filter button.";
        UIAlertView *noStudentAlert = [[UIAlertView alloc] initWithTitle:nil
                                                                 message:alertMessage
                                                                delegate:nil
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:@"Ok", nil];
        [noStudentAlert show];
        return;
    }
    
    JMSModel *newObject = [[JMSModel alloc] init];
    newObject.dataitem = [[NSDate date] description];
    newObject.studentid = self.studentIdToFilter;
    [self.azure insertObject:newObject atIndex:0];
}

- (void)loadAzureData;
{
    [self.azure loadAllItems];
}

- (void)reloadAllTableData:(NSNotification *)notification
{
    NSNumber *newRowIndex = notification.userInfo[kInsertedRowIndex];
    NSNumber *deletedRowIndex = notification.userInfo[kDeletedRowIndex];
    if (newRowIndex != nil) {
        NSInteger newRow = [newRowIndex intValue];
        NSIndexPath *newRowIndexPath = [NSIndexPath indexPathForRow:newRow inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[newRowIndexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if (deletedRowIndex != nil) {
        NSInteger deletedRow = [deletedRowIndex intValue];
        NSIndexPath *deletedRowIndexPath = [NSIndexPath indexPathForRow:deletedRow inSection:0];
        [self.tableView deleteRowsAtIndexPaths:@[deletedRowIndexPath]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
    } else {
        [self.tableView reloadData];
    }
}

- (void)showFilterByStudentBox
{
    UIAlertView *studentIdFilterAlert = [[UIAlertView alloc] initWithTitle:@"Enter Student ID"
                                                                   message:@"Enter the student ID to filter."
                                                                  delegate:self
                                                         cancelButtonTitle:@"Cancel"
                                                         otherButtonTitles:@"Ok", nil];
    studentIdFilterAlert.alertViewStyle = UIAlertViewStylePlainTextInput;
    studentIdFilterAlert.delegate = self;
    
    [studentIdFilterAlert show];
}

- (void)filterByStudentId:(NSString *)studentId
{
    self.studentIdToFilter = studentId.length == 0 ? nil : studentId;
    [self.azure filterObjectsByStudentId:self.studentIdToFilter];
    [self updateTitle];
}

- (void)updateTitle
{
    self.title = self.studentIdToFilter == nil ? @"All Students" : self.studentIdToFilter;
}

@end
