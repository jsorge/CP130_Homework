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
@property (weak, nonatomic) IBOutlet UILabel *connectionStatusLabel;

@property (weak, nonatomic)IBOutlet UIButton *startScanningButton;
@property (weak, nonatomic)IBOutlet UIButton *stopScanningButton;
@end

@implementation JMSCentralViewController
#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.central) {
        [self.central stopUpdating];
    }
}

#pragma mark - IBActions
- (IBAction)stopScanTapped:(id)sender
{
    [self.central stopUpdating];
    self.central = nil;
    [self updateStatusLabelToNotConnected];
    self.stopScanningButton.enabled = NO;
    self.startScanningButton.enabled = YES;
}

- (IBAction)startScanTapped:(id)sender
{
    self.central = [[JMSBTCentral alloc] initWithDelegate:self
                                                serviceID:SERVICE_UUID
                                         characteristicID:CHARACTERISTIC_UUID];
    
    [self.central startUpdating];
    self.stopScanningButton.enabled = YES;
    self.startScanningButton.enabled = NO;
}

#pragma mark - JMSBTCentralDelegate
- (void)jmsCentralDidUpdateDataOutput:(JMSBTCentral *)central withString:(NSString *)outputString
{
    self.receivedTextlabel.text = outputString;
}
- (void)jmsCentralDidConnectToPeripheral:(JMSBTCentral *)central
{
    self.connectionStatusLabel.text = @"Connected";
}

- (void)jmsCentralDidDisconnectPeripheral:(JMSBTCentral *)central
{
    [self updateStatusLabelToNotConnected];
}

#pragma mark - Private
- (void)updateStatusLabelToNotConnected
{
    self.connectionStatusLabel.text = @"Not Connected";
}
@end
