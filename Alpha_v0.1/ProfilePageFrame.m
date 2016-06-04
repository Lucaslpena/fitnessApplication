//
//  ProfilePageFrame.m
//
//
//  Created by Lucas L. Pena on 8/2/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import "ProfilePageFrame.h"

@interface ProfilePageFrame ()

@end

@implementation ProfilePageFrame

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self sideAction:self];
    [[self navigationController] setNavigationBarHidden:YES];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.profileHeader.font = [UIFont fontWithName:@"Lato-Regular" size:18];
    [self notifCheck];
    self.interactionButton.hidden = YES;
    [self interactionCheck];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Side Bar
- (IBAction)sideAction:(id)sender
{
    [self.realSideBarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - Notifications
-(void)notifCheck
{
    if ([UserSingleton singleUser].pendinfNotification == YES) {
        self.notification.image = [UIImage imageNamed:@"notif_dot"];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self notifCheck];
    });
}
#pragma mark - Enable Profile Page Button
-(void)interactionCheck
{
    if ([Connects connect].alert) {
        UIAlertView* alert = [Connects connect].alert;
        [Connects connect].alert = nil;
        [alert setDelegate:self];
        [alert show];
    }
    if ([Connects connect].fromSelf != -1) {
         self.interactionButton.hidden = NO;
        if ([Connects connect].fromSelf == 0) {
            self.interactionButton.hidden = YES;
        }
        else if ([Connects connect].fromSelf == 1) {
            self.interactionButton.hidden = NO;
            [self.interactionButton setBackgroundImage:[UIImage imageNamed:@"friend_connected"] forState:UIControlStateNormal];
        } else if ([Connects connect].fromSelf == 2) {
            self.interactionButton.hidden = NO;
            [self.interactionButton setBackgroundImage:[UIImage imageNamed:@"Friend_respond"] forState:UIControlStateNormal];
        } else if ([Connects connect].fromSelf == 3) {
            self.interactionButton.hidden = NO;
            [self.interactionButton setBackgroundImage:[UIImage imageNamed:@"friend_pending"] forState:UIControlStateNormal];
        } else {
            self.interactionButton.hidden = NO;
            [self.interactionButton setBackgroundImage:[UIImage imageNamed:@"freind_request"] forState:UIControlStateNormal];
        }
        [Connects connect].fromSelf = -1;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self interactionCheck];
    });
}
- (IBAction)interactionAction:(id)sender {
    [Connects connectToUser:[Connects connect].pageOwner];
}
#pragma Mark - Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex > 0) {
        [[Connects connect].currentConnectobject delete];
        [[UserSingleton singleUser] fetchConnects:YES];
        self.interactionButton.hidden = NO;
        [self.interactionButton setBackgroundImage:[UIImage imageNamed:@"freind_request"] forState:UIControlStateNormal];
    }
}
@end
