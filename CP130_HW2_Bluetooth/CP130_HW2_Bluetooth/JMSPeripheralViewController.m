//
//  JMSPeripheralViewController.m
//  CP130_HW2_Bluetooth
//
//  Created by Jared Sorge on 4/20/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSPeripheralViewController.h"
#import "JMSBTPeripheral.h"
#import "JMSBluetoothStrings.h"

@interface JMSPeripheralViewController () <JMSBTPeripheralDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *peripheralTextField;
@property (weak, nonatomic)IBOutlet UIButton *startBroadcastButton;
@property (weak, nonatomic)IBOutlet UIButton *stopBroadcastButton;

@property (strong, nonatomic)JMSBTPeripheral *peripheral;
@end

@implementation JMSPeripheralViewController
#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.peripheralTextField.delegate = self;
}

#pragma mark - Properties
- (JMSBTPeripheral *)peripheral
{
    if (!_peripheral) {
        _peripheral = [[JMSBTPeripheral alloc] initWithDelegate:self
                                                      serviceID:SERVICE_UUID
                                               characteristicID:CHARACTERISTIC_UUID];
    }
    return _peripheral;
}
#pragma mark - IBActions
- (IBAction)startBroadcastTapped:(id)sender
{
    [self.peripheral startBroadcasting];
    self.stopBroadcastButton.enabled = YES;
    self.startBroadcastButton.enabled = NO;
}

- (IBAction)stopBroadcastTapped:(id)sender
{
    [self.peripheral startBroadcasting];
    self.stopBroadcastButton.enabled = NO;
    self.startBroadcastButton.enabled = YES;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.peripheral broadcastData:self.peripheralTextField.text];
    [textField resignFirstResponder];
    return YES;
}

@end
