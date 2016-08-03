//
//  FriendsDetailViewController.m
//  FriendStocks
//
//  Created by Rakin Munjid on 2/17/15.
//  Copyright (c) 2015 Rakin Munjid. All rights reserved.
//

#import "FriendsDetailViewController.h"
#import "AppDelegate.h"

@interface FriendsDetailViewController () {
    NSTimer* myTimer;
    UITapGestureRecognizer *tapper;
}
@property (weak, nonatomic) IBOutlet UILabel *friend_name;
@property (weak, nonatomic) IBOutlet UILabel *current_price;
@property (weak, nonatomic) IBOutlet UILabel *open_price;
@property (weak, nonatomic) IBOutlet UILabel *change_price;
@property (weak, nonatomic) IBOutlet UITextField *quantityStock;
@property (strong, nonatomic) Friend *theFriend;
@property (weak, nonatomic) IBOutlet UIView *ownedView;
@property (weak, nonatomic) IBOutlet UILabel *quantityOwned;
@property (weak, nonatomic) IBOutlet UILabel *averagePricePaid;
@property (weak, nonatomic) IBOutlet UILabel *totalValue;
@property (weak, nonatomic) IBOutlet UITextField *quantityToSell;


@end

@implementation FriendsDetailViewController

-(void) cancelEditing {
    [self.quantityStock resignFirstResponder];
    [self.quantityToSell resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.theFriend = [self displayUpdatedInfo];
    tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelEditing)];
    [self.view addGestureRecognizer:tapper];
    
    if(self.theFriend){
        self.friend_name.text = self.theFriend.friend_name;
        self.current_price.text = [NSString stringWithFormat:@"Current Price: %0.2f$",self.theFriend.friend_price/100.0];
        self.open_price.text = [NSString stringWithFormat:@"Open Price: %0.2f$",self.theFriend.last_close/100.0];
        float theChange = (self.theFriend.friend_price - self.theFriend.last_close)/100.0;
        float thePercentage = (theChange/((self.theFriend.last_close*1.0)/100.0))*100.0;

        if(theChange < 0){
            NSString *theChangeStr = [NSString stringWithFormat:@"Change: %0.2f$ (%0.2f%%)",theChange, thePercentage];
            NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:theChangeStr];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,7)];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(7,string.length-7)];
            self.change_price.attributedText = string;
        } else {
            NSString *theChangeStr = [NSString stringWithFormat:@"Change: +%0.2f$ (+%0.2f%%)",theChange, thePercentage];
            NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:theChangeStr];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,7)];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:3.0/255.0 green:192.0/255.0 blue:60.0/255.0 alpha:1.0] range:NSMakeRange(7,string.length-7)];
            self.change_price.attributedText = string;
        }
        myTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                                            target: self
                                                          selector: @selector(updateChange)
                                                          userInfo: nil
                                                           repeats: YES];
        [self checkIfOwned];

    }
    
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [myTimer invalidate];
    [self.view removeGestureRecognizer:tapper];

}

-(void) updateChange{
    if(self.theFriend){
        self.current_price.text = [NSString stringWithFormat:@"Current Price: %0.2f$",self.theFriend.friend_price/100.0];
        float theChange = (self.theFriend.friend_price - self.theFriend.last_close)/100.0;
        float thePercentage = (theChange/((self.theFriend.last_close*1.0)/100.0))*100.0;
        
        if(theChange < 0){
            NSString *theChangeStr = [NSString stringWithFormat:@"Change: %0.2f$ (%0.2f%%)",theChange, thePercentage];
            NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:theChangeStr];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,7)];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(7,string.length-7)];
            self.change_price.attributedText = string;
        } else {
            NSString *theChangeStr = [NSString stringWithFormat:@"Change: +%0.2f$ (+%0.2f%%)",theChange, thePercentage];
            NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:theChangeStr];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,7)];
            [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:3.0/255.0 green:192.0/255.0 blue:60.0/255.0 alpha:1.0] range:NSMakeRange(7,string.length-7)];
            self.change_price.attributedText = string;
        }
        [self checkIfOwned];

    }
}


-(Friend *) displayUpdatedInfo {
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Friend" inManagedObjectContext:coreDataStack.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" friend_id = %d ",self.friendID];
    [fetchRequest setPredicate:predicate];

    NSError *error = nil;
    NSArray *fetchedObjects = [coreDataStack.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
//        NSLog(@"Error");
    } else {
        for (Friend *resultObject in fetchedObjects) {
            return resultObject;
        }
    }
    return nil;
}

