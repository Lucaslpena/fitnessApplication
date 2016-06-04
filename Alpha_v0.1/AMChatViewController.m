//
//  AMChatViewController.m
//
//  Created by Lucas L. Pena on 8/5/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import "AMChatViewController.h"

@interface AMChatViewController () <AMBubbleTableDataSource, AMBubbleTableDelegate>

@property (nonatomic, strong) NSMutableArray* data;

@end

@implementation AMChatViewController{
    NSMutableArray *fetchingPicsFor;
}

- (void)viewDidLoad
{
	// Bubble Table setup
	// Set a style
	[self setTableStyle:AMBubbleTableStyleFlat];
    
	[self setBubbleTableOptions:@{AMOptionsBubbleDetectionType: @(UIDataDetectorTypeAll),
								  AMOptionsBubblePressEnabled: @NO,
								  AMOptionsBubbleSwipeEnabled: @NO}];
	
	// Call super after setting up the options
	[super viewDidLoad];
    self.picHolder = [[NSMutableArray alloc] init];
	[self setDataSource:self]; // Weird, uh?
	[self setDelegate:self];
	
    
    self.teal = [[UIColor alloc]
                       initWithRed: 47/255.0
                       green:      190/255.0
                       blue:       190/255.0
                       alpha:      1.0];
    self.navy = [[UIColor alloc]
                       initWithRed: 0/255.0
                       green:      57/255.0
                       blue:       77/255.0
                       alpha:      1.0];
    self.orange = [[UIColor alloc]
                         initWithRed: 230/255.0
                         green:      150/255.0
                         blue:       46/255.0
                         alpha:      1.0];
    
	[self setTitle:@"Chat"];
    
    if (self.currentAd)
    {
        [UserSingleton singleUser].currentAd = self.currentAd;
        [self reloadDataValues];
        [self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
    }
    if (self.currentConnect)
    {
        [UserSingleton singleUser].currentConnect = self.currentConnect;
        PFUser *requestor = self.currentConnect[@"requestor"];
        PFUser *requestee = self.currentConnect[@"requestee"];
        if ([requestee.objectId isEqual:[PFUser currentUser].objectId])
            self.passedUser = requestor;
        else if ([requestor.objectId isEqual:[PFUser currentUser].objectId])
            self.passedUser = requestee;
        [self reloadDataValues];
        [self.tableView setContentInset:UIEdgeInsetsMake(5, 0, 0, 0)];
        //[requestee fetchIfNeeded];
        //[requestor fetchIfNeeded];
    }



    [self.tableView reloadData];
    [self checkMessagesForNotif];
}
-(void)viewDidAppear:(BOOL)animated
{
    [self.tableView reloadData];
}
- (void)checkMessagesForNotif //check user singleton if pendind notif (every 5 seconds)... then see if message and if connect is equal to to the one that is open.. IF SO refresh
{
    if ([UserSingleton singleUser].pendinfNotification == YES) {
        [UserSingleton singleUser].pendinfNotification = NO;
        if (self.currentConnect) {
            [self.currentConnect fetch];
        }
        if (self.currentAd) {
            [self.currentConnect fetch];
        }
        fetchingPicsFor = NULL;
        self.data = NULL;
        [self reloadDataValues];
        [self.tableView reloadData];
        [self scrollToBottomAnimated:YES];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self checkMessagesForNotif];
        });
}

- (void)swipedCellAtIndexPath:(NSIndexPath *)indexPath withFrame:(CGRect)frame andDirection:(UISwipeGestureRecognizerDirection)direction
{
	NSLog(@"swiped");
}

