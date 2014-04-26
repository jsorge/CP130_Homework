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
@property (readwrite, nonatomic)BOOL scanning;

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
        self.delegate = delegate;
        [self startUpdating];
    }
    
    return self;
}

- (void)startUpdating
{
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (void)stopUpdating
{
    [self.manager stopScan];
    [self.manager cancelPeripheralConnection:self.peripheral];
    self.scanning = NO;
}

#pragma mark - Properties
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
    if (central.state == CBCentralManagerStatePoweredOn) {
        [self startCentralScan];
        self.scanning = YES;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    if (peripheral != self.peripheral) {
        self.peripheral = peripheral;
        [self.manager connectPeripheral:peripheral options:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    [self cleanup];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [self.manager stopScan];
    
    self.dataOutput = nil;
    
    peripheral.delegate = self;
    [peripheral discoverServices:@[[CBUUID UUIDWithString:self.serviceID]]];
    
    [self.delegate jmsCentralDidConnectToPeripheral:self];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    self.peripheral = nil;
    [self.delegate jmsCentralDidDisconnectPeripheral:self];
    [self startCentralScan];
}

#pragma mark - CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error) {
        NSLog(@"Error: %@", error);
        [self cleanup];
        return;
    }
    
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:self.characteristicID]]
                                 forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error) {
        NSLog(@"Erro: %@", error);
        [self cleanup];
        return;
    }
    
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:self.characteristicID]]) {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }
    
    NSString *receivedString = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    if ([receivedString isEqualToString:@"EOM"]) {
        [self.delegate jmsCentralDidUpdateDataOutput:self withString:receivedString];
        [peripheral setNotifyValue:NO forCharacteristic:characteristic];
        [self.manager cancelPeripheralConnection:peripheral];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (![characteristic isEqual:[CBUUID UUIDWithString:self.characteristicID]]) {
        return;
    }
    
    if (!characteristic.isNotifying) {
        [self.manager cancelPeripheralConnection:peripheral];
    }
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
}

- (void)startCentralScan
{
    [self.manager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:self.serviceID]]
                                         options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @YES}];
}
@end