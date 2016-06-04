//
//  Settings.m
//  Alpha_v0.1
//
//  Created by Lucas Pena on 3/27/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import "Settings.h"

@interface Settings ()

@end

@implementation Settings {
    NSMutableDictionary *optionDictionary;
    NSArray *optionOrder;
    NSString *webAdress;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    self.versionHeader.font = [UIFont fontWithName:@"Lato-Regular" size:12];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    optionDictionary = [[NSMutableDictionary alloc] init];
    optionOrder = [NSArray arrayWithObjects:@"User Name", @"Manage Accounts",@"Notifications", @"Contact",@"More Information", @" ", nil];
    for (NSString *str in optionOrder)
    {
        NSMutableArray *holder = [[NSMutableArray alloc] init];
        if ([str isEqualToString:@"User Name"])
        {
            [holder addObject:[PFUser currentUser][@"fullName"]];
            [optionDictionary setObject:holder forKey:@"User Name"];
        }
        else if ([str isEqualToString:@"Manage Accounts"])
        {
            [holder addObject:@"Facebook"];
            [optionDictionary setObject:holder forKey:@"Manage Accounts"];

        }
        else if ([str isEqualToString:@"Notifications"])
        {
            [holder addObject:@"Allow Notifications"];
            [optionDictionary setObject:holder forKey:@"Notifications"];
        }
        else if ([str isEqualToString:@"Contact"])
        {
            [holder addObject:@"Support"];
            [optionDictionary setObject:holder forKey:@"Contact"];
        }
        else if ([str isEqualToString:@"More Information"])
        {
            [holder addObject:@"Privacy Policy"];
            [holder addObject:@"Terms of Service"];
            [optionDictionary setObject:holder forKey:@"More Information"];

        }
        else if ([str isEqualToString:@" "])
        {
            [holder addObject:@"Log Out"];
            [optionDictionary setObject:holder forKey:@" "];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table and Table Data
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionTitle = [optionOrder objectAtIndex:section];
    NSArray *sectionAds = [optionDictionary objectForKey:sectionTitle];
    return sectionAds.count;
}

//section here
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return optionOrder.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [optionOrder objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionTitle = [optionOrder objectAtIndex:indexPath.section];
    NSArray *sectionAds = [optionDictionary objectForKey:sectionTitle];
    NSString *optString = [sectionAds objectAtIndex:indexPath.row];
    NSString *CellIdentifier = @"";
    
    if ([sectionTitle isEqualToString:@"User Name"])
    {
        CellIdentifier = @"TextField";
        SettingCell *sCell = (SettingCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [sCell initCell];
        sCell.textField.text = optString;
        sCell.textField.delegate = self;
        sCell.textField.returnKeyType = UIReturnKeyDone;
        sCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return sCell;
    }
    else if ([sectionTitle isEqualToString:@"Notifications"])
    {
        CellIdentifier = @"Bool";
        SettingCell *sCell = (SettingCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [sCell initCell];
        sCell.cellLabelBool.text = optString;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *compare = [defaults stringForKey:@"Notifications"];
        if ([compare isEqualToString:@"Block"]) {
            [sCell.mySwitch setOn:NO];
        }
        else
            [sCell.mySwitch setOn:YES];
        [sCell.mySwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        sCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return sCell;
    }
    else if ([sectionTitle isEqualToString:@" "])
    {
        CellIdentifier = @"Button";
        SettingCell *sCell = (SettingCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [sCell initCell];
        sCell.button.text = optString;
        return sCell;
    }
    else
    {
        CellIdentifier = @"Disclosure";
        SettingCell *sCell = (SettingCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        [sCell initCell];
        sCell.cellLabelDisclosure.text = optString;
        return sCell;
    }
 }
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingCell *sCell = (SettingCell *)[tableView cellForRowAtIndexPath:indexPath];
    webAdress = [[NSString alloc] init];
    if ([sCell.button.text isEqualToString:@"Log Out"]) {
        [PFUser logOut];
        [[FBSession activeSession] closeAndClearTokenInformation];
        [[FBSession activeSession] close];
        [FBSession setActiveSession:nil];
        [self performSegueWithIdentifier:@"Logout" sender:self];
    }
    else if ([sCell.cellLabelDisclosure.text isEqualToString:@"Facebook"]) {
        [self performSegueWithIdentifier:@"accountView" sender:self];
    }    else if ([sCell.cellLabelDisclosure.text isEqualToString:@"Support"]) {
        webAdress = @"http://www.sofitu.com/contact";
        [self performSegueWithIdentifier:@"webView" sender:self];
    }
    else if ([sCell.cellLabelDisclosure.text isEqualToString:@"Privacy Policy"])
    {
        webAdress = @"http://www.sofitu.com/beta/policy.html";
        [self performSegueWithIdentifier:@"webView" sender:self];
    }
    else if ([sCell.cellLabelDisclosure.text isEqualToString:@"Terms of Service"]) {
        webAdress = @"http://www.sofitu.com/terms";
        [self performSegueWithIdentifier:@"webView" sender:self];
    }
}
#pragma mark - TextField
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textfield
{
    [textfield resignFirstResponder];
    [PFUser currentUser][@"fullName"] = textfield.text;
    NSArray *nameArray = [textfield.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [PFUser currentUser][@"fName"] = nameArray[0];
    [PFUser currentUser][@"lName"] = nameArray[1];
    [[PFUser currentUser] saveInBackground];
    [self.view endEditing:YES];
    return YES;
}
#pragma mark - Switch Action
- (IBAction)switchAction:(id)sender{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *compare = [defaults stringForKey:@"Notifications"];
    if ([compare isEqualToString:@"Block"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:@"Allow" forKey:@"Notifications"];
        [defaults synchronize];
    } else {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:@"Block" forKey:@"Notifications"];
        [defaults synchronize];
    }
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"webView"])
    {
        WebViewController *wVC = [segue destinationViewController];
        [wVC setWebAddress:webAdress];
    }
}
@end
