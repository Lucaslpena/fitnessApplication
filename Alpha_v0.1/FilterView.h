//
//  FilterView.h
//
//  Created by Lucas L. Pena on 8/27/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "FilterTableCell.h"
#import "UserSingleton.h"

@interface FilterView : UIView <UITableViewDataSource, UITableViewDelegate>

- (IBAction)toggleFilters:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *toggleImage;

@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;
@property (strong, nonatomic) IBOutlet UIButton *button3;

- (IBAction)action1:(id)sender;
- (IBAction)action2:(id)sender;
- (IBAction)action3:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *button1Image;
@property (strong, nonatomic) IBOutlet UIImageView *button2Image;
@property (strong, nonatomic) IBOutlet UIImageView *button3Image;

-(void) initForPair;

-(void) shrinkView;

@end
