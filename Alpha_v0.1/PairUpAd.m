//
//  PairUpAd.m
//
//
//  Created by Lucas Pena on 6/30/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import "PairUpAd.h"

@implementation PairUpAd
-(id)init
{
    self = [super init];
    if (self) {
        self.activity = @"Baseball";
        self.location = @"Doak Campbell";
        self.playerNum = [NSNumber numberWithInt:1];
        self.timeList = [[NSMutableArray alloc] init];
        self.additionalInformation = @"";
        self.hideSex = NO;
        self.sex = @"";
        self.experience = @"any";
        self.active = NO;
        self.lookGoal = NO;
    }
    return self;
}


+(NSMutableDictionary *)createDayDictionary:(NSArray *) adlist {
    NSMutableDictionary *returnDict = [[NSMutableDictionary alloc] init];
    
    NSMutableArray *dayList = [[NSMutableArray alloc] init];
    NSTimeInterval increment = 0;
    for (int i = 0; i <= 6; ++i)
    {
        NSDate *dateString = [NSDate dateWithTimeIntervalSinceNow:0+increment];
        NSDateFormatter *dayEEE = [[NSDateFormatter alloc] init];
        [dayEEE setDateFormat:@"EEE"];
        NSString *formattedDateString = [dayEEE stringFromDate:dateString];
        increment += 86400;
        if (i == 0) {
            [dayList addObject:@"Today"];
            continue;
        }
        if (i == 1) {
            [dayList addObject:@"Tomorrow"];
            continue;
        }
        [dayList addObject:formattedDateString];
    }
    
    NSMutableArray *day1 = [[NSMutableArray alloc] init];
    NSMutableArray *day2 = [[NSMutableArray alloc] init];
    NSMutableArray *day3 = [[NSMutableArray alloc] init];
    NSMutableArray *day4 = [[NSMutableArray alloc] init];
    NSMutableArray *day5 = [[NSMutableArray alloc] init];
    NSMutableArray *day6 = [[NSMutableArray alloc] init];
    NSMutableArray *day7 = [[NSMutableArray alloc] init];
    NSMutableArray *dayBank = [NSMutableArray arrayWithObjects:day1, day2, day3, day4, day5, day6, day7, nil];
    
    int dayBankIterator = 0;
    for (int i = 0; i < adlist.count; ++i)
    {
        int offsetDay = -1;
        PFObject *pairUpAd = [adlist objectAtIndex:i];
        NSMutableArray *dateList = pairUpAd[@"timeArray"];
        if (dateList.count == 0)
        {
            //[self updateTimes];
        }
        NSDate *adDate = dateList[0];
        NSDateFormatter *dayEEE = [[NSDateFormatter alloc] init];
        [dayEEE setDateFormat:@"EEE"];
        NSString *formattedDateString = [dayEEE stringFromDate:adDate];
        NSDate *current = [NSDate dateWithTimeIntervalSinceNow:0];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSGregorianCalendar];
        NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: current];
        [components setHour: 0];
        [components setMinute: 0];
        [components setSecond: 01];
        NSDate *comparative = [gregorian dateFromComponents:components];
        
        while ([comparative compare:adDate] == NSOrderedAscending)
        {
            ++offsetDay;
            comparative = [comparative dateByAddingTimeInterval:+(60 * 60 * 24)];
        }
        //dayBankIterator = offsetDay;
        if (i == 0) {
            [dayBank[dayBankIterator + offsetDay] addObject:pairUpAd];
        }
        if (i >= 1) {
            PFObject *temp = [adlist objectAtIndex:i-1];
            NSDate *adDate = [temp createdAt];
            NSDateFormatter *dayEEE = [[NSDateFormatter alloc] init];
            [dayEEE setDateFormat:@"EEE"];
            NSString *compareDate = [dayEEE stringFromDate:adDate];
            
            if ([formattedDateString isEqualToString:compareDate])
            {
                [dayBank[dayBankIterator + offsetDay] addObject:pairUpAd];
            }
            else
            {
                //++dayBankIterator;
                [dayBank[dayBankIterator + offsetDay] addObject:pairUpAd];
            }
            
        }
    }
    NSMutableDictionary *adDictionary = [[NSMutableDictionary alloc] init];
    for (int j = 0; j < dayBank.count; ++j)
    {
        [adDictionary setObject:dayBank[j] forKey:dayList[j]];
    }
    NSArray *daySectionTitles = [[adDictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2)
                        {
                            NSNumber *number1;
                            NSNumber *number2;
                            if ([obj1 isEqualToString:@"Today"]) {
                                number1 = [NSNumber numberWithInt:1];
                            }
                            if ([obj2 isEqualToString:@"Today"]) {
                                number2 = [NSNumber numberWithInt:1];
                            }
                            if ([obj1 isEqualToString:@"Tomorrow"]) {
                                number1 = [NSNumber numberWithInt:2];
                            }
                            if ([obj2 isEqualToString:@"Tomorrow"]) {
                                number2 = [NSNumber numberWithInt:2];
                            }
                            for (int i = 0; i < dayList.count; ++i)
                            {
                                if ([obj1 isEqualToString:dayList[i]]) {
                                    number1 = [NSNumber numberWithInt:i];
                                }
                                if ([obj2 isEqualToString:dayList[i]]) {
                                    number2 = [NSNumber numberWithInt:i];
                                }
                            }
                            return [number1 compare:number2];
                        }];
    
    
    for (int i = 0 ; i < [daySectionTitles count]; i++)
    {
        if ([adDictionary[daySectionTitles[i]] count] < 1)
        {
            [adDictionary removeObjectForKey:daySectionTitles[i]];
        }
    }
    daySectionTitles = [[adDictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2)
                        {
                            NSNumber *number1;
                            NSNumber *number2;
                            if ([obj1 isEqualToString:@"Today"]) {
                                number1 = [NSNumber numberWithInt:1];
                            }
                            if ([obj2 isEqualToString:@"Today"]) {
                                number2 = [NSNumber numberWithInt:1];
                            }
                            if ([obj1 isEqualToString:@"Tomorrow"]) {
                                number1 = [NSNumber numberWithInt:2];
                            }
                            if ([obj2 isEqualToString:@"Tomorrow"]) {
                                number2 = [NSNumber numberWithInt:2];
                            }
                            for (int i = 0; i < dayList.count; ++i)
                            {
                                if ([obj1 isEqualToString:dayList[i]]) {
                                    number1 = [NSNumber numberWithInt:i];
                                }
                                if ([obj2 isEqualToString:dayList[i]]) {
                                    number2 = [NSNumber numberWithInt:i];
                                }
                            }
                            return [number1 compare:number2];
                        }];
    [returnDict setObject:adlist forKey:@"adList"];
    [returnDict setObject:adDictionary forKey:@"adDictionary"];
    [returnDict setObject:daySectionTitles forKey:@"daySectionTitles"];
    [returnDict setObject:dayList forKey:@"dayList"];
    return returnDict;
}

@end
