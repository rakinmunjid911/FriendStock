//
//  AppDelegate.m
//  FriendStocks
//
//  Created by Rakin Munjid on 2/16/15.
//  Copyright (c) 2015 Rakin Munjid. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataStack.h"
#import "FacebookConnect.h"

@interface AppDelegate ()

@property (strong, nonatomic) NSTimer *theMarketTimer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [FBAppEvents activateApp];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor: [UIColor colorWithRed:0/255.0 green:85/255.0 blue:129/255.0 alpha:1.0]];
    NSDictionary *style = @{NSForegroundColorAttributeName :[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:style];
    
    self.window.backgroundColor = [UIColor whiteColor];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[CoreDataStack defaultStack] closeMarket];

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBAppCall handleDidBecomeActive];
    [self shouldIStartUpdating];

}

-(void) shouldIStartUpdating {
    
    //STart timer if doesnt exits - To update add stocks
    if([[CoreDataStack defaultStack] doWeHaveAStockMarket]) {
        if(![_theMarketTimer isValid]){
//            NSLog(@"Market Open");
            _theMarketTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updateFriends) userInfo:nil repeats:YES];
        }
    }
}

-(void)updateFriends {
    [[CoreDataStack defaultStack] updateAllStocks];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[CoreDataStack defaultStack] saveContext];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    //Step 3: User provides permission and comes back to app
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}

-(void)openActiveSessionWithPermissions:(NSArray *)permissions allowLoginUI:(BOOL)allowLoginUI{
    //Step 2: Authenticating user for permissions - WIll open Facebook App
    
    
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:allowLoginUI
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                      NSDictionary *sessionStateInfo = [[NSDictionary alloc] initWithObjectsAndKeys: session, @"session", [NSNumber numberWithInteger:status], @"state", error, @"error", nil];
                                      
                                      [FacebookConnect handleFBSessionStateChangeWithNotification:sessionStateInfo];
                                      
//                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"SessionStateChangeNotification" object:nil userInfo:sessionStateInfo];
                                      
                                  }];
}


@end
