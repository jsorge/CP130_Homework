//
//  JMSViewController.m
//  CocoaHTTPServer
//
//  Created by Jared Sorge on 6/8/14.
//  Copyright (c) 2014 net.jsorge. All rights reserved.
//

#import "JMSViewController.h"
#import <HTTPServer.h>
#import <ifaddrs.h>
#import <arpa/inet.h>

static NSString *const serverType = @"_http_tcp.";
static NSString *const webRoot = @"Website";

@interface JMSViewController ()
@property (nonatomic, strong) HTTPServer *server;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;
@end

@implementation JMSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.statusLabel.text = [self serverStatusString];
}

#pragma mark - Properties
- (HTTPServer *)server
{
    if (!_server) {
        _server = [[HTTPServer alloc] init];
        [_server setType:serverType];
        NSString *documentRoot = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:webRoot];
        _server.documentRoot = documentRoot;
        _server.port = 34321;
    }
    return _server;
}

#pragma mark - IBActions
- (IBAction)startServerTapped:(id)sender
{
    NSError *error;
    [self.server start:&error];
    
    if (error) {
        NSLog(@"Error starting server: %@", error);
    } else {
        self.statusLabel.text = [self serverStatusString];
    }
}

- (IBAction)stopServerTapped:(id)sender
{
    [self.server stop];
    self.statusLabel.text = [self serverStatusString];
}

#pragma mark - Private
- (NSString *)serverStatusString
{
    return [self.server isRunning] ? [NSString stringWithFormat:@"Server running at %@:%hu", [self getIPAddress], self.server.port] : @"Server stopped";
}


// Get IP Address
- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

@end
