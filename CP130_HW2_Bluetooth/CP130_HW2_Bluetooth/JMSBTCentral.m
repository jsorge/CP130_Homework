//
//  JMSBTCentral.m
//  CP130_HW2_Bluetooth
//
//  Created by Jared Sorge on 4/20/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSBTCentral.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface JMSBTCentral ()<CBCentralManagerDelegate, CBPeripheralDelegate>
@property (readwrite, nonatomic)NSString *serviceID;
@property (readwrite, nonatomic)NSString *characteristicID;
@property (readwrite, nonatomic)NSMutableData *dataOutput;

@property (strong, nonatomic)CBCentralManager *manager;
@property (strong, nonatomic)CBPeripheral *peripheral;
@end

@implementation JMSBTCentral
#pragma mark - API
- (instancetype)initWithDelegate:(id<JMSBTCentralDelegate>)delegate serviceID:(NSString *)serviceID characteristicID:(NSString *)characteristicID
{
    self = [super init];
    
    if (self) {
        self.serviceID = serviceID;
        self.characteristicID = characteristicID;
    }
    
    return self;
}

- (void)startUpdating
{
    if (!self.scanning) {
        [self.manager scanForPeripheralsWithServices:@[self.serviceID]
                                             options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @YES}];
        self.scanning = YES;
    }
}

- (void)stopUpdating
{
    if (self.scanning) {
        [self.manager stopScan];
        self.scanning = NO;
    }
}

#pragma mark - Properties
- (CBCentralManager *)manager
{
    if (!_manager) {
        _manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return _manager;
}

- (NSMutableData *)dataOutput
{
    if (!_dataOutput) {
        _dataOutput = [NSMutableData data];
    }
    return _dataOutput;
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            [self startUpdating];
            break;
            
        default:
            NSLog(@"Central manager didn't change state.");
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    [self.manager stopScan];
    
    if (self.peripheral != peripheral) {
        self.peripheral = peripheral;
        [self.manager connectPeripheral:peripheral options:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    self.dataOutput = nil;
    self.peripheral.delegate = self;
    [self.peripheral discoverServices:@[[CBUUID UUIDWithString:self.serviceID]]];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [self cleanup];
}

#pragma mark - CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering service.");
        [self cleanup];
        return;
    }
    
    CBUUID *selfServiceUUID = [CBUUID UUIDWithString:self.serviceID];
    CBUUID *selfCharacteristicID = [CBUUID UUIDWithString:self.characteristicID];
    for (CBService *service in peripheral.services) {
        NSLog(@"Periipheral with ID %@", service.UUID);
        
        if ([service.UUID isEqual:selfServiceUUID]) {
            [self.peripheral discoverCharacteristics:@[selfCharacteristicID] forService:service];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error changing state");
        [self cleanup];
        return;
    } else if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:self.characteristicID]]) {
        
    }
    
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on characteristic %@", characteristic);
        [peripheral readValueForCharacteristic:characteristic];
    } else {
        [self.manager cancelPeripheralConnection:self.peripheral];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Peripheral updated value error: %@", error);
        return;
    }
    
    [self.dataOutput appendData:characteristic.value];
    [self.delegate jmsCentralDidUpdateDataOutput:self];
}

#pragma mark - Private
 - (void)cleanup
{
    if (self.peripheral.services != nil) {
        for (CBService *service in self.peripheral.services) {
            if (service.peripheral != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if (characteristic.isNotifying) {
                        [self.peripheral setNotifyValue:NO forCharacteristic:characteristic];
                    }
                }
            }
        }
    }
    [self.manager cancelPeripheralConnection:self.peripheral];
}
@end