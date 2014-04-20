//
//  JMSBTCentral.h
//  CP130_HW2_Bluetooth
//
//  Created by Jared Sorge on 4/20/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JMSBTCentralDelegate;

@interface JMSBTCentral : NSObject
@property (strong, nonatomic)NSString *serviceID;
@property (strong, nonatomic)NSString *characteristicID;

- (instancetype)initWithDelegate:(id<JMSBTCentralDelegate>)delegate serviceID:(NSString *)serviceID characteristicID:(NSString *)characteristicID;
@end

@protocol JMSBTCentralDelegate <NSObject>
@end
