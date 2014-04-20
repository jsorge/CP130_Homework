//
//  JMSBTPeripheral.m
//  ImHere
//
//  Created by Jared Sorge on 4/13/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSBTPeripheral.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface JMSBTPeripheral () <CBPeripheralManagerDelegate>
@property (weak, nonatomic)id<JMSBTPeripheralDelegate>delegate;
@property (strong, nonatomic)CBPeripheralManager *peripheralManager;
@property (strong, nonatomic)CBMutableCharacteristic *transferCharacteristic;
@property (strong, nonatomic)CBMutableService *service;
@property (strong, nonatomic)NSString *characteristicID;
@end

@implementation JMSBTPeripheral
#pragma mark - API
- (instancetype)initWithDelegate:(id<JMSBTPeripheralDelegate>)delegate serviceID:(NSString *)serviceID characteristicID:(NSString *)characteristicID
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
        self.serviceID = serviceID;
        self.characteristicID = characteristicID;
    }
    return self;
}

- (void)broadcastData:(NSString *)data
{
    NSData *broadcastData = [data dataUsingEncoding:NSStringEncodingConversionExternalRepresentation];
    [self.peripheralManager updateValue:broadcastData
                      forCharacteristic:self.transferCharacteristic
                   onSubscribedCentrals:nil];
}

#pragma mark - CBPeripheralManagerDelegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    CBPeripheralManagerState state = peripheral.state;
    switch (state) {
        case CBPeripheralManagerStatePoweredOn:
            [self setupInitialService];
            break;
        default:
            NSLog(@"Peripheral manager did not power on");
            break;
    }
}

#pragma mark - Private
- (void)setupInitialService
{
    CBUUID *characteristicID = [CBUUID UUIDWithString:self.characteristicID];
    self.transferCharacteristic = [[CBMutableCharacteristic alloc] initWithType:characteristicID
                                                                     properties:CBCharacteristicPropertyNotify
                                                                          value:nil
                                                                    permissions:CBAttributePermissionsReadable];
    
    CBUUID *serviceID = [CBUUID UUIDWithString:self.serviceID];
    self.service = [[CBMutableService alloc] initWithType:serviceID primary:YES];
    
    [self.service setCharacteristics:@[self.transferCharacteristic]];
    [self.peripheralManager addService:self.service];
}
@end