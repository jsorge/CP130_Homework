//
//  JMSImHeereManagedObjectContext.m
//  ImHereStudent
//
//  Created by Jared Sorge on 5/27/14.
//  Copyright (c) 2014 net.jsorge. All rights reserved.
//

#import "JMSImHeereManagedObjectContext.h"
NSString *imHereModelName = @"ImHereModel";

@implementation JMSImHeereManagedObjectContext

+ (NSURL *)storeURL
{
    NSArray *locations = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = [locations firstObject];
    NSURL *storeLocation = [documentsDirectory URLByAppendingPathComponent:@"ImHere"];
    storeLocation = [storeLocation URLByAppendingPathExtension:@"sqlite"];
    
    return storeLocation;
}

@end
