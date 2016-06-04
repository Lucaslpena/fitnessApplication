//
//  SideBarCell.m
//
//  Created by Lucas Pena on 6/26/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, LLC. All rights reserved.
//

#import "SideBarCell.h"

@implementation SideBarCell

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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
