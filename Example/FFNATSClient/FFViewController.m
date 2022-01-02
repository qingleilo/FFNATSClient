//
//  FFViewController.m
//  FFNATSClient
//
//  Created by Roben on 01/02/2022.
//  Copyright (c) 2022 Roben. All rights reserved.
//

#import "FFViewController.h"
#import <FFNatsClient/FFNATS.h>
@interface FFViewController ()

@property(nonatomic,strong)FFNatsSubject *nSub;

@end

@implementation FFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationDidReceiveNatsMessage:) name:kNatsDidReceiveMessageNotificationKey object:nil];
    
    [FFNatsClient sharedClient].statusHandle = ^(NatsStatus status) {
        switch (status) {
            case NatsStatusError:
                NSLog(@"NatsStatusError");
                break;
            case NatsStatusConnected:
                NSLog(@"NatsStatusConnected");
                break;
            case NatsStatusDisconnected:
                NSLog(@"NatsStatusDisconnected");
                break;
            default:
                break;
        }
    };
    
}

/// notificationDidReceiveNatsMessage
/// @param notification notification
-(void)notificationDidReceiveNatsMessage:(NSNotification *)notification
{
    NSLog(@"%@",notification.object);
}

- (IBAction)connect:(UIButton *)sender
{
    [[FFNatsClient sharedClient] connect:@"ws://ruser:T0pS3cr3t@172.0.0.0:4223"];
}

- (IBAction)disconnect:(UIButton *)sender
{
    [[FFNatsClient sharedClient] disconnect];
}

- (IBAction)subscribe:(id)sender {
//    self.nsub3 = [FFNatsClient.sharedClient subscribe:@"icp.store.employee.status"];
    [FFNatsClient.sharedClient subscribeWithNatsSubject:self.nSub];
}

- (IBAction)unsubscribe:(id)sender
{
    [FFNatsClient.sharedClient unsubscribe:self.nSub];
}

- (IBAction)publish:(id)sender
{
    NSString *json = @"jsjon";
     [FFNatsClient.sharedClient publish:json to:self.nSub];
}

#pragma mark - Lazy load
- (FFNatsSubject *)nSub
{
    if (!_nSub) {
        _nSub = [[FFNatsSubject alloc] initWithSubject:@"topic"];
    }
    return _nSub;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
