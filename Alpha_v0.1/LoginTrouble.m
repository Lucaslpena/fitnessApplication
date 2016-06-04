//
//  LoginTrouble.m
//
//  Created by Lucas Pena on 8/20/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, LLC. All rights reserved.
//

#import "LoginTrouble.h"

@interface LoginTrouble ()

@end

@implementation LoginTrouble
{
    UIActivityIndicatorView *spinner;
}

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
    self.topHeader.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.emailHeader.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.passwordHeader.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.emailField.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.passwordField.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.buttomHeader.font = [UIFont fontWithName:@"Lato-Regular" size:10];
    
    self.verificationButton.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    [self.verificationButton setBackgroundColor:[UIColor colorWithRed:227/255.0 green:92/255.0 blue:73/255.0 alpha:1]];
    self.verificationButton.layer.cornerRadius = 3;
    self.verificationButton.layer.masksToBounds = YES;
    
    self.passwordButton.titleLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    
    self.emailField.delegate = self;
    self.passwordField.delegate = self;
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
    [spinner setCenter:CGPointMake(self.view.frame.size.width / 2, 100)];
    [self.view addSubview:spinner];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - TextField
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textfield
{
    [textfield resignFirstResponder];
    [self.view endEditing:YES];
    return YES;
}
#pragma mark - Button Actions
- (IBAction)passwordAction:(id)sender {
    if ( [self fieldCheck:NO] == true) {
        [spinner startAnimating];
        UIAlertView *confirmReset = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Reset password for %@", self.emailField.text] message:@"Instructions will be sent to your email" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
        confirmReset.tag = 0;
        [confirmReset show];
    }
}
- (IBAction)verificationAction:(id)sender {
    if ( [self fieldCheck:YES] == true) {
        [spinner startAnimating];
        UIAlertView *confirmResend = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Resend cofirmation email to %@", self.emailField.text] message:@"Link will be sent to your email" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
        confirmResend.tag = 1;
        [confirmResend show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ( (buttonIndex == 1) && (alertView.tag == 0) ) {
        [PFUser requestPasswordResetForEmailInBackground:self.emailField.text block:^(BOOL succeeded, NSError *error) {
            if (!error) {
                UIAlertView *sentEmail = [[UIAlertView alloc] initWithTitle:@"Reset Sent" message:@"Check your email soon for reset instructions" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                [sentEmail show];
            }
            else {
                UIAlertView *invalidEmail = [[UIAlertView alloc] initWithTitle:@"Invalid Email" message:@"Check the given email" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                [invalidEmail show];
            }
            [spinner stopAnimating];
        }];
    }
    else if ( (buttonIndex == 1) && (alertView.tag == 1) ) {
        
        [PFUser logInWithUsernameInBackground:self.emailField.text password:self.passwordField.text block:^(PFUser *user, NSError *error) {
            if (user) {
                user[@"emailVerified"] = @NO;
                [user setEmail:self.emailField.text];
                [user save];
                UIAlertView *sentEmail = [[UIAlertView alloc] initWithTitle:@"Sent Confirmation Email" message:@"Check your email soon for confirmation instructions" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                [sentEmail show];
                [PFUser logOut];
            }
            else
            {
                UIAlertView *invalidEmail = [[UIAlertView alloc] initWithTitle:@"Invalid Login" message:@"Check the given email and password" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                [invalidEmail show];
            }
            [spinner stopAnimating];
        }];
    }
    else if (buttonIndex == 3) {
    }
}
#pragma mark - FieldCheck
-(BOOL)fieldCheck:(BOOL)password
{
    if ([self.emailField.text isEqualToString:@""]) {
        UIAlertView *emptyEmail = [[UIAlertView alloc] initWithTitle:@"Empty Email" message:@"Please enter your college Email" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [emptyEmail show];
        return false;
    }
    
    if ( (password) && ([self.passwordField.text isEqualToString:@""]) )
    {
        UIAlertView *emptyPassword = [[UIAlertView alloc] initWithTitle:@"Empty Password" message:@"Your pass" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [emptyPassword show];
        return false;
    }
    else
        return true;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
