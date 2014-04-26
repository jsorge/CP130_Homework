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
@property (readwrite, nonatomic)BOOL broadcasting;

@property (strong, nonatomic)CBUUID *serviceUUID;
@property (strong, nonatomic)CBUUID *characteristicUUID;

@property (strong, nonatomic)CBPeripheralManager *peripheralManager;
@property (strong, nonatomic)CBMutableCharacteristic *transferCharacteristic;
@property (strong, nonatomic)CBMutableService *service;
@property (nonatomic)NSInteger sendDataIndex;
@end

@implementation JMSBTPeripheral
#pragma mark - API
- (instancetype)initWithDelegate:(id<JMSBTPeripheralDelegate>)delegate serviceID:(NSString *)serviceID characteristicID:(NSString *)characteristicID
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.serviceUUID = [CBUUID UUIDWithString:serviceID];
        self.characteristicUUID = [CBUUID UUIDWithString:characteristicID];
    }
    return self;
}

- (void)broadcastData:(NSString *)data
{
    if (self.broadcasting) {
        self.dataToSend = [data dataUsingEncoding:NSStringEncodingConversionExternalRepresentation];
        self.sendDataIndex = 0;
        [self sendData];
    }
}

- (void)startBroadcasting
{
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    [self.peripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey: @[self.serviceUUID]}];
    self.broadcasting = YES;
    NSLog(@"Started broadcasting");
}

- (void)stopBroadcasting
{
    [self.peripheralManager stopAdvertising];
    [self.peripheralManager removeAllServices];
    self.peripheralManager = nil;
    self.broadcasting = NO;
}

#pragma mark - Properties
- (CBPeripheralManager *)peripheralManager
{
    if (!_peripheralManager) {
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    }
    return _peripheralManager;
}

#pragma mark - CBPeripheralManagerDelegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        return;
    }
    
    self.transferCharacteristic = [[CBMutableCharacteristic alloc] initWithType:self.characteristicUUID
                                                                     properties:CBCharacteristicPropertyNotify
                                                                          value:nil
                                                                    permissions:CBAttributePermissionsReadable];
    CBMutableService *transferService = [[CBMutableService alloc] initWithType:self.serviceUUID
                                                                       primary:YES];
    transferService.characteristics = @[self.transferCharacteristic];
    [self.peripheralManager addService:transferService];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    [self sendData];
}

- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral
{
    [self sendData];
}

#pragma mark - Private
- (void)sendData
{
    static BOOL sendingEndOfMessage = NO;
    
    if (sendingEndOfMessage) {
        BOOL didSend = [self.peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding]
                                         forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
        
        if (didSend) {
            sendingEndOfMessage = NO;
        }
        return;
    }
    
    if (self.sendDataIndex >= self.dataToSend.length) {
        return;
    }
    
    BOOL didSend = YES;
    
    while (didSend) {
        NSInteger amountToSend = self.dataToSend.length - self.sendDataIndex;
        amountToSend = amountToSend > 20 ? 20 : amountToSend;
        
        NSData *chunk = [NSData dataWithBytes:self.dataToSend.bytes+self.sendDataIndex length:amountToSend];
        didSend = [self.peripheralManager updateValue:chunk
                                    forCharacteristic:self.transferCharacteristic
                                 onSubscribedCentrals:nil];
        if (!didSend) {
            return;
        }
        
        NSString *stringFromData = [[NSString alloc] initWithData:chunk encoding:NSUTF8StringEncoding];
        NSLog(@"Sent: %@", stringFromData);
        
        self.sendDataIndex += amountToSend;
        
        if (self.sendDataIndex >= self.dataToSend.length || self.sendDataIndex == self.dataToSend.length) {
            sendingEndOfMessage = YES;
            
            BOOL endOfMessageSent = [self.peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding]
                                             forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
            
            if (endOfMessageSent) {
                sendingEndOfMessage = NO;
                NSLog(@"Sent: EOM");
            }
            return;
        }
    }
}

@end