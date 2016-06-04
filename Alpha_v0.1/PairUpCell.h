//
//  PairUpCell.h
//
//  Created by Lucas L. Pena on 6/30/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PairUpCell : UITableViewCell
-(void) initCell;
@property (weak, nonatomic) IBOutlet UIImageView *activityPicture;
@property (weak, nonatomic) IBOutlet UILabel *parentLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;
@property (weak, nonatomic) IBOutlet UILabel *day;
@property (weak, nonatomic) IBOutlet UILabel *time;
@end
