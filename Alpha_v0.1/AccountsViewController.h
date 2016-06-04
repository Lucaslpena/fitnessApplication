//
//  AccountsViewController.h
//
//
//  Created by Dev on 12/2/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "UserSingleton.h"

@interface AccountsViewController : UIViewController

@property (strong, nonatomic) IBOutlet FBLoginView *loginView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;

@end
