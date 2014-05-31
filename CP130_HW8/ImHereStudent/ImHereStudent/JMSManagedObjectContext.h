//
//  JMSManagedObjectContext.h
//  GhostPost-iOS
//
//  Created by Jared Sorge on 3/25/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <CoreData/CoreData.h>

extern NSString *const ContextNeedsUIUpdateNotification;

@interface JMSManagedObjectContext : NSManagedObjectContext

#pragma mark - API
/**
 *  Creates a new managed object context for use on the main queue, setup for iCloud sync if the ubiquityStoreName is present.
 *
 *  @param storeURL          The location on disk where the store is to be kept.
 *  @param ubiquityStoreName The name of the ubiquity store.
 *
 *  @return JMSManagedObjectContext
 */
+ (instancetype)createContextWithStoreURL:(NSURL *)storeURL ubiquityStoreName:(NSString *)ubiquityStoreName modelName:(NSString *)modelName;

/**
 *  Checks to see if the managed object model at the given URL matches what is in the app bundle's managed object model.
 *
 *  @param storeURL The location of the persistent store.
 *
 *  @return YES if migration needs to happen, NO if not.
 */
+ (BOOL)storeNeedsMigrationAtURL:(NSURL *)storeURL modelName:(NSString *)modelName;

/**
 *  This method must be overridden by a subclass. Do not call super.
 *
 *  @return The URL where the datastore is to be kept.
 */
+ (NSURL *)storeURL;
@end
