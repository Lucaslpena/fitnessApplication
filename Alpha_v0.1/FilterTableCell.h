//
//  FilterTableCell.h
//
//  Created by Lucas L. Pena on 8/28/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterTableCell : UITableViewCell

@property (nonatomic, strong) UILabel *cellLabel;

-(void)hilightMe:(BOOL) ON;

@end
