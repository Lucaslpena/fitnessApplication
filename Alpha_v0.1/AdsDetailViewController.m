//
//  AdsDetailViewController.m
//  Alpha_v0.1
//
//  Created by Lucas L. Pena on 4/23/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena All rights reserved.
//

#import "AdsDetailViewController.h"

@interface AdsDetailViewController ()

@end

@implementation AdsDetailViewController{
    GMSMapView *mapView;
    NSArray *confirmedUsers;
    NSArray *geoArray;
    NSString *locationName;
    BOOL noAnchor;
}

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
    [self.navigationController setNavigationBarHidden:YES];
    self.isConnected = NO;
    noAnchor = YES;
    [self initPage];
    locationName = [[NSString alloc] init];
    [self initPairUp];
    locationName = [NSString stringWithString:self.pairUpAd[@"location"]];
    NSString *geoString = [[UserSingleton singleUser] fetchGpsByLocation:locationName];
    geoArray = [geoString componentsSeparatedByString:@", "];
    [self initContentScroll];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialize Page
-(void)initPairUp
{
    self.headerSentence.hidden = YES;
    PFObject *pairUpAd = self.pairUpAd;
    NSMutableArray *dateList = pairUpAd[@"timeArray"];
    NSDate *adDate = dateList[0];
    PFUser *creator = pairUpAd[@"parent"];
    [creator fetchIfNeeded];
    NSString *goalString = [[NSString alloc] init];
    if ([pairUpAd[@"goal"] isEqual: @YES]) {
        goalString = @"Look Good";
    }
    else
        goalString = @"Feel Good";
    self.activityLabel.text = pairUpAd[@"activity"];
    self.adPicture.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", pairUpAd[@"activity"]]];
    self.locationLabel.text = pairUpAd[@"location"];
    NSDateFormatter *displayDate = [[NSDateFormatter alloc] init];
    [displayDate setDateFormat:@"EEE"];
    NSString *formattedDateString = [displayDate stringFromDate:adDate];
    self.day.text = formattedDateString;
    [displayDate setDateFormat:@"h:mm a"];
    formattedDateString = [displayDate stringFromDate:adDate];
    self.time.text = formattedDateString;
    self.day.textColor = self.teal;
    self.time.textColor = self.teal;
    self.connectButton.backgroundColor = self.teal;
    self.connectButton.layer.cornerRadius = 5;
    [self.connectButton.layer masksToBounds];
}

