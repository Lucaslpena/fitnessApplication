//
//  PairUpAd.h
//
//
//  Created by Lucas Pena on 6/30/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface PairUpAd : NSObject
@property (nonatomic, strong) NSString *activity;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSNumber *playerNum;
@property (nonatomic, strong) NSMutableArray *timeList;
@property (nonatomic, strong) NSString *additionalInformation;
@property (nonatomic, strong) NSString *experience;
@property (nonatomic, strong) NSString *specialLocation;
@property BOOL lookGoal;
@property BOOL hideSex;
@property NSString *sex;
@property BOOL active;

+(NSMutableDictionary *)createDayDictionary:(NSArray *) adlist;
@end
