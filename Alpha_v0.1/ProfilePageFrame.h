//
//  ProfilePageFrame.h
//
//
//  Created by Lucas L. Pena on 8/2/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "ProfilePage.h"
#import "Connects.h"

@interface ProfilePageFrame : UIViewController <UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *realSideBarButton;
- (IBAction)sideAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *profileHeader;
@property (strong, nonatomic) IBOutlet UIImageView *notification;
@property (strong, nonatomic) IBOutlet UIButton *interactionButton;
- (IBAction)interactionAction:(id)sender;

@end
