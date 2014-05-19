//
//  JMSInAppPurchaseManager.m
//  CP130_HW7
//
//  Created by Jared Sorge on 5/18/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSInAppPurchaseManager.h"

NSString *kInAppPurchaseProductsFetchedNotification = @"kInAppPurchaseManagerProductsFetchedNotification";

@implementation JMSInAppPurchaseManager
+ (instancetype)sharedManager
{
    static JMSInAppPurchaseManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [JMSInAppPurchaseManager new];
    });
    return _sharedManager;
}


@end
