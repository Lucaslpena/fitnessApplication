//
//  CreatePairUp.h
//
//  Created by Lucas L. Pena on 6/11/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserSingleton.h"

@interface CreatePairUp : UIView <UIPickerViewDataSource,UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *activityLabel;
@property (weak, nonatomic) IBOutlet UIButton *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *additionalLabel;

-(void) setFonts;
-(void) setBorders:(UIButton *) myButton;

- (IBAction)activityInfoTouch:(id)sender;
- (IBAction)timeInfoTouch:(id)sender;
- (IBAction)additionalInfoTouch:(id)sender;

@property BOOL activityUP;
@property BOOL timeUP;
@property BOOL additionalUP;

//displayed tab contents are below//
//Activity Information
@property (weak, nonatomic) IBOutlet UILabel *activityLocationPickerTitle;
@property (nonatomic, strong) IBOutlet UIPickerView *pickerViewSportLocation;
@property (nonatomic, strong) NSMutableArray *activityList;
@property (nonatomic, strong) NSMutableArray *locationList;

@property (weak, nonatomic) IBOutlet UILabel *otherLocationTitle;
@property (strong, nonatomic) IBOutlet UITextField *otherLocationField;


//Time Infomation
@property (weak, nonatomic) IBOutlet UIDatePicker *myDatePicker;

//Additional Information
@property (weak, nonatomic) IBOutlet UITextView *additionalText;
@property (weak, nonatomic) IBOutlet UILabel *additionalTextTitle;
@property (weak, nonatomic) IBOutlet UITextField *textLeft;


@property (weak, nonatomic) IBOutlet UILabel *hideLabel;
@property (weak, nonatomic) IBOutlet UISwitch *hideSwitch;
- (IBAction)hideSwitchAction:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *chooseSex;
- (IBAction)sexSegment:(id)sender;

@property (nonatomic, strong) IBOutlet UIPickerView *pickerViewExperience;
@property (weak, nonatomic) IBOutlet UILabel *experienceLabel;
@property (nonatomic, strong) NSMutableArray *experienceList;

@end
