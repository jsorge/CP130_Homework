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
@property (readwrite, nonatomic)NSString *serviceID;
@property (readwrite, nonatomic)NSString *characteristicID;

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
        self.serviceID = serviceID;
        self.characteristicID = characteristicID;
    }
    return self;
}

- (void)broadcastData:(NSString *)data
{
    if (self.broadcasting) {
        NSData *broadcastData = [data dataUsingEncoding:NSStringEncodingConversionExternalRepresentation];
        [self.peripheralManager updateValue:broadcastData
                          forCharacteristic:self.transferCharacteristic
                       onSubscribedCentrals:nil];
    }
}

- (void)startBroadcasting
{
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}

- (void)stopBroadcasting
{
    NSLog(@"Stopping broadcast.");
    [self.peripheralManager stopAdvertising];
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
    
    NSLog(@"Starting to broadcast.");
    CBUUID *type = [CBUUID UUIDWithString:self.characteristicID];
    self.transferCharacteristic = [[CBMutableCharacteristic alloc] initWithType:type
                                                                     properties:CBCharacteristicPropertyNotify
                                                                          value:nil
                                                                    permissions:CBAttributePermissionsReadable];
    CBMutableService *transferService = [[CBMutableService alloc] initWithType:type
                                                                       primary:YES];
    [self.peripheralManager addService:transferService];
    [self.peripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey: @[[CBUUID UUIDWithString:self.serviceID]]}];
    self.broadcasting = YES;
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
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
        didSend = [self.peripheralManager updateValue:chunk forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
        
        if (!didSend) {
            return;
        }
        
        NSString *stringFromData = [[NSString alloc] initWithData:chunk encoding:NSUTF8StringEncoding];
        NSLog(@"Sent: %@", stringFromData);
        
        self.sendDataIndex += amountToSend;
        
        if (self.sendDataIndex >= self.dataToSend.length) {
            sendingEndOfMessage = YES;
            
            BOOL eomSent = [self.peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding]
                                             forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
            
            if (eomSent) {
                sendingEndOfMessage = NO;
                NSLog(@"Sent: EOM");
            }
            return;
        }
    }
}

@end