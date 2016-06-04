//
//  SearchView.h
//
//
//  Created by Lucas L. Pena on 7/10/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "UserSingleton.h"
#import "ConnectsCustomCell.h"
#import "ProfilePage.h"
#import "AccountsViewController.h"

@interface SearchView : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)search:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *noAccountsButton;

@end
