//
//  NotificationFeedView.h
//
//
//  Created by Lucas L. Pena on 6/27/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import <Parse/Parse.h>
#import "NotificationFeedCell.h"
#import "UserSingleton.h"
// views used to load specific pages
#import "ProfilePage.h"
#import "AMChatViewController.h"
#import "AdsDetailViewController.h"

@interface NotificationFeedView : UIViewController <UITableViewDataSource, UITableViewDelegate>

//sidebar
@property (weak, nonatomic) IBOutlet UIButton *realSideBarButton;
- (IBAction)sideAction:(id)sender;

//notification feed
@property (strong, nonatomic) IBOutlet UITableView *tableView;

//navigation back to tableView
- (IBAction)backButtonAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;

//main payload handler
-(void)notifPayLoadHandler:(NSDictionary *)payloadDic forTime:(BOOL)isFirstTime;
@property BOOL isFirstTime;
@end
