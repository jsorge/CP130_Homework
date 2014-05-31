//
//  JMSDetailViewController.m
//  ImHereStudent
//
//  Created by Jared Sorge on 5/27/14.
//  Copyright (c) 2014 net.jsorge. All rights reserved.
//

#import "JMSDetailViewController.h"
#import "JMSStudent.h"

@interface JMSDetailViewController ()
@property (nonatomic, weak)IBOutlet UILabel *studentNameLabel;
@property (nonatomic, weak)IBOutlet UILabel *classDateLabel;
@property (nonatomic, weak)IBOutlet UILabel *checkedInLabel;
@end

@implementation JMSDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterLongStyle;
    
    self.studentNameLabel.text = self.attendanceRecord.student.name;
    self.classDateLabel.text = [dateFormatter stringFromDate:self.attendanceRecord.classDate];
    self.checkedInLabel.text = self.attendanceRecord.confirmedString;
}

@end