#pragma mark - Fetch Chat Messages
-(void) reloadDataValues
{
    fetchingPicsFor = [[NSMutableArray alloc] init];
    NSArray *chatMessages = [[NSArray alloc] init];
    if (self.currentConnect)
    {
        NSMutableArray *chatArray = self.currentConnect[@"chatArray"];
        while (chatArray.count > 25) {
            [chatArray removeLastObject];
        }
        chatMessages = [[NSArray alloc] initWithArray:chatArray];
    }
    else
    {
        NSMutableArray *chatArray = self.currentAd[@"chatArray"];
        while (chatArray.count > 25) {
            [chatArray removeLastObject];
        }
        chatMessages = [[NSArray alloc] initWithArray:chatArray];
    }
    if (self.data.count == 0)
    {
        if (self.currentConnect)
        {
            self.data = [[NSMutableArray alloc] init];
            [self.data addObject:@{
                                   @"text": @"Make a schedule, plan a workout or share goals!",
                                   @"date": [NSDate date],
                                   @"type": @(AMBubbleCellReceived),
                                   @"username": @"SoFitU",
                                   @"color": self.teal
                                   }
             ];
        }
        else if (self.currentAd)
        {
            self.data = [[NSMutableArray alloc] init];
            [self.data addObject:@{
                                   @"text": @"Questions? Chat Below!",
                                   @"date": [NSDate date],
                                   @"type": @(AMBubbleCellReceived),
                                   @"username": @"SoFitU",
                                   @"color": self.teal
                                   }
                               ];
        }
        
    }
    //TIME LOG
    NSDate *now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"HH:mm:ss.SSS"];
    NSString *dateString = [outputFormatter stringFromDate:now];
    NSLog(@"TIME IS BEFORE: %@", dateString);
    
    
    
    
    for (int i = 0; i < chatMessages.count; ++i)    //DEADLY LOOP OF
    {                                               //INFINITE [ O(n) ] SUSPENSION!!!!!!!!!!!!!!!
        NSDictionary *chatMessage = chatMessages[i];
        //[chatMessage fetchIfNeeded];
        NSString *text = chatMessage[@"text"];
        NSString *creator = chatMessage[@"parent"];
        //if (self.currentConnect) {
        //    creator = self.passedUser.objectId;
        //}
        /*else
        {
            [creator fetchIfNeeded];
        }*/
        NSString *creatorname = chatMessage[@"parentName"]; //IF NOT CURRENT SET TO PASSED
        NSDate *currentDate = chatMessage[@"createdAt"];
        if (self.data.count >= (chatMessages.count+1)) {
            continue;
        }
        NSString *comparableID = [PFUser currentUser].objectId;
        if ([creator isEqualToString:comparableID]) {
            [self.data addObject:@{@"text":text,
                                   @"date": currentDate,
                                   @"parent":[PFUser currentUser].objectId,
                                   @"username": creatorname,
                                   @"type": @(AMBubbleCellSent),
                                   @"color": self.orange
                                   }];
        }
        else {
            [self.data addObject:@{@"text":text,
                                   @"date": currentDate,
                                   @"parent":creator,
                                   @"username": creatorname,
                                   @"type": @(AMBubbleCellReceived),
                                   @"color": self.orange
                                   }];
        }
    }
    
    
    
    //TIME LOG
    NSDate *now2 = [NSDate date];
    NSString *dateString2 = [outputFormatter stringFromDate:now2];
    NSLog(@"TIME IS AFTER: %@", dateString2);
    
    
    
    
    
    if (self.data.count == 1) {
        self.empty = TRUE;
    }
}
#pragma mark - AMBubbleTableDataSource

- (NSInteger)numberOfRows
{
	return self.data.count;
}

- (AMBubbleCellType)cellTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.data[indexPath.row][@"type"] intValue]; ////////////
}

- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.data[indexPath.row][@"text"];
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentAd = [UserSingleton singleUser].currentAd; //used to patch
    self.currentConnect = [UserSingleton singleUser].currentConnect; // used to patch
    return self.data[indexPath.row][@"date"];
}
- (UIImage*)avatarForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *returnImg = [UIImage imageNamed:@"feed-pairup-player"];
    if  (self.empty == TRUE)
    {
        return [UIImage imageNamed:@"Teal_U"];
    }
    
    //if (self.currentConnect)
    //{
        if ([ self.data[indexPath.row][@"parent"] isKindOfClass:[NSString class] ]) {
            for (int i = 0; i < self.picHolder.count; ++i) {
                NSString *holderkey = [self.data[indexPath.row] objectForKey:@"username"];
                UIImage *comparableImg = self.picHolder[i][holderkey];
                if (comparableImg)
                    return comparableImg;
            }
        }
        else
            return [UIImage imageNamed:@"Teal_U"];
        
        PFUser *creator ;
        if ([ [PFUser currentUser].objectId isEqualToString:self.data[indexPath.row][@"parent"] ])
            creator = [PFUser currentUser];
        else
        {
            if  (self.currentConnect) {
                creator = self.passedUser;
                [creator fetchIfNeeded];
            }
            if (self.currentAd) {
                creator = [PFUser user];
                creator.objectId = self.data[indexPath.row][@"parent"];
                [creator refresh];
            }
        }
        
        for (NSString *names in fetchingPicsFor) {
            if ([names isEqualToString:[self.data[indexPath.row] objectForKey:@"username"]]) {
                return returnImg;
            }
        }
         PFFile *profilePic = creator[@"profilePic"];
        [fetchingPicsFor addObject:[self.data[indexPath.row] objectForKey:@"username"]];
        [profilePic getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error)
            {
                NSString *holderkey = [self.data[indexPath.row] objectForKey:@"username"];
                UIImage *storageImg = [[UIImage alloc] init];
                storageImg = [UIImage imageWithData:data];
                [self.picHolder addObject:@{holderkey:storageImg}];
                [self.tableView reloadData];
            }
        }];
    /*}
    
    else if (self.currentAd)
    {
        if ([ self.data[indexPath.row][@"parent"] isKindOfClass:[NSString class] ]) {
            for (int i = 0; i < self.picHolder.count; ++i) {
                NSString *holderkey = [self.data[indexPath.row] objectForKey:@"username"];
                UIImage *comparableImg = self.picHolder[i][holderkey];
                if (comparableImg)
                    return comparableImg;
            }
        }
        else
            return [UIImage imageNamed:@"Teal_U"];
        
        
        
        
        PFUser *creator = [PFUser user];
        creator.objectId = self.data[indexPath.row][@"parent"];
        [creator refresh];
        PFFile *profilePic = creator[@"profilePic"];
        [profilePic getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error)
            {
                NSString *holderkey = [self.data[indexPath.row] objectForKey:@"username"];
                UIImage *storageImg = [[UIImage alloc] init];
                storageImg = [UIImage imageWithData:data];
                [self.picHolder addObject:@{holderkey:storageImg}];
                [self.tableView reloadData];
            }
        }];
//        [self scrollToBottomAnimated:YES];
        //return returnImg;
    }*/
    [self scrollToBottomAnimated:YES];
    return returnImg;
}

#pragma mark - AMBubbleTableDelegate

- (void)didSendText:(NSString*)text
{
	//NSLog(@"User wrote: %@", text);
	self.empty = FALSE;
    //PFObject *chatMessage = [PFObject objectWithClassName:@"Chat"];
    NSMutableDictionary *chatMessage = [[NSMutableDictionary alloc] init];
    [chatMessage setValue:text forKey:@"text"];
    [chatMessage setValue:[PFUser currentUser].objectId forKey:@"parent"];
    [chatMessage setValue:[PFUser currentUser][@"fName"] forKey:@"parentName"];
    NSDate *current = [NSDate dateWithTimeIntervalSinceNow:0];
    [chatMessage setValue:current forKey:@"createdAt"];
    [self.currentAd fetchIfNeeded]; ////////////////////////////////////////POTENTIAL NON FULLY UPDATING TO OTHE USERS ADDING .... NOT SURE HOW FETCH IF NEEED WORKS!!!!!!!!!!!!!
    if (self.currentAd) {
        NSMutableArray *chatArray = [NSMutableArray arrayWithArray:self.currentAd[@"chatArray"]];
        [chatArray addObject:chatMessage];
        self.currentAd[@"chatArray"] = chatArray;
        [self.currentAd saveInBackground];
    }
    if (self.currentConnect) {
        NSMutableArray *chatArray = [NSMutableArray arrayWithArray:self.currentConnect[@"chatArray"]];
        [chatArray addObject:chatMessage];
        self.currentConnect[@"chatArray"] = chatArray;
        [self.currentConnect saveInBackground];
        
        [PFCloud callFunctionInBackground:@"directChatPushNotif" withParameters:@{@"recievedId":self.passedUser.objectId, @"currentName": [PFUser currentUser][@"fName"], @"connectId": self.currentConnect.objectId}  block:^(NSString* result, NSError *error) {
            if (!error) {
                //doshit
            }
        }];
    }
    NSString *creator = [PFUser currentUser][@"fName"];
    [self.data addObject:@{
                            @"text": text,
                            @"date": current,
                            @"username": creator,
                            @"type": @(AMBubbleCellSent),
                            @"parent": [PFUser currentUser].objectId,
                            @"color": self.orange,
    }];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.data.count - 1) inSection:0];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [self.tableView endUpdates];
    // Either do this:
    [self scrollToBottomAnimated:YES];
    [self reloadDataValues];
}

- (NSString*)usernameForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return self.data[indexPath.row][@"username"];
}

- (UIColor*)usernameColorForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return self.data[indexPath.row][@"color"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end