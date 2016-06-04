//
//  ContainerViewController.h
//  Alpha_v0.1
//
//  Created by Lucas L. Pena on 4/15/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PairUpFeed.h"
#import "MyAdsFeed.h"

@interface ContainerViewController : UIViewController

-(void)swapViewControllers:(NSNumber *) numSwitch;

@property (nonatomic, retain) NSNumber *userID;

@end
