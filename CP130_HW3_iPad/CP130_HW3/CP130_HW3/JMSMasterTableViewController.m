//
//  JMSMasterTableViewController.m
//  CP130_HW3
//
//  Created by Jared Sorge on 4/25/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSMasterTableViewController.h"
#import "JMSModel.h"
#import "JMSDetailViewController.h"

@interface JMSMasterTableViewController ()

@end

@implementation JMSMasterTableViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.objects addObject:[JMSModel modelWithTitle:@"Thing 1" subtitle:@"Something"]];
    [self.objects addObject:[JMSModel modelWithTitle:@"Thing 2" subtitle:@"Some other thing"]];
    [self.objects addObject:[JMSModel modelWithTitle:@"Foo" subtitle:@"Bar"]];
    [self.objects addObject:[JMSModel modelWithTitle:@"Glorious model" subtitle:@"Wonderful!"]];
    
    [self.delegate master:self didSelectObject:self.objects[0]];
}

#pragma mark - Properties
- (NSMutableArray *)objects
{
    if (!_objects) {
        _objects = [NSMutableArray array];
    }
    return _objects;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    JMSModel *model = self.objects[indexPath.row];
    
    cell.textLabel.text = model.title;
    cell.detailTextLabel.text = model.subtitle;
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate master:self didSelectObject:self.objects[indexPath.row]];
}

@end
