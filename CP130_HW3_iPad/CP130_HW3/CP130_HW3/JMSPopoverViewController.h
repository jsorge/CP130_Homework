//
//  JMSPopoverViewController.h
//  CP130_HW3
//
//  Created by Jared Sorge on 4/25/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JMSPopoverDelegate;
@interface JMSPopoverViewController : UIViewController
@property (weak, nonatomic)id<JMSPopoverDelegate>delegate;
@end

@protocol JMSPopoverDelegate <NSObject>
- (void)jmsPopoverDidDismiss:(JMSPopoverViewController *)popover;
@end
