//
//  FilterView.m
//
//  Created by Lucas L. Pena on 8/27/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, LLC. All rights reserved.
//

#import "FilterView.h"

@implementation FilterView {
    BOOL shrunk;
    NSUInteger whichActive;
    UIView* xibView;
    
    UIView *view1;
    UIView *view2;
    UIView *view3;
    
    UISegmentedControl *segment1;
    UISegmentedControl *segment3;
    
    UITableView *tableView1;
    UITableView *tableView2;
    UITableView *tableView3;
    
    CGFloat height1;
    CGFloat height2;
    CGFloat height3;
    
    NSMutableArray *activityList;
    NSMutableArray *locationList;
    NSMutableArray *experienceList;

    
    NSMutableArray *selectedActivites;
    NSMutableArray *selectedLocations;
    NSMutableArray *selectedExperience;

    
    NSMutableDictionary *filterDictionary;
    
    NSArray *activitySectionTitles;
    NSArray *locationSectionTitles;
}

#define Yaxis 50
#define Xwidth 320

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tag = 0;
        xibView = [[[NSBundle mainBundle] loadNibNamed:@"FilterView" owner:self options:nil] objectAtIndex:0];
        [xibView setFrame:[self bounds]];
        [self addSubview:xibView];
        //tags used to check which is open
        self.button1.tag = 1;
        self.button2.tag = 2;
        self.button3.tag = 3;
        
        self.button1.layer.cornerRadius = 5;
        self.button1.layer.masksToBounds = YES;
        self.button2.layer.cornerRadius = 5;
        self.button2.layer.masksToBounds = YES;
        self.button3.layer.cornerRadius = 5;
        self.button3.layer.masksToBounds = YES;
        
    }
    shrunk = YES;

    locationList = [[NSMutableArray alloc] initWithArray:[[UserSingleton singleUser] fetchLocationList]];
    [locationList addObject:@"Other: Off Campus"];
    [locationList addObject:@"Other: On Campus"];
    experienceList = [[NSMutableArray alloc] initWithArray:[NSArray arrayWithObjects:@"No Experience", @"Little Experience", @"Some Experience", @"Lots of Experience", nil]];
    
    selectedActivites = [[NSMutableArray alloc] init];
    selectedLocations = [[NSMutableArray alloc] init];
    selectedExperience = [[NSMutableArray alloc] init];

    return self;
}
-(void) initForPair
{
    activityList = [[NSMutableArray alloc] initWithArray:[[UserSingleton singleUser] fetchActivityListIndividual]];
    [activityList  addObjectsFromArray:[[UserSingleton singleUser] fetchActivityListTeam]];
    [activityList sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    //SET FILTER KEYS
    filterDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Pair" , @"Filter", selectedLocations, @"Location", selectedActivites, @"Activities", selectedExperience, @"Exp", nil];

    [self.button1Image setImage:[UIImage imageNamed:@"location_icon_inverse"]];
    [self.button2Image setImage:[UIImage imageNamed:@"activity_icon_inverse"]];
    [self.button3Image setImage:[UIImage imageNamed:@"experience_icon_inverse"]];
    [self.toggleImage setImage:[UIImage imageNamed:@"refresh_icon_inverse"]];
    
    //SET SECTION TITLES
    activitySectionTitles = [[[UserSingleton singleUser].activityDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:[[[UserSingleton singleUser].locationDict allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    NSString *holder = [temp objectAtIndex:0];
    [temp removeObjectAtIndex:0];
    [temp addObject:holder];
    locationSectionTitles = [[NSArray alloc] initWithArray:temp];

    
    //FIRST BUTTON
    view1 = [[UIView alloc] initWithFrame:CGRectMake(0, Yaxis, Xwidth, 180)];
    tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 170)];
    [tableView1 setTag:1];
    tableView1.dataSource = self;
    tableView1.delegate = self;
    tableView1.rowHeight = 30;
    tableView1.scrollEnabled = YES;
    tableView1.showsVerticalScrollIndicator = YES;
    tableView1.userInteractionEnabled = YES;
    tableView1.bounces = YES;
    tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView1.allowsMultipleSelection = YES;
    [tableView1 setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
    [view1 addSubview:tableView1];
    height1 = view1.frame.size.height+50;
    
    
    //SECOND BUTTON
    view2 = [[UIView alloc] initWithFrame:CGRectMake(0, Yaxis, Xwidth, 180)];
    tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 170)];
    [tableView2 setTag:2];
    tableView2.dataSource = self;
    tableView2.delegate = self;
    tableView2.rowHeight = 30;
    tableView2.scrollEnabled = YES;
    tableView2.showsVerticalScrollIndicator = YES;
    tableView2.userInteractionEnabled = YES;
    tableView2.bounces = YES;
    tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView2.allowsMultipleSelection = YES;
    [tableView2 setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
    [view2 addSubview:tableView2];
    height2 = view2.frame.size.height+50;
    
    //THIRD BUTTON
    view3 = [[UIView alloc] initWithFrame:CGRectMake(0, Yaxis, Xwidth, 140)];
    tableView3 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 130)];
    [tableView3 setTag:3];
    tableView3.dataSource = self;
    tableView3.delegate = self;
    tableView3.rowHeight = 30;
    tableView3.scrollEnabled = YES;
    tableView3.showsVerticalScrollIndicator = YES;
    tableView3.userInteractionEnabled = YES;
    tableView3.bounces = YES;
    tableView3.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView3.allowsMultipleSelection = YES;
    [tableView3 setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
    [view3 addSubview:tableView3];
    height3 = view3.frame.size.height+50;
}

- (IBAction)action1:(id)sender {
    if ([self sizeChange:(UIButton*)sender toSize:height1])
        [self addSubview:view1];
}

- (IBAction)action2:(id)sender {
    if ([self sizeChange:(UIButton*)sender toSize:height2])
        [self addSubview:view2];
}

- (IBAction)action3:(id)sender {
    if ([self sizeChange:(UIButton*)sender toSize:height3])
        [self addSubview:view3];
}

#pragma mark - Resizing Below
-(BOOL)sizeChange: (UIButton*) forButton toSize: (CGFloat) height //potentially return bool
{
    if ( (whichActive != forButton.tag) && (!shrunk) )  //not active make active and DONT shrink
    {
        [self whipeToolbar];
        [self growView:height];
        whichActive = forButton.tag;
        return true;
    }
    else if (shrunk) {                                       //if is closed grow and set active to none.
        [self growView:height];
        whichActive = forButton.tag;
        return true;
    }                                                   //else close it
    [self shrinkView];
    whichActive = 0;
    return false;
}

-(void)growView: (CGFloat)height
{
    [UIView animateWithDuration:(.1)
                     animations:^{
                         self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width,height);
                        }];
    shrunk = NO;
}

-(void)shrinkView
{
    if (!shrunk) {
        [UIView animateWithDuration:(.1)
                     animations:^{
                         [self whipeToolbar];
                         self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 50);
                     }];
        shrunk = YES;
        if (self.tag == 2) {
            self.tag = 1;
            return;
        }
        if (self.tag == 0) {
            if (
                (selectedActivites.count  > 0) ||
                (selectedExperience.count > 0) ||
                (selectedLocations.count > 0) ||
                ([segment1 selectedSegmentIndex] == 1) ||
                ([segment3 selectedSegmentIndex] == 1) ||
                ([segment1 selectedSegmentIndex] == 0) ||
                ([segment3 selectedSegmentIndex] == 0)
                )
            {
                self.tag = 1;
            }
        }
    }
}
-(void)whipeToolbar
{
    [view1 removeFromSuperview];
    [view2 removeFromSuperview];
    [view3 removeFromSuperview];
}

