//
//  Connects.h
//  Lucas L. Pena
//
//  Created by Dev on 11/15/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Connects : NSObject

@property (nonatomic, retain) PFObject *currentConnectobject; //used to access curent status on page
@property (nonatomic, retain) NSDictionary *interactionPayload; //used to trigger buttons on top of page
@property int fromSelf; //used to dictate status of Connect
@property (nonatomic, retain) PFUser *pageOwner;
@property (nonatomic, retain) UIAlertView *alert;

+(Connects *) connect;

+(void)connectToUser:(PFUser *) user;
+(void)checkStatus:(PFUser *)user;
+(void)setInteractionPayload:(NSDictionary *)dict;
@end
