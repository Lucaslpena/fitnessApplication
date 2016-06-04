//
//  UserSingleton.m
//
//  Created by Lucas Pena on 3/24/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import "UserSingleton.h"

@implementation UserSingleton{
     dispatch_queue_t profileQueue;
    dispatch_queue_t adsQueue;
    
    NSMutableArray *collegeList;
    NSMutableArray *connects;
    NSArray *locationPFOs;
}

+(UserSingleton *) singleUser
{
    static UserSingleton *singleUser = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleUser = [[self alloc] init];
    });
    
    return singleUser;
}

-(id)init
{
    self = [super init];
    if (self) {
        //_userID = nil;
        //_fullName = @"";
        //_fName = @"";
        //_lName = @"";
        _myPairUpAd = [[PairUpAd alloc] init];
        _activities = [[NSArray alloc] init];
        _experienceForActivities = [[NSArray alloc] init];
        _pendinfNotification = NO;
        _filterTeamUpdate = NO;
        _tutorial = 0;
    }
    return self;
}

#pragma mark - NScoder Information
-(id)initWithCoder:(NSCoder *) decoder
{
    self = [super init];
    if (self) {
        _email = [decoder decodeObjectForKey:@"email"];
        _tempPass = [decoder decodeObjectForKey:@"temppas"];
        _profilePic = [decoder decodeObjectForKey:@"profilePic"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_email forKey:@"adID"];
    [encoder encodeObject:_tempPass forKey:@"parentID"];
    [encoder encodeObject:_profilePic forKey:@"parentName"];
}

#pragma mark - Saving Data
+ (void) setSingleUser:(PFUser *) user
{
    [UserSingleton singleUser].fName = user[@"fName"];
    [UserSingleton singleUser].lName = user[@"lName"];
    [UserSingleton singleUser].college = user[@"college"];
    PFFile *userImageFile = user[@"profilePic"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            [UserSingleton singleUser].profilePic = imageData;
        }
    }];
}

#pragma mark - Fetch Confirmed Ads
-(void) fetchConfirmedPairUp {
    [PFCloud callFunctionInBackground:@"fetchConfirmedAds" withParameters:@{@"objId" : [PFUser currentUser].objectId, @"type" : @1}
                                block:^(NSArray* result, NSError *error) {
                                    if (!error) {
                                        //NSLog(@"%@",result);
                                        self.confirmedPairUp = [NSMutableArray arrayWithArray:result];
                                    }
                                }];
}

-(void) fetchConfirmedTeamUp {
    [PFCloud callFunctionInBackground:@"fetchConfirmedAds" withParameters:@{@"objId" : [PFUser currentUser].objectId, @"type" : @0}
                                block:^(NSArray* result, NSError *error) {
                                    if (!error) {
                                        //NSLog(@"%@",result);
                                        self.confirmedTeamUp = [NSMutableArray arrayWithArray:result];
                                    }
                                }];
}

