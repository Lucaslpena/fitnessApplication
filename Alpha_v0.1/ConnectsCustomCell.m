//
//  ConnectsCustomCell.m
//
//  Created by Lucas L. Pena on 3/26/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import "ConnectsCustomCell.h"

@implementation ConnectsCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userName = [[UILabel alloc] initWithFrame:CGRectMake(103, 10, 185, 45)];
        self.userPic = [[UIImageView alloc] initWithFrame:CGRectMake(20, 3, 60, 60)];
        UIImageView *outline = [[UIImageView alloc] initWithFrame:CGRectMake(17, 0, 66, 66)];
        self.userPic.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.userPic];
        [self addSubview:self.userName];
        [self addSubview:outline];
    }
    return self;
}

- (void)awakeFromNib
{
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}
-(void)hilightMe:(BOOL)ON
{
    if (ON) {
        [self setBackgroundColor:[UIColor colorWithRed:0 green:57 blue:77 alpha:.15]];
    }
    else
        [self setBackgroundColor:[UIColor lightGrayColor]];
}
@end
