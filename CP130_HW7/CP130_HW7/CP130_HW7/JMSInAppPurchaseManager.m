//
//  JMSInAppPurchaseManager.m
//  CP130_HW7
//
//  Created by Jared Sorge on 5/18/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSInAppPurchaseManager.h"

NSString *kInAppPurchaseProductsFetchedNotification = @"kInAppPurchaseManagerProductsFetchedNotification";
NSString *thingIapBundleId = @"net.jsorge.CP130_HW7.thing";

@interface JMSInAppPurchaseManager () <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@end

@implementation JMSInAppPurchaseManager
#pragma mark - API
+ (instancetype)sharedManager
{
    static JMSInAppPurchaseManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [JMSInAppPurchaseManager new];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedManager];
    });
    return _sharedManager;
}

- (void)makePurchaseRequest
{
    NSSet *productIdentifiers = [NSSet setWithObjects:thingIapBundleId, nil];
    self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    self.productsRequest.delegate = self;
    [self.productsRequest start];
}

#pragma mark - SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *products = response.products;
    self.thingUpgrade = [products firstObject];
    
    if (self.thingUpgrade == nil) {
        NSLog(@"Something went wrong retrieving the product.");
        return;
    }
    SKPayment *payment = [SKPayment paymentWithProduct:self.thingUpgrade];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        if (transaction.error != nil) {
            NSLog(@"Transaction error: %@", transaction.error);
            continue;
        }
        
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Purchasing");
                break;
            
            case SKPaymentTransactionStatePurchased:
                [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseProductsFetchedNotification
                                                                    object:self
                                                                  userInfo:nil];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                //handle failure
                NSLog(@"Purchase failed");
                break;
                
            case SKPaymentTransactionStateRestored:
                //handle restore
                NSLog(@"Purchase restored");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
        }
    };
}

#pragma mark - dealloc
- (void)dealloc
{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

@end
