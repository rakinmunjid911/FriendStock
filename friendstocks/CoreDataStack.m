//
//  CoreDataStack.m
//  FriendStocks
//
//  Created by Rakin Munjid on 2/16/15.
//  Copyright (c) 2015 Rakin Munjid. All rights reserved.
//

#import "CoreDataStack.h"

@implementation CoreDataStack

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (CoreDataStack *) defaultStack {
    static CoreDataStack *coreDataStack;
    if(!coreDataStack) {
        coreDataStack = [[CoreDataStack alloc] init];
    }
    return coreDataStack;
    
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FriendStocks" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FriendStocks.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSArray *)getAllStocks {
    NSMutableArray *theReturnArray = [[NSMutableArray alloc] init];
    
    @try {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Friend" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"friend_symbol" ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        
        NSError *error = nil;
        NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
//            NSLog(@"Error");
        } else if(fetchedObjects.count ==0) {
//            NSLog(@"Nothing was returned");
        }else {
            
            for (Friend *resultObject in fetchedObjects) {
                [theReturnArray addObject:resultObject];
            }
        }
    }
    @catch (NSException *exception) {
//        NSLog(@"Exception:%@",exception);
        
    }
    @finally {
        
    }
    return theReturnArray;
    
}

- (NSArray *)updateAllStocks {

    NSMutableArray *theReturnArray = [[NSMutableArray alloc] init];

    @try {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Friend" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"friend_symbol" ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
        
        NSError *error = nil;
        NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
//            NSLog(@"Error");
        } else if(fetchedObjects.count ==0) {
//            NSLog(@"Nothing was returned");
        }else {
            
            for (Friend *resultObject in fetchedObjects) {
                NSInteger randomNumber = arc4random() % 10;
                NSInteger operation = arc4random() % 2;
                if(operation==1) {
                    resultObject.friend_price += randomNumber;
                } else {
                    resultObject.friend_price -= randomNumber;
                }
                if(!resultObject){
//                    NSLog(@"This is where it crashes");
                } else {
                    [theReturnArray addObject:resultObject];
                }
            }
            [self saveContext];
        }
    }
    @catch (NSException *exception) {
//        NSLog(@"Exception:%@",exception);

    }
    @finally {
        
    }
    return theReturnArray;

}

- (void)closeMarket {

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Friend" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"friend_symbol" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
//        NSLog(@"Error");
    } else if(fetchedObjects.count ==0) {
//        NSLog(@"Nothing was returned");
    }else {
        for (Friend *resultObject in fetchedObjects) {
            resultObject.last_close = resultObject.friend_price;
        }
        [self saveContext];
    }
//    NSLog(@"Market Closed");
}

- (BOOL) doWeHaveAStockMarket {
    BOOL isMarketAvalable = NO;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Friend" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
//        NSLog(@"Error");
    } else if(fetchedObjects.count ==0) {
//        NSLog(@"No Results");
    }else {
        isMarketAvalable = YES;
    }

    return isMarketAvalable;
}

- (NSString *)getUserBalance {
    
    float userBalance = [self getUserBalanceInNumber]/100.0;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:userBalance]];
    return numberAsString;


}

-(long) getMarketValueInNumber {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OwnedStock" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
//        NSLog(@"Error");
        return 0;
    } else if(fetchedObjects.count ==0) {
//        NSLog(@"NO User");
        return 0;
    }
    
    int64_t userBalance = 0;
    for(OwnedStock *theStock in fetchedObjects){
        Friend *friend = theStock.friend;
        userBalance += friend.friend_price * theStock.amount_owned;
    }
    
    return userBalance;
}

- (NSString *)getMarketValue {
    double userBalance = [self getMarketValueInNumber]/100.0;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:userBalance]];
    return numberAsString;
}

-(NSString *) getUserValue {
    double userMarket = [self getMarketValueInNumber]/100.0;
    double userBalance = [self getUserBalanceInNumber]/100.0;
    double totalBalance = userBalance + userMarket;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:totalBalance]];
    return numberAsString;

}

- (int64_t)getUserBalanceInNumber {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
//        NSLog(@"Error");
        return 0;
    } else if(fetchedObjects.count ==0) {
//        NSLog(@"NO User");
        return 0;
    }
    
    User *resultObject = [fetchedObjects objectAtIndex:0];
    return resultObject.user_balance;
    
    
}


