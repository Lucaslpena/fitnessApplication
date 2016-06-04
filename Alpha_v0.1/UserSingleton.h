//
//  UserSingleton.h
//  Alpha_v0.1
//
//  Created by Lucas Lorenzo Pena on 3/24/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <Foundation/NSCoder.h>
#import "PairUpAd.h"
#import <FacebookSDK/FacebookSDK.h>

@interface UserSingleton : NSObject

//used to store temporary ads before pushing
@property (nonatomic, retain) PairUpAd *myPairUpAd;


+ (UserSingleton *) singleUser;
+ (void) setSingleUser:(PFUser *) user; //used for initialization. setting data singelton:PFuser, name, profile pic, email, password.

//used for registration only!
@property (nonatomic, retain) NSString *fullName;
@property (nonatomic, retain) NSString *fName;
@property (nonatomic, retain) NSString *lName;
@property (nonatomic, retain) NSData *profilePic;
@property (nonatomic, retain) NSString *tempPass;
@property (nonatomic, retain) NSString *college;
@property (nonatomic, retain) NSString *gender;
@property (nonatomic, retain) NSString *about;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSNumber *age;
@property (nonatomic, retain) NSArray *activities;
@property (nonatomic, retain) NSArray *experienceForActivities;
@property (nonatomic, retain) NSString *FbId;

//used for local caching only!
@property (nonatomic, retain) NSMutableArray *confirmedTeamUp;
@property (nonatomic, retain) NSMutableArray *confirmedPairUp;
-(void) fetchConfirmedTeamUp;
-(void) fetchConfirmedPairUp;

-(NSMutableArray *)fetchActivityListTeam;
@property (nonatomic, retain) NSMutableArray *activityListTeam;

-(NSMutableArray *)fetchActivityListIndividual;
@property (nonatomic, retain) NSMutableArray *activityListIndividual;

@property (nonatomic, retain) NSMutableDictionary *activityDict;

-(NSMutableArray *)fetchLocationList;
@property (nonatomic, retain) NSMutableArray *locationList;
@property (nonatomic, retain) NSMutableDictionary *locationDict;
-(NSString *)fetchGpsByLocation:(NSString *) location;

-(NSMutableArray *)fetchColleges;

@property (nonatomic, retain) NSArray *confirmedConnectedUsers;
@property (nonatomic, retain) NSMutableArray *pairUpAdList;
@property (nonatomic, retain) NSMutableArray *teamUpAdList;

-(void)fetchConfirmedAds;
@property (nonatomic, retain) NSMutableArray *confirmedAds;

-(NSMutableArray *)fetchConnects:(BOOL)update;
-(void)fetchFbFriends;
@property (nonatomic, retain) NSMutableArray *FBconnects;

@property BOOL pairUpRefresh;
@property BOOL teamUpRefresh;

@property (nonatomic, retain) PFObject *currentAd; //used to patch chat!!!!!
@property (nonatomic, retain) PFObject *currentConnect; //used to patch chat!!!!!
@property (nonatomic, retain) PFObject *cornerUser; //used to save user on pop!!!! //delegation might break page so keeping it simple for now
@property (nonatomic, retain) NSMutableDictionary *cornerObject; //used for creating ads for groups

//notification indicator below
@property BOOL pendinfNotification;


-(void)saveFilters:(NSDictionary *) forValues whipe:(BOOL)delete;
@property BOOL filterTeamUpdate;
@property BOOL filterPairUpdate;

//utilities here
+(NSArray *)sortPull:(NSArray *)array;
@property int tutorial; //used activate

//server interaction
+(void)connectToUser:(PFUser *) user;

@end