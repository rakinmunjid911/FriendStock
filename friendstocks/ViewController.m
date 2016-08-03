//
//  ViewController.m
//  FriendStocks
//
//  Created by Rakin Munjid on 2/16/15.
//  Copyright (c) 2015 Rakin Munjid. All rights reserved.
//

#import "ViewController.h"
#import "User.h"
#import "Friend.h"
#import "CoreDataStack.h"
#import "AppDelegate.h"
#import "StocksTableViewCell.h"
#import "FriendsDetailViewController.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *theStockArray;
    NSMutableDictionary *theStockDictionary;
    NSArray *sortedKeys;
}

@property (weak, nonatomic) IBOutlet UITableView *showStocks;
@property (strong, nonatomic) NSTimer *theMarketTimer;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.showStocks.delegate = self;
    self.showStocks.dataSource = self;

    if([self displayFriends]){
        if(![_theMarketTimer isValid]){
            _theMarketTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updateFriends) userInfo:nil repeats:YES];
        }
        
    }

}


-(void)updateFriends {
    [theStockArray removeAllObjects];
    [theStockArray addObjectsFromArray:[[CoreDataStack defaultStack] getAllStocks]];
    [theStockDictionary removeAllObjects];
    theStockDictionary = [[NSMutableDictionary alloc] initWithDictionary:[self convertArrayToKeyedDictionary:theStockArray]];
    sortedKeys = [[theStockDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

    [self.showStocks reloadData];
    
}

-(NSDictionary *) convertArrayToKeyedDictionary:(NSArray *) theArray {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (char firstChar = 'a'; firstChar <= 'z'; firstChar++) {
        NSString *firstCharacter = [NSString stringWithFormat:@"%c", firstChar];
        NSArray *content = [theArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.friend_name beginswith[cd] %@", firstCharacter]];
        NSMutableArray *mutableContent = [NSMutableArray arrayWithArray:content];

        if ([mutableContent count] > 0)
        {
            NSString *key = [firstCharacter uppercaseString];
            [dict setObject:mutableContent forKey:key];
        }
    }
    return dict;
}



-(BOOL) displayFriends{
    BOOL friendsAvailable = NO;
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Friend" inManagedObjectContext:coreDataStack.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"friend_symbol" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
//        NSLog(@"Error");
    } else if(fetchedObjects.count ==0) {
        
    }else {
        
        theStockArray = [[NSMutableArray alloc] initWithArray:fetchedObjects];
        theStockDictionary = [[NSMutableDictionary alloc] initWithDictionary:[self convertArrayToKeyedDictionary:theStockArray]];
        sortedKeys = [[theStockDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

        [self.showStocks reloadData];
        friendsAvailable = YES;
        if(![_theMarketTimer isValid]){
            _theMarketTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updateFriends) userInfo:nil repeats:YES];
        }
    }
    return friendsAvailable;

}



#pragma mark -
#pragma TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ([sortedKeys count]);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString *key = [sortedKeys objectAtIndex:section];
    return [[theStockDictionary valueForKey:key] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return ([sortedKeys objectAtIndex:section]);
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return sortedKeys;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    StocksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StocksCell"];
    
    UIView *theView = [[UIView alloc] init];
    theView.backgroundColor = [UIColor colorWithRed:254/255.0 green:251/255.0 blue:169/255.0 alpha:1.0];
    
    cell.selectedBackgroundView = theView;
    
    
    NSString *key = [sortedKeys objectAtIndex:indexPath.section];
    NSArray *array = [theStockDictionary objectForKey:key];
    Friend *friend = [array objectAtIndex:indexPath.row];
    [cell drawTheCell:friend];
    return cell;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath * indexPath = [self.showStocks indexPathForCell:sender];
    FriendsDetailViewController *friendDetailViewController = segue.destinationViewController;
    
    NSString *key = [sortedKeys objectAtIndex:indexPath.section];
    NSArray *array = [theStockDictionary objectForKey:key];
    Friend *friend = [array objectAtIndex:indexPath.row];

    friendDetailViewController.title = friend.friend_symbol;
    friendDetailViewController.friendID = friend.friend_id;
}

@end
