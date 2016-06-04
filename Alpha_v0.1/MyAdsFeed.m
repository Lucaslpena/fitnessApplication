//
//  MyAdsFeed.m
//
//  Created by Lucas L. Pena on 7/21/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import "MyAdsFeed.h"

@interface MyAdsFeed ()

@end

@implementation MyAdsFeed
{
    NSMutableArray* pairUpAdsList;
    NSMutableArray *dayList;
    NSMutableDictionary *pairDictionary;
    NSArray *daySectionTitles;
    NSUInteger selectedRowNum;
    
    UIActivityIndicatorView *spinner;
    UILabel *emptyLabel;
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
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(update)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    
    emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2, 320, 40)];
    emptyLabel.text = @"No Ads to Display";
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    emptyLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:emptyLabel];
    [self.navigationController setNavigationBarHidden:YES];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    self.tableView.hidden = YES;
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    [spinner setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height/2-60)];
    [self.view addSubview:spinner];
    [spinner startAnimating];
    [self.view sendSubviewToBack:self.tableView];
}
-(void)viewDidAppear:(BOOL)animated
{
    [spinner startAnimating];
    self.tableView.hidden = YES;
    [self fetchAllConfirmedAds];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    [self update];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)update {
    dispatch_queue_t myQueue = dispatch_queue_create("fetchMyAds",NULL);
    dispatch_async(myQueue, ^{
        [[UserSingleton singleUser] fetchConfirmedAds];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            [self createDictionary];
        });
    });
}
#pragma mark - Parse Pulling
-(void)fetchAllConfirmedAds {
    [[UserSingleton singleUser] fetchConfirmedAds];
    if ([UserSingleton singleUser].confirmedAds.count == 0)
    {
        self.tableView.hidden = YES;
    }
    else if ([UserSingleton singleUser].confirmedAds.count > 0)
    {
        self.tableView.hidden = NO;
    }
    pairUpAdsList = [NSMutableArray arrayWithArray:[UserSingleton singleUser].confirmedAds];
    [self createDictionary];
    [spinner stopAnimating];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}
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
/*#pragma mark - Table and Table Data
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (confirmedAds.count <= 0) {
        self.tableView.hidden = YES;
        emptyLabel.hidden = NO;
    }
    else
        emptyLabel.hidden = YES;
    return confirmedAds.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *compareObject = [confirmedAds objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"PairUpCell";
    PairUpCell *puCell = (PairUpCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (puCell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"PairUpCell" bundle:nil] forCellReuseIdentifier:@"PairUpCell"];
        puCell = [tableView dequeueReusableCellWithIdentifier:@"PairUpCell"];
    }
    [puCell initCell];
    NSMutableArray *dateList = compareObject[@"timeArray"];
    NSDate *adDate = dateList[0];
    PFUser *creator = compareObject[@"parent"];
    [creator fetchIfNeeded];
    puCell.parentLabel.text = creator[@"fName"];
    puCell.activityLabel.text = compareObject[@"activity"];
    puCell.activityPicture.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", compareObject[@"activity"]]];
    puCell.locationLabel.text = compareObject[@"location"];
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
}*/
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    PFObject *selectedAd = pairUpAdsList[path.row];
    AdsDetailViewController *advc = [segue destinationViewController];
    if ([selectedAd.parseClassName isEqualToString:@"PairUpAd"])
        [advc setPairUpAd:selectedAd];
    PFUser *creator = selectedAd[@"parent"];
    [creator fetchIfNeeded];
    [advc setAdOwner:creator];
}

@end
