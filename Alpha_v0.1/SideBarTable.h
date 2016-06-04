//
//  SideBarTable.h
//
//  Created by Lucas Pena on 6/26/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideBarCell.h"
#import "SWRevealViewController.h"
#import "ProfilePage.h"

@interface SideBarTable : UITableViewController

-(void)loadForNotifications;
@property BOOL emptyLoad;

@end
