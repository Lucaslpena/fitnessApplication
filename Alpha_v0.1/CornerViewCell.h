//
//  CornerViewCell.h
//
//  Created by Lucas L. Pena on 7/29/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CornerViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *activityImage;
@property (strong, nonatomic) IBOutlet UILabel *cornerName;
@end