- (IBAction)buyStock:(id)sender {
    [self.quantityStock resignFirstResponder];
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    int64_t quantity = [self.quantityStock.text intValue];
    int64_t price = self.theFriend.friend_price;
    int64_t userBalance = [coreDataStack getUserBalanceInNumber];
    if(quantity == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Quantity" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    if((price*quantity) > userBalance){
//        NSLog(@"You do not have enough money");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Balance" message:@"You do not have enough Cash in hand" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    } else {
        if([coreDataStack buyStock:self.theFriend InQuantity:quantity AtPrice:price]){
            [self checkIfOwned];
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] shouldIStartUpdating];
            
            NSString *shareString = [NSString stringWithFormat:@"I just added %@ to my Stocky Market Portfolio",self.theFriend.friend_name];
            UIImage *shareImage = [UIImage imageNamed:@"Default"];
            NSURL *shareUrl = [NSURL URLWithString:@"https://itunes.apple.com/us/app/id969869187?mt=8"];
            
            NSArray *activityItems = [NSArray arrayWithObjects:shareString, shareImage, shareUrl, nil];
            
            UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            activityViewController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAirDrop, UIActivityTypeAddToReadingList];
            
            [self presentViewController:activityViewController animated:YES completion:nil];
            
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Problem" message:@"There was a Technical Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
    
}

-(void) checkIfOwned{
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    OwnedStock *ownedStock = [coreDataStack checkIfIOwn:self.theFriend];
    
    if(ownedStock) {
        self.ownedView.hidden = NO;
        self.quantityOwned.text = [NSString stringWithFormat:@"Quantity Owned: %lld",ownedStock.amount_owned];
        self.averagePricePaid.text = [NSString stringWithFormat:@"Quantity Owned: %0.2f",ownedStock.bought_price/100.0];
        float totalValue = ((self.theFriend.friend_price/100.0)*ownedStock.amount_owned);
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
        NSString *numberAsString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:totalValue]];
        self.totalValue.text = [NSString stringWithFormat:@"Market Value: %@",numberAsString];
    } else {
        self.ownedView.hidden = YES;
    }
}

- (IBAction)sellAllStocks:(id)sender {
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    if([coreDataStack sellStocksForFriend:self.theFriend]){
        
        NSString *shareString = [NSString stringWithFormat:@"I just sold stocks of %@ from my Stocky Market Portfolio",self.theFriend.friend_name];
        UIImage *shareImage = [UIImage imageNamed:@"Default"];
        NSURL *shareUrl = [NSURL URLWithString:@"https://itunes.apple.com/us/app/id969869187?mt=8"];
        
        NSArray *activityItems = [NSArray arrayWithObjects:shareString, shareImage, shareUrl, nil];
        
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        activityViewController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAirDrop, UIActivityTypeAddToReadingList];
        
        [self presentViewController:activityViewController animated:YES completion:nil];
        

    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:@"Technial Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
}

- (IBAction)sellTheStocks:(id)sender {
    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    OwnedStock *ownedStock = [coreDataStack checkIfIOwn:self.theFriend];
    int amountToSell = [self.quantityToSell.text intValue];
    if(amountToSell == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Quantity" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if(amountToSell > ownedStock.amount_owned) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Quantity" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    if([coreDataStack sellStocks:amountToSell forFriend:self.theFriend]){
        NSString *shareString = [NSString stringWithFormat:@"I just sold stocks of %@ from my Stocky Market Portfolio",self.theFriend.friend_name];
        UIImage *shareImage = [UIImage imageNamed:@"Default"];
        NSURL *shareUrl = [NSURL URLWithString:@"https://itunes.apple.com/us/app/id969869187?mt=8"];
        
        NSArray *activityItems = [NSArray arrayWithObjects:shareString, shareImage, shareUrl, nil];
        
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        activityViewController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAirDrop, UIActivityTypeAddToReadingList];
        
        [self presentViewController:activityViewController animated:YES completion:nil];
        
        self.quantityToSell.text = @"";
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"OOPS" message:@"Technial Error" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }

}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.view.frame = CGRectMake(0, -100, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:nil];
    

}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    [UIView animateWithDuration:0.5
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height  );
                     }
                     completion:nil];
    
}


@end
