//
//  ConnectsUserFeed.h
//
//  Created by Lucas L. Pena on 7/31/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ConnectsCustomCell.h"
#import "ProfilePage.h"
#import "UserSingleton.h"
#import "CornersDetailViewController.h"

@interface ConnectsUserFeed : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) NSArray *confirmedConnects;
@property (weak, nonatomic) NSDictionary *passedCornerObject;

@end
