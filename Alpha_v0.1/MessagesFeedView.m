//
//  MessagesFeedView.m
//
//
//  Created by Lucas L Pena on 6/27/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import "MessagesFeedView.h"

@interface MessagesFeedView ()

@end

@implementation MessagesFeedView

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
    [self sideAction:self];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.tableView.hidden = YES;
    self.messageHeader.font = [UIFont fontWithName:@"Lato-Regular" size:18];
    [self initPage];
    self.plusIsActive= NO;
    self.chatIsActive= NO;
    [self notifCheck];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initPage
{
    [PFCloud callFunctionInBackground:@"fetchConnects" withParameters:@{@"forUser" : [PFUser currentUser].objectId, @"returnType": @"2D"}
                                    block:^(NSArray* result, NSError *error) {
                                        if (!error) {
                                            NSMutableArray *connectUsersWithChat = [[NSMutableArray alloc] init];
                                            NSMutableArray *connectHolder = [[NSMutableArray alloc] initWithCapacity:(result.count / 2)];
                                            NSMutableArray *connectsWithOUTChats = [[NSMutableArray alloc] initWithCapacity:(result.count / 2)];
                                            int adjustment = result.count/2;
                                            for (int i =0; i < adjustment; ++i) {
                                                [connectHolder addObject:result[i]];
                                                NSArray *chatArray = result[i][@"chatArray"];
                                                if (chatArray.count >= 1)
                                                {
                                                    [connectUsersWithChat addObject:result[i+adjustment]];
                                                    self.tableView.hidden = NO;
                                                }
                                                else
                                                    [connectsWithOUTChats addObject:result[i+adjustment]];
                                            }
                                            self.connectsWithOUTChats = [[NSArray alloc] initWithArray:connectsWithOUTChats];
                                            self.confirmedConnectObjects = [[NSArray alloc] initWithArray:connectHolder];
                                            self.connectsWithChats = [[NSArray alloc] initWithArray:connectUsersWithChat];
                                            self.activeList = [[NSArray alloc] initWithArray:self.connectsWithChats];
                                            [self.tableView reloadData];
                                        }
                                    }];
}
#pragma mark - Side Bar
- (IBAction)sideAction:(id)sender
{
    [self.realSideBarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - Notifications
-(void)notifCheck
{
    if ([UserSingleton singleUser].pendinfNotification == YES) {
        self.notification.image = [UIImage imageNamed:@"notif_dot"];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self notifCheck];
    });
}
#pragma mark - Table and Table Data
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.activeList count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{ //NEEDS TESTING ON MORE THAN ONE!!
    
    if (self.chatIsActive == NO) {
        PFUser *connectedUser = [self.activeList objectAtIndex:indexPath.row];
        for (PFObject *connect in self.confirmedConnectObjects) {
            [connect fetchIfNeeded];
            PFUser *connectRequestor  = connect[@"requestor"];
            PFUser *connectRequestee  = connect[@"requestee"];;
            [connectRequestee fetchIfNeeded];
            [connectRequestor fetchIfNeeded];
            if( ([connectRequestee.objectId isEqual:connectedUser.objectId]) || ([connectRequestor.objectId isEqual:connectedUser.objectId]) ){
                self.currentConnect = connect;
                self.passUser = connectedUser;
            }
        }
        //self.currentConnect = [self.confirmedConnectObjects objectAtIndex:indexPath.row];
        self.tableView.frame = CGRectMake(0, 62, 320, 66);
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [self generateChatBelow];
        self.messageHeader.text = @"Messages";
        self.messageHeader.font = [UIFont fontWithName:@"lato-Regular" size:18];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomConnectsCell";
    ConnectsCustomCell *ccCell = (ConnectsCustomCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (ccCell == nil) {
        ccCell = [[ConnectsCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    PFUser *resultUser = [PFUser user];
    if (self.connectsWithChats.count > 0) {
        resultUser = [self.connectsWithChats objectAtIndex:indexPath.row];
    }
    if (self.plusIsActive == YES) {
        if (self.connectsWithOUTChats.count) {
            resultUser = [self.connectsWithOUTChats objectAtIndex:indexPath.row];
            self.tableView.hidden = NO;
        }
    }
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

#pragma mark - Button
- (IBAction)plusAction:(id)sender {
    if (self.chatIsActive == NO)
    {
        self.plusIsActive = YES;
        [self.tableView reloadData];
        self.messageHeader.text = @"Select Connect to Message";
        self.messageHeader.font = [UIFont fontWithName:@"Lato-Regular" size:14];
        self.activeList = [[NSArray alloc] initWithArray:self.connectsWithOUTChats];
        [self.tableView reloadData];
    }
}

#pragma mark - Chat
-(void)generateChatBelow{
    UIView *chatViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 61, 320, 507)];
    AMChatViewController* chatViewController = [[AMChatViewController alloc] init];
    [chatViewController setCurrentConnect:self.currentConnect];
    [chatViewController setPassedUser:self.passUser];
    chatViewController.view.frame = CGRectMake(0, 0, 320, 507);
    [self addChildViewController:chatViewController];
    [chatViewContainer addSubview:chatViewController.view];
    [chatViewController didMoveToParentViewController:self];
    chatViewContainer.backgroundColor = [UIColor grayColor];
    [self.view addSubview:chatViewContainer];
    self.chatIsActive = YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
