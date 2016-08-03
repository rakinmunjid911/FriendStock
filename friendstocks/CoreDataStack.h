//
//  CoreDataStack.h
//  FriendStocks
//
//  Created by Rakin Munjid on 2/16/15.
//  Copyright (c) 2015 Rakin Munjid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Friend.h"
#import "User.h"
#import "OwnedStock.h"

@interface CoreDataStack : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CoreDataStack *) defaultStack;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (NSArray *)updateAllStocks;
- (NSArray *)getAllStocks;
- (void)closeMarket;
- (BOOL) doWeHaveAStockMarket;

- (NSString *)getUserBalance;
- (NSString *)getMarketValue;
- (NSString *)getUserValue;
- (int64_t)getUserBalanceInNumber;
- (long)getMarketValueInNumber;

- (BOOL)buyStock:(Friend *)friend InQuantity:(int64_t) quantity AtPrice:(int64_t) price;

-(NSArray *) getAllOwnedStocks;

-(OwnedStock *) checkIfIOwn:(Friend *) theFriend;
-(BOOL) sellStocksForFriend:(Friend *) theFriend;
-(BOOL) sellStocks:(int)quantity forFriend:(Friend *) theFriend;

-(void) addMoneyToUser:(int64_t) amount;

@end
