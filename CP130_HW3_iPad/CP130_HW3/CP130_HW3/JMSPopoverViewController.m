//
//  JMSPopoverViewController.m
//  CP130_HW3
//
//  Created by Jared Sorge on 4/25/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSPopoverViewController.h"

@implementation JMSPopoverViewController

#pragma mark - IBActions
- (IBAction)goAwayButtonTapped:(id)sender
{
    [self.delegate jmsPopoverDidDismiss:self];
}

@end
