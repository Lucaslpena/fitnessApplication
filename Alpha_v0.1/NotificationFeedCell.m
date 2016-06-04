//
//  NotificationFeedCell.m
//
//
//  Created by Lucas L. Pena on 8/10/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import "NotificationFeedCell.h"

@implementation NotificationFeedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    self.cellLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12];
    UIColor *navy = [[UIColor alloc]
                  initWithRed: 0/255.0
                  green:      57/255.0
                  blue:       77/255.0
                  alpha:      1.0];
    self.cellLabel.textColor = navy;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
