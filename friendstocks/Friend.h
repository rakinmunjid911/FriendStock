//
//  Friend.h
//  FriendStocks
//
//  Created by Rakin Munjid on 2/16/15.
//  Copyright (c) 2015 Rakin Munjid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Friend : NSManagedObject

@property (nonatomic) int64_t friend_id;
@property (nonatomic, retain) NSString * friend_name;
@property (nonatomic, retain) NSString * friend_symbol;
@property (nonatomic) int64_t last_close;
@property (nonatomic) int64_t friend_price;

@end
