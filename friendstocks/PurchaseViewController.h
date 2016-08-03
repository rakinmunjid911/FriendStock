//
//  PurchaseViewController.h
//  FriendStocks
//
//  Created by Rakin Munjid on 3/16/15.
//  Copyright (c) 2015 Rakin Munjid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface PurchaseViewController : UIViewController <SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (strong, nonatomic) SKProduct *productOne;
@property (strong, nonatomic) NSString *productOneID;
//@property (strong, nonatomic) IBOutlet UILabel *productOneTitle;
@property (strong, nonatomic) IBOutlet UIButton *buyOneButton;
//@property (strong, nonatomic) IBOutlet UITextView *productOneDescription;



@property (strong, nonatomic) SKProduct *productTwo;
@property (strong, nonatomic) NSString *productTwoID;
//@property (strong, nonatomic) IBOutlet UILabel *productTwoTitle;
@property (strong, nonatomic) IBOutlet UIButton *buyTwoButton;
//@property (strong, nonatomic) IBOutlet UITextView *productTwoDescription;


@property (strong, nonatomic) SKProduct *productThree;
@property (strong, nonatomic) NSString *productThreeID;
//@property (strong, nonatomic) IBOutlet UILabel *productThreeTitle;
@property (strong, nonatomic) IBOutlet UIButton *buyThreeButton;
//@property (strong, nonatomic) IBOutlet UITextView *productThreeDescription;


@property (strong, nonatomic) SKProduct *productFour;
@property (strong, nonatomic) NSString *productFourID;
//@property (strong, nonatomic) IBOutlet UILabel *productFourTitle;
@property (strong, nonatomic) IBOutlet UIButton *buyFourButton;
//@property (strong, nonatomic) IBOutlet UITextView *productFourDescription;


@property (strong, nonatomic) SKProduct *productFive;
@property (strong, nonatomic) NSString *productFiveID;
//@property (strong, nonatomic) IBOutlet UILabel *productFiveTitle;
@property (strong, nonatomic) IBOutlet UIButton *buyFiveButton;
//@property (strong, nonatomic) IBOutlet UITextView *productFiveDescription;

- (IBAction)buyProduct:(UIButton *)sender;
- (void)getProductInfo;


@end
