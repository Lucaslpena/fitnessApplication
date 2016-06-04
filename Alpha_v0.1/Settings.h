//
//  Settings.h
//  Alpha_v0.1
//
//  Created by Lucas Pena on 3/27/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "SettingCell.h"
#import "WebViewController.h"

@interface Settings : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

// Header
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *versionHeader;

@end
