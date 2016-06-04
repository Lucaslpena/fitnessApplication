//
//  SettingPageFrame.h
//
//
//  Created by Lorenzo Pena on 9/24/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "UserSingleton.h"

@interface SettingPageFrame : UIViewController <UIScrollViewDelegate>

// Side Bar
@property (strong, nonatomic)IBOutlet UIButton *realSideBarButton;
- (IBAction)sideAction:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *settingHeader;

//Tutorial
@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewContent;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControlContent;
- (IBAction)changePage:(id)sender;
@property BOOL pageControlBeingUsed;

@end
