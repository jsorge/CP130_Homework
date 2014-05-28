//
//  JMSInAppPurchaseManager.h
//  CP130_HW7
//
//  Created by Jared Sorge on 5/18/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <Foundation/Foundation.h>
@import StoreKit;

extern NSString *kInAppPurchaseProductsFetchedNotification;
extern NSString *thingIapBundleId;

@interface JMSInAppPurchaseManager : NSObject
@property (nonatomic, strong)SKProduct *thingUpgrade;
@property (nonatomic, strong)SKProductsRequest *productsRequest;

+ (instancetype)sharedManager;
- (void)makePurchaseRequest;
@end
