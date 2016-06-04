//
//  SideBarTable.m
//
//  Created by Lucas Pena on 6/26/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, LLC. All rights reserved.
//

#import "SideBarTable.h"

@interface SideBarTable ()

@end

@implementation SideBarTable
{
    NSMutableArray *buttonTitles;
    NSMutableArray *pageNames;
    BOOL firstTime;
    BOOL notif;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    UIColor *grey = [[UIColor alloc]
                           initWithRed: 78/255.0
                           green:      78/255.0
                           blue:       78/255.0
                           alpha:      1.0];
    self.view.backgroundColor = grey;
    self.tableView.backgroundColor = grey;
    self.tableView.separatorColor = grey;
    
    buttonTitles = [NSMutableArray arrayWithObjects:@"profile_grey.png", @"fitness_feed_grey.png", @"friends_grey.png", @"notifications_grey.png", @"messages_grey.png", @"search_grey.png", @"settings_grey.png", nil];
    pageNames = [NSMutableArray arrayWithObjects:@"profile", @"fitness_feed", @"friends", @"notifications", @"messages", @"search", @"settings", nil];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    if (!self.emptyLoad) {
        firstTime = YES;
    }
    else
        firstTime = YES;
    [self notifCheck];
}

#pragma mark - Notifications
-(void)notifCheck
{
    if ([UserSingleton singleUser].pendinfNotification == YES) {
        notif = YES;
        [self.tableView reloadData];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self notifCheck];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Notifications Load
-(void)loadForNotifications {
    self.emptyLoad = YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return buttonTitles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [pageNames objectAtIndex:indexPath.row];
    SideBarCell *sbCell = (SideBarCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIColor *grey = [[UIColor alloc]
                           initWithRed: 78/255.0
                           green:      78/255.0
                           blue:       78/255.0
                           alpha:      1.0];
    sbCell.backgroundColor = grey;
    
    if (sbCell == nil) {
        sbCell = [[SideBarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    sbCell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *imageName = [buttonTitles objectAtIndex:indexPath.row];
    if ([CellIdentifier isEqualToString:@"profile"]) {
        PFFile *profilePic = [PFUser currentUser][@"profilePic"];
        [sbCell.imageView.layer setCornerRadius:(sbCell.frame.size.height/2)];
        [sbCell.imageView.layer setMasksToBounds:YES];
        [sbCell.imageView.layer setBorderWidth:3];
        [sbCell.imageView setContentMode:UIViewContentModeScaleAspectFill];

        NSData *data = [NSData dataWithData:[profilePic getData]];
        sbCell.sideBarButton.image = [UIImage imageWithData:data];

        
        /*[profilePic getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error)
                sbCell.sideBarButton.image = [UIImage imageWithData:data];
            [sbCell.imageView.layer setCornerRadius:(sbCell.frame.size.height/2)];
            [sbCell.imageView.layer setMasksToBounds:YES];
            [sbCell.imageView.layer setBorderWidth:3];
            [sbCell.imageView setContentMode:UIViewContentModeScaleAspectFill];
        }];*/
    }
    
    if ((firstTime == YES) && ([CellIdentifier isEqualToString:@"fitness_feed"])) {
        if (!self.emptyLoad) {
            sbCell.sideBarButton.image = [UIImage imageNamed:@"fitness_feed_teal.png"];
        }
        firstTime = NO;
    }
    else if ((self.emptyLoad == YES) && ([CellIdentifier isEqualToString:@"notifications"])) {
        sbCell.sideBarButton.image = [UIImage imageNamed:@"notifications_teal.png"];
        self.emptyLoad = NO;
        //if ([UserSingleton singleUser].pendinfNotification == YES)
        //    [UserSingleton singleUser].pendinfNotification = NO;
    }
    else if ((notif == YES) && ([CellIdentifier isEqualToString:@"notifications"])) {
        sbCell.sideBarButton.image = [UIImage imageNamed:@"notifications_orange.png"];
        notif = NO;
    }
    else
        sbCell.sideBarButton.image = [UIImage imageNamed:imageName];
    sbCell.nameLabel.text = CellIdentifier;
    return sbCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView reloadData];
    SideBarCell *sbCell = ((SideBarCell *)[tableView cellForRowAtIndexPath:indexPath]);
    NSString *identifier = [pageNames objectAtIndex:indexPath.row];
    sbCell.sideBarButton.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_teal", identifier]];
    ///if( ([UserSingleton singleUser].pendinfNotification == YES) && ([identifier isEqualToString:@"notifications"]))
        //[UserSingleton singleUser].pendinfNotification = NO;
    [sbCell setNeedsLayout];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 5) {
        return 283;
    }
    else
        return 44;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[pageNames objectAtIndex:indexPath.row] capitalizedString];
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
}


@end
