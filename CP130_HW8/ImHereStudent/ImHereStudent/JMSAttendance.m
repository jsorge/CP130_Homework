//
//  JMSAttendance.m
//  ImHereStudent
//
//  Created by Jared Sorge on 5/27/14.
//  Copyright (c) 2014 net.jsorge. All rights reserved.
//

#import "JMSAttendance.h"
#import "JMSStudent.h"
#import "NSDate+Today.h"

NSString *const JMSAttendanceClassDateKEY = @"classDate";
NSString *const JMSAttendanceConfirmedWithTeacherKEY = @"confirmedWithTeacher";
NSString *const JMSAttendanceStudentKEY = @"student";

@implementation JMSAttendance

@dynamic classDate;
@dynamic confirmedWithTeacher;
@dynamic student;

- (void)awakeFromInsert
{
    [super awakeFromInsert];
    
    self.confirmedWithTeacher = YES;
    self.classDate = [NSDate today];
}

- (NSString *)confirmedString
{
    NSString *status = self.confirmedWithTeacher ? @"Confirmed" : @"Not Confirmed";
    return status;
}

@end
