//
//  JMSDetailViewController.m
//  CP130_HW6
//
//  Created by Jared Sorge on 5/11/14.
//  Copyright (c) 2014 jsorge. All rights reserved.
//

#import "JMSDetailViewController.h"

@interface JMSDetailViewController ()
@property (nonatomic, weak)IBOutlet UIImageView *downloadedImageView;
@end

@implementation JMSDetailViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.downloadedImageView.image = self.image;
}

@end
