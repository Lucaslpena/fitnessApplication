//
//  PairUpFeed.m
//
//  Created by Lucas L. Pena on 6/30/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, LLC. All rights reserved.
//

#import "PairUpFeed.h"

@interface PairUpFeed ()

@end

//used for toolbar animation//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#import <objc/runtime.h>
static char const * const ObjectTagKeyLastContentOffset = "lastContentOffset";
static char const * const ObjectTagKeyStartContentOffset = "startContentOffset";

typedef enum ScrollDirection {
    ScrollDirectionUp,
    ScrollDirectionDown
} ScrollDirection;

#define ANIMATION_HIDE_BUTTONS_TIME 0.2
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

@implementation PairUpFeed
{
    NSMutableArray* pairUpAdsList;
    NSMutableArray *dayList;
    NSMutableDictionary *pairDictionary;
    NSArray *daySectionTitles;
    NSUInteger selectedRowNum;
    
    UIActivityIndicatorView *spinner;
    
    NSInteger startContentOffset;
    NSInteger lastContentOffset;
    
    FilterView *filterToolBar;
    UILabel *emptyLabel;
    NSMutableDictionary *expDictConvert;
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
    
    self.loginview.hidden = YES;
    //dispatch_queue_t myQueue = dispatch_queue_create("fetchMyAds",NULL);
    //dispatch_async(myQueue, ^{
            [[UserSingleton singleUser] fetchFbFriends]; //Used to pre load reccomended friends
    //});
    
    emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, 320, 40)];
    emptyLabel.text = @"No Ads to Display";
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    emptyLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:emptyLabel];
    emptyLabel.hidden = YES;
    
    //filter toolbar
    filterToolBar = [[FilterView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [filterToolBar initForPair];
    [self.view addSubview:filterToolBar];
    //refresh control initalization
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(fetchPairUpAds)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    pairUpAdsList = [[NSMutableArray alloc] init];
    if ([UserSingleton singleUser].pairUpAdList.count > 0) {
        pairUpAdsList = [UserSingleton singleUser].pairUpAdList;
    }
    self.tableView.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];

    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    [spinner setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height/2-60)];
    [self.view addSubview:spinner];
    [self.view sendSubviewToBack:self.tableView];
    
    expDictConvert = [[NSMutableDictionary alloc] init];
    [expDictConvert setObject:@"None" forKey:@"No Experience"];
    [expDictConvert setObject:@"A Little" forKey:@"Little Experience"];
    [expDictConvert setObject:@"Some" forKey:@"Some Experience"];
    [expDictConvert setObject:@"A Lot" forKey:@"Lots of Experience"];
    
    [self refreshFromFilter];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadEntireData];
}
-(void)loadEntireData{
    self.tableView.hidden = YES;
    [self.navigationController setNavigationBarHidden:YES];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    if (self.tableView.hidden == YES)
    {
        [spinner startAnimating];
    }
    dispatch_queue_t fetchQueue = dispatch_queue_create("pairUpFeed",NULL);
    dispatch_sync(fetchQueue, ^{
        [self fetchPairUpAds];
    });
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Facebook
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    [PFUser currentUser][@"fbid"] = user.objectID;
    [[PFUser currentUser] saveInBackground];
}
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
}
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
}
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again: Settings >> Accounts.";
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}
#pragma mark - Filter Refresh
-(void)refreshFromFilter
{
    if ( (filterToolBar.tag == 3) || ([UserSingleton singleUser].pairUpRefresh == YES) ){
        filterToolBar.tag = 0;
        pairUpAdsList = nil;
        [UserSingleton singleUser].pairUpRefresh = NO;
        [self loadEntireData];
    }
    if (filterToolBar.tag == 1) {
        filterToolBar.tag = 2;
        dispatch_queue_t myQueue = dispatch_queue_create("fetchMyAds",NULL);
        dispatch_async(myQueue, ^{
            NSUserDefaults *pairUpFilter = [NSUserDefaults standardUserDefaults];
            NSDictionary *filter = [pairUpFilter objectForKey:@"filterPairUp"];
            NSArray *expCompare = [NSArray arrayWithArray:filter[@"Exp"]];
            NSMutableArray *exp = [[NSMutableArray alloc] init];
            for (NSString *compareString in expCompare)
            {
                    [exp addObject:[expDictConvert objectForKey:compareString]];

            }
            NSArray *locations = [NSArray arrayWithArray:filter[@"Location"]];
            NSArray *activities = [NSArray arrayWithArray:filter[@"Activities"]];
            
            for(int i = 0; i < pairUpAdsList.count; ++i)
            {
                PFObject *ad = [pairUpAdsList objectAtIndex:i];
                [ad fetchIfNeeded];
                NSString *puActivity = [NSString stringWithString:ad[@"activity"]];
                NSString *puLocation = [NSString stringWithString:ad[@"location"]];
                if (ad[@"specialLocation"]) {
                    puLocation = [NSString stringWithString:ad[@"specialLocation"]];
                }
                NSString *puExp = [NSString stringWithString:ad[@"exp"]];
                
                //filter on experience
                bool ifEquals = NO;
                if  (exp.count == 0)
                    ifEquals = YES;
                for (NSString *experience in exp){
                    if ([puExp isEqualToString:experience])
                        ifEquals = YES;
                }
                if (ifEquals == NO) {
                    [pairUpAdsList removeObjectAtIndex:i];
                    --i;
                    continue;
                }
                
                //filter on location
                ifEquals = NO;
                if  (locations.count == 0)
                    ifEquals = YES;
                for (NSString *location in locations){
                    if ([puLocation isEqualToString:location])
                        ifEquals = YES;
                }
                if (ifEquals == NO) {
                    [pairUpAdsList removeObjectAtIndex:i];
                    --i;
                    continue;
                }
                //filter on activity
                ifEquals = NO;
                if  (activities.count == 0)
                    ifEquals = YES;
                for (NSString *activity in activities){
                    if ([puActivity isEqualToString:activity])
                        ifEquals = YES;
                }
                if (ifEquals == NO) {
                    [pairUpAdsList removeObjectAtIndex:i];
                    --i;
                    continue;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self createDictionary];
            });
        });
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshFromFilter];
    });
}

