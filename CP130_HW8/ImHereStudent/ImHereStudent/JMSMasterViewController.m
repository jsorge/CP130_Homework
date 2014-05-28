//
//  JMSMasterViewController.m
//  ImHereStudent
//
//  Created by Jared Sorge on 5/27/14.
//  Copyright (c) 2014 net.jsorge. All rights reserved.
//

#import "JMSMasterViewController.h"
#import "JMSStudent.h"
#import "JMSImHeereManagedObjectContext.h"

@import CoreData;

@interface JMSMasterViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak)IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong)JMSImHeereManagedObjectContext *managedObjectContext;
@end

@implementation JMSMasterViewController
#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

#pragma mark - Properties
- (NSFetchedResultsController *)fetchedResultsController
{
    if (!_fetchedResultsController) {
        NSFetchRequest *allObjectsFech = [JMSStudent fetchRequest];
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:allObjectsFech
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
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

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.fetchedResultsController fetchedObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"attendedCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
