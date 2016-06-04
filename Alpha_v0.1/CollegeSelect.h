//
//  CollegeSelect.h
//
//  Created by Lucas L. Pena on 6/5/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "UserSingleton.h"

@interface CollegeSelect : UIViewController <FBLoginViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

//Headers
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *collegeLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *majorLabel;
@property (strong, nonatomic) IBOutlet UILabel *atLabel;

//Fields
@property (weak, nonatomic) IBOutlet UITextField *registerCollege;
@property (weak, nonatomic) IBOutlet UITextField *registerMajor;

//Facebook
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;
@property BOOL viewFB;

//Navigation
@property (weak, nonatomic) IBOutlet UIButton *finishButton;
- (IBAction)confirmButton:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *termsLabel;

@end
