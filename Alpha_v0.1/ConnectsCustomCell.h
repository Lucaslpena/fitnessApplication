//
//  ConnectsCustomCell.h
//
//  Created by Lucas L. Pena on 3/26/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConnectsCustomCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UIImageView *userPic;
-(void)hilightMe:(BOOL)ON;

@end
