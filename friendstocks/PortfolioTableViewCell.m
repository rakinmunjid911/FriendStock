//
//  PortfolioTableViewCell.m
//  FriendStocks
//
//  Created by Rakin Munjid on 2/20/15.
//  Copyright (c) 2015 Rakin Munjid. All rights reserved.
//

#import "PortfolioTableViewCell.h"

@implementation PortfolioTableViewCell

-(void)drawCell:(OwnedStock *) ownedStock {
    
    Friend *friend = ownedStock.friend;
    
    self.stock_name.text = friend.friend_name;
    self.stock_symbol.text = friend.friend_symbol;
    self.stock_price.text = [NSString stringWithFormat:@"%0.2f",friend.friend_price/100.0];
    self.stock_avg_price.text = [NSString stringWithFormat:@"Avg Price: %0.2f",ownedStock.bought_price/100.0];
    self.stock_quantity.text = [NSString stringWithFormat:@"Quantity: %lld",ownedStock.amount_owned];
    
    float theChange = (friend.friend_price - friend.last_close)/100.0;

    float thePercentage = (theChange/((friend.last_close*1.0)/100.0))*100.0;
    if(theChange < 0){
        self.stock_change.text = [NSString stringWithFormat:@"%0.2f",theChange];
        self.stock_change_percent.text = [NSString stringWithFormat:@"%0.2f%%",thePercentage];
        self.stock_change_view.backgroundColor = [UIColor redColor];
    } else {
        self.stock_change.text = [NSString stringWithFormat:@"+%0.2f",theChange];
        self.stock_change_percent.text = [NSString stringWithFormat:@"+%0.2f%%",thePercentage];
        self.stock_change_view.backgroundColor = [UIColor greenColor];
    }
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    float totalValue = ((friend.friend_price/100.0)*ownedStock.amount_owned);
    
    NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:totalValue]];

    
    self.total_value.text = [NSString stringWithFormat:@"Total Value: %@", numberAsString];
    
    // border radius
    [self.stock_change_view.layer setCornerRadius:10.0f];
    
    // border
    [self.stock_change_view.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.stock_change_view.layer setBorderWidth:0.5f];
    
    // drop shadow
    [self.stock_change_view.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.stock_change_view.layer setShadowOpacity:0.8];
    [self.stock_change_view.layer setShadowRadius:1.0];
    [self.stock_change_view.layer setShadowOffset:CGSizeMake(1.0, 1.0)];
    

}

@end
