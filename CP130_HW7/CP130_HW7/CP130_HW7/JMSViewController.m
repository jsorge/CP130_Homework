//
//  JMSViewController.m
//  CP130_HW7
//
//  Created by Jared Sorge on 5/18/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSViewController.h"
#import "JMSInAppPurchaseManager.h"
@import StoreKit;

@interface JMSViewController ()
@property (nonatomic, weak) IBOutlet UILabel *purchasedLabel;
@property (nonatomic, strong)JMSInAppPurchaseManager *iapManager;
@end

@implementation JMSViewController
#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updatePurchaseLabelWithPurchaseCount:[self currentThingPurchaseCount]];
    
    __weak __typeof__(self)weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:kInAppPurchaseProductsFetchedNotification
                                                      object:self.iapManager
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *note) {
                                                      __typeof__(self)strongSelf = weakSelf;
                                                      [strongSelf incrementPurchaseCount];
                                                  }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Properties
- (JMSInAppPurchaseManager *)iapManager
{
    if (!_iapManager) {
        _iapManager = [JMSInAppPurchaseManager sharedManager];
    }
    return _iapManager;
}

#pragma mark - IBActions
- (IBAction)buyButtonTapped:(id)sender
{
    [self.iapManager makePurchaseRequest];
}

#pragma mark - Private
- (NSInteger)currentThingPurchaseCount
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:thingIapBundleId];
}

- (void)incrementPurchaseCount
{
    NSInteger currentCount = [self currentThingPurchaseCount];
    currentCount += 1;
    [[NSUserDefaults standardUserDefaults] setInteger:currentCount forKey:thingIapBundleId];
    [self updatePurchaseLabelWithPurchaseCount:currentCount];
}

- (void)updatePurchaseLabelWithPurchaseCount:(NSInteger)purchaseCount
{
    NSString *times = purchaseCount == 1 ? @"time" : @"times";
    NSString *labelText = [NSString stringWithFormat:@"Purchased %ld %@.", (long)purchaseCount, times];
    
    self.purchasedLabel.text = labelText;
}

@end
