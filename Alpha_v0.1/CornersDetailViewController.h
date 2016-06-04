//
//  CornersDetailViewController.h
//
//  Created by Lucas L. Pena on 8/9/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena,  All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ConnectsCustomCell.h"
#import "ConnectsUserFeed.h"
#import "CornersView.h"
#import "UserSingleton.h"

@interface CornersDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource,UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *connectList;

@property (strong, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)backAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)saveAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteAction:(id)sender;

@property (strong, nonatomic) IBOutlet NSMutableDictionary *cornerObject;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
-(void) initModifying;

@end
