
//
//  MainViewController.m
//  FriendStocks
//
//  Created by Rakin Munjid on 2/18/15.
//  Copyright (c) 2015 Rakin Munjid. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "CoreDataStack.h"
#import "User.h"
#import "Friend.h"
#import "PurchaseViewController.h"

@interface MainViewController () {
    NSTimer *theTimer;
}
@property (weak, nonatomic) IBOutlet UIButton *stockMarket;
@property (weak, nonatomic) IBOutlet UIButton *myPortfolio;
@property (weak, nonatomic) IBOutlet UILabel *connectHelp;
@property (weak, nonatomic) IBOutlet UIButton *connectWithFacebook;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cashLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;


@end

@implementation MainViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkTheSetup) name:@"FacebookConnected" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noFriendsToAdd) name:@"FacebookConnectedNoFriends" object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Get Cash" style:UIBarButtonItemStyleDone target:self action:@selector(getCash)];

    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStyleDone target:self action:@selector(shareApp)];
    
}

-(void) shareApp {
    
    NSString *shareString = @"Join me at The Stocky Market";
    UIImage *shareImage = [UIImage imageNamed:@"Default"];
    NSURL *shareUrl = [NSURL URLWithString:@"https://itunes.apple.com/us/app/id969869187?mt=8"];
    
    NSArray *activityItems = [NSArray arrayWithObjects:shareString, shareImage, shareUrl, nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    activityViewController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeAirDrop, UIActivityTypeAddToReadingList];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

-(void) getCash{
    
    UIStoryboard *mystoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    PurchaseViewController *purchaseController =  [mystoryboard instantiateViewControllerWithIdentifier:@"purchaseviewcontroller"];
    
    [self.navigationController pushViewController:purchaseController animated:YES];
    
}

-(void) noFriendsToAdd {
    
    self.stockMarket.hidden = self.myPortfolio.hidden = self.balanceLabel.hidden = self.marketBalanceLabel.hidden = self.totalBalanceLabel.hidden = self.cashLabel.hidden = self.marketLabel.hidden = self.totalLabel.hidden = self.connectWithFacebook.hidden = YES;
    self.connectHelp.hidden = NO;
    self.connectHelp.text = @"Connect Successful. \n No Friends Found.";
    
}

-(void) checkTheSetup {

    [(AppDelegate *)[[UIApplication sharedApplication] delegate] shouldIStartUpdating];

    CoreDataStack *coreDataStack = [CoreDataStack defaultStack];
    
    if([coreDataStack doWeHaveAStockMarket]){
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Get Cash" style:UIBarButtonItemStyleDone target:self action:@selector(getCash)];
        
        if(![theTimer isValid]){
            theTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(checkTheSetup) userInfo:nil repeats:YES];
        }
        self.stockMarket.hidden = self.myPortfolio.hidden = self.balanceLabel.hidden = self.marketBalanceLabel.hidden = self.totalBalanceLabel.hidden = self.cashLabel.hidden = self.marketLabel.hidden = self.totalLabel.hidden = NO;
        self.connectHelp.hidden = self.connectWithFacebook.hidden = YES;
        
        self.balanceLabel.text = [coreDataStack getUserBalance];
        self.marketBalanceLabel.text = [coreDataStack getMarketValue];
        self.totalBalanceLabel.text = [coreDataStack getUserValue];

    } else {
        self.stockMarket.hidden = self.myPortfolio.hidden = self.balanceLabel.hidden = self.marketBalanceLabel.hidden = self.totalBalanceLabel.hidden = self.cashLabel.hidden = self.marketLabel.hidden = self.totalLabel.hidden = YES;
        self.connectHelp.hidden = self.connectWithFacebook.hidden = NO;
    }
    
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self checkTheSetup];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if([theTimer isValid])
        [theTimer invalidate];
}


-(IBAction)getMyFriends:(id)sender{
    //Step 1: User connects to Facebook - Calls method in Appdelegate to authenticate User
    if ([FBSession activeSession].state != FBSessionStateOpen &&
        [FBSession activeSession].state != FBSessionStateOpenTokenExtended) {
        
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        [appDelegate openActiveSessionWithPermissions:@[@"user_friends"] allowLoginUI:YES];
    }
}



@end
