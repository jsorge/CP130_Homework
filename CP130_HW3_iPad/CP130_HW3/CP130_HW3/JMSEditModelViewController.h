//
//  JMSEditModelViewController.h
//  CP130_HW3
//
//  Created by Jared Sorge on 4/25/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JMSModel;

@protocol JMSEditModelDelegate;

@interface JMSEditModelViewController : UIViewController
@property (weak, nonatomic)id<JMSEditModelDelegate>delegate;
@property (strong, nonatomic)JMSModel *model;
@end

@protocol JMSEditModelDelegate <NSObject>
- (void)modelDidFinishEditing:(JMSModel *)model;
@end