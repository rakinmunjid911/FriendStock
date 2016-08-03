//
//  StocksTableViewCell.m
//  FriendStocks
//
//  Created by Rakin Munjid on 2/17/15.
//  Copyright (c) 2015 Rakin Munjid. All rights reserved.
//

#import "StocksTableViewCell.h"

@implementation StocksTableViewCell

-(void) drawTheCell:(Friend *)theFriend {
    self.stock_symbol.text = theFriend.friend_symbol;
    self.stock_name.text = theFriend.friend_name;
    self.stock_price.text = [NSString stringWithFormat:@"%0.2f",theFriend.friend_price/100.0];
    float theChange = (theFriend.friend_price - theFriend.last_close)/100.0;
    
    float thePercentage = (theChange/((theFriend.last_close*1.0)/100.0))*100.0;
    if(theChange < 0){
        self.stock_change.text = [NSString stringWithFormat:@"%0.2f",theChange];
        self.stock_percentage.text = [NSString stringWithFormat:@"%0.2f%%",thePercentage];
        self.stock_change_view.backgroundColor = [UIColor redColor];
    } else {
        self.stock_change.text = [NSString stringWithFormat:@"+%0.2f",theChange];
        self.stock_percentage.text = [NSString stringWithFormat:@"+%0.2f%%",thePercentage];
        self.stock_change_view.backgroundColor = [UIColor greenColor];
    }
    
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
