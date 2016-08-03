//
//  User.h
//  FriendStocks
//
//  Created by Rakin Munjid on 2/17/15.
//  Copyright (c) 2015 Rakin Munjid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * user_name;
@property (nonatomic) int64_t user_balance;

@end
