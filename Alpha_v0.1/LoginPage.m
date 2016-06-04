//
//  LoginPage.m
//  Alpha_v0.1
//
//  Created by Lucas Pena on 2/10/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, LLC. All rights reserved.
//

#import "LoginPage.h"

@interface LoginPage ()
{
    dispatch_queue_t(loadQueue);
}

@end

@implementation LoginPage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textFieldView = NO;
    self.password.tag = 1;
    self.password.hidden = YES;
    self.email.hidden = YES;
    self.needRegisterButton.hidden = YES;
    self.hasTroubleButton.hidden = YES;
    [self.registerEmail.titleLabel setFont:[UIFont fontWithName:@"Lato-Regular" size:16]];
    [UserSingleton singleUser].FbId = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.loginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
    [[FBSession activeSession] closeAndClearTokenInformation];
    [[FBSession activeSession] close];
    [FBSession setActiveSession:nil];
    
    self.email.textColor = [UIColor whiteColor];
    self.password.textColor = [UIColor whiteColor];
        
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        dispatch_async(loadQueue, ^{
            [NSThread sleepForTimeInterval:.5];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self saveUserContinue:currentUser];
            });
        });
        [self saveUserContinue:currentUser];
    }
    
    for (id obj in self.loginView.subviews)
    {
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.text = @"register with facebook";
            loginLabel.textAlignment = NSTextAlignmentCenter;
            loginLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
            loginLabel.frame = CGRectMake(0, 5, 271, 37);
            
        }
    }
    self.email.font = [UIFont fontWithName:@"Lato-Black" size:16];
    self.password.font = [UIFont fontWithName:@"Lato-Black" size:16];
    self.needRegisterButton.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    self.hasTroubleButton.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Animations
-(void) animateFields
{
    [UIView animateWithDuration:0.25 animations:^{
        self.email.center = CGPointMake(160, 322);
        self.password.center = CGPointMake(160, 374);
        self.needRegisterButton.center  = CGPointMake(255, 464);
        self.hasTroubleButton.center  = CGPointMake(55, 464);
        self.registerEmail.center = CGPointMake(500, 291);
        self.loginView.center = CGPointMake(500, 338);
        
    } completion:^(BOOL finished) {
        self.loginView.hidden = YES;
        self.registerEmail.hidden = YES;
        self.password.hidden = NO;
        self.email.hidden = NO;
        self.needRegisterButton.hidden = NO;
        self.hasTroubleButton.hidden = NO;
    }];
    self.textFieldView = YES;
}
- (IBAction)animateback:(id)sender {
    self.loginView.hidden = NO;
    self.registerEmail.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.email.center = CGPointMake(-154, 322);
        self.password.center = CGPointMake(-154, 374);
        self.loginView.center  = CGPointMake(160, 346);
        self.registerEmail.center = CGPointMake(160, 291);
        self.needRegisterButton.center = CGPointMake(-76, 464);
        self.hasTroubleButton.center = CGPointMake(-198, 464);
    } completion:^(BOOL finished) {
        self.password.hidden = YES;
        self.email.hidden = YES;
        self.needRegisterButton.hidden = YES;
        self.hasTroubleButton.hidden = YES;
    }];
    self.textFieldView = NO;
}

#pragma mark - Facebook
// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    //self.profilePictureView.profileID = user.objectID;
}

// Logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    [self setViewFB:TRUE];
    [self performSegueWithIdentifier:@"registerUser" sender:self];
}

// Logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}
#pragma mark - Text Views
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textfield
{
    [textfield resignFirstResponder];
    if (textfield.tag == 1) {
        [self login:self];
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}
- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    int movementDistance = 75;
    const float movementDuration = 0.15f;
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

#pragma mark - Login & Navigation
- (IBAction)registerEmail:(id)sender
{
    [self performSegueWithIdentifier:@"registerUser" sender:self];
}
- (IBAction)login:(id)sender
{
    if (self.textFieldView == NO)
    {
        [self animateFields];
        return;
    }
    NSString *email = [self.email.text lowercaseString];
    [PFUser logInWithUsernameInBackground:email password:self.password.text block:^(PFUser *user, NSError *error) {
        
        NSString *errorString = [error userInfo][@"error"];
        if ([[user objectForKey:@"emailVerified"] boolValue])
        {
            [self saveUserContinue:user];
        }
        else if ([errorString isEqualToString:@"invalid login credentials"])
        {
            UIAlertView *falselogin = [[UIAlertView alloc] initWithTitle:@"False Login Information" message:@"Your email and password combination is not valid" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [falselogin show];
        }
        else if (![[user objectForKey:@"emailVerified"] boolValue])
        {
            UIAlertView *check = [[UIAlertView alloc] initWithTitle:@"Email not Verified" message:@"please verify email associated with account" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [check show];
        }
        else{}
        self.password.text = @"";
    }];
}
- (IBAction)loginTrouble:(id)sender {
    [self performSegueWithIdentifier:@"loginTrouble" sender:self];
}

-(void)saveUserContinue:(PFUser *)mainUser
{
    [UserSingleton singleUser].tutorial = 7;
    [UserSingleton setSingleUser:mainUser];
    [self performSegueWithIdentifier:@"login" sender:self];
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    //  Registering User is below//
    if ([[segue identifier] isEqualToString:@"registerUser"])
    {
        NSLog(@"Registering User");
        
        EmailRegister *em = [segue destinationViewController];
        //  Registering Facebook User
        if (self.viewFB == TRUE) {
            [em setViewFB:TRUE];
        }
        else
        //  Registering Email Only User
            [em setViewFB:FALSE];
    }
    
    //  Automated Login is below  //
    if ([[segue identifier] isEqualToString:@"login"])
    {
        
    }
    if ([[segue identifier] isEqualToString:@"loginTrouble"])
    {
        
    }
    
}
@end
