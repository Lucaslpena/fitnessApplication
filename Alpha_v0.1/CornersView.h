//
//  CornersView.h
//
//  Created by Lucas Lorenzo Pena on 7/29/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "CornerViewCell.h"
#import <Parse/Parse.h>
#import "CornersDetailViewController.h"

@interface CornersView : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *realSideBarButton;
- (IBAction)sideAction:(id)sender;

@property (strong, nonatomic) IBOutlet UICollectionView *connectsCollectionView;

@end
