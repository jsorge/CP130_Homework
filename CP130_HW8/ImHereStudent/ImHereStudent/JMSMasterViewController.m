//
//  JMSMasterViewController.m
//  ImHereStudent
//
//  Created by Jared Sorge on 5/27/14.
//  Copyright (c) 2014 net.jsorge. All rights reserved.
//

#import "JMSMasterViewController.h"
#import "JMSStudent.h"
#import "JMSImHeereManagedObjectContext.h"
#import "JMSAttendance.h"
#import "JMSProfileViewController.h"
#import "JMSDetailViewController.h"
#import "JMSBTCentral.h"

static NSString *const seg_showAttendance = @"seg_showAttendance";
static NSString *const seg_showProfile = @"seg_showProfile";
static NSString *const bt_attendanceService = @"BAD8";
static NSString *const bt_attendanceReadCharacteristic = @"BADA";

@interface JMSMasterViewController () <UITableViewDataSource, UITableViewDelegate, JMSProfileDelegate, JMSBTCentralDelegate>
@property (nonatomic, weak)IBOutlet UITableView *tableView;
@property (nonatomic, weak)IBOutlet UIBarButtonItem *checkInButton;
@property (nonatomic, strong)NSDateFormatter *dateFormatter;
@property (nonatomic, strong)NSMutableArray *classesAttended;
@property (nonatomic, strong)JMSBTCentral *bluetoothCentral;
@end

@implementation JMSMasterViewController
#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.title = self.student.name;
    
    if (self.student.canCheckIn) {
        [self.checkInButton setEnabled:YES];
    } else {
        [self.checkInButton setEnabled:NO];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:seg_showAttendance]) {
        NSAssert([sender isKindOfClass:[JMSAttendance class]], @"The sender for segue %@ must be an Attendance object", seg_showAttendance);
        
        JMSDetailViewController *dest = (JMSDetailViewController *)segue.destinationViewController;
        dest.attendanceRecord = sender;
    } else if ([segue.identifier isEqualToString:seg_showProfile]) {
        NSAssert([sender isKindOfClass:[JMSStudent class]], @"The sendor for segue %@ must be a Student object.", seg_showProfile);
        
        UINavigationController *nav = segue.destinationViewController;
        JMSProfileViewController *dest = (JMSProfileViewController *)nav.topViewController;
        dest.student = sender;
        dest.delegate = self;
    }
}

#pragma mark - Properties
- (NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    }
    return _dateFormatter;
}

- (NSMutableArray *)classesAttended
{
    if (!_classesAttended) {
        _classesAttended = [[self.student.attendedClasses allObjects] mutableCopy];
    }
    return _classesAttended;
}

- (JMSBTCentral *)bluetoothCentral
{
    if (!_bluetoothCentral) {
        _bluetoothCentral = [[JMSBTCentral alloc] initWithDelegate:self
                                                         serviceID:bt_attendanceService
                                                  characteristicID:bt_attendanceReadCharacteristic];
    }
    return _bluetoothCentral;
}

#pragma mark - IBActions
- (IBAction)addButtonTapped:(id)sender
{
    [self.bluetoothCentral startUpdating];
}

- (IBAction)profileButtonTapped:(id)sender
{
    [self performSegueWithIdentifier:seg_showProfile sender:self.student];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.classesAttended count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const cellId = @"attendedCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    JMSAttendance *attendance = self.classesAttended[indexPath.row];
    
    cell.textLabel.text = [self.dateFormatter stringFromDate:attendance.classDate];
    cell.detailTextLabel.text = attendance.confirmedString;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMSAttendance *selectedAttendance = self.classesAttended[indexPath.row];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:seg_showAttendance sender:selectedAttendance];
}

#pragma mark - JMSProfileDelegate
- (void)profileViewDismissed:(JMSProfileViewController *)profileVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - JMSBTCentralDelegate
- (void)jmsCentralDidDiscoverCharacteristic:(CBCharacteristic *)characteristic
{
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:bt_attendanceReadCharacteristic]] && self.student.canCheckIn) {
        [self.bluetoothCentral stopUpdating];
        
        JMSAttendance *newAttendance = [JMSAttendance newInstanceInManagedObjectContext:self.student.managedObjectContext];
        [self.student addAttendedClassesObject:newAttendance];
        
        NSError *saveError;
        if (![self.student.managedObjectContext save:&saveError]) {
            NSLog(@"Error saving: %@", saveError);
        } else {
            [self.classesAttended insertObject:newAttendance atIndex:0];
            [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.checkInButton setEnabled:NO];
        }
        
        self.bluetoothCentral = nil;
    }
}
@end
