//
//  FacebookConnect.h
//  FriendStocks
//
//  Created by Rakin Munjid on 2/16/15.
//  Copyright (c) 2015 Rakin Munjid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookConnect : NSObject

+(void)handleFBSessionStateChangeWithNotification:(NSDictionary *)notification;

@end
