//
//  CornersDetailViewController.m
//
//  Created by Lucas L. Pena on 8/9/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import "CornersDetailViewController.h"

@interface CornersDetailViewController ()

@end

@implementation CornersDetailViewController{
    UIPickerView *pickerViewActivity;
    NSMutableArray *activityList;
    BOOL isModifying;
    int startingPickerRow;
    BOOL loadFromSingleton;
    NSMutableArray *totalConnectList;
    
    UIColor* navy;
    UIColor* teal;
    UIColor* orange;
    UIColor* salmon;
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
    [self.navigationController setDelegate:self];
    self.connectList = [[NSMutableArray alloc] init];
    activityList = [[NSMutableArray alloc] init];
    teal = [[UIColor alloc]
                       initWithRed: 47/255.0
                       green:      190/255.0
                       blue:       190/255.0
                       alpha:      1.0];
    salmon = [[UIColor alloc]
                       initWithRed: 227/255.0
                       green:      92/255.0
                       blue:       73/255.0
                       alpha:      1.0];
    navy = [[UIColor alloc]
                       initWithRed: 0/255.0
                       green:      57/255.0
                       blue:       77/255.0
                       alpha:      1.0];
    orange = [[UIColor alloc]
                         initWithRed: 230/255.0
                         green:      150/255.0
                         blue:       46/255.0
                         alpha:      1.0];
    
    self.view.backgroundColor = navy;
    
    //self.backButton.backgroundColor = self.teal;
    self.saveButton.backgroundColor = salmon;
    //self.deleteButton.backgroundColor = self.orange;
    //self.addButton.backgroundColor = self.orange;
    self.nameField.backgroundColor = [UIColor colorWithWhite:1 alpha:.5];
    
    self.backButton.layer.cornerRadius = 5;
    self.saveButton.layer.cornerRadius = 5;
    self.deleteButton.layer.cornerRadius = 5;
    
    self.backButton.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14];
    self.saveButton.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14];
    self.deleteButton.titleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14];
    self.nameField.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.nameField.textColor = [UIColor whiteColor];
    
    [self.backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton addTarget:self action:@selector(saveAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [pickerViewActivity selectedRowInComponent:0];
    CGRect tmpFrame = CGRectMake(60,5, 100, 100);
    pickerViewActivity= [[UIPickerView alloc] initWithFrame:tmpFrame];
    pickerViewActivity.center = CGPointMake(self.view.frame.size.width/2, pickerViewActivity.center.y);
    pickerViewActivity.delegate    = self;
    pickerViewActivity.dataSource  = self;
    [self.view addSubview:pickerViewActivity];
    [self.view sendSubviewToBack:pickerViewActivity];
    activityList = [[NSMutableArray alloc] initWithArray:[[UserSingleton singleUser] fetchActivityListTeam]];
    [activityList addObjectsFromArray:[[UserSingleton singleUser] fetchActivityListIndividual]];
    [activityList sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    [UserSingleton singleUser].myPairUpAd.activity = [activityList objectAtIndex:0];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 164, 320, 343)];
    [self.tableView setTag:2];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 30;
    self.tableView.scrollEnabled = YES;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.tableView.userInteractionEnabled = YES;
    self.tableView.bounces = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsMultipleSelection = YES;
    //[tableView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];

    [self.view addSubview:self.tableView];
    
    totalConnectList = [[NSMutableArray alloc] init];
    [PFCloud callFunctionInBackground:@"fetchConnects" withParameters:@{@"forUser" : [PFUser currentUser].objectId}
                                block:^(NSArray* result, NSError *error) {
                                    if (!error) {
                                        if (result.count == 0) {
                                            return;
                                        }
                                        for (PFUser *thisUser in result)
                                        {
                                            [thisUser refresh];
                                            [totalConnectList addObject:thisUser];
                                        }
                                        [self.tableView reloadData];
                                    }
                                }];
    self.nameField.delegate = self;
    [UserSingleton singleUser].cornerObject = self.cornerObject;
    if (!self.cornerObject) {
        self.cornerObject = [[NSMutableDictionary alloc] init];
    }
    else {
        isModifying = YES;
        [self initModifying];
    }
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([UserSingleton singleUser].cornerUser)
    {
        if (loadFromSingleton == YES) {
            loadFromSingleton = NO;
            bool dontAdd = NO;
            for (PFUser *connectUser in self.connectList){
                if ([[UserSingleton singleUser].cornerUser.objectId isEqualToString:connectUser.objectId]) {
                    dontAdd = YES;
                }
            }
            if (dontAdd == NO) {
                [self.connectList addObject:[UserSingleton singleUser].cornerUser];
                [self.tableView reloadData];
            }
            [UserSingleton singleUser].cornerUser = nil;
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
-(void)viewDidDisappear:(BOOL)animated {
    [UserSingleton singleUser].cornerObject = nil;
}
#pragma mark - Modyfing Initaliziers are here
-(void)initModifying{
    self.nameField.text = [self.cornerObject objectForKey:@"name"];
    NSString *activity = [NSString stringWithString:[self.cornerObject objectForKey:@"activity"]];
    startingPickerRow = 0;
    for (int i = 0; i < activityList.count; ++i)
    {
        if ([activityList[i] isEqualToString:activity]) {
            startingPickerRow = i;
        }
    }
    [pickerViewActivity selectRow:startingPickerRow inComponent:0 animated:YES];
    self.connectList = [self.cornerObject objectForKey:@"users"];
    [self.tableView reloadData];
}

#pragma mark - Table and Table Data
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [totalConnectList count];
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
    PFUser *resultUser = [totalConnectList objectAtIndex:indexPath.row];
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
    [ccCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [ccCell hilightMe:NO];
    for (PFUser *thisUser in self.connectList)
    {
        if ([thisUser[@"fullName"] isEqualToString:fullName])
        {
            [ccCell hilightMe:YES];
            [self.tableView selectRowAtIndexPath:indexPath animated:false scrollPosition:UITableViewScrollPositionNone];
        }
    }
    return ccCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConnectsCustomCell *cell = (ConnectsCustomCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell hilightMe:YES];
    PFUser *selectedUser = totalConnectList[indexPath.row];
    [self.connectList addObject:selectedUser];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConnectsCustomCell *cell = (ConnectsCustomCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell hilightMe:NO];
    PFUser *selectedUser = totalConnectList[indexPath.row];
    for (int i = 0; i < self.connectList.count; ++i)
    {
        PFUser *thisUser = self.connectList[i];
        if ([thisUser[@"fullName"] isEqualToString:selectedUser[@"fullName"]])
        {
            [self.connectList removeObjectAtIndex:i];
            --i;
        }
    }
}

#pragma mark - Users
/*-(void) addUser:(PFUser *)connectUser;
{
    bool addUser = YES;
    for (PFUser *compareduser in self.connectList) {
        if ([connectUser.objectId isEqual:compareduser.objectId])
    }
    if (addUser == YES)
        
    
}*/
#pragma mark - Picker View below
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
        tView.font = [UIFont fontWithName:@"Lato-Regular" size:14];
        tView.textAlignment = NSTextAlignmentCenter;
        tView.textColor = [UIColor whiteColor];
    }
    tView.text =activityList[row];
    return tView;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)myPicker numberOfRowsInComponent: (NSInteger)component
{
    return activityList.count;
    
}
-(NSString *)pickerView:(UIPickerView *)myPicker titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return [activityList objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)myPicker didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    NSString *chosenActivity = [activityList objectAtIndex:[myPicker selectedRowInComponent:0]];
    [self.cornerObject setObject:chosenActivity forKey:@"activity"];
}

