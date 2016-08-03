//
//  StocksTableViewCell.h
//  FriendStocks
//
//  Created by Rakin Munjid on 2/17/15.
//  Copyright (c) 2015 Rakin Munjid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Friend.h"

@interface StocksTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *stock_symbol;
@property (weak, nonatomic) IBOutlet UILabel *stock_name;
@property (weak, nonatomic) IBOutlet UILabel *stock_price;
@property (weak, nonatomic) IBOutlet UILabel *stock_change;
@property (weak, nonatomic) IBOutlet UILabel *stock_percentage;
@property (weak, nonatomic) IBOutlet UIView *stock_change_view;

-(void) drawTheCell:(Friend *)theFriend;

@end