-(void)initPage
{
    BOOL changeLabel = false;
    [[PFUser currentUser] refresh];
    
    NSArray *adArray = [PFUser currentUser][@"confirmedAds"];
    //PFObject *comparable = [[PFObject alloc] init];
    for (PFObject *comparable in adArray) {
        if ([comparable.objectId isEqualToString:self.pairUpAd.objectId])
        {
            changeLabel = true;
        }
    }
    if (changeLabel == true)
    {
        [self.connectButton setTitle:@"Disconnect from Ad" forState:UIControlStateNormal];
        self.isConnected = YES;
    }
    
    self.teal = [[UIColor alloc]
                       initWithRed: 47/255.0
                       green:      190/255.0
                       blue:       190/255.0
                       alpha:      1.0];
    self.navy = [[UIColor alloc]
                       initWithRed: 0/255.0
                       green:      57/255.0
                       blue:       77/255.0
                       alpha:      1.0];
    self.orange = [[UIColor alloc]
                        initWithRed: 230/255.0
                        green:      150/255.0
                        blue:       46/255.0
                        alpha:      1.0];
    self.activityLabel.font = [UIFont fontWithName:@"Lato-Light" size:10];
    self.locationLabel.font = [UIFont fontWithName:@"Lato-Bold" size:16];
    self.activityLabel.textColor = self.navy;
    self.locationLabel.textColor = self.navy;
    self.day.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    self.time.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    self.connectButton.titleLabel.font = [UIFont fontWithName:@"Lato-regular" size:16];
    self.connectButton.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:18];
    
    // subview under button below
    self.parentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 90)];
    self.parentView.backgroundColor = self.navy;
    CGRect buttonFrame;
    buttonFrame.origin.x = (self.parentView.frame.size.width / 2) - 115;
    buttonFrame.origin.y = (self.parentView.frame.size.height / 2) - 20;
    buttonFrame.size.width = 50;
    buttonFrame.size.height = 50;
    UIButton *subviewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    subviewButton.frame = buttonFrame;
    [subviewButton setTitle:@"" forState:UIControlStateNormal];
    [subviewButton setTag:1];
    [subviewButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *parentPic = [[UIImageView alloc] initWithFrame:buttonFrame];
    PFFile *pic = self.adOwner[@"profilePic"];
    parentPic.image = [UIImage imageNamed:@"feed-pairup-player"];
    [pic getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            parentPic.image = [UIImage imageWithData:imageData];
        }
    }];
    parentPic.layer.cornerRadius  = parentPic.frame.size.height/2;
    parentPic.layer.masksToBounds = YES;
    parentPic.contentMode = UIViewContentModeScaleAspectFill;
    CGRect nameFrame = CGRectMake(0,0, 100, 45);
    UILabel *name = [[UILabel alloc]init];
    name.text = [NSString stringWithFormat:@"%@ %@",self.adOwner[@"fName"], self.adOwner[@"lName"]];
    name.frame = nameFrame;
    [name sizeToFit];
    name.center = CGPointMake(self.parentView.center.x, 30);
    name.font = [UIFont fontWithName:@"Lato-Bold" size:16];
    name.textColor = [UIColor whiteColor];
    name.textAlignment = NSTextAlignmentLeft;
    
    CGRect majorFrame = CGRectMake(0,0, 150, 45);
    UILabel *majorString = [[UILabel alloc]init];
    majorString.frame = majorFrame;
    majorString.center = CGPointMake(155, 50);
    majorString.frame = CGRectMake(name.frame.origin.x, majorString.frame.origin.y, 150, 45);
    majorString.font = [UIFont fontWithName:@"Lato-Regular" size:12];
    majorString.text = self.adOwner[@"major"];
    majorString.textColor = [UIColor whiteColor];
    majorString.textAlignment = NSTextAlignmentLeft;
    UILabel *ageString = [[UILabel alloc]init];
    ageString.frame = majorFrame;
    ageString.center = CGPointMake(155, 70);
    ageString.frame = CGRectMake(majorString.frame.origin.x, ageString.frame.origin.y, 150, 45);
    ageString.font = [UIFont fontWithName:@"Lato-Regular" size:12];
    NSNumber *age = self.adOwner[@"age"];
    ageString.text = [NSString stringWithFormat:@"Age: %@", age];
    ageString.textColor = [UIColor whiteColor];
    ageString.textAlignment = NSTextAlignmentLeft;
    
    CGRect xpFrame = CGRectMake(0,0, 150, 45);
    UIImageView *expImg = [[UIImageView alloc]initWithFrame:xpFrame];
    expImg.center = CGPointMake(240, 70);
    expImg.contentMode = UIViewContentModeCenter;
    NSString *chosenExperience = [[NSString alloc] init];
    chosenExperience = self.pairUpAd[@"exp"];
    expImg.image = [UIImage imageNamed:@"experience1"];
    if ([chosenExperience isEqualToString:@"a little"])
        expImg.image = [UIImage imageNamed:@"experience2"];
    else if ([chosenExperience isEqualToString:@"some"])
        expImg.image = [UIImage imageNamed:@"experience3"];
    else if ([chosenExperience isEqualToString:@"a lot"])
        expImg.image = [UIImage imageNamed:@"experience4"];
    UILabel *expImgLabel = [[UILabel alloc]initWithFrame:xpFrame];
    expImgLabel.center = CGPointMake(285, 50);
    expImgLabel.text = @"Experience";
    expImgLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12];
    expImgLabel.textColor = [UIColor whiteColor];
    
    [self.parentView addSubview:name];
    [self.parentView addSubview:majorString];
    [self.parentView addSubview:ageString];
    [self.parentView addSubview:parentPic];
    [self.parentView addSubview:subviewButton];
    [self.parentView addSubview:expImg];
    [self.parentView addSubview:expImgLabel];
}