#pragma mark - Filters Below
-(void)saveFilters:(NSDictionary *) forValues whipe:(BOOL)delete
{
    NSString *filterType = [forValues objectForKey:@"Filter"];
    if ([filterType isEqualToString:@"Team"])
    {
        NSUserDefaults *teamFilter = [NSUserDefaults standardUserDefaults];

        if (!delete) {
            [teamFilter setObject:forValues forKey:@"filterTeamUp"];
        }
        else {
            [teamFilter removeObjectForKey:@"filterTeamUp"];
        }
        [teamFilter synchronize];
    }
    if ([filterType isEqualToString:@"Pair"])
    {
        NSUserDefaults *pairFilter = [NSUserDefaults standardUserDefaults];
        
        if (!delete) {
            [pairFilter setObject:forValues forKey:@"filterPairUp"];
        }
        else {
            [pairFilter removeObjectForKey:@"filterPairUp"];
        }
        [pairFilter synchronize];
    }
}
#pragma mark - Stati Caching
-(NSMutableArray *)fetchActivityListTeam
{
    if (!_activityListTeam) {
        _activityListTeam = [[NSMutableArray alloc] init];
        PFQuery *fetchActivities = [PFQuery queryWithClassName:@"Activities"];
        [fetchActivities orderByAscending:@"name"];
        [fetchActivities whereKey:@"type" notEqualTo:@"individual"];
        NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:[fetchActivities findObjects]];
        for (PFObject *object in temp)
        {
            NSString *activityTitle = object[@"name"];
            [_activityListTeam addObject:activityTitle];
           
            
        }
    }
    NSMutableArray *array = [NSMutableArray arrayWithArray:_activityListTeam];
    [array addObjectsFromArray:_activityListIndividual];
    [array sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    _activityDict = [NSMutableDictionary dictionaryWithDictionary:[self createAlphaDict:array addOther:NO]];
    return _activityListTeam;
}
-(NSMutableArray *)fetchActivityListIndividual
{
    if (!_activityListIndividual) {
        _activityListIndividual = [[NSMutableArray alloc] init];
        PFQuery *fetchActivities = [PFQuery queryWithClassName:@"Activities"];
        [fetchActivities orderByAscending:@"name"];
        [fetchActivities whereKey:@"type" equalTo:@"individual"];
        NSMutableArray *temp = [[NSMutableArray alloc] initWithArray:[fetchActivities findObjects]];
        for (PFObject *object in temp)
        {
            NSString *activityTitle = object[@"name"];
            [_activityListIndividual addObject:activityTitle];
        }
    }
    return _activityListIndividual;
}
-(NSMutableArray *)fetchLocationList
{
    if (!_locationList) {
        _locationList = [[NSMutableArray alloc] init];
        PFQuery *fetchLocations = [PFQuery queryWithClassName:@"Locations"];
        [fetchLocations whereKey:@"parentName" equalTo:[PFUser currentUser][@"college"]];
        [fetchLocations orderByAscending:@"name"];
        locationPFOs = [[NSMutableArray alloc] initWithArray:[fetchLocations findObjects]];
        for (int i = 0; i < locationPFOs.count; ++i)
        {
            NSString *locationTitle = locationPFOs[i][@"name"];
            [_locationList addObject:locationTitle];
        }
    }
    _locationDict = [NSMutableDictionary dictionaryWithDictionary:[self createAlphaDict:_locationList addOther:YES]];
    return _locationList;
}
-(NSString *)fetchGpsByLocation:(NSString *) location {
    NSString *gps = [[NSString alloc] init];
    for (PFObject *local in locationPFOs) {
        if ([location isEqualToString:local[@"name"]]) {
            gps = local[@"geo"];
            return gps;
        }
        if ([local[@"name"] isEqualToString:[PFUser currentUser][@"college"]]) {
            gps = local[@"geo"];
        }
    }
    return gps;
}


-(void)fetchConfirmedAds
{
    [[PFUser currentUser] refresh];
    NSMutableArray *templist = [PFUser currentUser][@"confirmedAds"];
    BOOL needsupdating = NO;
    for (int i = 0; i < templist.count; ++i)
    {
        PFObject *ad = templist[i];
        [ad fetchIfNeeded];
        if ([ad[@"isActive"] isEqual:@NO])
        {
            [templist removeObjectAtIndex:i];
            needsupdating = YES;
            i--;
        }
    }
    [PFUser currentUser][@"confirmedAds"] = templist;
    if (needsupdating) {
        [[PFUser currentUser] saveInBackground];
    }
    templist = [[NSMutableArray alloc] initWithArray:[UserSingleton sortPull:templist]];
    _confirmedAds = templist;
}
-(NSMutableArray *)fetchColleges
{
    if (!collegeList)
    {
        PFQuery *fetchQuery = [PFQuery queryWithClassName:@"Colleges"];
        NSArray *colleges = [[NSArray alloc] initWithArray:[fetchQuery findObjects]];
        collegeList = [[NSMutableArray alloc] init];
        for (PFObject *obj in colleges)
        {
            [obj fetchIfNeeded];
            NSMutableDictionary *collegeObject = [[NSMutableDictionary alloc] init];
            [collegeObject setObject:obj[@"collegeName"] forKey:@"name"];
            [collegeObject setObject:obj[@"collegeEmails"] forKey:@"emails"];
            [collegeList addObject:collegeObject];
        }
    }
    return collegeList;
}
-(NSMutableArray *)fetchConnects: (BOOL)update
{
    if ( (!connects) || (update) )
    {
        [PFCloud callFunctionInBackground:@"fetchConnects" withParameters:@{@"forUser" : [PFUser currentUser].objectId}
                                block:^(NSArray* result, NSError *error) {
                                    if (!error) {
                                        if (result.count == 0) {
                                            connects = [[NSMutableArray alloc] initWithCapacity:0];
                                        }
                                        else
                                        {
                                            for (PFUser *connected in result)
                                                [connected fetchIfNeeded];
                                            connects = [[NSMutableArray alloc] initWithArray:result];
                                        }
                                    }
                                }];
    }
    return connects;
}

