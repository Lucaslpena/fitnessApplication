//
//  AccountsViewController.m
//
//
//  Created by Dev on 12/2/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import "AccountsViewController.h"

@interface AccountsViewController ()

@end

@implementation AccountsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundImage.image = [UIImage imageNamed:@"connectwfacebook"];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Facebook
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    [PFUser currentUser][@"fbid"] = user.objectID;
    [[PFUser currentUser] saveInBackground];
    [[UserSingleton singleUser] fetchFbFriends];
}
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    [self.backgroundImage setImage:[UIImage imageNamed:@"disconnectwfacebook"]];
}
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.backgroundImage.image = [UIImage imageNamed:@"connectwfacebook"];
    [PFUser currentUser][@"fbid"] = @"";
    [[PFUser currentUser] saveInBackground];
    [[FBSession activeSession] closeAndClearTokenInformation];
    [[FBSession activeSession] close];
    [FBSession setActiveSession:nil];
    NSMutableArray *empty = [[NSMutableArray alloc] init];
    [UserSingleton singleUser].FBconnects = empty;
}
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
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
@end
