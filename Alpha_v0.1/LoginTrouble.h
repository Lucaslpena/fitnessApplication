//
//  LoginTrouble.h
//
//  Created by Lucas Pena on 8/20/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface LoginTrouble : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *verificationButton;
@property (strong, nonatomic) IBOutlet UIButton *passwordButton;

@property (strong, nonatomic) IBOutlet UILabel *topHeader;
@property (strong, nonatomic) IBOutlet UILabel *buttomHeader;
@property (strong, nonatomic) IBOutlet UILabel *emailHeader;
@property (strong, nonatomic) IBOutlet UILabel *passwordHeader;

@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)passwordAction:(id)sender;
- (IBAction)verificationAction:(id)sender;

@end
