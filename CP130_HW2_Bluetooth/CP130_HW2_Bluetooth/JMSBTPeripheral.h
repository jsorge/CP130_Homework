//
//  JMSBTPeripheral.h
//  ImHere
//
//  Created by Jared Sorge on 4/13/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JMSBTPeripheralDelegate;

@interface JMSBTPeripheral : NSObject
@property (strong, nonatomic)NSString *serviceID;
- (instancetype)initWithDelegate:(id<JMSBTPeripheralDelegate>)delegate serviceID:(NSString *)serviceID characteristicID:(NSString *)characteristicID;
- (void)broadcastData:(NSString *)data;
@end

@protocol JMSBTPeripheralDelegate <NSObject>
@end