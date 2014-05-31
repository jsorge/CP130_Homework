//
//  JMSDetailViewController.h
//  ImHereStudent
//
//  Created by Jared Sorge on 5/27/14.
//  Copyright (c) 2014 net.jsorge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMSAttendance.h"

@interface JMSDetailViewController : UIViewController
@property (nonatomic, strong)JMSAttendance *attendanceRecord;
@end
