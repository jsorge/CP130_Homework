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
@property (readonly, nonatomic)BOOL broadcasting;
@property (readonly, nonatomic)NSString *serviceID;
@property (readonly, nonatomic)NSString *characteristicID;
@property (weak, nonatomic)id<JMSBTPeripheralDelegate>delegate;
@property (strong, nonatomic)NSData *dataToSend;

- (instancetype)initWithDelegate:(id<JMSBTPeripheralDelegate>)delegate serviceID:(NSString *)serviceID characteristicID:(NSString *)characteristicID;
- (void)broadcastData:(NSString *)data;
- (void)startBroadcasting;
- (void)stopBroadcasting;
@end

@protocol JMSBTPeripheralDelegate <NSObject>

@end