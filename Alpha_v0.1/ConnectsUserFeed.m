//
//  ConnectsUserFeed.m
//
//  Created by Lucas L. Pena on 7/31/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena All rights reserved.
//

#import "ConnectsUserFeed.h"

@interface ConnectsUserFeed ()

@end

@implementation ConnectsUserFeed
{
    NSMutableArray *recievingArray;
    BOOL hideAdd;
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
    self.tableView.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES];
    [self initPage];
    recievingArray = [[NSMutableArray alloc] initWithArray:self.confirmedConnects];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)initPage
{
    if (!self.confirmedConnects) {
        hideAdd = YES;
        [PFCloud callFunctionInBackground:@"fetchConnects" withParameters:@{@"forUser" : [PFUser currentUser].objectId}
                                block:^(NSArray* result, NSError *error) {
                                    if (!error) {
                                        if (result.count == 0) {
                                            self.tableView.hidden = YES;
                                            return;
                                        }
                                        [recievingArray addObjectsFromArray:result];
                                        self.tableView.hidden = NO;
                                        [self.tableView reloadData];
                                        [UserSingleton singleUser].confirmedConnectedUsers = [[NSArray alloc] initWithArray:result];
                                    }
                                }];
    }
    else
        self.tableView.hidden = NO;
}
#pragma mark - Table and Table Data
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [recievingArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomConnectsCell";
    ConnectsCustomCell *ccCell = (ConnectsCustomCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (ccCell == nil) {
        ccCell = [[ConnectsCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    PFUser *resultUser = [recievingArray objectAtIndex:indexPath.row];
    [resultUser fetchIfNeeded];
    // Display friend data in the table cell
    NSString* fullName = resultUser[@"fullName"];
    ccCell.userName.text = fullName;
    ccCell.userName.font = [UIFont fontWithName:@"Lato-Bold" size:16];
    PFFile *profilePic = resultUser[@"profilePic"];
    [profilePic getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error)
            ccCell.userPic.image = [UIImage imageWithData:data];
    }];
    ccCell.userPic.layer.cornerRadius = ccCell.userPic.frame.size.height/2;
    ccCell.userPic.layer.masksToBounds = YES;
    ccCell.userPic.layer.borderWidth = 0;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return ccCell;
}

#pragma mark - Navigation
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"profileView"])
    {
        PFUser *selectedUser;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        selectedUser= [recievingArray objectAtIndex:indexPath.row];
        
        ProfilePage *pp = [segue destinationViewController];
        [pp setPageOwner:selectedUser];
        if (hideAdd == YES) {
            pp.friendButton.hidden = YES;
        }
    }
}

@end
