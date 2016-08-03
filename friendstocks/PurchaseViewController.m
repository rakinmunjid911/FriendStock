//
//  PurchaseViewController.m
//  FriendStocks
//
//  Created by Rakin Munjid on 3/16/15.
//  Copyright (c) 2015 Rakin Munjid. All rights reserved.
//

#import "PurchaseViewController.h"
#import "MainViewController.h"
#import "CoreDataStack.h"

@interface PurchaseViewController ()
@property (strong, nonatomic) MainViewController *homeViewController;
@property (weak, nonatomic) IBOutlet UILabel *userBalanceCash;

@end

@implementation PurchaseViewController

-(void) updateBalance {
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    self.userBalanceCash.text = [coreDataStack getUserBalance];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Get Cash";
    
    [self updateBalance];

    
    _buyOneButton.enabled = NO;
    _buyTwoButton.enabled = NO;
    _buyThreeButton.enabled = NO;
    _buyFourButton.enabled = NO;
    _buyFiveButton.enabled = NO;
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    self.productOneID = @"com.rakinmunjid.stockmarket.hundredthousand";
    self.productTwoID = @"com.rakinmunjid.stockmarket.fivehundredthousand";
    self.productThreeID = @"com.rakinmunjid.stockmarket.million";
    self.productFourID = @"com.rakinmunjid.stockmarket.tenmillion";
    self.productFiveID = @"com.rakinmunjid.stockmarket.billion";
    
    [self getProductInfo];

    
}

-(void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(void)getProductInfo
{
    
    if ([SKPaymentQueue canMakePayments])
    {
        NSSet *productList = [NSSet setWithObjects:self.productOneID, self.productTwoID, self.productThreeID, self.productFourID, self.productFiveID, nil];
        
        SKProductsRequest *request = [[SKProductsRequest alloc]
                                      initWithProductIdentifiers:productList];
        request.delegate = self;
        
        [request start];
    }
    else {
        //        _productOneDescription.text = @"Please enable In App Purchase in Settings";
#warning add this crap
    }
}

#pragma mark -
#pragma mark SKProductsRequestDelegate

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    
    NSSortDescriptor *mySortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"price" ascending:YES];
    
    NSArray *products = response.products;
    NSArray *myArrayOfProducts;
    if (products.count != 0) {
        NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:response.products];
        [tempArray sortUsingDescriptors:[NSArray arrayWithObject:mySortDescriptor]];
        myArrayOfProducts = tempArray;
    }
    
    
    if (myArrayOfProducts.count != 0)
    {
        
        _productOne = myArrayOfProducts[0];
        _buyOneButton.enabled = YES;
        
        _productTwo = myArrayOfProducts[1];
        _buyTwoButton.enabled = YES;
        
        _productThree = myArrayOfProducts[2];
        _buyThreeButton.enabled = YES;
        
        
        _productFour = myArrayOfProducts[3];
        _buyFourButton.enabled = YES;
        
        
        _productFive = myArrayOfProducts[4];
        _buyFiveButton.enabled = YES;
    } else {
#warning alert message
    }
    
    products = response.invalidProductIdentifiers;
    
    for (SKProduct *product in products)
    {
//        NSLog(@"Product not found: %@", product);
    }
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
//    NSLog(@"request - didFailWithError: %@", [[error userInfo] objectForKey:@"NSLocalizedDescription"]);
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)buyProduct:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1: {
            SKPayment *payment = [SKPayment paymentWithProduct:_productOne];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
            break;
        }
        case 2: {
            SKPayment *payment = [SKPayment paymentWithProduct:_productTwo];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
            break;
        }
        case 3: {
            SKPayment *payment = [SKPayment paymentWithProduct:_productThree];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
            break;
        }
        case 4: {
            SKPayment *payment = [SKPayment paymentWithProduct:_productFour];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
            break;
        }
        case 5: {
            SKPayment *payment = [SKPayment paymentWithProduct:_productFive];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
            break;
        }
        default:
            break;
    }
    
    
}

#pragma mark -
#pragma mark SKPaymentTransactionObserver

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                if([transaction.payment.productIdentifier isEqual:self.productOneID]){
                    [self unlockFeatureOne];
                } else if([transaction.payment.productIdentifier isEqual:self.productTwoID]){
                    [self unlockFeatureTwo];
                } else if([transaction.payment.productIdentifier isEqual:self.productThreeID]){
                    [self unlockFeatureThree];
                } else if([transaction.payment.productIdentifier isEqual:self.productFourID]){
                    [self unlockFeatureFour];
                } else if([transaction.payment.productIdentifier isEqual:self.productFiveID]){
                    [self unlockFeatureFive];
                }
                
                [[SKPaymentQueue defaultQueue]
                 finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
//                NSLog(@"Transaction Failed");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            default:
                break;
        }
    }
}

-(void)unlockFeatureOne
{
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [coreDataStack addMoneyToUser:10000000];
    [self updateBalance];

    
}

-(void)unlockFeatureTwo
{
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [coreDataStack addMoneyToUser:50000000];
    [self updateBalance];

}

-(void)unlockFeatureThree
{
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [coreDataStack addMoneyToUser:100000000];
    [self updateBalance];
}

-(void)unlockFeatureFour
{
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [coreDataStack addMoneyToUser:1000000000];
    [self updateBalance];
}

-(void)unlockFeatureFive
{
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    [coreDataStack addMoneyToUser:100000000000];
    [self updateBalance];
}



@end
