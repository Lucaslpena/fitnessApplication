//
//  ProfilePage.m
//  Alpha_v0.1
//
//  Created by Lucas L. Pena on 2/17/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import "ProfilePage.h"

@interface ProfilePage ()

@end


@implementation ProfilePage {
    NSMutableArray *bigList;
    NSMutableArray *confirmedAds;
    UITableView *recentTable;
    UITableView *connects;
    UIView *mainPage;
    NSMutableArray *totalConnectList;
    BOOL pageControlBeingUsed;
    UIColor *navy;
    
    UILabel *noAds;
    UILabel *noActivity;
    UILabel *noFriends;
    
    //Edit Mode
    BOOL editIsActive;
    UILabel *major;
    UILabel *aboutMe;
    //UITextView *majorEdit;
    UITextView *aboutMeEdit;
    
    //Different Picture Selector
    BOOL selectingPP;
    
    //used for button
    NSMutableDictionary *interaction;
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
    interaction = [[NSMutableDictionary alloc] init];
    [self.navigationController setNavigationBarHidden:YES];
    if (!self.pageOwner)
    {
        self.pageOwner = [PFUser currentUser];
        [interaction setObject:@"MINE" forKey:@"isFriend"];
        [Connects connect].interactionPayload = [[NSDictionary alloc] initWithDictionary:interaction];
    }
    else {
        [interaction setObject:self.pageOwner forKey:@"user"];
        [Connects checkStatus:self.pageOwner];
        [Connects connect].pageOwner = self.pageOwner;
    }
    [self.pageOwner refresh];
    [self initPage];
}


