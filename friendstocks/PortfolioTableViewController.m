//
//  PortfolioTableViewController.m
//  FriendStocks
//
//  Created by Rakin Munjid on 2/20/15.
//  Copyright (c) 2015 Rakin Munjid. All rights reserved.
//

#import "PortfolioTableViewController.h"
#import "CoreDataStack.h"
#import "PortfolioTableViewCell.h"
#import "FriendsDetailViewController.h"

@interface PortfolioTableViewController () {
    NSMutableArray *portfolioStocks;
    NSTimer *theTimer;
}
@end

@implementation PortfolioTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    portfolioStocks = [[NSMutableArray alloc] initWithArray:[coreDataStack getAllOwnedStocks]];
    if(![theTimer isValid]){
        theTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updateStocks) userInfo:nil repeats:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(portfolioStocks.count == 0){
        return 1;
    }
    return [portfolioStocks count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(portfolioStocks.count == 0){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = @"No Stocks in Portfolio";
        return cell;
    }
    PortfolioTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"portfolioCell" forIndexPath:indexPath];
    
    UIView *theView = [[UIView alloc] init];
    theView.backgroundColor = [UIColor colorWithRed:254/255.0 green:251/255.0 blue:169/255.0 alpha:1.0];
    
    cell.selectedBackgroundView = theView;

    
    [cell drawCell:[portfolioStocks objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void)updateStocks {
    [self performSelectorInBackground:@selector(updateFriends) withObject:nil];
}

-(void)updateFriends{
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [portfolioStocks removeAllObjects];
    portfolioStocks = [[NSMutableArray alloc] initWithArray:[coreDataStack getAllOwnedStocks]];
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
    FriendsDetailViewController *friendDetailViewController = segue.destinationViewController;
    
    OwnedStock *theStock = [portfolioStocks objectAtIndex:indexPath.row];
    
    Friend *friend = theStock.friend;
    
    friendDetailViewController.title = friend.friend_symbol;
    friendDetailViewController.friendID = friend.friend_id;
}

@end