- (BOOL)buyStock:(Friend *)friend InQuantity:(int64_t) quantity AtPrice:(int64_t) price{

    OwnedStock *ownedStock = nil;
    User *user = nil;

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"OwnedStock" inManagedObjectContext:self.managedObjectContext];
    request.predicate = [NSPredicate predicateWithFormat:@"friend == %@", friend];
    
    NSFetchRequest *uRequest = [[NSFetchRequest alloc] init];
    uRequest.entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    
    NSError *error = nil;
    NSError *uError = nil;
    ownedStock = [[self.managedObjectContext executeFetchRequest:request error:&error] lastObject];
    user = [[self.managedObjectContext executeFetchRequest:uRequest error:&uError] lastObject];

    if (!error && !ownedStock)
    {
        ownedStock = [NSEntityDescription insertNewObjectForEntityForName:@"OwnedStock" inManagedObjectContext:self.managedObjectContext];
        ownedStock.amount_owned = quantity;
        ownedStock.bought_price = price;
        ownedStock.friend = friend;
        
    } else {
        if(error) {
            return NO;
        }
        if(ownedStock){
            int64_t totalShares = ownedStock.amount_owned + quantity;
            int64_t avgPrice = ((ownedStock.amount_owned * ownedStock.bought_price) + (quantity*price))/totalShares;
            ownedStock.amount_owned += quantity;
            ownedStock.bought_price = avgPrice;
        }
    }
    
    user.user_balance -= price * quantity;
    [self saveContext];

    return YES;
}

-(NSArray *) getAllOwnedStocks {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"OwnedStock" inManagedObjectContext:self.managedObjectContext];

    NSError *error = nil;
    return [self.managedObjectContext executeFetchRequest:request error:&error];

}

-(OwnedStock *) checkIfIOwn:(Friend *) theFriend {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"OwnedStock" inManagedObjectContext:self.managedObjectContext];
    request.predicate = [NSPredicate predicateWithFormat:@"friend == %@", theFriend];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (fetchedObjects == nil) {
//        NSLog(@"Error");
        return nil;
    } else if(fetchedObjects.count ==0) {
//        NSLog(@"NO User");
        return nil;
    }

    return [fetchedObjects lastObject];
}

-(BOOL) sellStocksForFriend:(Friend *) theFriend {
    
    BOOL saleSuccess = NO;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"OwnedStock" inManagedObjectContext:self.managedObjectContext];
    request.predicate = [NSPredicate predicateWithFormat:@"friend == %@", theFriend];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (fetchedObjects == nil) {
//        NSLog(@"Error");
        saleSuccess = NO;
    } else if(fetchedObjects.count ==0) {
//        NSLog(@"NO User");
        saleSuccess = NO;
    } else {
        OwnedStock *stock = [fetchedObjects lastObject];
        int64_t numberOfStocks = stock.amount_owned;
        int64_t currentPrice = theFriend.friend_price;
        int64_t moneyForSale = currentPrice * numberOfStocks;
        [self.managedObjectContext deleteObject:stock];
        
        NSFetchRequest *uRequest = [[NSFetchRequest alloc] init];
        uRequest.entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        NSError *uError;
        User *user = [[self.managedObjectContext executeFetchRequest:uRequest error:&uError] lastObject];
        user.user_balance +=  moneyForSale;
        [self saveContext];
        saleSuccess = YES;
    }
    
    return saleSuccess;
    
    
    
}

-(BOOL) sellStocks:(int)quantity forFriend:(Friend *) theFriend {
    BOOL saleSuccess = NO;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"OwnedStock" inManagedObjectContext:self.managedObjectContext];
    request.predicate = [NSPredicate predicateWithFormat:@"friend == %@", theFriend];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (fetchedObjects == nil) {
//        NSLog(@"Error");
        saleSuccess = NO;
    } else if(fetchedObjects.count ==0) {
//        NSLog(@"NO User");
        saleSuccess = NO;
    } else {
        OwnedStock *stock = [fetchedObjects lastObject];
        int64_t numberOfStocks = stock.amount_owned;
        int64_t currentPrice = theFriend.friend_price;
        int64_t moneyForSale = currentPrice * quantity;
        
        if(numberOfStocks == quantity) {
            [self.managedObjectContext deleteObject:stock];
        } else {
            stock.amount_owned -= quantity;
        }
        
        NSFetchRequest *uRequest = [[NSFetchRequest alloc] init];
        uRequest.entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        NSError *uError;
        User *user = [[self.managedObjectContext executeFetchRequest:uRequest error:&uError] lastObject];
        user.user_balance +=  moneyForSale;
        [self saveContext];
        saleSuccess = YES;
    }
    
    return saleSuccess;
    

}

-(void) addMoneyToUser:(int64_t) amount {
    NSFetchRequest *uRequest = [[NSFetchRequest alloc] init];
    uRequest.entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:self.managedObjectContext];
    NSError *uError;
    User *user = [[self.managedObjectContext executeFetchRequest:uRequest error:&uError] lastObject];
    user.user_balance +=  amount;
    [self saveContext];
}



@end