-(void) initPage
{
    self.capturedImages = [[NSMutableArray alloc] init];
    navy = [[UIColor alloc]
                       initWithRed: 0/255.0
                       green:      57/255.0
                       blue:       77/255.0
                       alpha:      1.0];
    self.selectPicButton.hidden = YES;
    self.selectPicButton.tag = 1;
    self.selectBPic.hidden = YES;
    self.makeblue.backgroundColor = navy;
    dispatch_queue_t myImageQueue = dispatch_queue_create("fetchImages",NULL);
    dispatch_async(myImageQueue, ^{
        PFFile *profilePic = self.pageOwner[@"profilePic"];
        NSData *ppData = [profilePic getData];
        PFFile *backPic = self.pageOwner[@"backgroundPic"];
        NSData *bgData = [backPic getData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.profileImage.image = [UIImage imageWithData:ppData];
            self.backGround.image = [UIImage imageWithData:bgData];
        });
    });
    
    self.profileImage.layer.borderWidth = 3.0f;
    self.profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.profileImage setContentMode:UIViewContentModeScaleAspectFill];
    [self.backGround setContentMode:UIViewContentModeScaleAspectFill];
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2;
    self.profileImage.clipsToBounds = YES;

    if ([self.pageOwner.objectId isEqualToString:[PFUser currentUser].objectId]) {
        
        self.friendButton.hidden = YES;
        self.selectPicButton.hidden = NO;
        self.selectBPic.hidden = NO;
    }
    
    for (int i = 0; i < 3; i++) {
        CGRect frame;
        frame.origin.x = self.scrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollView.frame.size;
        UIView *subview = [[UIView alloc] initWithFrame:frame];
        subview.backgroundColor = navy;
        
        if (i == 0) {
            totalConnectList = [[NSMutableArray alloc] init];
            connects = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 295)];
            connects.tag =1;
            connects.dataSource = self;
            connects.delegate = self;
            connects.rowHeight = 30;
            connects.scrollEnabled = YES;
            connects.showsVerticalScrollIndicator = YES;
            connects.userInteractionEnabled = YES;
            connects.bounces = YES;
            connects.separatorStyle = UITableViewCellSeparatorStyleNone;
            connects.allowsMultipleSelection = YES;
            [connects setBackgroundColor:navy];
            [subview addSubview:connects];
            
            noFriends = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 320, 30)];
            noFriends.text = @"no friends to display";
            noFriends.font = [UIFont fontWithName:@"Lato-Regular" size:12];
            noFriends.textAlignment = NSTextAlignmentCenter;
            noFriends.textColor = [UIColor whiteColor];
            [subview addSubview:noFriends];
            [self fetchConnections];
        }
        if (i == 1)
        {
            NSString *name = [NSString stringWithFormat:@"%@    %@.", self.pageOwner[@"fName"], [self.pageOwner[@"lName"] substringToIndex:1]];
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 40)];
            nameLabel.text = name;
            nameLabel.center = CGPointMake(160, 25);
            nameLabel.textColor = [UIColor whiteColor];
            nameLabel.font = [UIFont fontWithName:@"Lato-Regular" size:18];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            [subview addSubview:nameLabel];
            
            UILabel *activitiesHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 35, 320, 40)];
            activitiesHeader.text = @"Recent Activities";
            activitiesHeader.textColor = [UIColor whiteColor];
            activitiesHeader.font = [UIFont fontWithName:@"Lato-Regular" size:14];
            activitiesHeader.textAlignment = NSTextAlignmentCenter;
            [subview addSubview:activitiesHeader];
            
            UILabel *aboutMeHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 175, 320, 30)];
            aboutMeHeader.textColor = [UIColor whiteColor];
            aboutMeHeader.textAlignment = NSTextAlignmentCenter;
            aboutMeHeader.font = [UIFont fontWithName:@"Lato-Regular" size:16];
            aboutMeHeader.text = @"About Me:";
            aboutMeHeader.center = CGPointMake(160, 140);
            [subview addSubview:aboutMeHeader];
            
            major = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 320, 30)];
            major.text = [NSString stringWithFormat:@"Major: %@", self.pageOwner[@"major"]];
            major.textColor = [UIColor whiteColor];
            major.font = [UIFont fontWithName:@"Lato-Regular" size:14];
            major.textAlignment = NSTextAlignmentCenter;
            [subview addSubview:major];
            
            aboutMe = [[UILabel alloc] initWithFrame:CGRectMake(20, 175, 280, 100)];
            aboutMe.lineBreakMode = NSLineBreakByWordWrapping;
            aboutMe.numberOfLines = 6;
            aboutMe.text = self.pageOwner[@"aboutMe"];
            aboutMe.textColor = [UIColor whiteColor];
            aboutMe.font = [UIFont fontWithName:@"Lato-Regular" size:14];
            aboutMe.textAlignment = NSTextAlignmentCenter;
            [subview addSubview:aboutMe];
            
            mainPage = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 310)];
            [subview addSubview:mainPage];
        
            noActivity = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, 320, 30)];
            noActivity.text = @"no activities to display";
            noActivity.font = [UIFont fontWithName:@"Lato-Regular" size:12];
            noActivity.textAlignment = NSTextAlignmentCenter;
            noActivity.textColor = [UIColor whiteColor];
            [subview addSubview:noActivity];
            
            UIButton *editButton = [[UIButton alloc] initWithFrame:CGRectMake(115, 125, 95, 40)];
            if  ([self.pageOwner.objectId isEqualToString:[PFUser currentUser].objectId])
                [editButton addTarget:self action:@selector(editMode) forControlEvents:UIControlEventTouchUpInside ];
            [editButton setTitle:@"" forState:UIControlStateNormal];
            [subview addSubview:editButton];
            
            aboutMeEdit = [[UITextView alloc] initWithFrame:CGRectMake(20, 180, 280, 120)];
            [aboutMeEdit.layer setCornerRadius:5];
            [aboutMeEdit setText:aboutMe.text];
            [aboutMeEdit setBackgroundColor:[UIColor whiteColor]];
            [aboutMeEdit setReturnKeyType:UIReturnKeyDone];
            [aboutMeEdit setDelegate:self];
            [aboutMeEdit setFont:[UIFont fontWithName:@"Lato-Regular" size:14]];
            [subview addSubview:aboutMeEdit];
            //majorEdit = [[UITextView alloc] initWithFrame:major.frame];
            //[majorEdit setBackgroundColor:[UIColor whiteColor]];
            //[subview addSubview:majorEdit];
            //[subview addSubview:majorEdit];
            
            [self generateActivities];
            editIsActive = YES;
            [self editMode];
        }
        if (i == 2) {
            recentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 295)];
            [recentTable setTag:2];
            recentTable.dataSource = self;
            recentTable.delegate = self;
            recentTable.rowHeight = 30;
            recentTable.scrollEnabled = YES;
            recentTable.showsVerticalScrollIndicator = YES;
            recentTable.userInteractionEnabled = YES;
            recentTable.bounces = YES;
            recentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
            recentTable.allowsMultipleSelection = YES;
            [recentTable setBackgroundColor:navy];
            [subview addSubview:recentTable];
            
            noAds = [[UILabel alloc] initWithFrame:CGRectMake(0, 125, 320, 30)];
            noAds.text = @"no recent activity";
            noAds.font = [UIFont fontWithName:@"Lato-Regular" size:12];
            noAds.textAlignment = NSTextAlignmentCenter;
            noAds.textColor = [UIColor whiteColor];
            [subview addSubview:noAds];
            [self setTableData];
        }
        [self.scrollView addSubview:subview];
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 3, self.scrollView.frame.size.height);
    pageControlBeingUsed = NO;
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * 1;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Scroll View
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    if ([sender tag] == 1) {
        CGFloat pageWidth = self.scrollView.frame.size.width;
        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        self.pageControl.currentPage = page;
    }
}
- (IBAction)changePage:(id)sender { //ContentScrollView
    CGRect frame;
    frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollView.frame.size;
    [self.scrollView scrollRectToVisible:frame animated:YES];
    pageControlBeingUsed = YES;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([scrollView tag] == 1)
        pageControlBeingUsed = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView tag] == 1)
        pageControlBeingUsed = NO;
}
#pragma mark - User Interaction
- (IBAction)requestFriend:(id)sender {
    [PFCloud callFunctionInBackground:@"connectWithUser" withParameters:@{@"requestor" : [PFUser currentUser].objectId, @"requestee" : self.pageOwner.objectId}
     //@{@"requestee" : [PFUser currentUser].objectId, @"requestor" : self.pageOwner.objectId}
                                block:^(NSString* result, NSError *error) {
                                    if (!error) {
                                        if ([result isEqualToString:@"saved"])
                                        {
                                            NSLog(@"%@",result);
                                            UIAlertView *confirm = [[UIAlertView alloc] initWithTitle:@"Connect Sent" message:[ NSString stringWithFormat:@"Requested to connect with %@", self.pageOwner[@"fName"]] delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                                            [confirm show];
                                        }
                                        if ([result isEqualToString:@"already requested"])
                                        {
                                            NSLog(@"%@",result);
                                            UIAlertView *confirm = [[UIAlertView alloc] initWithTitle:@"Already Requested" message:@"awaiting confirmation from user" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                                            [confirm show];
                                        }
                                        if ([result isEqualToString:@"already friends"])
                                        {
                                            NSLog(@"%@",result);
                                            UIAlertView *confirm = [[UIAlertView alloc] initWithTitle:@"Already Connected" message:@"already Connected with user" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
                                            [confirm show];
                                        }
                                    }
                                }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        
    }else{
        
    }
}
#pragma mark - Activities
-(void)generateActivities
{
    dispatch_queue_t myQueue = dispatch_queue_create("fetchMyAds",NULL);
    dispatch_async(myQueue, ^{
         PFQuery *query = [PFQuery queryWithClassName:@"PairUpAd"];
        [query whereKey:@"parent" equalTo:self.pageOwner];
        query.limit = 4;
        NSMutableArray *objects = [[NSMutableArray alloc] initWithArray:[query findObjects]];
        
        query = [PFQuery queryWithClassName:@"TeamUpAd"];
        [query whereKey:@"parent" equalTo:self.pageOwner];
        query.limit = 4;
        [objects addObjectsFromArray:[query findObjects]];
    
        NSMutableArray *activityList =[[NSMutableArray alloc] init];
        NSMutableArray *expList =[[NSMutableArray alloc] init];

        for (PFObject *currentObject in objects)
        {
            [currentObject fetch];
            [activityList addObject:currentObject[@"activity"]];
            [expList addObject:currentObject[@"exp"]];
        }
        if (activityList.count < 2)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.noActivities.font = [UIFont fontWithName:@"Lato-Regular" size:14];
                self.noActivities.hidden = NO;
            });
            return;
        }
        NSMutableDictionary *counter = [[NSMutableDictionary alloc] init];
        for (NSString *activity in activityList) {
            NSNumber *storeThis = [NSNumber numberWithInt:1];
            if ([counter objectForKey:activity]) {
                NSNumber *x = [counter objectForKey:activity];
                storeThis = [NSNumber numberWithInt:[x intValue] + 1];
            }
            [counter setObject:storeThis forKey:activity];
        }
        
        NSArray *sortedKey = [counter keysSortedByValueUsingComparator: ^(id obj1, id obj2) {
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
            
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([obj1 integerValue] > [obj2 integerValue]) {
            
                return (NSComparisonResult)NSOrderedAscending;
            }
        
            return (NSComparisonResult)NSOrderedSame;
        }];
    
        NSMutableArray *sortedKeys = [[NSMutableArray alloc] initWithArray:sortedKey];
    
        while (sortedKeys.count > 2) {
            [sortedKeys removeLastObject];
        }

        NSMutableArray *expList1 = [[NSMutableArray alloc] init];
        NSMutableArray *expList2 = [[NSMutableArray alloc] init];
    
        for (int i = 0; i < activityList.count; ++i)
        {
            if ([sortedKeys[0] isEqualToString:activityList[i]])
                {
                    NSString *chosenExperience = expList[i];
                    if ([chosenExperience isEqualToString:@"none"])
                        [expList1 addObject:@1];
                    else if ([chosenExperience isEqualToString:@"a little"])
                    [expList1 addObject:@2];
                    else if ([chosenExperience isEqualToString:@"some"])
                        [expList1 addObject:@3];
                    else if ([chosenExperience isEqualToString:@"a lot"])
                        [expList1 addObject:@4];
                    else if ([chosenExperience isEqualToString:@"any"])
                        [expList1 addObject:@5];
                }
            if ([sortedKeys[1] isEqualToString:activityList[i]])
            {
                NSString *chosenExperience = expList[i];
                if ([chosenExperience isEqualToString:@"none"])
                    [expList2 addObject:@1];
                else if ([chosenExperience isEqualToString:@"a little"])
                    [expList2 addObject:@2];
                else if ([chosenExperience isEqualToString:@"some"])
                    [expList2 addObject:@3];
                else if ([chosenExperience isEqualToString:@"a lot"])
                    [expList2 addObject:@4];
                else if ([chosenExperience isEqualToString:@"any"])
                    [expList2 addObject:@5];
            }
        }
        if ((expList1.count == 0) || (expList2.count == 0) )
            return;
        activityList = sortedKeys;
        NSMutableArray *experienceList = [[NSMutableArray alloc] init];
    
        int mean = 0;
        for (NSNumber *number in expList1) {
            mean += number.integerValue;
        }
        mean = mean / expList1.count;
        [experienceList addObject:[NSNumber numberWithInt:mean]];
    
        mean = 0;
        for (NSNumber *number in expList2) {
            mean += number.integerValue;
        }
        mean = mean / expList1.count;
        [experienceList addObject:[NSNumber numberWithInt:mean]];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CGFloat beginXCoor = (320/ (activityList.count + 1));
            CGFloat beginYCoor = 75;
            for (int i=0; i < activityList.count; ++i) {
                noActivity.hidden = YES;
                UIImageView *actImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:activityList[i]]];
                actImg.frame = CGRectMake(beginXCoor, beginYCoor, 40, 40);
                actImg.center = CGPointMake(beginXCoor, actImg.center.y);
                actImg.contentMode = UIViewContentModeScaleAspectFit;
                [mainPage addSubview:actImg];
        
                UIImageView *expImg = [[UIImageView alloc] init];
                expImg.frame = CGRectMake(beginXCoor, beginYCoor+40, 50 , 15);
                expImg.center = CGPointMake(actImg.center.x, expImg.center.y);
                expImg.contentMode = UIViewContentModeCenter;
                NSNumber *chosenExperience = experienceList[i];
                if (chosenExperience.integerValue == 1)
                    expImg.image = [UIImage imageNamed:@"experience1"];
                else if (chosenExperience.integerValue == 2)
                    expImg.image = [UIImage imageNamed:@"experience2"];
                else if (chosenExperience.integerValue == 3)
                    expImg.image = [UIImage imageNamed:@"experience3"];
                else
                    expImg.image = [UIImage imageNamed:@"experience4"];
                [mainPage addSubview:expImg];
        
                beginXCoor *= 2;
            }
        });
    });
}

