//
//  CollegeSelect.m
//
//  Created by Lucas L. Pena on 6/5/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, LLC. All rights reserved.
//

#import "CollegeSelect.h"

@interface CollegeSelect ()

@end

@implementation CollegeSelect {
    NSArray *collegeBank;
    UIActivityIndicatorView *spinner;
    UIPickerView *collegePicker;
    UIPickerView *emailPicker;
    NSArray *currentEmails;
    NSString *pickedEmail;
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
    if (self.viewFB == FALSE)
    {
        self.loginView.hidden = YES;
    }
    else
    {
        self.finishButton.hidden = YES;
    }
    self.headerLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.emailLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12];
    self.collegeLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12];
    self.majorLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    self.registerMajor.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    self.registerMajor.delegate = self;
    self.registerMajor.tag = 1;
    self.registerCollege.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    self.atLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.registerCollege.keyboardType = UIKeyboardTypeEmailAddress;
    self.loginView.hidden = YES;
    for (id obj in self.loginView.subviews)
    {
        if ([obj isKindOfClass:[UILabel class]])
        {
            UILabel * loginLabel =  obj;
            loginLabel.text = @"finish Facebook registering & log out";
            loginLabel.textAlignment = NSTextAlignmentCenter;
            loginLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12];
            loginLabel.frame = CGRectMake(0, 5, 271, 37);
            
        }
    }
    self.finishButton.hidden = NO;
    [self.finishButton setBackgroundImage:[UIImage imageNamed:@"finish_button"] forState:UIControlStateNormal];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height/2-60)];
    [self.view addSubview:spinner];

    self.termsLabel.font = [UIFont fontWithName:@"Lato-Regular" size:12];
    
    dispatch_queue_t myQueue = dispatch_queue_create("fetchColleges",NULL);
    dispatch_async(myQueue, ^{
        collegeBank = [[NSArray alloc] initWithArray:[[UserSingleton singleUser] fetchColleges]];
        CGRect tmpFrame = CGRectMake(0, 80, 300, 20);
        collegePicker = [[UIPickerView alloc] initWithFrame:tmpFrame];
        collegePicker.center = CGPointMake(320/2, 160);
        collegePicker.delegate    = self;
        collegePicker.dataSource  = self;
        collegePicker.tag = 1;
        
        tmpFrame = CGRectMake(0, 80, 300, 20);
        emailPicker = [[UIPickerView alloc] initWithFrame:tmpFrame];
        emailPicker.center = CGPointMake(320/2, 355);
        emailPicker.delegate    = self;
        emailPicker.dataSource  = self;
        emailPicker.tag = 2;
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            currentEmails = [[NSArray alloc] initWithArray:collegeBank[0][@"emails"]];
            pickedEmail = [[NSString alloc] initWithString:currentEmails[0]];
            [UserSingleton singleUser].college = collegeBank[0][@"name"];
            [self.view addSubview:collegePicker];
            [self.view addSubview:emailPicker];
        });
        
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
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
    float movementDuration;
    int movement;
    if (textField.tag == 1)
    {
        int movementDistance = 165;
        movementDuration = 0.15f;
        movement = (up ? -movementDistance : movementDistance);
    }
    else {
        int movementDistance = 65;
        movementDuration = 0.15f;
        movement = (up ? -movementDistance : movementDistance);
    }
    const float movementDurationFinal = movementDuration;

    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDurationFinal];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (IBAction)confirmButton:(id)sender
{
    [UserSingleton singleUser].email = [[NSString stringWithFormat:@"%@%@", self.registerCollege.text, pickedEmail] lowercaseString];
    /*if ([self NSStringIsValidEmail:[UserSingleton singleUser].email ] == NO )
    {
        UIAlertView *check = [[UIAlertView alloc] initWithTitle:@"Email Invalid" message:@"please enter a valid email" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [check show];
        self.registerCollege.text = @"";
        return;
    }*/
    [self createUser];
}

- (void) createUser
{
    [spinner startAnimating];
    PFUser *user = [PFUser user];
    user.username = [UserSingleton singleUser].email;
    user[@"college"] = [UserSingleton singleUser].college;
    user.password =  [UserSingleton singleUser].tempPass;
    user.email = [UserSingleton singleUser].email;
    user[@"fullName"] =  [UserSingleton singleUser].fullName;
    user[@"fName"] =  [UserSingleton singleUser].fName;
    user[@"lName"] =  [UserSingleton singleUser].lName;
    PFFile *pic = [PFFile fileWithData:[UserSingleton singleUser].profilePic];
    user[@"profilePic"] =  pic;
    user[@"gender"] =  [UserSingleton singleUser].gender;
    user[@"age"] = [UserSingleton singleUser].age;
    user[@"xpForActivities"] = [UserSingleton singleUser].experienceForActivities;
    user[@"major"] = self.registerMajor.text;
    NSArray *empty = [[NSArray alloc] init];
    user[@"confirmedAds"] = empty;
    user[@"cornerArray"] = empty;
    if ([UserSingleton singleUser].FbId)
        user[@"fbid"] = [UserSingleton singleUser].FbId;
    user[@"aboutMe"] = [NSString stringWithFormat:@"I am a student at %@", user[@"college"]];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"Allow" forKey:@"Notification"];
    [defaults synchronize];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [spinner stopAnimating];
        if (!error) {
            [PFUser logOut];
            UIAlertView *check = [[UIAlertView alloc] initWithTitle:@"Welcome to SoFitU!" message:@"please confirm your email before logging in" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [check show];
            [self performSegueWithIdentifier:@"backToMain" sender:self];
        }
        else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"%@", errorString);
            UIAlertView *check = [[UIAlertView alloc] initWithTitle:@"Email Invalid" message:@"email already associated with account" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [check show];
            self.registerCollege.text = @"";
        }
    }];
    
}

#pragma mark - Picker View below
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:
(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (pickerView.tag == 1) {
        if (!tView){
            tView = [[UILabel alloc] init];
            tView.font = [UIFont fontWithName:@"Lato-Regular" size:16];
            tView.textAlignment = NSTextAlignmentCenter;
            tView.textColor = [UIColor whiteColor];
        }
        tView.text = collegeBank[row][@"name"];
    }
    else{
        if (!tView){
            tView = [[UILabel alloc] init];
            tView.font = [UIFont fontWithName:@"Lato-Regular" size:16];
            tView.textAlignment = NSTextAlignmentCenter;
            tView.textColor = [UIColor whiteColor];
        }
        tView.text = [currentEmails[row] substringFromIndex:1];
    }
    return tView;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)myPicker numberOfRowsInComponent: (NSInteger)component
{
    if (myPicker.tag == 1)
        return collegeBank.count;
    else return currentEmails.count;
}
-(NSString *)pickerView:(UIPickerView *)myPicker titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    if (myPicker.tag == 1)
        return [collegeBank objectAtIndex:row][@"name"];
    else
        return [currentEmails objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)myPicker didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    if (myPicker.tag == 1)
    {
        NSDictionary *collegeObj = [collegeBank objectAtIndex:[myPicker selectedRowInComponent:0]];
        [UserSingleton singleUser].college = collegeObj[@"name"];
        currentEmails = collegeObj[@"emails"];
        pickedEmail = currentEmails[0];
        [emailPicker reloadAllComponents];
    }
    else {
        pickedEmail = currentEmails[row];
    }
}
@end
