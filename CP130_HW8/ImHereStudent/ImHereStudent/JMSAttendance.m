//
//  JMSAttendance.m
//  ImHereStudent
//
//  Created by Jared Sorge on 5/27/14.
//  Copyright (c) 2014 net.jsorge. All rights reserved.
//

#import "JMSAttendance.h"
#import "JMSStudent.h"

NSString *const JMSAttendanceNameKEY = @"name";
NSString *const JMSAttendanceIdKEY = @"id";
NSString *const JMSAttendancePictureKEY = @"picture";
NSString *const JMSAttendanceAttendedClassesKEY = @"attendedClasses";

@implementation JMSAttendance

@dynamic classDate;
@dynamic confirmedWithTeacher;
@dynamic student;

@end
