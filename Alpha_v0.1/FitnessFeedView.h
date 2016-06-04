//
//  FitnessFeedView.h
//  Alpha_v0.1
//
//  Created by Lucas L. Pena on 4/15/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ContainerViewController.h"
#import "CreatePosts.h"
#import "UIViewController+CWPopup.h"
#import "SWRevealViewController.h"

@interface FitnessFeedView : UIViewController <UIGestureRecognizerDelegate, UINavigationBarDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *container;
@property (nonatomic, weak) ContainerViewController *containerViewController;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *oneFingerTap;

- (IBAction)segmentButton:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)adPostPop:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *postPop;
- (void) dismissPopup;
- (void) generateExit;
- (void) dismissExit;

-(void) submitButton;

@property (strong, nonatomic) IBOutlet UIButton *exitbutton;
@property (strong, nonatomic) IBOutlet UIButton *submitbutton;

-(void) fieldCheck;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sideBarButton;
@property (weak, nonatomic) IBOutlet UIButton *realSideBarButton;
- (IBAction)sideAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *notification;

//Tutorial
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewContent;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControlContent;
- (IBAction)changePage2:(id)sender;
@property BOOL pageControlBeingUsed2;

@end