#pragma mark - Connections
-(void)fetchConnections
{
[PFCloud callFunctionInBackground:@"fetchConnects" withParameters:@{@"forUser" : self.pageOwner.objectId}
                                block:^(NSArray* result, NSError *error) {
                                    if (!error) {
                                        if (result.count == 0) {
                                            self.connectList = [[NSMutableArray alloc] initWithCapacity:0];
                                        }
                                        else
                                        {
                                            for (PFUser *connected in result){
                                                [connected refresh];
                                                [totalConnectList addObject:connected];
                                                [connects reloadData];
                                                noFriends.hidden = YES;
                                            }
                                            self.connectList = [[NSMutableArray alloc] initWithArray:result];
                                        }
                                    }
                                }];
}
#pragma mark - Image Picker
- (IBAction)selectPic:(id)sender
{
    UIButton *mySender = (UIButton *)sender;
    if (mySender.tag == 1) {
        selectingPP = YES;
    }
    else selectingPP = NO;
    self.picker.delegate = self;
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    if (self.profileImage.isAnimating)
    {
        [self.profileImage stopAnimating];
    }
    
    if (self.capturedImages.count > 0)
    {
        [self.capturedImages removeAllObjects];
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.sourceType = sourceType;
    picker.delegate = self;
    
    
    self.picker = picker;
    [self presentViewController:self.picker animated:YES completion:nil];
}

- (void)finishAndUpdate
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if ([self.capturedImages count] > 0)
    {
        if ([self.capturedImages count] == 1)
        {
            // Camera took a single picture.
            if (selectingPP) {
                [self.profileImage setImage:[[self.capturedImages objectAtIndex:0] resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(300, 300) interpolationQuality:2]];
                NSData *imageData = UIImagePNGRepresentation(self.profileImage.image);
                PFFile *ppfile = [PFFile fileWithData:imageData];
                [PFUser currentUser][@"profilePic"] = ppfile;
                [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        [[PFUser currentUser] refresh];
                    }
                }];
            } else {
                [self.backGround setImage:[[self.capturedImages objectAtIndex:0] resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(320*2, 179*2) interpolationQuality:2]];
                NSData *imageData = UIImagePNGRepresentation(self.backGround.image);
                PFFile *ppfile = [PFFile fileWithData:imageData];
                [PFUser currentUser][@"backgroundPic"] = ppfile;
                [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        [[PFUser currentUser] refresh];
                    }
                }];
            }
        }
        else
        {
            // Camera took multiple pictures; use the list of images for animation.
            //self.profileImage.animationImages = self.capturedImages;
            //self.profileImage.animationDuration = 5.0;    // Show each captured photo for 5 seconds.
            //self.profileImage.animationRepeatCount = 0;   // Animate forever (show all photos).
            //[self.profileImage startAnimating];
        }
        
        // To be ready to start again, clear the captured images array.
        [self.capturedImages removeAllObjects];
    }
    self.picker = nil;
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self.capturedImages addObject:image];
    [self finishAndUpdate];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Table and Table Data
