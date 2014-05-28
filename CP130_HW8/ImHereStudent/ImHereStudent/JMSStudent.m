//
//  JMSStudent.m
//  ImHereStudent
//
//  Created by Jared Sorge on 5/27/14.
//  Copyright (c) 2014 net.jsorge. All rights reserved.
//

#import "JMSStudent.h"
#import "JMSAttendance.h"

NSString *const JMSStudentNameKEY = @"name";
NSString *const JMSStudentIdKEY = @"id";
NSString *const JMSStudentPictureKEY = @"picture";
NSString *const JMSStudentAttendedClassesKEY = @"attendedClasses";

@implementation JMSStudent

@dynamic name;
@dynamic id;
@dynamic picture;
@dynamic attendedClasses;

@end