#pragma mark - Parse Pulling
-(void)fetchPairUpAds {
    NSString *network = [PFUser currentUser][@"college"];
    if ( (pairUpAdsList.count > 0))
    {
        PFObject *pairUp = [pairUpAdsList objectAtIndex:0];
        [pairUp fetch];
        NSDate *createdDate = [[NSDate alloc] init];
        createdDate = pairUp.createdAt;
        
        for (PFObject *ad in pairUpAdsList)
        {
            NSDate *compareDate = ad.createdAt;
            if ([createdDate compare:compareDate] == NSOrderedAscending) {
                createdDate = compareDate;
            }
        }
        [PFCloud callFunctionInBackground:@"fetchPairUpAds" withParameters:@{@"withDate":createdDate, @"forNetwork":network}
                                    block:^(NSArray* result, NSError *error) {
                                        if (!error) {
                                            [self.refreshControl endRefreshing];
                                            if (result.count != 0)
                                            {
                                                result = [UserSingleton sortPull:result];
                                                [PFObject fetchAllIfNeeded:result];
                                                [pairUpAdsList addObjectsFromArray:result];
                                                pairUpAdsList = [[NSMutableArray alloc] initWithArray:[UserSingleton sortPull:pairUpAdsList]];
                                            }
                                            [self createDictionary];
                                            self.tableView.hidden = NO;
                                            [spinner stopAnimating];
                                        }
                                    }];
    }
    else
    {
        [PFCloud callFunctionInBackground:@"fetchPairUpAds" withParameters:@{@"forNetwork":network}
                                block:^(NSArray* result, NSError *error) {
                                    if (!error) {
                                        if (result.count > 0)
                                        {
                                            result = [UserSingleton sortPull:result];
                                            [self.refreshControl endRefreshing];
                                            [PFObject fetchAllIfNeeded:result];
                                            //self.tableView.hidden = NO;
                                            [UserSingleton singleUser].pairUpAdList = [NSMutableArray arrayWithArray:result];
                                            pairUpAdsList = [NSMutableArray arrayWithArray:result];
                                            [self createDictionary];
                                        }
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [spinner stopAnimating];
                                            if (pairUpAdsList.count > 0) {
                                                self.tableView.hidden = NO;
                                            }
                                            else
                                            {
                                                self.tableView.hidden = YES;
                                                //display alert message
                                            }
                                        });
                                    }
                                }];
    }
}
#pragma mark - Setting Pulled to Dictionary
- (void) createDictionary
{
    NSMutableDictionary *returned = [PairUpAd createDayDictionary:pairUpAdsList];
    pairUpAdsList = [returned objectForKey:@"adList"];
    pairDictionary = [[NSMutableDictionary alloc] initWithDictionary:[returned objectForKey:@"adDictionary"]];
    daySectionTitles = [[NSArray alloc] initWithArray:[returned objectForKey:@"daySectionTitles"]];
    dayList = [[NSMutableArray alloc] initWithArray:[returned objectForKey:@"dayList"]];
    [self.tableView reloadData];
}
#pragma mark - Table and Table Data
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *sectionTitle = [daySectionTitles objectAtIndex:section];
    NSArray *sectionAds = [pairDictionary objectForKey:sectionTitle];
    return sectionAds.count;
}