-(void)fetchFbFriends
{
    if (!self.FBconnects)
    {
        //dispatch_queue_t fbQueue = dispatch_queue_create("fetchMyAds",NULL);
        //dispatch_async(fbQueue, ^{
        self.FBconnects = [[NSMutableArray alloc] init];
        [FBRequestConnection startWithGraphPath:@"me?fields=friends.limit(1337)"
                              completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                  if (!error) {
                                      NSLog(@"user events: %@", result);
                                      NSMutableDictionary *resultDict = result;
                                      NSMutableDictionary *data = resultDict[@"friends"];
                                      NSMutableArray *friendArray = [data objectForKey:@"data"];
                                      int limit = friendArray.count;
                                      for (int i = 0; i < limit; i++){
                                          NSDictionary *friend = friendArray[i];
                                          NSString *fId = [friend objectForKey:@"id"];
                                          PFQuery* facebookFriendQuery = [PFUser query];
                                          [facebookFriendQuery whereKey:@"fbid" equalTo:fId];
                                          PFObject *queryFriend = [facebookFriendQuery getFirstObject];
                                          if (!queryFriend) {
                                              continue;
                                          }
                                          bool remove = false;
                                          for (PFObject *user in connects) {
                                              if ([queryFriend.objectId isEqualToString: user.objectId]) {
                                                  remove = TRUE;
                                              }
                                          }
                                          if (remove == false)
                                              [self.FBconnects addObject:queryFriend];
                                          for (PFObject* user in self.FBconnects)
                                          {
                                              NSLog(@"%@",user.objectId);
                                          }
                                      }
                                  }
                              }];//});
    }
}
#pragma mark - Utilities!!!!!!!
-(NSMutableDictionary *)createAlphaDict:(NSMutableArray *) givenArray addOther:(BOOL) add
{
    NSMutableDictionary *alphaDict = [[NSMutableDictionary alloc] init];
    if (add) {
        NSArray* temp = [[NSArray alloc] initWithObjects:@"Other: Off Campus",@"Other: On Campus", nil];
        [alphaDict setObject:temp forKey:@"?"];
    }
    for (NSString *tempString in givenArray)
    {
        NSString *first = [tempString substringToIndex:1];
        
        NSMutableArray *assets = [alphaDict objectForKey:first];
        if (!assets) {
            NSMutableArray *assets = [NSMutableArray arrayWithObject:tempString];
            [alphaDict setObject:assets forKey:first];
        } else {
            NSMutableArray *assets = [alphaDict objectForKey:first];
            [assets addObject:tempString];
            [alphaDict setObject:assets forKey:first];
        }
        
    }
    return alphaDict;
}
+(NSArray *)sortPull:(NSArray *)array {
    NSArray *sortedArray;
    sortedArray = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSDate* time1 = obj1[@"timeArray"][0];
        NSDate* time2 = obj2[@"timeArray"][0];
        return [time1 compare:time2];
    }];
    
    return sortedArray;
}

@end