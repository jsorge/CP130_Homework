//
//  JMSBTCentral.h
//  CP130_HW2_Bluetooth
//
//  Created by Jared Sorge on 4/20/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreBluetooth;

@protocol JMSBTCentralDelegate;

@interface JMSBTCentral : NSObject
@property (weak, nonatomic)id<JMSBTCentralDelegate>delegate;
@property (readonly, nonatomic)BOOL scanning;

- (instancetype)initWithDelegate:(id<JMSBTCentralDelegate>)delegate serviceID:(NSString *)serviceID characteristicID:(NSString *)characteristicID;
- (void)startUpdating;
- (void)stopUpdating;
@end

@protocol JMSBTCentralDelegate <NSObject>
@optional
- (void)jmsCentralDidUpdateDataOutput:(JMSBTCentral *)central withString:(NSString *)outputString;
- (void)jmsCentralDidConnectToPeripheral:(JMSBTCentral *)central;
- (void)jmsCentralDidDisconnectPeripheral:(JMSBTCentral *)central;
- (void)jmsCentralDidDiscoverCharacteristic:(CBCharacteristic *)characteristic;
@end
