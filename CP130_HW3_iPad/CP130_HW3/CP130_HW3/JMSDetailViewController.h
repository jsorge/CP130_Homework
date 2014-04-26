//
//  JMSDetailViewController.h
//  CP130_HW3
//
//  Created by Jared Sorge on 4/25/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMSMasterTableViewController.h"
@class JMSModel;

@interface JMSDetailViewController : UIViewController <UISplitViewControllerDelegate, JMSMasterDelegate>
@property (strong, nonatomic)JMSModel *modelObject;
@end