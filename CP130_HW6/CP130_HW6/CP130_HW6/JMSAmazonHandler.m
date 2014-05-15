//
//  JMSAmazonHandler.m
//  CP130_HW6
//
//  Created by Jared Sorge on 5/11/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSAmazonHandler.h"
#import "JMSModel.h"

@interface JMSAmazonHandler () <AmazonServiceRequestDelegate>
@property (nonatomic, readwrite)AmazonS3Client *s3Client;
@property (nonatomic, readwrite)AmazonSimpleDBClient *simpleDBClient;
@property (nonatomic, readwrite)id response;
@property (nonatomic, strong)NSString *uploadedFilename;
@end

static NSString *accessKey = @"AKIAJSSOLT3RALF6JNDQ";
static NSString *secretKey = @"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";

@implementation JMSAmazonHandler
+ (instancetype)sharedHandler
{
    static JMSAmazonHandler *_sharedInstance = nil;
    static dispatch_once_t dispatchToken;
    dispatch_once(&dispatchToken, ^{
        _sharedInstance = [[JMSAmazonHandler alloc] initAWSWithAccessKey:accessKey SecretKey:secretKey];
    });
    return _sharedInstance;
}

- (instancetype)initAWSWithAccessKey:(NSString *)accessKey SecretKey:(NSString *)secretKey;
{
    self = [super init];
    if (self) {
        self.s3Client = [[AmazonS3Client alloc] initWithAccessKey:accessKey withSecretKey:secretKey];
        self.s3Client.endpoint = [AmazonEndpoints s3Endpoint:US_WEST_2];
        
        self.simpleDBClient = [[AmazonSimpleDBClient alloc] initWithAccessKey:accessKey withSecretKey:secretKey];
        self.simpleDBClient.endpoint = [AmazonEndpoints sdbEndpoint:US_WEST_2];
        
    }
    return self;
}

- (void)putObject:(NSData *)object InS3Bucket:(NSString *)bucketName WithFilename:(NSString *)filename
{
    self.uploadedFilename = filename;
    
    S3PutObjectRequest *putObject = [[S3PutObjectRequest alloc] initWithKey:filename inBucket:bucketName];
    putObject.contentType = [self contentTypeForFilename:filename];
    putObject.data = object;
    putObject.delegate = self;
    
    [self.s3Client putObject:putObject];
}

- (NSMutableArray *)allObjectsInHomeworkTable
{
    NSString *searchString = @"SELECT student, dataitem FROM homework";
    SimpleDBSelectRequest *selectRequest = [[SimpleDBSelectRequest alloc] initWithSelectExpression:searchString];
    SimpleDBSelectResponse *response = [self.simpleDBClient select:selectRequest];
    
    NSMutableArray *allItems = [NSMutableArray array];
    for (SimpleDBItem *row in response.items) {
        NSArray *rowAttributes = row.attributes;
        SimpleDBAttribute *dataAttribute = rowAttributes[0];
        SimpleDBAttribute *studentAttribute = rowAttributes[1];
        
        JMSModel *object = [[JMSModel alloc] init];
        object.dataitem = dataAttribute.value;
        object.student = studentAttribute.value;
        
        [allItems insertObject:object atIndex:0];
    }
    
    return allItems;
}

- (NSArray *)allObjectsInBucket:(NSString *)bucketname
{
    NSArray *bucketObjects = [self.s3Client listObjectsInBucket:bucketname];
    
    return bucketObjects;
}

- (NSURL *)s3UrltForKey:(NSString *)key InBucket:(NSString *)bucket
{
    S3GetPreSignedURLRequest *urlRequest = [[S3GetPreSignedURLRequest alloc] init];
    urlRequest.key = key;
    urlRequest.bucket = bucket;
    urlRequest.expires = [NSDate dateWithTimeIntervalSinceNow:(NSTimeInterval) 3600];
    
    NSError *error;
    NSURL *url = [self.s3Client getPreSignedURL:urlRequest error:&error];
    
    if (error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSLog(@"Error getting image url: %@", error);
        }];
        return nil;
    }
    
    return url;
}

- (void)clearStatus
{
    self.response = nil;
    self.uploadedFilename = nil;
}

- (void)insertRow:(JMSModel *)row inTable:(NSString *)table
{
    SimpleDBReplaceableAttribute *dataitem = [[SimpleDBReplaceableAttribute alloc] initWithName:@"dataitem" andValue:row.dataitem andReplace:NO];
    SimpleDBReplaceableAttribute *student = [[SimpleDBReplaceableAttribute alloc] initWithName:@"student" andValue:row.student andReplace:NO];
    NSMutableArray *attributes = [@[dataitem, student] mutableCopy];
    
    SimpleDBPutAttributesRequest *putAttributesRequest = [[SimpleDBPutAttributesRequest alloc] initWithDomainName:table andItemName:row.dataitem andAttributes:attributes];
    SimpleDBPutAttributesResponse *putResponse = [self.simpleDBClient putAttributes:putAttributesRequest];
    
    if (putResponse.exception == nil) {
        [self.delegate amazonHandler:self DatabaseInsertSucceeded:row];
    } else {
        [self.delegate amazonHandler:self DataBaseInsertFailedWithException:putResponse.exception];
    }
}

#pragma mark - AmazonServicesRequestDelegate
-(void)request:(AmazonServiceRequest *)request didCompleteWithResponse:(AmazonServiceResponse *)response
{
    self.response = response;
    [self.delegate amazonHandlerDidFinishUpload:self WithFilename:self.uploadedFilename];
}

#pragma mark - Private
- (NSString *)contentTypeForFilename:(NSString *)filename
{
    NSString *type;
    NSArray *fileComponents = [filename componentsSeparatedByString:@"."];
    NSString *extenstion = [[fileComponents lastObject] lowercaseString];
    
    if ([extenstion isEqualToString:@"jpg"] || [extenstion isEqualToString:@"jpeg"]) {
        type = @"jpeg";
    } else if ([extenstion isEqualToString:@"png"]) {
        type = @"png";
    }
    
    NSString *contentType = [NSString stringWithFormat:@"image/%@", type];
    
    return contentType;
}

@end