//
//  JMSMasterTableViewController.h
//  CP130_HW3
//
//  Created by Jared Sorge on 4/25/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JMSModel;

@protocol JMSMasterDelegate;

@interface JMSMasterTableViewController : UITableViewController
@property (weak, nonatomic)id<JMSMasterDelegate>delegate;
@property (strong, nonatomic)NSMutableArray *objects;
@end

@protocol JMSMasterDelegate <NSObject>
- (void)master:(JMSMasterTableViewController *)master didSelectObject:(JMSModel *)model;
@end