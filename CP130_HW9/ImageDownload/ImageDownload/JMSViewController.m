//
//  JMSViewController.m
//  ImageDownload
//
//  Created by Jared Sorge on 6/5/14.
//  Copyright (c) 2014 net.jsorge. All rights reserved.
//

#import "JMSViewController.h"

static NSString *const imageURLString = @"http://jsorge.s3.amazonaws.com/alfred/DSCN0361.JPG";

@interface JMSViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitySpinner;
@end

@implementation JMSViewController

#pragma mark - Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self stopSpinner];
}

#pragma mark - IBActions
- (IBAction)synchronousButtonTapped:(id)sender
{
    [self clearImageView];
    [self startSpinner];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[self urlFromImageURLString]];
    
    NSError *error;
    NSURLResponse *response;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];
    if (error) {
        NSLog(@"Something went wrong synchronously: %@", error);
        return;
    }
    
    UIImage *responseImage = [UIImage imageWithData:responseData];
    [self stopSpinner];
    self.imageView.image = responseImage;
}

- (IBAction)asynchronousButtonTapped:(id)sender
{
    [self clearImageView];
    [self startSpinner];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[self urlFromImageURLString]
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            if (error) {
                                                NSLog(@"Something went wrong asynchronously: %@", error);
                                                [self stopSpinner];
                                                return;
                                            }
                                            
                                            UIImage *downloadedImage = [UIImage imageWithData:data];
                                            [self stopSpinner];
                                            self.imageView.image = downloadedImage;
                                        }];
    [task resume];
}

- (IBAction)clearButtonTapped:(id)sender
{
    [self clearImageView];
}

#pragma mark - Private
- (NSURL *)urlFromImageURLString
{
    NSURL *imageURL = [NSURL URLWithString:imageURLString];
    return imageURL;
}

- (void)clearImageView
{
    self.imageView.image = nil;
}

- (void)startSpinner
{
    self.activitySpinner.hidden = NO;
    [self.activitySpinner startAnimating];
}

- (void)stopSpinner
{
    self.activitySpinner.hidden = YES;
    [self.activitySpinner stopAnimating];
}
@end
