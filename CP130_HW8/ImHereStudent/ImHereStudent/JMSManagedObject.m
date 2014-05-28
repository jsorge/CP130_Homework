//
//  JMSManagedObject.m
//  GhostPost-iOS
//
//  Created by Jared Sorge on 3/25/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSManagedObject.h"

@implementation JMSManagedObject

#pragma mark - API
+ (instancetype)newInstanceInManagedObjectContext:(NSManagedObjectContext *)context;
{
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName]
                                              inManagedObjectContext:context];
}


+ (NSString *)entityName;
{
    return NSStringFromClass(self);
}

+ (NSFetchRequest *)fetchRequest;
{
    return [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
}

+ (NSArray *)allInstancesWithPredicate:(NSPredicate *)predicate inContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *request = [self fetchRequest];
    request.predicate = predicate;
    
    NSError *error;
    NSArray *result = [context executeFetchRequest:request
                                             error:&error];
    
    if (!result) {
        NSLog(@"ERROR loading fetch with predicate: %@, error: %@", predicate, error);
    }
    
    return result;
}

+ (NSArray *)allInstancesInContext:(NSManagedObjectContext *)context;
{
    return [self allInstancesWithPredicate:nil inContext:context];
}

@end
