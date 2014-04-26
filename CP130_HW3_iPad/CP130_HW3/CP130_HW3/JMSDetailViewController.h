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
@protocol JMSDetailDelegate;

@interface JMSDetailViewController : UIViewController <UISplitViewControllerDelegate, JMSMasterDelegate>
@property (strong, nonatomic)JMSModel *modelObject;
@property (weak, nonatomic)id<JMSDetailDelegate>delegate;
@end

@protocol JMSDetailDelegate <NSObject>
- (void)detail:(JMSDetailViewController *)detail didUpdateModelObject:(JMSModel *)model;
@end