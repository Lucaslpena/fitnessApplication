//
//  AdsDetailViewController.h
//  Alpha_v0.1
//
//  Created by Lucas L. Pena on 4/23/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Mapkit/MapKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "ProfilePage.h"
#import "AMChatViewController.h"

@interface AdsDetailViewController : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate>
-(void)initPage;
- (IBAction)popButton:(id)sender;
@property (strong, nonatomic) UIColor *teal;
@property (strong, nonatomic) UIColor *navy;
@property (strong, nonatomic) UIColor *orange;

//pairUpOnly
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *day;
@property (weak, nonatomic) IBOutlet UILabel *time;

//teamUpOnly
@property (weak, nonatomic) IBOutlet UILabel *headerSentence;

//BOTH
@property (weak, nonatomic) IBOutlet UIImageView *adPicture;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;

@property (weak, nonatomic) IBOutlet UIButton *connectButton;
- (IBAction)connectToAd:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *parentView;

@property (strong, nonatomic) PFObject *pairUpAd;
@property (strong, nonatomic) PFUser *adOwner;
@property (strong, nonatomic) PFUser *clickedConfirmed;

- (IBAction)reportAction:(id)sender;

-(void) initContentScroll;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewContent;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControlContent;
- (IBAction)changePage2:(id)sender;
@property BOOL pageControlBeingUsed2;

@property BOOL isConnected;

@end
