//
//  JMSCentralViewController.m
//  CP130_HW2_Bluetooth
//
//  Created by Jared Sorge on 4/20/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSCentralViewController.h"
#import "JMSBTCentral.h"
#import "JMSBluetoothStrings.h"

@interface JMSCentralViewController () <JMSBTCentralDelegate>
@property (strong, nonatomic)JMSBTCentral *central;
@end

@implementation JMSCentralViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Properties
- (JMSBTCentral *)central
{
    if (!_central) {
        _central = [[JMSBTCentral alloc] initWithDelegate:self
                                                serviceID:SERVICE_UUID
                                         characteristicID:CHARACTERISTIC_UUID];
    }
    return _central;
}
@end
