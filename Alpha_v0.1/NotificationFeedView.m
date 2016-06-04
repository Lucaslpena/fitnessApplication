//
//  NotificationFeedView.m
//
//
//  Created by Lucas L. Pena on 6/27/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import "NotificationFeedView.h"

#define connect @"com.sofitu.NOTIF.connect"
#define message @"com.sofitu.NOTIF.message"
#define ad @"com.sofitu.NOTIF.ad"

@interface NotificationFeedView () {
    NSMutableArray *notificationList;
    //BOOL stopChecking;
    UIView *notifContainer;
}

@end

@implementation NotificationFeedView

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
    [[self navigationController] setNavigationBarHidden:YES];
    [self sideAction:self];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.tableView.hidden = YES;
    [self initNotifications:nil];
    [self notifCheck];
    self.backButton.hidden = YES;
    self.backImage.hidden = YES;
}
-(void)viewDidAppear:(BOOL)animated
{
    [self notifCheck];
}
-(void)viewDidDisappear:(BOOL)animated
{
    //stopChecking = YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initNotifications:(NSDictionary *)openedNotification
{
    //dispatch_queue_t loadQueue = dispatch_queue_create("loadQueue", NULL);
    //dispatch_async(loadQueue, ^{
    notificationList = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"notifications"]];
        //potential checking to make sure we do not store TOO many notifications here
        //ability to delete notifs??
        [[NSUserDefaults standardUserDefaults] synchronize];
        //dispatch_async(dispatch_get_main_queue(), ^{
            if (notificationList.count > 0)
            {
                self.tableView.hidden = NO;
                [self.tableView reloadData];
            }
        //});
    //});
}

#pragma mark - Notifications
-(void)notifCheck
{
    //if (stopChecking == YES) {
    //    return;
   // }
    if ([UserSingleton singleUser].pendinfNotification == YES) {
        [self initNotifications:NULL];
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self notifCheck];
    });
}
#pragma mark - Side Bar
- (IBAction)sideAction:(id)sender
{
    [self.realSideBarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Payload Handler
-(void)notifPayLoadHandler:(NSDictionary *)payloadDic forTime:(BOOL)isFirstTime {
    if (isFirstTime == YES)
        [self initNotifications:NULL];
    self.backButton.hidden = NO;
    self.backImage.hidden = NO;
    NSString *action = payloadDic[@"action"];
    if ([action isEqualToString:connect]) {
        [self plhConnects:payloadDic];
    }
    else if ([action isEqualToString:message]) {
        [self plhMessages:payloadDic];
    }
    else if ([action isEqualToString:ad]) {
        [self plhAds:payloadDic];
    }
}
#pragma mark - Payload Functions Below

//reciever functions below

-(void)plhConnects:(NSDictionary *)connectPLD
{
    PFUser *connectUser = [PFUser user];
    connectUser.objectId = connectPLD[@"withData"];
    [connectUser refresh];
    double delayInSeconds = 0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self createChildProfile:connectUser];
    });
}
-(void)plhMessages:(NSDictionary *)connectPLD
{
    PFObject *connects = [PFObject objectWithClassName:@"Connects"];
    connects.objectId = connectPLD[@"withData"];
    [connects refresh];
    double delayInSeconds = 0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self createChildMessage:connects];
    });
}
-(void)plhAds:(NSDictionary *)connectPLD
{
    NSString *adType = connectPLD[@"withType"];
    PFObject *notifAd;
    if ([adType isEqualToString:@"pair"]) {
        notifAd = [PFObject objectWithClassName:@"PairUpAd"];
        notifAd.objectId = connectPLD[@"withData"];
        [notifAd refresh];
    }
    else
    {
        notifAd = [PFObject objectWithClassName:@"TeamUpAd"];
        notifAd.objectId = connectPLD[@"withData"];
        [notifAd refresh];
    }
    double delayInSeconds = 0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self createChildAd:notifAd forType:adType];
    });
}

