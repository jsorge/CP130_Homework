//
//  JMSDetailViewController.h
//  CP130_HW6
//
//  Created by Jared Sorge on 5/11/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMSDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
