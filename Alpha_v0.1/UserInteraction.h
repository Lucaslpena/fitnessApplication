//
//  UserInteraction.h
//
//  Created by Lucas Lorenzo Pena on 7/29/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena,  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "UserSingleton.h"
#import "UIViewController+CWPopup.h"
#import "CreatePosts.h"

@interface UserInteraction : UIViewController <UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *realSideBarButton;
- (IBAction)sideAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *notification;
@property (strong, nonatomic) IBOutlet UILabel *cornerHeader;

// Create Popup Here
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *oneFingerTap;
- (IBAction)adPostPop:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *postPop;
@property (strong, nonatomic) IBOutlet UIImageView *headerImage;
- (void) dismissPopup;
- (void) generateExit;
- (void) dismissExit;
-(void) submitButton;
@property (strong, nonatomic) IBOutlet UIButton *exitbutton;
@property (strong, nonatomic) IBOutlet UIButton *submitbutton;

//Tutorial
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewContent;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControlContent;
- (IBAction)changePage:(id)sender;
@property BOOL pageControlBeingUsed;
@end
