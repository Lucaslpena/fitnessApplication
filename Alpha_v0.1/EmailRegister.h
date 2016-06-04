//
//  EmailRegister.h
//
//  Created by Lucas Pena on 5/31/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserSingleton.h"
#import "CollegeSelect.h"
#import <FacebookSDK/FacebookSDK.h>
#import "UIImage+Resize.h"

@interface EmailRegister : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, NSURLConnectionDataDelegate>

-(void)initPage;

//headers
@property (strong, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerFN;
@property (weak, nonatomic) IBOutlet UILabel *headerLN;
@property (weak, nonatomic) IBOutlet UILabel *headerP;
@property (weak, nonatomic) IBOutlet UILabel *headerPC;
@property (weak, nonatomic) IBOutlet UILabel *headerAge;
@property (weak, nonatomic) IBOutlet UILabel *headerSex;

//registration values
@property (weak, nonatomic) IBOutlet UITextField *registerName;
@property (weak, nonatomic) IBOutlet UITextField *registerLName;
@property (weak, nonatomic) IBOutlet UITextField *registerPass;
@property (weak, nonatomic) IBOutlet UITextField *registerPass2;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentSex;
- (IBAction)segmentSexChange:(id)sender;
- (IBAction)stepperAge:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *ageValue;

//profile picture selector
@property (nonatomic) UIImagePickerController *picker;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic) NSMutableArray *capturedImages;
- (IBAction)selectPic:(id)sender;

//navigation
- (IBAction)buttonForward:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
-(void) checkForwardButton;

//PushedThroughFacebook
@property BOOL viewFB;
-(void) fsFBData;
@property (nonatomic, strong) NSMutableData *imageData;

@end
