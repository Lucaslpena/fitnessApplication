//
//  FilterTableCell.m
//
//  Created by Lucas L. Pena on 8/28/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena All rights reserved.
//

#import "FilterTableCell.h"

@implementation FilterTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 30)];
        self.cellLabel.center = CGPointMake(160, 15);
        self.cellLabel.textAlignment = NSTextAlignmentCenter;
        self.cellLabel.textColor = [[UIColor alloc] initWithRed: 0/255.0
                                                    green:      57/255.0
                                                   blue:       77/255.0
                                                  alpha:      1.0];
        self.cellLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14.0f];
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
}

-(void)hilightMe:(BOOL)ON
{
    if (ON) {
        [self setBackgroundColor:[UIColor colorWithRed:0 green:57 blue:77 alpha:1]];
    }
    else
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
}
@end
