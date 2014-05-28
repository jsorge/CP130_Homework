//
//  JMSManagedObject.h
//  GhostPost-iOS
//
//  Created by Jared Sorge on 3/25/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface JMSManagedObject : NSManagedObject

#pragma mark - API
+ (instancetype)newInstanceInManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSString *)entityName;
+ (NSFetchRequest *)fetchRequest;
+ (NSArray *)allInstancesWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;
+ (NSArray *)allInstancesInContext:(NSManagedObjectContext *)context;

@end
