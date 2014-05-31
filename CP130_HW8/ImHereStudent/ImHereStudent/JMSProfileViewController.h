//
//  JMSProfileViewController.h
//  ImHereStudent
//
//  Created by Jared Sorge on 5/29/14.
//  Copyright (c) 2014 net.jsorge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMSStudent.h"

@protocol JMSProfileDelegate;

@interface JMSProfileViewController : UIViewController
@property (nonatomic, strong)JMSStudent *student;

@property (nonatomic, weak)id<JMSProfileDelegate>delegate;
@end

@protocol JMSProfileDelegate <NSObject>
- (void)profileViewDismissed:(JMSProfileViewController *)profileVC;
@end