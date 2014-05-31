//
//  JMSManagedObjectContext.m
//  GhostPost-iOS
//
//  Created by Jared Sorge on 3/25/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSManagedObjectContext.h"

NSString *const ContextNeedsUIUpdateNotification = @"contextNeedsUIUpdate";

@implementation JMSManagedObjectContext
#pragma mark - API
+ (instancetype)createContextWithStoreURL:(NSURL *)storeURL ubiquityStoreName:(NSString *)ubiquityStoreName modelName:(NSString *)modelName
{
    NSMutableArray *models = [NSMutableArray array];
    NSManagedObjectModel *firstModel = [self loadManagedObjectModelNamed:modelName];
    [models addObject:firstModel];
    
    NSManagedObjectModel *finalModel = [NSManagedObjectModel modelByMergingModels:models];
    NSAssert(finalModel != nil, @"Could not laod MOM");
    
    NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc ]initWithManagedObjectModel:finalModel];
    NSError *error;
    NSString *storeType = NSSQLiteStoreType;
    NSDictionary *options = (ubiquityStoreName.length > 0) ? @{NSPersistentStoreUbiquitousContentNameKey:ubiquityStoreName} : nil;
    
    if (![coordinator addPersistentStoreWithType:storeType
                                   configuration:nil
                                             URL:storeURL
                                         options:options
                                           error:&error]) {
        //TODO: Handle error better
        NSLog(@"Failed creating persistent store with error: %@", error);
        abort();
    }
    
    JMSManagedObjectContext *context = [[self alloc] initWithPersistentStoreCoordinator:coordinator];
    if (options[NSPersistentStoreUbiquitousContentNameKey] != nil) {
        [context registerForiCloudNotifications];
    }
    
    return context;
}

+ (BOOL)storeNeedsMigrationAtURL:(NSURL *)storeURL modelName:(NSString *)modelName;
{
    BOOL compatible = NO;
    NSError *error;
    
    NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:nil
                                                                                              URL:storeURL
                                                                                            error:&error];
    if (error) {
        //TODO: Handle error
        abort();
    } else if (sourceMetadata != nil) {
        NSManagedObjectModel *destinationModel = [self loadManagedObjectModelNamed:modelName];
        compatible = [destinationModel isConfiguration:nil
                           compatibleWithStoreMetadata:sourceMetadata];
    }
    
    return !compatible;
}

+ (NSURL *)storeURL
{
    [NSException raise:@"JMSException" format:@"This method must be overridden by a subclass."];
    return nil;
}

#pragma mark - Private
- (instancetype)initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator
{
    self = [super initWithConcurrencyType:NSMainQueueConcurrencyType];
    if (self) {
        self.persistentStoreCoordinator = coordinator;
    }
    return self;
}

+ (NSManagedObjectModel *)loadManagedObjectModelNamed:(NSString *)modelName
{
    NSURL *bundleURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:bundleURL];
}

#pragma mark - iCloud
- (void)registerForiCloudNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
	
    [notificationCenter addObserver:self
                           selector:@selector(storesWillChange:)
                               name:NSPersistentStoreCoordinatorStoresWillChangeNotification
                             object:self.persistentStoreCoordinator];
    
    [notificationCenter addObserver:self
                           selector:@selector(storesDidChange:)
                               name:NSPersistentStoreCoordinatorStoresDidChangeNotification
                             object:self.persistentStoreCoordinator];
    
    [notificationCenter addObserver:self
                           selector:@selector(persistentStoreDidImportUbiquitousContentChanges:)
                               name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                             object:self.persistentStoreCoordinator];
}

- (void)storesWillChange:(NSNotification *)notification
{
    [self performBlockAndWait:^{
        NSError *error;
        if ([self hasChanges]) {
            BOOL success = [self save:&error];
            if (!success && error) {
                // perform error handling
                NSLog(@"%@",[error localizedDescription]);
            }
        }
        [self reset];
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ContextNeedsUIUpdateNotification object:self];
}

- (void)storesDidChange:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ContextNeedsUIUpdateNotification object:self];
}

- (void)persistentStoreDidImportUbiquitousContentChanges:(NSNotification *)notification
{
    [self performBlock:^{
        [self mergeChangesFromContextDidSaveNotification:notification];
    }];
}

#pragma mark - Cleanup
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
