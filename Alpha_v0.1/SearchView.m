//
//  SearchView.m
//
//
//  Created by Lucas L. Pena on 7/10/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import "SearchView.h"

@interface SearchView ()
{
    NSArray *searchResults;
    bool    firstLoad;
    UILabel *emptyLabel;
}

@end

@implementation SearchView

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
    firstLoad = YES;
    searchResults = [[NSArray alloc] init];
    [self.navigationController setNavigationBarHidden:YES];
    self.searchField.delegate = self;
    [self setNeedsStatusBarAppearanceUpdate];
    self.tableView.hidden = YES;
    self.searchField.font = [UIFont fontWithName:@"Lato-Regular" size:18];
    searchResults = [UserSingleton singleUser].FBconnects;
    emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, 320, 40)];
    emptyLabel.text = @"No Users to Display";
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    emptyLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:emptyLabel];
    emptyLabel.hidden = YES;
    if  ([[PFUser currentUser][@"fbid"] length] > 1)
        self.noAccountsButton.hidden = YES;
    else
        self.noAccountsButton.hidden = NO;
    UIColor *orange = [[UIColor alloc]
                                      initWithRed: 230/255.0
                                      green:      150/255.0
                                      blue:       46/255.0
                                      alpha:      1.0];
    [self.noAccountsButton setTitleColor:orange forState:UIControlStateNormal];
}
- (void)viewDidAppear:(BOOL)animated
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Text View
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""])
        return;
    [self search:self];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textfield
{
    [textfield resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.tableView.hidden = YES;
}

#pragma mark - Search Function
- (IBAction)search:(id)sender {
    firstLoad = NO;
    [PFCloud callFunctionInBackground:@"searchUsers" withParameters:@{@"college" : [PFUser currentUser][@"college"], @"searchString" : self.searchField.text}
                                block:^(NSArray* result, NSError *error) {
                                    if (!error) {
                                        searchResults = result;
                                        if (searchResults.count > 0)
                                        {
                                            [self.tableView reloadData];
                                            self.tableView.hidden = NO;
                                        }
                                    }
                                }];
    [self.searchField endEditing:YES];
}

#pragma mark - Table and Table Data
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if  (firstLoad == YES)
        return @"Reccomended / Facebook friends";
    else return @"";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ((searchResults.count == 0) && (firstLoad == NO)) {
        emptyLabel.hidden = NO;
        self.tableView.hidden = YES;
    }
    else if (searchResults.count == 0)
    {
        self.tableView.hidden = YES;
        emptyLabel.hidden = NO;
    }
    else {
        self.tableView.hidden = NO;
        emptyLabel.hidden = YES;
    }
    return [searchResults count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomConnectsCell";
    ConnectsCustomCell *ccCell = (ConnectsCustomCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (ccCell == nil) {
        ccCell = [[ConnectsCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    PFUser *resultUser = [searchResults objectAtIndex:indexPath.row];

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
        selectedUser= [searchResults objectAtIndex:indexPath.row];
        
        ProfilePage *pp = [segue destinationViewController];
        [pp setPageOwner:selectedUser];
    }
}
@end
