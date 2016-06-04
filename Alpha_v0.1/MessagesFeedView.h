//
//  MessagesFeedView.h
//
//
//  Created by Lucas Lorenzo Pena on 6/27/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "SWRevealViewController.h"
#import "ConnectsCustomCell.h"
#import "AMChatViewController.h"

@interface MessagesFeedView : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *messageHeader;
//sidebar
@property (weak, nonatomic) IBOutlet UIButton *realSideBarButton;
- (IBAction)sideAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *notification;

//contents
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *connectsWithOUTChats;
@property (strong, nonatomic) NSArray *confirmedConnectObjects;
@property (strong, nonatomic) NSArray *connectsWithChats;
@property (strong, nonatomic) PFObject *currentConnect;
@property (strong, nonatomic) NSArray *activeList;
@property (strong, nonatomic) PFUser *passUser;

@property (strong, nonatomic) IBOutlet UIButton *plusButton;
- (IBAction)plusAction:(id)sender;
@property BOOL plusIsActive;
@property BOOL chatIsActive;
-(void)generateChatBelow;
@end