#pragma mark - Text Field
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 20) ? NO : YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSString *nameString = textField.text;
    if (nameString.length > 0)
        [self.cornerObject setObject:nameString forKey:@"name"];
    else
        [self.cornerObject removeObjectForKey:@"name"];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - Navigation
- (IBAction)backAction:(id)sender {
    UIAlertView *check = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Changes have not been saved" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
    [check show];
    [self performSegueWithIdentifier:@"viewCorners" sender:self];
}
- (IBAction)saveAction:(id)sender {
    NSString *nameString = [self.cornerObject objectForKey:@"name"];
    if (!nameString) {
        UIAlertView *check = [[UIAlertView alloc] initWithTitle:@"No Name Given" message:@"Please enter a name to identify the Corner" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [check show];
        return;
    }
    if (self.connectList.count == 0) {
        UIAlertView *check = [[UIAlertView alloc] initWithTitle:@"No Group Members" message:@"Please select atleast one group member" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [check show];
        return;
    }
    if (!isModifying) {
        NSMutableArray *userArray = [[NSMutableArray alloc] initWithArray:self.connectList];
        [self.cornerObject setObject:userArray forKey:@"users"];
        NSMutableArray *cornersArray = [ [NSMutableArray alloc] initWithArray:[PFUser currentUser][@"cornerArray"] ];
        [cornersArray addObject:self.cornerObject];
        [PFUser currentUser][@"cornerArray"] = cornersArray;
        [[PFUser currentUser] save];
        [[PFUser currentUser] refresh];
    }
    if (isModifying) {
        NSMutableArray *userArray = [[NSMutableArray alloc] initWithArray:self.connectList];
        [self.cornerObject setObject:userArray forKey:@"users"];
        NSMutableArray *cornersArray = [ [NSMutableArray alloc] initWithArray:[PFUser currentUser][@"cornerArray"] ];
        bool doNotAd = NO;
        for (int i = 0; i < cornersArray.count; ++i) {
            NSDictionary *cornerObject = [[NSDictionary alloc] initWithDictionary:cornersArray[i]];
            if ([[cornerObject objectForKey:@"name"] isEqual:[self.cornerObject objectForKey:@"name"]]) {
                doNotAd = YES;
            }
            if (doNotAd == YES) { //update THAT one not append
                cornersArray[i] = self.cornerObject;
                break;
            }
        }
        if (doNotAd == NO) {
            [cornersArray addObject:self.cornerObject];
        }
        [PFUser currentUser][@"cornerArray"] = cornersArray;
        [[PFUser currentUser] save];
        [[PFUser currentUser] refresh];
    }
    [self performSegueWithIdentifier:@"viewCorners" sender:self];
}
- (IBAction)deleteAction:(id)sender {
     if (isModifying) {
         NSMutableArray *cornersArray = [[NSMutableArray alloc] initWithArray:[PFUser currentUser][@"cornerArray"]];
         for (int i = 0; i < cornersArray.count; ++i) {
             NSDictionary *cornerObject = cornersArray[i];
             NSString *compareTitle = [cornerObject objectForKey:@"name"];
             NSString *currentTitle = [self.cornerObject objectForKey:@"name"];
             if ([compareTitle isEqualToString:currentTitle]) {
                 [cornersArray removeObject:cornerObject];
                 --i;
             }
         }
         [PFUser currentUser][@"cornerArray"] = cornersArray;
         [[PFUser currentUser] save];
         [[PFUser currentUser] refresh];
     }
    [self performSegueWithIdentifier:@"viewCorners" sender:self];
}
- (IBAction)addAction:(id)sender {
    loadFromSingleton = YES;
    [self performSegueWithIdentifier:@"viewConnects" sender:self];
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"viewCorners"])
    {
        NSMutableArray *userArray = [[NSMutableArray alloc] initWithArray:self.connectList];
        [self.cornerObject setObject:userArray forKey:@"users"];
        CornersView *cV = [[CornersView alloc] init];
        cV = [segue destinationViewController];
    }
}
@end
