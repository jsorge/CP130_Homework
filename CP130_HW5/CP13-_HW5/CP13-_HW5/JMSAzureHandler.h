//
//  JMSAzureHandler.h
//  CP13-_HW5
//
//  Created by Jared Sorge on 4/30/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
@class JMSModel;

extern NSString *kHomeworkTable;
extern NSString *kStudentIdColumn;
extern NSString *kDataItemColumn;
extern NSString *kLoadedDataNotification;
extern NSString *kSuccessfulInsertNotification;
extern NSString *kSuccessfulDeletionNotification;
extern NSString *kDeletedAllRowsNotification;
extern NSString *kInsertedRowIndex;
extern NSString *kDeletedRowIndex;

@interface JMSAzureHandler : NSObject
@property (strong, nonatomic)MSClient *azureClient;
@property (strong, nonatomic)NSString *studentid;
@property (strong, nonatomic)NSMutableArray *allAzureObjects;
@property (nonatomic)BOOL loggedIn;
@property (nonatomic)BOOL loggingIn;

+ (instancetype)sharedAzureInstance;
- (void)loadAllItems;
- (void)deleteAzureObject:(JMSModel *)object;
- (void)insertObject:(JMSModel *)detailitem atIndex:(NSUInteger)index;
- (void)logout;
- (void)filterObjectsByStudentId:(NSString *)studentId;
@end
