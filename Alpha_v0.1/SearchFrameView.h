//
//  SearchFrameView.h
//
//
//  Created by Lucas L. Pena on 8/6/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "UserSingleton.h"
#import "CornersView.h"

@interface SearchFrameView : UIViewController

@property (strong, nonatomic)IBOutlet UIButton *realSideBarButton;
- (IBAction)sideAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *searchHeader;
@property (strong, nonatomic) IBOutlet UIImageView *notification;
@property (strong, nonatomic) IBOutlet UIButton *interactionButton;
- (IBAction)interactionAction:(id)sender;
@end
