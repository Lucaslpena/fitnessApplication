//
//  CreatePairUp.m
//
//  Created by Lucas L. Pena on 6/11/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, LLC. All rights reserved.
//

#import "CreatePairUp.h"

@implementation CreatePairUp {
    BOOL createCustomLocation;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView* xibView = [[[NSBundle mainBundle] loadNibNamed:@"CreatePairUp" owner:self options:nil] objectAtIndex:0];
        [xibView setFrame:[self bounds]];
        xibView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        [self setFonts];
        [self setBorders:self.activityLabel];
        [self setBorders:self.timeLabel];
        [self setBorders:self.additionalLabel];
        self.activityList = [[NSMutableArray alloc] initWithArray:[[UserSingleton singleUser] fetchActivityListIndividual]];
        [self.activityList addObjectsFromArray:[[UserSingleton singleUser] fetchActivityListTeam]];
        [self.activityList sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        self.locationList = [[NSMutableArray alloc] initWithArray:[[UserSingleton singleUser] fetchLocationList]];
        [self.locationList addObject:@"Other: Off Campus"];
        [self.locationList addObject:@"Other: On Campus"];
        [self addSubview:xibView];
        
        //ACTIVITY BELOW
        self.activityUP = YES;
        CGRect tmpFrame = CGRectMake(15, 40, 250, 185);
        self.pickerViewSportLocation= [[UIPickerView alloc] initWithFrame:tmpFrame];
        self.pickerViewSportLocation.delegate    = self;
        self.pickerViewSportLocation.dataSource  = self;
        self.pickerViewSportLocation.tag = 1;
        [self addSubview:self.pickerViewSportLocation];
        self.otherLocationTitle.font = [UIFont fontWithName:@"Lato-Regular" size:14];
        self.otherLocationField.font = [UIFont fontWithName:@"Lato-Bold" size:14];
        self.otherLocationField.textAlignment = NSTextAlignmentCenter;
        self.otherLocationField.returnKeyType = UIReturnKeyDone;
        self.otherLocationField.keyboardType = UIKeyboardTypeNamePhonePad;
        self.otherLocationField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
        self.otherLocationField.delegate = self;
        createCustomLocation = NO;
        [self customLocationFields];
        self.hideLabel.font = [UIFont fontWithName:@"Lato-Regular" size:8];
        self.hideLabel.hidden = NO;
        self.hideSwitch.hidden = NO;
        self.chooseSex.hidden = YES;
        tmpFrame = CGRectMake(150, 238, 100, 20);
        self.pickerViewExperience= [[UIPickerView alloc] initWithFrame:tmpFrame];
        self.pickerViewExperience.delegate    = self;
        self.pickerViewExperience.dataSource  = self;
        self.pickerViewExperience.tag = 2;
        [self addSubview:self.pickerViewExperience];
        self.pickerViewExperience.hidden = NO;
        self.experienceLabel.hidden = NO;
        self.experienceLabel.font = [UIFont fontWithName:@"Lato-Regular" size:10];
        self.experienceList = [NSMutableArray arrayWithObjects:@"Any", @"None", @"A Little", @"Some", @"A Lot", nil];
        
        //TIME BELOW
        self.myDatePicker.hidden = YES;
        self.myDatePicker.minimumDate = [[NSDate alloc] initWithTimeIntervalSinceNow:60*5];
        self.myDatePicker.maximumDate = [[NSDate alloc] initWithTimeIntervalSinceNow:518400];
        self.myDatePicker.minuteInterval = 15;
        [self.myDatePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        [self dateChanged:self.myDatePicker];
        self.additionalText.hidden = YES;
        self.additionalText.delegate = self;
        self.additionalText.layer.cornerRadius = 5;
        self.additionalText.layer.masksToBounds = YES;
        self.additionalText.font = [UIFont fontWithName:@"Lato-Regular" size:12];
        self.additionalText.returnKeyType = UIReturnKeyDone;
        self.additionalText.enablesReturnKeyAutomatically = YES;
        self.additionalTextTitle.hidden = YES;
        self.additionalTextTitle.font = [UIFont fontWithName:@"Lato-Regular" size:12];
        self.textLeft.hidden = YES;
        self.textLeft.font = [UIFont fontWithName:@"Lato-Regular" size:8];

        [UserSingleton singleUser].myPairUpAd.location = [self.locationList objectAtIndex:0];
        [UserSingleton singleUser].myPairUpAd.specialLocation = @"";
        [UserSingleton singleUser].myPairUpAd.activity = [self.activityList objectAtIndex:0];
    }
    return self;
}

-(void) setFonts
{
    UIFont *latoReg = [UIFont fontWithName:@"Lato-Regular" size:14];
    [self.activityLabel.titleLabel setFont:latoReg];
    [self.timeLabel.titleLabel setFont:latoReg];
    [self.additionalLabel.titleLabel setFont:latoReg];
    latoReg = [UIFont fontWithName:@"Lato-Regular" size:10];
}
-(void) setBorders:(UIButton *) myButton
{
    myButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    myButton.layer.borderWidth = 1.0f;
}
#pragma mark - Tab Touches
- (IBAction)activityInfoTouch:(id)sender {
    if (self.timeUP == YES) {
        [UIView animateWithDuration:.25
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             //time up
                             self.myDatePicker.hidden = YES;
                             self.additionalText.hidden = YES;
                             self.additionalTextTitle.hidden = YES;
                             self.textLeft.hidden = YES;
                             //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                             self.timeLabel.center = CGPointMake(self.timeLabel.center.x, self.timeLabel.center.y+350);
                             
                             if (self.additionalUP == YES) {
                                 self.additionalLabel.center = CGPointMake(self.additionalLabel.center.x, self.additionalLabel.center.y+350);
                                 self.additionalUP = NO;
                                 //additional tab
                                 //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                             }
                             
                         }completion:^(BOOL finished){
                             self.timeUP = NO;
                             //activity tab
                             self.activityLocationPickerTitle.hidden = NO;
                             self.pickerViewSportLocation.hidden = NO;
                             [self customLocationFields];
                             self.hideLabel.hidden = NO;
                             self.hideSwitch.hidden = NO;
                             if (self.hideSwitch.on) {
                                 self.chooseSex.hidden =NO;
                             }
                             else
                                 self.chooseSex.hidden = YES;
                             self.pickerViewExperience.hidden = NO;
                             self.experienceLabel.hidden = NO;
                             //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                         }];
    }
    
}

- (IBAction)timeInfoTouch:(id)sender {
    if (self.timeUP == NO) {
        [UIView animateWithDuration:.25
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.timeLabel.center = CGPointMake(self.timeLabel.center.x, self.timeLabel.center.y-350);
                             
                             if (self.additionalUP == YES) {
                                 self.additionalLabel.center = CGPointMake(self.additionalLabel.center.x, self.additionalLabel.center.y+350);
                                 //additional tab
                                 //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                             }
                             //activity tab
                             self.activityLocationPickerTitle.hidden = YES;
                             self.pickerViewSportLocation.hidden = YES;
                             self.otherLocationTitle.hidden = YES;
                             self.otherLocationField.hidden = YES;
                             self.hideLabel.hidden = YES;
                             self.hideSwitch.hidden = YES;
                             self.chooseSex.hidden = YES;
                             self.pickerViewExperience.hidden = YES;
                             self.experienceLabel.hidden = YES;
                             //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                         }completion:^(BOOL finished){
                             self.timeUP = YES;
                             //time tab
                             self.myDatePicker.hidden = NO;
                             self.additionalText.hidden = NO;
                             self.additionalTextTitle.hidden = NO;
                             self.textLeft.hidden = NO;
                             //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                         }];
    }
    if (self.additionalUP == YES) {
        [UIView animateWithDuration:.25
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             //additional tab
                             //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                             self.additionalLabel.center = CGPointMake(self.additionalLabel.center.x, self.additionalLabel.center.y+350);
                             
                         }completion:^(BOOL finished){
                             self.additionalUP = NO;
                             //time tab
                             self.myDatePicker.hidden = NO;
                             self.additionalText.hidden = NO;
                             self.additionalTextTitle.hidden = NO;
                             self.textLeft.hidden = NO;
                             //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                         }];
    }
}
#pragma mark - Picker View
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        tView.font = [UIFont fontWithName:@"Lato-Bold" size:14];
        tView.textAlignment = NSTextAlignmentCenter;
       UIColor *orange = [[UIColor alloc]
                                 initWithRed: 230/255.0
                                 green:      150/255.0
                                 blue:       46/255.0
                                 alpha:      1.0];
        tView.textColor = orange;
        if (pickerView.tag == 1)
        {
            if (component == 0) {
                tView.text = self.activityList[row];
            }
            else
                tView.text = self.locationList[row];
        }
        else if (pickerView.tag == 2)
        {
            tView.text =self.experienceList[row];
        }
    }
    return tView;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView.tag == 1)
    {
        return 2;
    }
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)myPicker numberOfRowsInComponent: (NSInteger)component
{
    if (myPicker.tag == 1)
    {
        if (component == 0) {
            return self.activityList.count;
        }
        else
            return self.locationList.count;
    }
    else
        return self.experienceList.count;
}

- (void)pickerView:(UIPickerView *)myPicker didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    if (myPicker.tag == 1)
    {
        NSString *chosenActivity = [self.activityList objectAtIndex:[self.pickerViewSportLocation selectedRowInComponent:0]];
        NSString *chosenLocation = [self.locationList objectAtIndex:[self.pickerViewSportLocation selectedRowInComponent:1]];
        NSLog(@"%@", chosenActivity);
        NSLog(@"%@", chosenLocation);
        if( ([chosenLocation isEqualToString:@"Other: Off Campus"]) || ([chosenLocation isEqualToString:@"Other: On Campus"]) )
        {
            [UserSingleton singleUser].myPairUpAd.specialLocation = chosenLocation;
            [UserSingleton singleUser].myPairUpAd.location = @"";
            self.otherLocationField.text = @"";
            createCustomLocation = YES;
            [self customLocationFields];
        }
        else {
            createCustomLocation = NO;
            [self customLocationFields];
            [UserSingleton singleUser].myPairUpAd.specialLocation = @"";
            [UserSingleton singleUser].myPairUpAd.activity = chosenActivity;
            [UserSingleton singleUser].myPairUpAd.location = chosenLocation;
        }
    }
    else if (myPicker.tag == 2)
    {
        NSString *chosenExperience = [self.experienceList objectAtIndex:[self.pickerViewExperience selectedRowInComponent:0]];
        NSLog(@"%@", chosenExperience);
        [UserSingleton singleUser].myPairUpAd.experience = chosenExperience;
    }
}

#pragma mark - Segment
- (IBAction)sexSegment:(id)sender {
    if (self.chooseSex.selectedSegmentIndex == 0) {
        [UserSingleton singleUser].myPairUpAd.sex = @"M";
    }
    else if (self.chooseSex.selectedSegmentIndex == 1) {
        [UserSingleton singleUser].myPairUpAd.sex = @"F";
    }
}

#pragma mark - Time Fields
- (void) dateChanged:(id)sender{
    NSArray *timeArray = [NSArray arrayWithObject:self.myDatePicker.date];
    [UserSingleton singleUser].myPairUpAd.timeList = [NSMutableArray arrayWithArray:timeArray];
}
#pragma mark - Text Below
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    int tempNum = 160 - textView.text.length;
    self.textLeft.text = [NSString stringWithFormat:@"%d", tempNum];
    if ([text hasSuffix:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return textView.text.length + (text.length - range.length) <= 160;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.additionalTextTitle.text = @"[DONE]";
    return true;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 25) ? NO : YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [UserSingleton singleUser].myPairUpAd.location = textField.text;
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.additionalTextTitle.text = @"Enter Below";
    NSLog(@"%@", textView.text);
    [UserSingleton singleUser].myPairUpAd.additionalInformation = textView.text;
    return true;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textfield
{
    [textfield resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
    NSLog(@"%@", textField.text);
}
- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    CGPoint temp = [textField.superview convertPoint:textField.frame.origin toView:nil];
    int animatedDis = 0;
    int moveUpValue = temp.y+textField.frame.size.height;
    animatedDis = moveUpValue-301;
    int movementDistance = animatedDis;
    
    const float movementDuration = 0.15f;
    int movement = (up ? -movementDistance : movementDistance);
    if(up)
    {
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.frame = CGRectOffset(self.frame, 0, movement);
        self.activityLabel.hidden = YES;
        [UIView commitAnimations];
    }
    if (!up) {
        movement = 9;
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        self.frame = CGRectOffset(self.frame, 0, movement);
        [UIView commitAnimations];
        self.activityLabel.hidden = NO;
    }
}
#pragma mark - Switch
- (IBAction)hideSwitchAction:(id)sender {
    if (self.hideSwitch.on == YES) {
        self.chooseSex.hidden = NO;
        [UserSingleton singleUser].myPairUpAd.hideSex = YES;
    }
    if (self.hideSwitch.on == NO) {
        self.chooseSex.hidden = YES;
        [UserSingleton singleUser].myPairUpAd.hideSex = NO;
    }
}

#pragma mark - Custom Locations
-(void)customLocationFields
{
    if (createCustomLocation == NO) {
        self.otherLocationField.hidden = YES;
        self.otherLocationTitle.hidden = YES;
    }
    else {
        self.otherLocationField.hidden = NO;
        self.otherLocationTitle.hidden = NO;
    }
}
@end
