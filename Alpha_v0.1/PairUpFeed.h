//
//  PairUpFeed.h
//
//  Created by Lucas L. Pena on 6/30/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PairUpAd.h"
#import "PairUpCell.h"
#import "AdsDetailViewController.h"
#import "FilterView.h"

@interface PairUpFeed : UIViewController <UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UINavigationBarDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)fetchPairUpAds;
@property (nonatomic, strong) UIRefreshControl * refreshControl;
@property (strong, nonatomic) IBOutlet FBLoginView *loginview;

@end
