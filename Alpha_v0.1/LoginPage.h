//
//  LoginPage.h
//  Alpha_v0.1
//
//  Created by Lucas Pena on 2/10/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "UserSingleton.h"
#import "EmailRegister.h"
#import "SWRevealViewController.h"
#import "FitnessFeedView.h"
#import "SideBarTable.h"

@interface LoginPage : UIViewController <FBLoginViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *backHolderLogo;

@property (nonatomic) IBOutlet UITextField *email;
@property (nonatomic) IBOutlet UITextField *password;

- (IBAction)registerEmail:(id)sender;
- (IBAction)login:(id)sender;

-(void)saveUserContinue:(PFUser *)mainUser;

@property (strong, nonatomic) IBOutlet FBLoginView *loginView;
@property BOOL viewFB;
@property BOOL textFieldView;
@property (strong, nonatomic) IBOutlet UIButton *registerEmail;
@property (strong, nonatomic) IBOutlet UIButton *loginEmail;

- (IBAction)animateback:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *needRegisterButton;
@property (strong, nonatomic) IBOutlet UIButton *hasTroubleButton;
- (IBAction)loginTrouble:(id)sender;

@end
