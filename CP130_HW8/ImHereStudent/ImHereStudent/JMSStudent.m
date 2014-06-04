//
//  JMSStudent.m
//  ImHereStudent
//
//  Created by Jared Sorge on 5/27/14.
//  Copyright (c) 2014 net.jsorge. All rights reserved.
//

#import "JMSStudent.h"
#import "JMSAttendance.h"
#import "NSDate+Today.h"

NSString *const JMSStudentNameKEY = @"name";
NSString *const JMSStudentIdKEY = @"id";
NSString *const JMSStudentPictureKEY = @"picture";
NSString *const JMSStudentAttendedClassesKEY = @"attendedClasses";

@implementation JMSStudent

@dynamic name;
@dynamic id;
@dynamic picture;
@dynamic attendedClasses;

#pragma mark - Properties
- (BOOL)canCheckIn
{
    NSDate *today = [NSDate today];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@ AND %K = %@", JMSAttendanceStudentKEY, self, JMSAttendanceClassDateKEY, today];
    NSArray *checkedInToday = [JMSAttendance allInstancesWithPredicate:predicate inContext:self.managedObjectContext];
    
    if (checkedInToday.count == 0) {
        return YES;
    }
    
    return NO;
}

#pragma mark - API
- (NSString *)emailDescription
{
    NSString *emailText;
    
    emailText = [NSString stringWithFormat:@"%@ (ID - %@)<p>", self.name, self.id];
    
    NSArray *classesAttended = self.attendedClasses.allObjects;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    for (JMSAttendance *class in classesAttended) {
        emailText = [emailText stringByAppendingString:[NSString stringWithFormat:@"%@<br />", [dateFormatter stringFromDate:class.classDate]]];
    }
    
    return emailText;
}

@end
