//
//  FriendsDetailViewController.h
//  FriendStocks
//
//  Created by Rakin Munjid on 2/17/15.
//  Copyright (c) 2015 Rakin Munjid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"
#import "CoreDataStack.h"

@interface FriendsDetailViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, assign) int64_t friendID;

@end