#pragma mark - Scroll View
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    if ([sender tag] == 1) {
        CGFloat pageWidth = self.scrollViewContent.frame.size.width;
        int page = floor((self.scrollViewContent.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.pageControlContent.currentPage = page;
    }
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
    for (int i = 0; i < 3; i++) {
        CGRect frame;
        frame.origin.x = self.scrollViewContent.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollViewContent.frame.size;
        UIView *subview = [[UIView alloc] initWithFrame:frame];
        subview.backgroundColor = self.navy;
        
        if (i ==0)
        {
            UILabel *connectHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 320, 20) ];
            
            connectHeader.text = @"Connected Users";
            connectHeader.textColor = [UIColor whiteColor];
            connectHeader.textAlignment = NSTextAlignmentCenter;
            connectHeader.font = [UIFont fontWithName:@"Lato-Bold" size:18];
            connectHeader.backgroundColor = self.navy;
            [subview addSubview:connectHeader];
            
            UIView *connectView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 320, 340)];
            connectView.backgroundColor = [UIColor colorWithWhite:1 alpha:.8];
            
            confirmedUsers = [[NSArray alloc] init];
            confirmedUsers = self.pairUpAd[@"confirmedUsers"];
            CGFloat Yrange= 20;
            CGFloat Xrange = 150;
            for (int i = 0; i < confirmedUsers.count; ++i)
            {
                PFUser *thisUser = confirmedUsers[i];
                [thisUser fetchIfNeeded];
                
                CGRect buttonFrame;
                buttonFrame.origin.x = (self.parentView.frame.size.width / 2) - Xrange;
                buttonFrame.origin.y = Yrange;
                buttonFrame.size.width = 50;
                buttonFrame.size.height = 50;
                UIButton *subviewButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                subviewButton.frame = buttonFrame;
                [subviewButton setTitle:@"" forState:UIControlStateNormal];
                [subviewButton setTag:3+i];
                [subviewButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
                UIImageView *parentPic = [[UIImageView alloc] initWithFrame:buttonFrame];
                PFFile *pic = thisUser[@"profilePic"];
                parentPic.image = [UIImage imageNamed:@"feed-pairup-player"];
                [pic getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                    if (!error) {
                        parentPic.image = [UIImage imageWithData:imageData];
                    }
                }];
                parentPic.layer.cornerRadius  = parentPic.frame.size.height/2;
                parentPic.layer.masksToBounds = YES;
                CGRect nameFrame = CGRectMake(parentPic.center.x + 30 , parentPic.center.y-10, 200, 20);
                parentPic.contentMode = UIViewContentModeScaleAspectFill;
                UILabel *name = [[UILabel alloc]initWithFrame:nameFrame];
                name.text = [NSString stringWithFormat:@"%@ %@", thisUser[@"fName"], thisUser[@"lName"]];
                name.font = [UIFont fontWithName:@"Lato-Bold" size:16];
                name.textColor = self.navy;
                name.textAlignment = NSTextAlignmentLeft;
                
                
                if( ([self.adOwner.objectId isEqualToString:[PFUser currentUser].objectId]) && (i > 0) ){
                    UIButton *removeButton = [[UIButton alloc] initWithFrame:CGRectMake(225,buttonFrame.origin.y,100,50)];
                    [removeButton setTag:-3-i];
                    [removeButton setTitle:@"remove" forState:UIControlStateNormal];
                    [removeButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [connectView addSubview:removeButton];
                }
                [connectView addSubview:subviewButton];
                [connectView addSubview:parentPic];
                [connectView addSubview:name];
                
                Yrange += 75;
                if (i == 3)
                {
                    Yrange= 55;
                    Xrange = 30;
                }
            }
            
            [subview addSubview:connectView];
        }
        
        if (i ==1) {
            
            [subview addSubview:self.parentView];
            UIView *additional = [[UIView alloc] initWithFrame:CGRectMake(0, 85, 320, 305)];
            additional.backgroundColor = [UIColor whiteColor];
            
            if (geoArray.count == 2) {
                double lat = [geoArray[0] doubleValue];
                double lon = [geoArray[1] doubleValue];
                GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat longitude:lon zoom:13];
                mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, 320, 150) camera:camera];
                [additional addSubview:mapView];
                mapView.myLocationEnabled = YES;
                if (noAnchor)
                {
                    GMSMarker *marker = [[GMSMarker alloc] init];
                    marker.position = CLLocationCoordinate2DMake(lat, lon);
                    marker.title = @"";
                    marker.snippet = @"";
                    marker.map = mapView;
                }
            }
        
            UILabel *additionalI = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, 320, 30) ];
            additionalI.text = @"Additional Information";
            additionalI.textColor = self.navy;
            additionalI.textAlignment = NSTextAlignmentCenter;
            additionalI.font = [UIFont fontWithName:@"Lato-Bold" size:18];
            [additional addSubview:additionalI];
            
            /*UIButton *mapsButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            mapsButton.frame = CGRectMake(0, 0, 320, 150);
            [mapsButton setTitle:@"CLICK ME" forState:UIControlStateNormal];
            [mapsButton setTag:2];
            [mapsButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
             [additional addSubview:mapsButton];*/
                
                
            UILabel *additionalC = [[UILabel alloc] initWithFrame:CGRectMake(10, 200, 300, 50)];
            NSString *appendMe = [[NSString alloc] init];
            if ([self.pairUpAd[@"extra"] isEqualToString:@""]) {
                appendMe = @"[no extra information]";
            }
            else
                appendMe = self.pairUpAd[@"extra"];
            
            additionalC.text = appendMe;
            [additionalC setNumberOfLines:4];
            additionalC.textColor = self.navy;
            additionalC.center = CGPointMake(additionalC.center.x, 200);
            additionalC.textAlignment = NSTextAlignmentCenter;
            additionalC.font = [UIFont fontWithName:@"Lato-Regular" size:14];
            additionalC.lineBreakMode = NSLineBreakByWordWrapping;
            additionalC.numberOfLines = 4;
            [additional addSubview:additionalC];
            
            [subview addSubview:additional];
        }
        if (i ==2)
        {
            UIView *chatContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 390)];
            [chatContainer removeConstraints:chatContainer.constraints];
            AMChatViewController* chatViewController = [[AMChatViewController alloc] init];
            [chatViewController setCurrentAd:self.pairUpAd];
            chatViewController.view.frame = CGRectMake(0, 0, 320, 390);
            [chatViewController.tableView removeConstraints:chatViewController.tableView.constraints];
            [self addChildViewController:chatViewController];
            [chatContainer addSubview:chatViewController.view];
            [chatViewController didMoveToParentViewController:self];
            [subview addSubview:chatContainer];
        
            
            if (self.isConnected == NO)
            {
                UIButton *chatBlocker = [[UIButton alloc] initWithFrame:CGRectMake(0, 355, 320, 30)];
                chatBlocker.backgroundColor = [UIColor whiteColor];
                [chatBlocker setTitle:@"Connect Before Chatting" forState:UIControlStateNormal];
                [chatBlocker.titleLabel setFont:[UIFont fontWithName:@"Lato-Bold" size:14]];
                [chatBlocker setTitleColor:self.teal forState:UIControlStateNormal];
                
                //[subview sendSubviewToBack:chatContainer];
                [subview addSubview:chatBlocker];
            }
        }
        [self.scrollViewContent addSubview:subview];
    }
    
    self.scrollViewContent.contentSize = CGSizeMake(self.scrollViewContent.frame.size.width * 3, self.scrollViewContent.frame.size.height);
    self.pageControlBeingUsed2 = NO;
    CGRect frame = self.scrollViewContent.frame;
    frame.origin.x = frame.size.width * 1;
    frame.origin.y = 0;
    [self.scrollViewContent scrollRectToVisible:frame animated:YES];
}


