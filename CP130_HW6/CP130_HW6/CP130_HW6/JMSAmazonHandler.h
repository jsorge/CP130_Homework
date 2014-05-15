//
//  JMSAmazonHandler.h
//  CP130_HW6
//
//  Created by Jared Sorge on 5/11/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSSimpleDB/AWSSimpleDB.h>
#import <AWSRuntime/AWSRuntime.h>
#import <AWSS3/AWSS3.h>

@class JMSModel;
@protocol JMSAmazonDelegate;

@interface JMSAmazonHandler : NSObject
@property (nonatomic, readonly)AmazonS3Client *s3Client;
@property (nonatomic, readonly)AmazonSimpleDBClient *simpleDBClient;
@property (nonatomic, weak)id<JMSAmazonDelegate>delegate;
@property (nonatomic, readonly)id response;

+ (instancetype)sharedHandler;
- (void)putObject:(NSData *)object InS3Bucket:(NSString *)bucketName WithFilename:(NSString *)filename;
- (NSMutableArray *)allObjectsInHomeworkTable;
- (NSArray *)allObjectsInBucket:(NSString *)bucketname;
- (NSURL *)s3UrltForKey:(NSString *)key InBucket:(NSString *)bucket;
- (void)clearStatus;
- (void)insertRow:(JMSModel *)row inTable:(NSString *)table;
@end

@protocol JMSAmazonDelegate <NSObject>
- (void)amazonHandlerDidFinishUpload:(JMSAmazonHandler *)handler WithFilename:(NSString *)filename;
- (void)amazonHandler:(JMSAmazonHandler *)handler DatabaseInsertSucceeded:(JMSModel *)model;

@optional
- (void)amazonHandler:(JMSAmazonHandler *)handler DataBaseInsertFailedWithException:(NSException *)exception;
@end