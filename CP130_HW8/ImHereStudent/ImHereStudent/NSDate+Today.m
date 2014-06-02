//
//  NSDate+Today.m
//  ImHereStudent
//
//  Created by Jared Sorge on 6/1/14.
//  Copyright (c) 2014 net.jsorge. All rights reserved.
//

#import "NSDate+Today.h"

@implementation NSDate (Today)
+ (NSDate *)today
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit
                                          fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    
    return today;
}
@end
