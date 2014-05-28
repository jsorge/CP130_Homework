//
//  JMSStudent.h
//  ImHereStudent
//
//  Created by Jared Sorge on 5/27/14.
//  Copyright (c) 2014 net.jsorge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMSManagedObject.h"

extern NSString *const JMSStudentNameKEY;
extern NSString *const JMSStudentIdKEY;
extern NSString *const JMSStudentPictureKEY;
extern NSString *const JMSStudentAttendedClassesKEY;

@class JMSAttendance;

@interface JMSStudent : JMSManagedObject
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSData * picture;
@property (nonatomic, retain) NSSet *attendedClasses;
@end

@interface JMSStudent (CoreDataGeneratedAccessors)

- (void)addAttendedClassesObject:(JMSAttendance *)value;
- (void)removeAttendedClassesObject:(JMSAttendance *)value;
- (void)addAttendedClasses:(NSSet *)values;
- (void)removeAttendedClasses:(NSSet *)values;

@end