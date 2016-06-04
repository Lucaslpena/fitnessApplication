//
//  FitnessFeedView.m
//  Alpha_v0.1
//
//  Created by Lucas L. Pena on 4/15/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, LLC. All rights reserved.
//

#import "FitnessFeedView.h"


@interface FitnessFeedView ()


@end

@implementation FitnessFeedView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ( ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568.0) == false) {
        CGRect newFrame = CGRectMake(self.container.frame.origin.x, self.container.frame.origin.y, self.container.frame.size.width, self.container.frame.size.height - 88);
        self.container.frame = newFrame;
        NSLog(@"%f",self.container.frame.size.height);
    }
    [[UserSingleton singleUser] fetchConfirmedTeamUp];
    [[UserSingleton singleUser] fetchConfirmedPairUp];
    [self sideAction:self];
    [[self navigationController] setNavigationBarHidden:YES];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    [self setNeedsStatusBarAppearanceUpdate];

    self.oneFingerTap = [[UITapGestureRecognizer alloc]
                             initWithTarget:self
                             action:@selector(dismissPopup)];
    self.oneFingerTap.numberOfTapsRequired = 1;
    self.oneFingerTap.delegate = self;
    [[self view] addGestureRecognizer:self.oneFingerTap];
    self.useBlurForPopup = YES;
    UIFont *font = [UIFont fontWithName:@"Lato-Black" size:10];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [self.segmentedControl setTitleTextAttributes:attributes
                                    forState:UIControlStateNormal];
    [self notifCheck];
    [self.scrollViewContent setDelegate:self];
    
    if ([UserSingleton singleUser].tutorial < 4) {
        self.scrollViewContent.hidden = YES;
        [self.scrollViewContent removeFromSuperview];
        self.pageControlContent.hidden = YES;
        [self.pageControlContent removeFromSuperview];
    }
    else {
        [UserSingleton singleUser].tutorial = [UserSingleton singleUser].tutorial - 4;
        [self initContentScroll];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Side Bar
- (IBAction)sideAction:(id)sender
{
    [self.realSideBarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - Notifications
-(void)notifCheck
{
    if ([UserSingleton singleUser].pendinfNotification == YES) {
        self.notification.image = [UIImage imageNamed:@"notif_dot"];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self notifCheck];
    });
}
#pragma mark - Activate Popup
- (IBAction)adPostPop:(id)sender {
    self.postPop.hidden = YES;
    CreatePosts *cpPOP = [[CreatePosts alloc]init];
    [self presentPopupViewController:cpPOP animated:YES completion:^(void){
        NSLog(@"presented");
    }];
    [self generateExit];
    [self submitButton];
}

#pragma mark - Exit Button
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return touch.view == self.view;
}
- (void) generateExit
{
    self.exitbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.exitbutton.hidden = NO;
    
    UIImage *btnImg = [UIImage imageNamed:@"popup-header-create post.png"];
    [self.exitbutton setImage:btnImg forState:UIControlStateNormal];
    self.exitbutton.layer.cornerRadius = 5;
    self.exitbutton.layer.masksToBounds = YES;
    
    [self.exitbutton addTarget:self
               action:@selector(dismissPopup)
     forControlEvents:UIControlEventTouchUpInside];
    self.exitbutton.frame = CGRectMake(18, 500, 283.5, 28.5);
    
    [UIView animateWithDuration:.20 animations:^{
        self.exitbutton.frame = CGRectMake(18.25, 32, 283.5, 28.5);
    } completion:^(BOOL finished) {
    }];
    
    [self.view addSubview:self.exitbutton];
}


- (void) submitButton
{
    self.submitbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitbutton.hidden = NO;
    UIImage *btnImg = [UIImage imageNamed:@"submit button.png"];
    [self.submitbutton setImage:btnImg forState:UIControlStateNormal];
    self.submitbutton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.submitbutton.layer.cornerRadius = 5;
    self.submitbutton.layer.masksToBounds = YES;
    [self.submitbutton addTarget:self
                        action:@selector(fieldCheck) ///////////NEEDS TO BE CHANGED!!!!!! TO SAVE THEN DISMISS
              forControlEvents:UIControlEventTouchUpInside];
    self.submitbutton.frame = CGRectMake(125, 943, 80, 30);
    
    [UIView animateWithDuration:.20 animations:^{
        self.submitbutton.frame = CGRectMake(125, 475, 80, 30);
    } completion:^(BOOL finished) {
    }];
    [self.view addSubview:self.submitbutton];
}

