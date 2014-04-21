//
//  JMSPeripheralViewController.m
//  CP130_HW2_Bluetooth
//
//  Created by Jared Sorge on 4/20/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSPeripheralViewController.h"

@interface JMSPeripheralViewController ()
@property (weak, nonatomic) IBOutlet UIButton *broadcastButton;
@property (weak, nonatomic) IBOutlet UITextField *peripheralTextField;
@end

@implementation JMSPeripheralViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - IBActions
- (IBAction)broadcastButtonTapped:(id)sender
{
    
}

@end
