//
//  CustomRecentAdsCell.m
//
//
//  Created by Lucas L. Pena on 9/4/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import "CustomRecentAdsCell.h"

@implementation CustomRecentAdsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 10, 275, 45)];
        self.cellImage = [[UIImageView alloc] initWithFrame:CGRectMake(5, 20, 35, 20)];
        
        [self addSubview:self.cellImage];
        [self addSubview:self.cellLabel];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