-(void)setTableData
{
    dispatch_queue_t myQueue = dispatch_queue_create("fetchAdList",NULL);
    dispatch_async(myQueue, ^{
        if ([self.pageOwner isEqual:[PFUser currentUser]]) {
            bigList = [NSMutableArray arrayWithArray:[UserSingleton singleUser].confirmedAds];
        }
        else {
            bigList = [[NSMutableArray alloc] initWithArray:self.pageOwner[@"confirmedAds"]];
            for (int i  = 0; i < bigList.count; ++i) {
                PFObject *thisObject = bigList[i];
                [thisObject fetch];
                self.pageOwner[@"confirmedAds"] = bigList;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [recentTable reloadData];
        });

    });
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        return totalConnectList.count;
    }
    else {
        if (bigList.count == 0) {
            return 0;
        }
    }
    return bigList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1)
        return 66;
    return 58;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        static NSString *CellIdentifier = @"CustomConnectsCell";
        ConnectsCustomCell *ccCell = (ConnectsCustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (ccCell == nil) {
            ccCell = [[ConnectsCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        PFUser *resultUser = [totalConnectList objectAtIndex:indexPath.row];
        [resultUser refresh];
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
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [ccCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [ccCell setBackgroundColor:navy];
        [ccCell.userName setTextColor:[UIColor whiteColor]];
        return ccCell;
    }
    else {
        static NSString *CellIdentifier = @"CustomRecentAdsCell";
        CustomRecentAdsCell *ccCell = (CustomRecentAdsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
        if (ccCell == nil) {
            ccCell = [[CustomRecentAdsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        PFObject *bigListObj = [bigList objectAtIndex:indexPath.row];
        [bigListObj fetchIfNeeded];
        // Display friend data in the table cell
        NSString* fullName = self.pageOwner[@"fName"];
        noAds.hidden = YES;
        if ([bigListObj.parseClassName isEqualToString:@"TeamUpAd"]) {
             ccCell.cellLabel.text = [NSString stringWithFormat:@"%@ teamed up to play %@",fullName, bigListObj[@"activity"]];
            ccCell.cellImage.image = [UIImage imageNamed:@"connected_teamup"];
        }
        else {
            ccCell.cellLabel.text = [NSString stringWithFormat:@"%@ paired up to play %@",fullName, bigListObj[@"activity"]];
            ccCell.cellImage.image = [UIImage imageNamed:@"connected_pairup"];
        }
        ccCell.cellLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
        //    ccCell.cellImage
    
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [ccCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [ccCell setBackgroundColor:navy];
        [ccCell.cellLabel setTextColor:[UIColor whiteColor]];
        return ccCell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        PFUser *current = [totalConnectList objectAtIndex:indexPath.row];
        //[self performSegueWithIdentifier:@"profileView" sender:self];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        ProfilePage *dest = [storyboard instantiateViewControllerWithIdentifier:@"Profile"];
        [self.navigationController pushViewController:dest animated:YES];
        [dest setPageOwner:current];
    }
}
#pragma mark - Edit Mode

- (void)editMode
{
    if  (editIsActive == NO)
    {
        editIsActive = YES;
        //majorEdit.hidden = NO;
        aboutMeEdit.hidden = NO;
        //major.hidden = YES;
        aboutMe.hidden = YES;
    }
    else
    {
        editIsActive = NO;
        //majorEdit.hidden = YES;
        aboutMeEdit.hidden = YES;
        //major.hidden = NO;
        aboutMe.hidden = NO;
    }
}

#pragma mark - Text Views
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [aboutMeEdit resignFirstResponder];
}
- (BOOL) textView: (UITextView*) textView shouldChangeTextInRange: (NSRange) range replacementText: (NSString*) text
{
    NSString *totalText = textView.text;
    if ([text hasSuffix:@"\n"]) {
        aboutMe.text = totalText;
        [PFUser currentUser][@"aboutMe"] = totalText;
        [[PFUser currentUser] saveInBackground];
        
        [self editMode];
        [textView resignFirstResponder];
        
        return NO;
    }
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self animateTextView:textView up:YES];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self animateTextView:textView up:NO];
}
- (void) animateTextView: (UITextView*) textView up: (BOOL) up
{
    int movementDistance = 215;
    const float movementDuration = 0.15f;
    int movement = (up ? -movementDistance : movementDistance);
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

#pragma mark - Navigation
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"connectView"])
    {
        ConnectsUserFeed *cUf = [segue destinationViewController];
        [cUf setConfirmedConnects:self.connectList];
    }
}
@end
