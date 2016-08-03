//
//  OwnedStock.h
//  FriendStocks
//
//  Created by Rakin Munjid on 2/20/15.
//  Copyright (c) 2015 Rakin Munjid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Friend;

@interface OwnedStock : NSManagedObject

@property (nonatomic) int64_t amount_owned;
@property (nonatomic) int64_t bought_price;
@property (nonatomic, retain) Friend *friend;

@end
