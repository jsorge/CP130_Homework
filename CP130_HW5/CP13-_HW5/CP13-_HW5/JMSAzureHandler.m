//
//  JMSAzureHandler.m
//  CP13-_HW5
//
//  Created by Jared Sorge on 4/30/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSAzureHandler.h"
#import "JMSModel.h"

NSString *kHomeworkTable = @"homework";
NSString *kStudentIdColumn = @"student";
NSString *kDataItemColumn = @"dataitem";
NSString *kLoadedDataNotification = @"allDataLoaded";
NSString *kSuccessfulInsertNotification = @"addedNewItem";
NSString *kSuccessfulDeletionNotification = @"deletedItem";
NSString *kInsertedRowIndex = @"insertedRowIndex";
NSString *kDeletedRowIndex = @"deletedRowIndex";
NSString *kDeletedAllRowsNotification = @"deletedAllRows";

static NSString *const kAzureIdColumn = @"id";
static NSString *const kApplicationUrlString = @"https://cp130-uw-test.azure-mobile.net/";
static NSString *const kApplicationKey = @"MiYEeTYZcZFRzRljRWKTXDmmhyxMZx21";

@interface JMSAzureHandler ()
@property (strong, nonatomic)MSTable *azureTable;
@end

@implementation JMSAzureHandler
#pragma mark - API
+ (instancetype)sharedAzureInstance
{
    static JMSAzureHandler *_sharedInstance = nil;
    static dispatch_once_t dispatchToken;
    dispatch_once(&dispatchToken, ^{
        _sharedInstance = [[JMSAzureHandler alloc] init];
        _sharedInstance.azureClient = [MSClient clientWithApplicationURLString:kApplicationUrlString
                                                                applicationKey:kApplicationKey];
        _sharedInstance.azureTable = [_sharedInstance.azureClient tableWithName:kHomeworkTable];
        _sharedInstance.loggingIn = NO;
    });
    
    return _sharedInstance;
}

- (void)loadAllItems
{
    [self.azureTable readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        self.allAzureObjects = [NSMutableArray array];
        for (NSDictionary *item in items) {
            JMSModel *newObject = [[JMSModel alloc] init];
            newObject.dataitem = item[kDataItemColumn];
            newObject.studentid = item[kStudentIdColumn];
            newObject.azureid = item[kAzureIdColumn];
            
            [self.allAzureObjects insertObject:newObject atIndex:0];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kLoadedDataNotification
                                                            object:self
                                                          userInfo:nil];
    }];
}

- (void)deleteAzureObject:(JMSModel *)object
{
    NSInteger row = [self.allAzureObjects indexOfObject:object];
    [self.azureTable deleteWithId:object.azureid
                       completion:^(id itemId, NSError *error) {
                           [self.allAzureObjects removeObjectAtIndex:row];
                           [[NSNotificationCenter defaultCenter] postNotificationName:kSuccessfulDeletionNotification
                                                                               object:self
                                                                             userInfo:@{kDeletedRowIndex: @(row)}];
                       }];
}

- (void)insertObject:(JMSModel *)detailitem atIndex:(NSUInteger)index
{
    NSDictionary *toInsert = @{
                               kDataItemColumn: detailitem.dataitem,
                               kStudentIdColumn: detailitem.studentid
                               };
    [self.azureTable insert:toInsert
                 completion:^(NSDictionary *item, NSError *error) {
                     if (error) {
                         NSLog(@"Error inserting: %@", error);
                         return;
                     }
                     detailitem.azureid = item[kAzureIdColumn];
                     NSInteger insertedIndex = 0;
                     [self.allAzureObjects insertObject:detailitem atIndex:insertedIndex];
                     [[NSNotificationCenter defaultCenter] postNotificationName:kSuccessfulInsertNotification
                                                                         object:self
                                                                       userInfo:@{kInsertedRowIndex: @(insertedIndex)}];
                 }];
}

- (void)logout
{
    [self.azureClient logout];
    [self.allAzureObjects removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:kDeletedAllRowsNotification
                                                        object:self];
    self.loggedIn = NO;
}

- (void)filterObjectsByStudentId:(NSString *)studentId
{
    if (studentId == nil) {
        self.studentid = nil;
        [self loadAllItems];
    }
    
    self.studentid = studentId;
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"studentid = %@", studentId];
    NSArray *filteredArray = [self.allAzureObjects filteredArrayUsingPredicate:filterPredicate];
    
    self.allAzureObjects = [filteredArray mutableCopy];
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoadedDataNotification
                                                        object:self];
}

@end