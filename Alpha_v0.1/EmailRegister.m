//
//  EmailRegister.m
//
//  Created by Lucas Pena on 5/31/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, LLC. All rights reserved.
//

#import "EmailRegister.h"

@interface EmailRegister ()

@end

@implementation EmailRegister

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
    [self initPage];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initPage
{
    self.capturedImages = [[NSMutableArray alloc] init];
    self.registerName.keyboardType = UIKeyboardTypeAlphabet;
    self.registerLName.keyboardType = UIKeyboardTypeAlphabet;
    if (self.viewFB == TRUE) {
        [self fsFBData];
    }
    self.registerName.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.registerLName.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.registerPass.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.registerPass2.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.imageView.layer.cornerRadius = self.imageView.frame.size.height/2;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderWidth = 0;
    self.headerLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    self.headerFN.font = [UIFont fontWithName:@"Lato-Regular" size:12];
    self.headerLN.font = [UIFont fontWithName:@"Lato-Regular" size:12];
    self.headerP.font = [UIFont fontWithName:@"Lato-Regular" size:12];
    self.headerPC.font = [UIFont fontWithName:@"Lato-Regular" size:12];
    self.headerAge.font = [UIFont fontWithName:@"Lato-Regular" size:18];
    self.ageValue.font = [UIFont fontWithName:@"Lato-Regular" size:18];
    self.headerSex.font = [UIFont fontWithName:@"Lato-Regular" size:18];
    [UserSingleton singleUser].age = [NSNumber numberWithDouble:18.0];
    dispatch_queue_t myQueue = dispatch_queue_create("fetchCollegeList",NULL);
    dispatch_async(myQueue, ^{
        [[UserSingleton singleUser] fetchColleges];
    });
}

#pragma mark - Text Views
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textfield
{
    [textfield resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 20) ? NO : YES;
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
    int movementDistance = 65;
    const float movementDuration = 0.15f;
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
    [self checkForwardButton];
}

#pragma mark - Image Picker

- (IBAction)selectPic:(id)sender
{
    self.picker.delegate = self;
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if (self.imageView.isAnimating)
    {
        [self.imageView stopAnimating];
    }
    
    if (self.capturedImages.count > 0)
    {
        [self.capturedImages removeAllObjects];
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.sourceType = sourceType;
    picker.delegate = self;
    
    
    self.picker = picker;
    [self presentViewController:self.picker animated:YES completion:nil];

}

- (void)finishAndUpdate
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if ([self.capturedImages count] > 0)
    {
        if ([self.capturedImages count] == 1)
        {
            // Camera took a single picture.
            [self.imageView setImage:[[self.capturedImages objectAtIndex:0] resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(300, 300) interpolationQuality:2]];
        }
        else
        {
            // Camera took multiple pictures; use the list of images for animation.
            self.imageView.animationImages = self.capturedImages;
            self.imageView.animationDuration = 5.0;    // Show each captured photo for 5 seconds.
            self.imageView.animationRepeatCount = 0;   // Animate forever (show all photos).
            [self.imageView startAnimating];
        }
        
        // To be ready to start again, clear the captured images array.
        [self.capturedImages removeAllObjects];
    }
    
    self.picker = nil;
}

#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self.capturedImages addObject:image];
    [self finishAndUpdate];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - Facebook Fetch and Set

- (void) fsFBData
{
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSDictionary *userData  = (NSDictionary *) result;
            
            NSString *facebookID = userData[@"id"];
            [UserSingleton singleUser].FbId = facebookID;
            NSString *name = userData[@"name"];
            NSString *gender = userData[@"gender"];
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            NSArray *nameArray = [ name componentsSeparatedByString:@" "];
            NSMutableString *fName = [[NSMutableString alloc] init];
            [fName appendString:nameArray[0]];
            for (int i = 1; i < nameArray.count-1; ++i)
            {
                [fName appendString:@" "];
                [fName appendString:nameArray[i]];
            }
            NSString *lName = [NSString stringWithString:nameArray[nameArray.count-1]];
            
            // Download the user's facebook profile picture
            self.imageData = [[NSMutableData alloc] init]; // the data will be loaded in here
            
            NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                      cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                  timeoutInterval:2.0f];
            // Run network request asynchronously
            NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
            NSLog(@"%@", urlConnection);
            self.registerName.text = fName;
            self.registerLName.text = lName;
            if ([gender isEqual: @"male"])
            {
                self.segmentSex.selectedSegmentIndex = 0;
                [UserSingleton singleUser].gender = @"male";
            }
            else if ( [gender isEqual: @"female"])
            {
                self.segmentSex.selectedSegmentIndex = 1;
                [UserSingleton singleUser].gender = @"female";

            }
            [self.imageView setImage:[[UIImage imageWithData:[UserSingleton singleUser].profilePic] resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(300, 300) interpolationQuality:2]];
            
            [[FBSession activeSession] closeAndClearTokenInformation];
            [[FBSession activeSession] close];
            [FBSession setActiveSession:nil];
        }
    }];
}

