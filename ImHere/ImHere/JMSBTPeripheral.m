//
//  JMSBTPeripheral.m
//  ImHere
//
//  Created by Jared Sorge on 4/13/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSBTPeripheral.h"
#import <CoreBluetooth/CoreBluetooth.h>

NSString *const SERVICE_ID = @"EDE5EEFE-7D30-4695-B067-4A23FC8CD02F";
NSString *const CHARACTERISTIC_ID = @"5B7D56E3-89D6-442C-A4FC-EB30D5FFE15F";

@interface JMSBTPeripheral () <CBPeripheralManagerDelegate>
@property (weak, nonatomic)id<JMSBTPeripheralDelegate>delegate;
@property (strong, nonatomic)CBPeripheralManager *peripheralManager;
@property (strong, nonatomic)CBMutableCharacteristic *transferCharacteristic;
@property (strong, nonatomic)CBMutableService *service;
@end

@implementation JMSBTPeripheral
#pragma mark - API
- (instancetype)initWithDelegate:(id<JMSBTPeripheralDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
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
    CBUUID *characteristicID = [CBUUID UUIDWithString:CHARACTERISTIC_ID];
    self.transferCharacteristic = [[CBMutableCharacteristic alloc] initWithType:characteristicID
                                                                     properties:CBCharacteristicPropertyNotify
                                                                          value:nil
                                                                    permissions:CBAttributePermissionsReadable];
    
    CBUUID *serviceID = [CBUUID UUIDWithString:SERVICE_ID];
    self.service = [[CBMutableService alloc] initWithType:serviceID primary:YES];
    
    [self.service setCharacteristics:@[self.transferCharacteristic]];
    [self.peripheralManager addService:self.service];
}
@end