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
@property (weak, nonatomic) IBOutlet UILabel *receivedTextlabel;
@property (weak, nonatomic) IBOutlet UIButton *scanButton;
@end

@implementation JMSCentralViewController
#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.central stopUpdating];
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

#pragma mark - IBActions
- (IBAction)scanButtonTapped:(id)sender
{
    if (self.central.scanning) {
        [self.central stopUpdating];
        self.scanButton.titleLabel.text = @"Stop Scan";
    } else {
        [self.central startUpdating];
        self.scanButton.titleLabel.text = @"Start Scan";
    }
}

#pragma mark - JMSBTCentralDelegate
- (void)jmsCentralDidUpdateDataOutput:(JMSBTCentral *)central
{
    self.receivedTextlabel.text = [[NSString alloc] initWithData:self.central.dataOutput encoding:NSUTF8StringEncoding];
}

@end