-(void)fieldCheck ////////INCLUDE ANALYTICS!!!!!!!! HERE<<<<<<<<<<<
{

    if ([UserSingleton singleUser].myPairUpAd.active == YES)
    {
        if ([UserSingleton singleUser].myPairUpAd.timeList.count <= 0) {
            //error checking required on time
            UIAlertView *check = [[UIAlertView alloc] initWithTitle:@"No Time Given" message:@"please enter atleast one time slot" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [check show];
            return;
        }
        if( ( ([[UserSingleton singleUser].myPairUpAd.specialLocation isEqualToString:@"Other: Off Campus"]) || ([[UserSingleton singleUser].myPairUpAd.specialLocation isEqualToString:@"Other: On Campus"]) ) && ([[UserSingleton singleUser].myPairUpAd.location isEqualToString:@""]) )
        {
            //error checking required on time
            UIAlertView *check = [[UIAlertView alloc] initWithTitle:@"No Custom Location Given" message:@"Please enter a loation" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [check show];
            return;
        }
        if (([UserSingleton singleUser].myPairUpAd.hideSex == TRUE)
            && ([[UserSingleton singleUser].myPairUpAd.sex isEqualToString:@""])){
            //error checking not completing hidden
            UIAlertView *check = [[UIAlertView alloc] initWithTitle:@"No Gender Given" message:@"please select a gender to hide post from or turn off hidden post" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [check show];
            return;
        }
        
        PFObject *pairUpAd = [PFObject objectWithClassName:@"PairUpAd"];
        PFUser *parent = [PFUser currentUser];
        pairUpAd[@"parent"] = parent;
        if ([UserSingleton singleUser].myPairUpAd.lookGoal)
        {
            pairUpAd[@"goal"] = @YES;
        }
        else
        {
            pairUpAd[@"goal"] = @NO;
        }
        if ([UserSingleton singleUser].myPairUpAd.hideSex)
        {
            pairUpAd[@"hiddenSex"] = @YES;
            pairUpAd[@"hideAgainst"] = [UserSingleton singleUser].myPairUpAd.sex;
        }
        else
        {
            pairUpAd[@"hiddenSex"] = @NO;
            [UserSingleton singleUser].myPairUpAd.sex = @"";
        }
        pairUpAd[@"activity"] = [UserSingleton singleUser].myPairUpAd.activity;
        pairUpAd[@"exp"] = [UserSingleton singleUser].myPairUpAd.experience;
        pairUpAd[@"playerNum"] = [UserSingleton singleUser].myPairUpAd.playerNum;
        pairUpAd[@"location"] = [UserSingleton singleUser].myPairUpAd.location;
        pairUpAd[@"extra"] = [UserSingleton singleUser].myPairUpAd.additionalInformation;
        pairUpAd[@"timeArray"] = [UserSingleton singleUser].myPairUpAd.timeList;
        pairUpAd[@"isActive"] = @YES;
        pairUpAd[@"network"] = [PFUser currentUser][@"college"];
        NSMutableArray *confirmedUsers = [[NSMutableArray alloc] init];
        pairUpAd[@"chatArray"] = confirmedUsers;
        pairUpAd[@"confirmedUsers"] = confirmedUsers;
        pairUpAd[@"flaggedFor"] = confirmedUsers;
        pairUpAd[@"specialLocation"] = [UserSingleton singleUser].myPairUpAd.specialLocation;
        pairUpAd[@"sortTime"] =[UserSingleton singleUser].myPairUpAd.timeList[0];
        [pairUpAd saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error)
            {
                [pairUpAd refresh];
                [PFCloud callFunctionInBackground:@"confirmedAds" withParameters:@{@"type":@"pair" , @"objId":[PFUser currentUser].objectId , @"ad" : pairUpAd.objectId}
                                            block:^(NSString* result, NSError *error) {
                                                if (!error) {
                                                    [[UserSingleton singleUser] fetchConfirmedAds];
                                                }
                                                self.segmentedControl.selectedSegmentIndex = 1;
                                                [self segmentButton:self];
                                            }];
            }
        }];
    }
    [self dismissPopup];
    [self segmentButton:self];
}

- (void)dismissPopup {
    [UserSingleton singleUser].myPairUpAd.active = NO;
    self.postPop.hidden = NO;
    if (self.popupViewController != nil) {
        [self dismissExit];
        [self dismissPopupViewControllerAnimated:YES completion:^(void){
             NSLog(@"pop-up dismissed");
          }];
    }
}
- (void) dismissExit
{
    [UIView animateWithDuration:.20 animations:^{
        self.exitbutton.frame = CGRectMake(18.25, 500, 283.5, 28.5);
    } completion:^(BOOL finished) {
        self.exitbutton.hidden = YES;
    }];
    
    [UIView animateWithDuration:.20 animations:^{
        self.submitbutton.frame = CGRectMake(125, 943, 80, 30);
    } completion:^(BOOL finished) {
        self.submitbutton.hidden = YES;
        self.submitbutton.hidden = YES;
    }];
}

#pragma mark - Navigation
//External
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"embedContainer"]) {
        self.containerViewController = segue.destinationViewController;
    }
}

