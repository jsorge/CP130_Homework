//
//  JMSDetailViewController.h
//  CP13-_HW5
//
//  Created by Jared Sorge on 4/30/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JMSModel;

@interface JMSDetailViewController : UIViewController
@property (strong, nonatomic) JMSModel *detailItem;
@end