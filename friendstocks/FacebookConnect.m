//
//  FacebookConnect.m
//  FriendStocks
//
//  Created by Rakin Munjid on 2/16/15.
//  Copyright (c) 2015 Rakin Munjid. All rights reserved.
//

#import "FacebookConnect.h"
#import "CoreDataStack.h"

@implementation FacebookConnect

+(void)handleFBSessionStateChangeWithNotification:(NSDictionary *)notification {
    
    //You get users information
    //Get Friends and convert them to stock - Add them to coredata
    NSDictionary *userInfo = notification;
    
    FBSessionState sessionState = [[userInfo objectForKey:@"state"] integerValue];
    NSError *error = [userInfo objectForKey:@"error"];
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    
    if (!error) {
        if (sessionState == FBSessionStateOpen) {
            [[FBRequest requestForMe] startWithCompletionHandler:
             ^(FBRequestConnection *connection,
               NSDictionary<FBGraphUser> *user,
               NSError *error) {
                 if (!error) {
                     //User Information
                     
                     User *theUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:coreDataStack.managedObjectContext];
                     theUser.user_name = [NSString stringWithFormat:@"%@ %@",user.first_name, user.last_name];
                     theUser.user_balance = 10000000;
                 }
             }];
            
            FBRequest *request = [FBRequest requestWithGraphPath:@"me/taggable_friends"
                                    parameters:@{@"fields":@"name,first_name,picture,last_name"}
                                                       HTTPMethod:@"GET"];
            

            
            [request startWithCompletionHandler:^(FBRequestConnection *connection,
                                                  id result,
                                                  NSError *error){
                 NSMutableArray *frnd_arr = [result objectForKey:@"data"];
                 
                 int countID = 1;
                 for (NSDictionary<FBGraphUser>* friend in frnd_arr) {
                     //All the Friends
                     Friend *friendToSave =  [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:coreDataStack.managedObjectContext];
                     friendToSave.friend_id = countID++;
                     friendToSave.friend_name = friend.name;
                     friendToSave.friend_symbol = [FacebookConnect randomStringWithLength:4 fromString:friend.name];
                     friendToSave.friend_price = 1000;
                     friendToSave.last_close = 1000;
                 }
                 [coreDataStack saveContext];
                if(countID > 1){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"FacebookConnected" object:nil];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"FacebookConnectedNoFriends" object:nil];
                }
             }];
        }
        else if (sessionState == FBSessionStateClosed || sessionState == FBSessionStateClosedLoginFailed){
            NSLog(@"Session Expired");
        }
    }
    else{
        // In case an error has occured, then just log the error and update the UI accordingly.
        NSLog(@"Error: %@", [error localizedDescription]);
    }
}

+(NSString *) randomStringWithLength:(int)len fromString:(NSString *)theStr {
    
    NSData *noSpeicalStringData = [theStr dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *noSpeicalString = [[NSString alloc] initWithData:noSpeicalStringData encoding:NSASCIIStringEncoding];
    
    NSString *noDot = [[noSpeicalString stringByReplacingOccurrencesOfString:@"." withString:@""] uppercaseString];
    //    dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES
    
    NSArray *seperatedArray = [noDot componentsSeparatedByString:@" "];
    NSMutableString *theSymbol = [[NSMutableString alloc] initWithCapacity:len];
    for (int i=0; i<seperatedArray.count; i++) {
        
        NSString *theStringObject = [seperatedArray objectAtIndex:i];
        if(theStringObject.length >= 2){
            [theSymbol appendString:[[seperatedArray objectAtIndex:i] substringToIndex:2]];
        } else {
            [theSymbol appendString:[[seperatedArray objectAtIndex:i] substringToIndex:theStringObject.length]];
        }
        
    }
    
    if(theSymbol.length >= len)
        return [theSymbol substringToIndex:len];
    
    return theSymbol;
    
}

@end
