//
//  JMSBTPeripheral.h
//  ImHere
//
//  Created by Jared Sorge on 4/13/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JMSBTPeripheralDelegate;

extern NSString *const SERVICE_ID;
extern NSString *const CHARACTERISTIC_ID;

@interface JMSBTPeripheral : NSObject
- (instancetype)initWithDelegate:(id<JMSBTPeripheralDelegate>)delegate;
- (void)broadcastData:(NSString *)data;
@end

@protocol JMSBTPeripheralDelegate <NSObject>
@end