//
//  PairUpCell.m
//
//  Created by Lucas L. Pena on 6/30/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, LLC. All rights reserved.
//

#import "PairUpCell.h"

@implementation PairUpCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
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
-(void) initCell {
    _parentLabel.font = [UIFont fontWithName:@"Lato-Regular" size:10];
    _activityLabel.font = [UIFont fontWithName:@"Lato-Regular" size:10];
    _day.font = [UIFont fontWithName:@"Lato-Regular" size:12];
    _time.font = [UIFont fontWithName:@"Lato-Regular" size:12];
    UIColor *teal = [[UIColor alloc]
                           initWithRed: 47/255.0
                           green:      190/255.0
                           blue:       190/255.0
                           alpha:      1.0];
    _day.textColor = teal;
    _time.textColor = teal;
    [self setIndentationLevel:0];
    [self setIndentationWidth:0];
}
@end
