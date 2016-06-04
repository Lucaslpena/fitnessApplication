//
//  ContainerViewControllerTwo.h
//
//  Created by Lucas Lorenzo Pena on 7/29/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CornersView.h"
#import "ConnectsUserFeed.h"

@interface ContainerViewControllerTwo : UIViewController

-(void)swapViewControllers:(NSNumber *) numSwitch;

@property (nonatomic, retain) NSNumber *userID;

@end