//section here
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (daySectionTitles.count == 0) {
        emptyLabel.hidden = NO;
        self.tableView.hidden = YES;
    }
    else
        emptyLabel.hidden = YES;
    return daySectionTitles.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [daySectionTitles objectAtIndex:section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PairUpCell";
    PairUpCell *puCell = (PairUpCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (puCell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"PairUpCell" bundle:nil] forCellReuseIdentifier:@"PairUpCell"];
        puCell = [tableView dequeueReusableCellWithIdentifier:@"PairUpCell"];
    }
    [puCell initCell];
    NSString *sectionTitle = [daySectionTitles objectAtIndex:indexPath.section];
    NSArray *sectionAds = [pairDictionary objectForKey:sectionTitle];
    PFObject *pairUpAd = [sectionAds objectAtIndex:indexPath.row];
    NSMutableArray *dateList = pairUpAd[@"timeArray"];
    NSDate *adDate = dateList[0];
    PFUser *creator = pairUpAd[@"parent"];
    [creator fetchIfNeeded];
    puCell.parentLabel.text = [ NSString stringWithFormat:@"%@ %@.",creator[@"fName"], [creator[@"lName"] substringToIndex:1] ];
    puCell.activityLabel.text = pairUpAd[@"activity"];
    puCell.activityPicture.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", pairUpAd[@"activity"]]];
    puCell.locationLabel.text = pairUpAd[@"location"];
    NSDateFormatter *displayDate = [[NSDateFormatter alloc] init];
    [displayDate setDateFormat:@"EEE"];
    NSString *formattedDateString = [displayDate stringFromDate:adDate];
    puCell.day.text = formattedDateString;
    [displayDate setDateFormat:@"h:mm a"];
    formattedDateString = [displayDate stringFromDate:adDate];
    puCell.time.text = formattedDateString;
    return puCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"Detail" sender:self];
}
#pragma mark - Filter ToolBar View
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if  (pairUpAdsList.count <= 7)
         return;
    startContentOffset = lastContentOffset = scrollView.contentOffset.y;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if  (pairUpAdsList.count <= 7)
        return;
    [filterToolBar shrinkView];
    
    __block BOOL wasAnimated = NO;
    ScrollDirection scrollDirection = ScrollDirectionDown;
    
    if (self.lastContentOffset > scrollView.contentOffset.y)
        scrollDirection = ScrollDirectionUp;
    
    else {
        scrollDirection = ScrollDirectionDown;
    }
    
    CGFloat currentOffset = scrollView.contentOffset.y;
    CGFloat differenceFromLast = self.lastContentOffset - currentOffset;
    self.lastContentOffset = currentOffset;
    
    if(scrollView.contentOffset.y <= 0 && scrollView.frame.origin.y != filterToolBar.frame.size.height ) {
        
        scrollView.frame = CGRectMake(scrollView.bounds.origin.x,
                                      filterToolBar.frame.size.height,
                                      scrollView.bounds.size.width,
                                      scrollView.bounds.size.height
                                      - filterToolBar.frame.size.height);
        
        
        filterToolBar.frame = CGRectMake(filterToolBar.bounds.origin.x,
                                         filterToolBar.bounds.origin.y,
                                         filterToolBar.bounds.size.width,
                                         filterToolBar.bounds.size.height);
        wasAnimated = YES;
        
    } else if(scrollView.contentOffset.y > 0 && scrollView.frame.origin.y != 0){
        
        scrollView.frame = CGRectMake(scrollView.bounds.origin.x,
                                      0,
                                      scrollView.bounds.size.width,
                                      scrollView.bounds.size.height
                                      +  filterToolBar.frame.size.height); //minus because self.currentTableHideY is negative
        
    }
    if((abs(differenceFromLast)>1) && scrollView.isTracking && !wasAnimated ) {
        if(scrollDirection == ScrollDirectionDown) {
            [UIView animateWithDuration:ANIMATION_HIDE_BUTTONS_TIME
                             animations:^{
                                 filterToolBar.frame = CGRectMake(filterToolBar.frame.origin.x,
                                                                  - filterToolBar.bounds.size.height*2,
                                                                  filterToolBar.bounds.size.width,
                                                                  filterToolBar.bounds.size.height);
                             }];
        } else {
            [UIView animateWithDuration:ANIMATION_HIDE_BUTTONS_TIME
                             animations:^{
                                 filterToolBar.frame = CGRectMake(filterToolBar.bounds.origin.x,
                                                                  filterToolBar.bounds.origin.y,
                                                                  filterToolBar.bounds.size.width,
                                                                  filterToolBar.bounds.size.height);
                             }];
        }
    }
}


- (NSInteger)startContentOffset {
    return [objc_getAssociatedObject(self, ObjectTagKeyStartContentOffset) integerValue];
}

- (void)setStartContentOffset:(NSInteger)newObjectTag {
    objc_setAssociatedObject(self, ObjectTagKeyStartContentOffset, @(newObjectTag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)lastContentOffset {
    return [objc_getAssociatedObject(self, ObjectTagKeyLastContentOffset) integerValue];
}

- (void)setLastContentOffset:(NSInteger)newObjectTag {
    objc_setAssociatedObject(self, ObjectTagKeyLastContentOffset, @(newObjectTag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    NSString *dayholder = daySectionTitles[path.section];
    NSArray *listHolder = [pairDictionary objectForKey:dayholder];
    PFObject *selectedAd = listHolder[path.row];
    AdsDetailViewController *advc = [segue destinationViewController];
    [advc setPairUpAd:selectedAd];
    PFUser *creator = selectedAd[@"parent"];
    [creator fetchIfNeeded];
    [advc setAdOwner:creator];
}

@end
