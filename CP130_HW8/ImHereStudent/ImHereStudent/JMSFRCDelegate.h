//
//  JMSFRCDelegate.h
//  ImHereStudent
//
//  Created by Jared Sorge on 5/29/14.
//  Copyright (c) 2014 net.jsorge. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;

@interface JMSFRCDelegate : NSObject <NSFetchedResultsControllerDelegate>
#pragma mark - API

/**
 *  The designated initializer. Do not call init.
 *
 *  @param tableView The table view hooked up to the fetched results controller.
 *
 *  @return An instance of this class, ready to take delegate calls.
 */
- (instancetype)initWithTableView:(UITableView *)tableView;
@end
