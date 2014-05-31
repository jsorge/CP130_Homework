//
//  JMSAttendance.h
//  ImHereStudent
//
//  Created by Jared Sorge on 5/27/14.
//  Copyright (c) 2014 net.jsorge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMSManagedObject.h"

extern NSString *const JMSAttendanceClassDateKEY;
extern NSString *const JMSAttendanceConfirmedWithTeacherKEY;
extern NSString *const JMSAttendanceStudentKEY;

@class JMSStudent;

@interface JMSAttendance : JMSManagedObject

@property (nonatomic, retain) NSDate * classDate;
@property (nonatomic) BOOL confirmedWithTeacher;
@property (nonatomic, retain) JMSStudent *student;
@property (nonatomic, readonly)NSString *confirmedString;

@end