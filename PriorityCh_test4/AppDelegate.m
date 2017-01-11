//
//  AppDelegate.m
//  PriorityCh_test4
//
//  Created by Manulife on 4/26/13.
//  Copyright (c) 2013 Manulife. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "SQLiteManager.h"
#import "TIMERUIApplication.h"
#import "Utility.h"
#import "ExitViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
//    // Override point for customization after application launch.
//    
//    MainViewController *vc = [[MainViewController alloc]init];
//    [self.window setRootViewController:vc];
//    
//    self.window.backgroundColor = [UIColor whiteColor];
//    [self.window makeKeyAndVisible];
    
    NSLog(@"%@", [SQLiteManager databasePath]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidTimeout:) name:kApplicationDidTimeoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationTimeoutWarning:) name:kApplicationDidTimeoutWarning object:nil];
    
    return YES;
}

-(void)applicationDidTimeout:(NSNotification *) notif
{
    NSLog (@"time exceeded!!");
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    ExitViewController *vc = [[[ExitViewController alloc] init]autorelease];
    UINavigationController *nav = [[[UINavigationController alloc]init]autorelease];
    
    self.window.rootViewController = [nav initWithRootViewController:vc];
    [self.window makeKeyAndVisible];
    
    [(TIMERUIApplication *)[UIApplication sharedApplication] resetIdleTimer];
}

-(void)applicationTimeoutWarning:(NSNotification *) notif
{
    NSLog (@"timeout warning!!!");
    
    UIAlertView *alert_View = [[[UIAlertView alloc] initWithTitle:@"Priority Choice" message:@"Lock in a few minutes" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil] autorelease];
    [alert_View show];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