#pragma mark - Variable Generate Fields
- (IBAction)connectToAd:(id)sender {
    if ([self.adOwner.objectId isEqualToString:[PFUser currentUser].objectId]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Oops!" message:@"You can't disconnect from your own Ad" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Delete Ad", nil];
        alert.tag = 2;
        [alert show];
        return;
    }
        [PFCloud callFunctionInBackground:@"confirmedAds" withParameters:@{@"type":@"pair" , @"objId":[PFUser currentUser].objectId , @"ad" : self.pairUpAd.objectId}
                                    block:^(NSString* result, NSError *error) {
                                        if (!error) {
                                            if ([result isEqualToString:@"added"])
                                            {
                                                [self.connectButton setTitle:@"Disconnect from Ad" forState:UIControlStateNormal];
                                                self.isConnected = YES;
                                            }
                                        
                                            if ([result isEqualToString:@"deleted"])
                                            {
                                                [self.connectButton setTitle:@"Connect to Ad" forState:UIControlStateNormal];
                                                self.isConnected = NO;
                                            }
                                        }
                                        [self.pairUpAd fetch];
                                        [self initContentScroll];
                                    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        NSMutableArray *flags= [NSMutableArray arrayWithArray:self.pairUpAd[@"flaggedFor"]];
        if (flags.count == 1) {
            self.pairUpAd[@"isActive"] = @NO;
        }
        if (buttonIndex == 1) {
            [flags addObject:@"Offensive"];
        }
        else if (buttonIndex == 2) {
            [flags addObject:@"Spam"];
        }
        else if (buttonIndex == 3) {
            [flags addObject:@"Other"];
        }
        self.pairUpAd[@"flaggedFor"] = flags;
        [self.pairUpAd saveInBackground];
        UIAlertView *alert = [[UIAlertView alloc]
                                initWithTitle:@"Thanks for the Feedback" message:@"We will check this out promptly" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil,nil];
        [alert show];
        return;
    }

    if (buttonIndex == 1)
    {
        self.pairUpAd[@"isActive"] = @NO;
        [self.pairUpAd save];
        [UserSingleton singleUser].pairUpRefresh = YES;
        [[UserSingleton singleUser] fetchConfirmedAds];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - Parent Scroll Button Action
- (IBAction)buttonPressed:(id)sender {
    if ([sender tag] == 1) {
        [self performSegueWithIdentifier:@"profileView" sender:self];
    }
    else if ([sender tag] == 2) {
        if ([[UIApplication sharedApplication] canOpenURL:
             [NSURL URLWithString:@"comgooglemaps://"]]) {
            [[UIApplication sharedApplication] openURL:
             [NSURL URLWithString:@"comgooglemaps://?center=40.765819,-73.975866&zoom=14&views=traffic"]];
        } else {
            NSLog(@"Can't use comgooglemaps://");
        }
    }
    else if ([sender tag] > 2)
    {
        int iterator = [sender tag] - 3;
        self.clickedConfirmed = [confirmedUsers objectAtIndex:iterator];
        [self performSegueWithIdentifier:@"profileView" sender:self];
    }
    else if ([sender tag] < -2)
    {
        int iterator = [sender tag] + 3;
        iterator = abs(iterator);
        PFUser *clicked= [confirmedUsers objectAtIndex:iterator];
        [PFCloud callFunctionInBackground:@"confirmedAds" withParameters:@{@"type":@"pair" , @"objId":clicked.objectId , @"ad" : self.pairUpAd.objectId}
                                    block:^(NSString* result, NSError *error) {
                                        if (!error) {
                                            if ([result isEqualToString:@"added"])
                                            {
                                                    [self.connectButton setTitle:@"Disconnect from Ad" forState:UIControlStateNormal];
                                                    self.isConnected = YES;
                                                }
                                                
                                                if ([result isEqualToString:@"deleted"])
                                                {
                                                    [self.connectButton setTitle:@"Connect to Ad" forState:UIControlStateNormal];
                                                    self.isConnected = NO;
                                                }
                                            }
                                            [self.pairUpAd fetch];
                                            [self initContentScroll];
                                        }];
    }
}
#pragma mark - Report Button
-(IBAction)reportAction:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Report" message:@"Are you sure you want to report this ad and user?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Offensive",@"Spam", @"Other",nil];
    alert.tag = 1;
    [alert show];
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"profileView"])
    {
        ProfilePage *pp = [segue destinationViewController];
        if (self.clickedConfirmed) {
            [pp setPageOwner:self.clickedConfirmed];
            self.clickedConfirmed = NULL;
        }
        else
            [pp setPageOwner:self.adOwner];
    }
}
- (IBAction)popButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
