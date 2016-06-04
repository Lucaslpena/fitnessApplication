//
//  ProfilePage.h
//  Alpha_v0.1
//
//  Created by Lucas L. Pena on 2/17/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "UserSingleton.h"
#import "ConnectsUserFeed.h"
#import "UserSingleton.h"
#import "NotificationFeedCell.h"
#import "CustomRecentAdsCell.h"
#import "ConnectsCustomCell.h"
#import "UIImage+Resize.h"
#import "Connects.h"

@interface ProfilePage : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UITextViewDelegate>

@property PFUser *pageOwner;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;

-(void)generateActivities;
-(void)fetchConnections;
@property (strong, nonatomic) NSMutableArray *connectList;

// User Relationships
@property (strong, nonatomic) IBOutlet UIButton *friendButton;
- (IBAction)requestFriend:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *makeblue;

// Picture Selector
@property (nonatomic) UIImagePickerController *picker;
@property (nonatomic) NSMutableArray *capturedImages;
- (IBAction)selectPic:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *selectPicButton;
@property (strong, nonatomic) IBOutlet UIImageView *backGround;
@property (strong, nonatomic) IBOutlet UIButton *selectBPic;

// Scroll View Properties
@property (strong, nonatomic) IBOutlet UILabel *noActivities;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

- (IBAction)changePage:(id)sender;

@end