//creater functions below

-(void)createChildProfile:(PFUser *)forUser;
{
    notifContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 61, 320, 507)];
    ProfilePage* pP = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Profile"];
    UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:pP];
    [pP setPageOwner:forUser];
    [self addChildViewController:nav];
    [notifContainer addSubview:nav.view];
    [nav didMoveToParentViewController:self];
    notifContainer.backgroundColor = [UIColor grayColor];
    [self.view addSubview:notifContainer];
}
-(void)createChildMessage:(PFObject *)connection;
{
    notifContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 61, 320, 507)];
    AMChatViewController* chatViewController = [[AMChatViewController alloc] init];
    [chatViewController setCurrentConnect:connection];
    //[chatViewController setPassedUser:self.passUser];
    chatViewController.view.frame = CGRectMake(0, 0, 320, 507);
    [self addChildViewController:chatViewController];
    [notifContainer addSubview:chatViewController.view];
    [chatViewController didMoveToParentViewController:self];
    notifContainer.backgroundColor = [UIColor grayColor];
    [self.view addSubview:notifContainer];
}
-(void)createChildAd:(PFObject *)notifAd forType:adType;
{
    notifContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 61, 320, 507)];
    AdsDetailViewController* aDVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AdDetail"];
    UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:aDVC];
    if ([adType isEqualToString:@"pair"]) {
        
        [aDVC setPairUpAd:notifAd];
    }
    [notifAd fetchIfNeeded];
    PFUser *owner = notifAd[@"parent"];
    [owner fetch];
    [aDVC setAdOwner:owner];
    [self addChildViewController:nav];
    [notifContainer addSubview:nav.view];
    [nav didMoveToParentViewController:self];
    notifContainer.backgroundColor = [UIColor grayColor];
    [self.view addSubview:notifContainer];
}
#pragma mark - Table and Table Data
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [notificationList count];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *currentNotif = [notificationList objectAtIndex:indexPath.row];
    [UserSingleton singleUser].pendinfNotification = NO;
    [self notifCheck];
    [self notifPayLoadHandler:currentNotif forTime:NO];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NotificationFeedCell";
    NotificationFeedCell *nfCell = (NotificationFeedCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (nfCell == nil) {
        nfCell = [[NotificationFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (([UserSingleton singleUser].pendinfNotification == YES) && (indexPath.row == 0) ){
        UIColor *orange = [[UIColor alloc]
                             initWithRed: 230/255.0
                             green:      150/255.0
                             blue:       46/255.0
                             alpha:      1.0];
        nfCell.backgroundColor = orange;
        [UserSingleton singleUser].pendinfNotification = NO;
    }
    NSDictionary *currentNotif = [notificationList objectAtIndex:indexPath.row];
    NSString *action = currentNotif[@"action"];
    if ([action isEqualToString:connect]) {
        nfCell.cellImg.image = [UIImage imageNamed:@"confirmed_friend-icon"];
    }
    if ([action isEqualToString:message]) {
        nfCell.cellImg.image = [UIImage imageNamed:@"active_message-icon"];
    }
    if ([action isEqualToString:ad]) {
        NSString *adType = currentNotif[@"type"];
        if ([adType isEqualToString:@"pair"]) {
            nfCell.cellImg.image = [UIImage imageNamed:@"connected_pairup"];
        }
        else
        {
            nfCell.cellImg.image = [UIImage imageNamed:@"connected_teamup"];
            
        }
    }
    nfCell.cellImg.contentMode = UIViewContentModeScaleAspectFit;
    nfCell.cellLabel.text = currentNotif[@"withString"];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    return nfCell;
}

#pragma mark - Navigation
- (IBAction)backButtonAction:(id)sender {
    [notifContainer removeFromSuperview];
    self.backButton.hidden = YES;
    self.backImage.hidden = YES;
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
