//
//  Connects.m
//
//
//  Created by Dev on 11/15/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import "Connects.h"

@implementation Connects {
    UIAlertView *confirm;
}

#pragma Mark - Getters and Setters

#pragma Mark - Singleton
+(Connects *) connect {
    static Connects *connect = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        connect = [[self alloc] init];
    });
    return connect;
}

-(id)init
{
    self = [super init];
    if (self) {
        _fromSelf =-1;
    }
    return self;
}

#pragma Mark - Methods

+(void)connectToUser:(PFUser *)user {
    [PFCloud callFunctionInBackground:@"connectWithUser" withParameters:@{@"requestor" : [PFUser currentUser].objectId, @"requestee" : user.objectId}
     //@{@"requestee" : [PFUser currentUser].objectId, @"requestor" : self.pageOwner.objectId}
                                block:^(NSString* result, NSError *error) {
                                    if (!error) {
                                        if ([result isEqualToString:@"saved"])
                                        {
                                            NSLog(@"%@",result);
                                            UIAlertView *confirm = [[UIAlertView alloc] initWithTitle:@"Connect Sent" message:[ NSString stringWithFormat:@"Requested to connect with %@", user[@"fName"]] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                                            [Connects connect].alert = confirm;
                                        }
                                        if ([result isEqualToString:@"already requested"])
                                        {
                                            NSLog(@"%@",result);
                                            UIAlertView *confirm = [[UIAlertView alloc] initWithTitle:@"Already Requested" message:@"Do you want to cancel request?" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes, I am sure.", nil];
                                            [Connects connect].alert = confirm;
                                        }
                                        if ([result isEqualToString:@"already friends"])
                                        {
                                            NSLog(@"%@",result);
                                            UIAlertView *confirm = [[UIAlertView alloc] initWithTitle:@"Already Connected" message:@"Do you want to disconnect from user?" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes, I am sure.", nil];
                                            [Connects connect].alert = confirm;
                                        }
                                    }
                                }];
}
+(void)checkStatus:(PFUser *)user{
    
    //returns number for status of Connect as well as sets current Connect
    // 0 = self page
    // 1 = connect page ..ability to cancel
    // 2 = requested... ability to respond or not
    // 3 = requestee... ability to cancel
    // 4 = no connecction... ability to request
    
    if ([user.objectId isEqualToString:[PFUser currentUser].objectId]) {
        [Connects connect].fromSelf = 0;
        return;
    }
    PFQuery *connectQuery = [PFQuery queryWithClassName:@"Connects"];
    [connectQuery whereKey:@"requestor" equalTo:[PFUser currentUser]];
    [connectQuery whereKey:@"requestee" equalTo:user];
    NSArray *holder = [connectQuery findObjects];
    if (holder.count == 1) {
        [Connects connect].currentConnectobject = holder[0];
        if ([[Connects connect].currentConnectobject[@"isConfirmed"] isEqualToNumber:@YES])
        {
            [Connects connect].fromSelf = 1;
        }
        else
            [Connects connect].fromSelf = 3;
    }
    else
    {
        PFQuery *connectQuery2 = [PFQuery queryWithClassName:@"Connects"];
        [connectQuery2 whereKey:@"requestee" equalTo:[PFUser currentUser]];
        [connectQuery2 whereKey:@"requestor" equalTo:user];
        NSArray *holder = [connectQuery2 findObjects];
        if (holder.count == 1) {
            [Connects connect].currentConnectobject = holder[0];
            [Connects connect].currentConnectobject = holder[0];
            if ([[Connects connect].currentConnectobject[@"isConfirmed"] isEqualToNumber:@YES])
            {
                [Connects connect].fromSelf = 1;
            }
            else
                [Connects connect].fromSelf = 2;
        }
        else {
            [Connects connect].currentConnectobject = nil;
            [Connects connect].fromSelf = 4;
        }
    }
}

#pragma Mark - Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [[Connects connect].currentConnectobject deleteEventually];
    [Connects connect].fromSelf = 4;
}
@end