#pragma  mark - NSURL deletate methods

// Called every time a chunk of the data is received
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.imageData appendData:data]; // Build the image
}

// Called when the entire image is finished downloading
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Set the image in the header imageView
    self.imageView.image = [UIImage imageWithData:self.imageData];
    [UserSingleton singleUser].profilePic = UIImageJPEGRepresentation(self.imageView.image, 1);
}

#pragma mark - Age
- (IBAction)stepperAge:(id)sender {
    UIStepper *stepper = (UIStepper *) sender;
    double value = stepper.value;
    [self.ageValue setText:[NSString stringWithFormat:@"%d", (int)value]];
    [UserSingleton singleUser].age = [NSNumber numberWithDouble:value];
}

#pragma mark - Sex Segment
- (IBAction)segmentSexChange:(id)sender {
    if (self.segmentSex.selectedSegmentIndex == 0)
        [[UserSingleton singleUser] setGender:@"male"];
    else if (self.segmentSex.selectedSegmentIndex == 1)
        [[UserSingleton singleUser] setGender:@"female"];
    [self checkForwardButton];
}
#pragma mark - Navigation

-(void)checkForwardButton
{
    if ( ((self.registerName.text.length >= 1) && (self.registerLName.text.length >= 1)
        && (self.registerPass.text.length >= 1) && (self.registerPass2.text.length >= 1)) && ( (self.segmentSex.selectedSegmentIndex == 0) || (self.segmentSex.selectedSegmentIndex == 1)) )
        [self.headerImage setImage:[UIImage imageNamed:@"reg_teal"]];
    else
        [self.headerImage setImage:[UIImage imageNamed:@"reg_grey"]];
}

- (IBAction)buttonForward:(id)sender
{
    //check entered data
    if (self.registerName.text.length <= 1) {
        UIAlertView *check = [[UIAlertView alloc] initWithTitle:@"First Name Not Valid" message:@"first name must contain more than 1 letter" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [check show];
        self.registerName.text = @"";
        return;
    }
    if (self.registerLName.text.length <= 1) {
        UIAlertView *check = [[UIAlertView alloc] initWithTitle:@"Last Name Not Valid" message:@"last name must contain more than 1 letter" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [check show];
        self.registerLName.text = @"";
        return;
    }
    if (self.registerPass.text.length < 6) {
        UIAlertView *check = [[UIAlertView alloc] initWithTitle:@"Password Not Valid" message:@"password must contain at least 6 characters" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [check show];
        self.registerPass.text = @"";
        return;
    }
    if ([self.registerPass.text isEqualToString:self.registerPass2.text])
        NSLog(@"matching passwords");
    else
    {
        UIAlertView *check = [[UIAlertView alloc] initWithTitle:@"Passwords Do Not Match" message:@"password must match" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [check show];
        self.registerPass.text = @"";
        self.registerPass2.text = @"";
        return;
    }
    if ( (self.segmentSex.selectedSegmentIndex != 0) && (self.segmentSex.selectedSegmentIndex != 1) )
    {
        UIAlertView *check = [[UIAlertView alloc] initWithTitle:@"No Gender Association" message:@"please choose either 'Male' or 'Female'" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [check show];
        return;
    }
    NSData *myTempProfilePic = UIImageJPEGRepresentation(self.imageView.image, 1);
    if (myTempProfilePic == nil)
    {
        UIAlertView *check = [[UIAlertView alloc] initWithTitle:@"No Picture Selected" message:@"you can update that later" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    [check show];
    }
    
    //set data
    [UserSingleton singleUser].fName = self.registerName.text;
    [UserSingleton singleUser].lName = self.registerLName.text;
    NSMutableString *completename = [NSMutableString stringWithString:self.registerName.text];
    [completename appendString:@" "];
    [completename appendString:self.registerLName.text];
    [UserSingleton singleUser].fullName = completename;
    [UserSingleton singleUser].profilePic = UIImageJPEGRepresentation(self.imageView.image,1);
    [UserSingleton singleUser].tempPass = self.registerPass.text;
    [self performSegueWithIdentifier:@"schoolSelect" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"schoolSelect"])
    {
        CollegeSelect *cs = [segue destinationViewController];
        //  Registering Facebook User
        if (self.viewFB == TRUE) {
            [cs setViewFB:TRUE];
        }
        else
            //  Registering Email Only User
            [cs setViewFB:FALSE];
    }
}



@end
