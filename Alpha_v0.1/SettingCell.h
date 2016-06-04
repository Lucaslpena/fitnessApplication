//
//  SettingCell.h
//
//
//  Created by Lucas L. Pena on 9/24/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *cellLabelDisclosure;
@property (strong, nonatomic) IBOutlet UILabel *button;
@property (strong, nonatomic) IBOutlet UILabel *cellLabelBool;
@property (strong, nonatomic) IBOutlet UISwitch *mySwitch;

-(void) initCell;

@end