#pragma mark - Table View
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 1) {
        return locationSectionTitles.count;
    }
    if (tableView.tag == 2) {
        return activitySectionTitles.count;
    } else
        return 1;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        return [locationSectionTitles objectAtIndex:section];
    }
    else if (tableView.tag == 2) {
        return [activitySectionTitles objectAtIndex:section];
    }
    return nil;
}
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView.tag == 1) {
        return locationSectionTitles;
    }
    if (tableView.tag == 2) {
        return activitySectionTitles;
    }
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger returnME = tableView.tag;
    if (tableView.tag == 1) {
        NSString *sectionTitle = [locationSectionTitles objectAtIndex:section];
        NSArray *sectionArray = [[UserSingleton singleUser].locationDict objectForKey:sectionTitle];
        return [sectionArray count];
    }
    else if (tableView.tag == 2) {
        NSString *sectionTitle = [activitySectionTitles objectAtIndex:section];
        NSArray *sectionArray = [[UserSingleton singleUser].activityDict objectForKey:sectionTitle];
        return [sectionArray count];
    }
    else if (tableView.tag == 3) {
        returnME = experienceList.count;
    }
    return returnME;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"FilterTableCell";
    FilterTableCell *cell = (FilterTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[FilterTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (tableView.tag == 1)
    {
        [tableView1 deselectRowAtIndexPath:indexPath animated:YES];
        NSString *sectionTitle = [locationSectionTitles objectAtIndex:indexPath.section];
        NSArray *sectionArray = [[UserSingleton singleUser].locationDict objectForKey:sectionTitle];
        NSString *cellLocation = [sectionArray objectAtIndex:indexPath.row];
        cell.cellLabel.text = cellLocation;
        for (NSString* location in selectedLocations) {
            if ([cellLocation isEqualToString:location]) {
                [cell hilightMe:YES];
                break;
            }
            else
                [cell setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
        }
    }
    else if (tableView.tag == 2)
    {
        [tableView2 deselectRowAtIndexPath:indexPath animated:YES];
        NSString *sectionTitle = [activitySectionTitles objectAtIndex:indexPath.section];
        NSArray *sectionArray = [[UserSingleton singleUser].activityDict objectForKey:sectionTitle];
        NSString *cellActivity = [sectionArray objectAtIndex:indexPath.row];
        
        cell.cellLabel.text = cellActivity;
        for (NSString* activity in selectedActivites) {
            if ([cellActivity isEqualToString:activity]) {
                [cell hilightMe:YES];
                break;
            }
            else
                [cell setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
        }
    }
    else if (tableView.tag == 3)
    {
        [tableView1 deselectRowAtIndexPath:indexPath animated:YES];
        NSString *cellExp = [experienceList objectAtIndex:indexPath.row];
        cell.cellLabel.text = cellExp;
        for (NSString* exp in selectedExperience) {
            if ([cellExp isEqualToString:exp]) {
                [cell hilightMe:YES];
                break;
            }
            else
                [cell setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
        }
    }
    [cell hilightMe:NO];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterTableCell *cell = (FilterTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell hilightMe:YES];
    if (tableView.tag == 1) {
        [selectedLocations addObject:cell.cellLabel.text];
        [filterDictionary setObject:selectedLocations forKey:@"Location"];
    }
    else if (tableView.tag == 2) {
        [selectedActivites addObject:cell.cellLabel.text];
        [filterDictionary setObject:selectedActivites forKey:@"Activities"];
    }
    else if (tableView.tag == 3) {
        [selectedExperience addObject:cell.cellLabel.text];
        [filterDictionary setObject:selectedExperience forKey:@"Exp"];
    }
    [self saveFilter];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FilterTableCell *cell = (FilterTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell hilightMe:NO];
    if (tableView.tag == 1) {
        [selectedLocations removeObjectIdenticalTo:cell.cellLabel.text];
        [filterDictionary setObject:selectedLocations forKey:@"Location"];
    }
    else if (tableView.tag == 2) {
        [selectedActivites removeObjectIdenticalTo:cell.cellLabel.text];
        [filterDictionary setObject:selectedActivites forKey:@"Activities"];
    }
    if (tableView.tag == 3) {
        [selectedExperience removeObjectIdenticalTo:cell.cellLabel.text];
        [filterDictionary setObject:selectedExperience forKey:@"Exp"];
    }
    [self saveFilter];
}
#pragma mark - Segment Below
- (IBAction)segmentAction:(id)sender
{
    UISegmentedControl* segment = (UISegmentedControl*)sender;
    if (segment.tag == 1) {
        [filterDictionary setObject:[segment titleForSegmentAtIndex:segment.selectedSegmentIndex] forKey:@"Seeking"];
    }
    if (segment.tag == 3) {
        [filterDictionary setObject:[segment titleForSegmentAtIndex:segment.selectedSegmentIndex] forKey:@"Goal"];
    }
    [self saveFilter];
}
#pragma mark - Updating Filters
- (IBAction)toggleFilters:(id)sender {
    [self shrinkView];
    self.tag = 3;
    [self whipeFiter];
}
-(void)saveFilter
{
    [[UserSingleton singleUser] saveFilters:filterDictionary whipe:NO];
}
-(void)whipeFiter
{
    [[UserSingleton singleUser] saveFilters:filterDictionary whipe:YES];
    selectedActivites = [[NSMutableArray alloc] init];
    selectedLocations = [[NSMutableArray alloc] init];
    selectedExperience = [[NSMutableArray alloc] init];
    [tableView1 reloadData];
    [tableView2 reloadData];
    [tableView3 reloadData];
    
    [segment1 setSelectedSegmentIndex:UISegmentedControlNoSegment];
    [segment3 setSelectedSegmentIndex:UISegmentedControlNoSegment];
}
@end