//Internal
- (IBAction)segmentButton:(id)sender {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        [self.containerViewController swapViewControllers:@1];
    }
    else if (self.segmentedControl.selectedSegmentIndex == 1) {
        [self.containerViewController swapViewControllers:@2];
    }
}


#pragma mark - Scroll View
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollViewContent.frame.size.width;
    int page = floor((self.scrollViewContent.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControlContent.currentPage = page;
}
- (IBAction)changePage2:(id)sender { //ContentScrollView
    CGRect frame;
    frame.origin.x = self.scrollViewContent.frame.size.width * self.pageControlContent.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollViewContent.frame.size;
    [self.scrollViewContent scrollRectToVisible:frame animated:YES];
    self.pageControlBeingUsed2 = YES;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([scrollView tag] == 1)
        self.pageControlBeingUsed2 = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView tag] == 1)
        self.pageControlBeingUsed2 = NO;
}
-(void) initContentScroll
{
    for (int i = 0; i < 4; i++) {
        CGRect frame;
        frame.origin.x = self.scrollViewContent.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollViewContent.frame.size;
        UIView *subview = [[UIView alloc] initWithFrame:frame];
        subview.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        
        if (i ==0)
        {
            UIImageView *holderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 570)];
            [holderView setImage:[UIImage imageNamed:@"fitness-feed-0"]];
            [subview addSubview:holderView];
        }
        
        if (i ==1) {
            
            UIImageView *holderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 570)];
            [holderView setImage:[UIImage imageNamed:@"fitness-feed-1"]];
            [subview addSubview:holderView];
        }
        if (i ==2)
        {
            UIImageView *holderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 570)];
            [holderView setImage:[UIImage imageNamed:@"fitness-feed-2"]];
            [subview addSubview:holderView];
        }
        if (i ==3)
        {
            UIImageView *holderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 570)];
            [holderView setImage:[UIImage imageNamed:@"fitness-feed-3"]];
            [subview addSubview:holderView];
            [holderView sendSubviewToBack:subview];
            
            UIButton *exitButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 400, 260, 90)];
            [exitButton addTarget:self action:@selector(removePopup) forControlEvents:UIControlEventTouchUpInside];
            [subview addSubview:exitButton];
        }
        [self.scrollViewContent addSubview:subview];
    }
    
    self.scrollViewContent.contentSize = CGSizeMake(self.scrollViewContent.frame.size.width * 4, self.scrollViewContent.frame.size.height);
    self.pageControlBeingUsed2 = NO;
    CGRect frame = self.scrollViewContent.frame;
    frame.origin.x = frame.size.width * 0;
    frame.origin.y = 0;
    [self.scrollViewContent scrollRectToVisible:frame animated:YES];
}
-(void)removePopup
{
    [self.scrollViewContent removeFromSuperview];
}

@end
