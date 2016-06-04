//
//  AMChatViewController.h
//
//  Created by Lucas L. Pena on 8/5/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMBubbleTableViewController.h"
#import <Parse/Parse.h>
#import "UserSingleton.h"

@interface AMChatViewController : AMBubbleTableViewController

@property (weak, nonatomic) PFObject *currentAd;
@property (weak, nonatomic) PFObject *currentConnect;
@property (weak, nonatomic) PFUser *passedUser;

@property (strong, nonatomic) UIColor *navy;
@property (strong, nonatomic) UIColor *teal;
@property (strong, nonatomic) UIColor *orange;
@property BOOL empty;
@property (strong, nonatomic) NSMutableArray *picHolder;

-(void) reloadDataValues;

@end
