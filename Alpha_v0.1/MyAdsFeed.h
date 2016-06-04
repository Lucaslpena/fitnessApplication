//
//  MyAdsFeed.h
//
//  Created by Lucas L. Pena on 7/21/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PairUpCell.h"
#import "UserSingleton.h"
#import "AdsDetailViewController.h"

@interface MyAdsFeed : UIViewController <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UINavigationBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl * refreshControl;

@end
