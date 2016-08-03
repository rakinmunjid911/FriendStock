//
//  PortfolioTableViewCell.h
//  FriendStocks
//
//  Created by Rakin Munjid on 2/20/15.
//  Copyright (c) 2015 Rakin Munjid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OwnedStock.h"
#import "Friend.h"

@interface PortfolioTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *stock_name;
@property (weak, nonatomic) IBOutlet UILabel *stock_symbol;
@property (weak, nonatomic) IBOutlet UILabel *stock_price;
@property (weak, nonatomic) IBOutlet UILabel *stock_avg_price;
@property (weak, nonatomic) IBOutlet UILabel *stock_quantity;
@property (weak, nonatomic) IBOutlet UILabel *stock_change;
@property (weak, nonatomic) IBOutlet UILabel *stock_change_percent;
@property (weak, nonatomic) IBOutlet UIView *stock_change_view;
@property (weak, nonatomic) IBOutlet UILabel *total_value;


-(void)drawCell:(OwnedStock *) ownedStock;

@end
