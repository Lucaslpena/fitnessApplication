//
//  SettingCell.m
//
//
//  Created by Lucas Pena on 9/24/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

-(void) initCell {
    UIColor *teal = [[UIColor alloc]
                           initWithRed: 47/255.0
                           green:      190/255.0
                           blue:       190/255.0
                           alpha:      1.0];
    
    _cellLabelBool.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    _cellLabelDisclosure.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    _textField.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    _button.font = [UIFont fontWithName:@"Lato-Bold" size:16];
    _button.textColor = teal;
    [self setIndentationLevel:0];
    [self setIndentationWidth:0];
}

@end
