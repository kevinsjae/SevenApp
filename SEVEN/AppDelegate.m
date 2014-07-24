//
//  AppDelegate.m
//  SEVEN
//
//  Created by Bobby Ren on 7/2/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Parse setApplicationId:@"HBwUDQrOSWLhK7Lx2yNYviQ6xe8sJHeBMkpoX3Mm"
                  clientKey:@"Oqu48KsSu2fg8SFEJjoAElCIqaSPDpPqxW5QceBM"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    /*
    PFUser *user = [PFUser currentUser];
    if (user) {
        NSLog(@"Logged in");
        [self goToProfile];
    }
    else {
        NSLog(@"Not logged in");
    }
     */
    // facebook
    [PFFacebookUtils initializeFacebook];

    return YES;
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
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)goToProfile {
    UIStoryboard *storyboard = self.window.rootViewController.storyboard;
    UINavigationController *rootNav = [storyboard instantiateViewControllerWithIdentifier:@"MainNavigationController"];
    if (![self.window.rootViewController isKindOfClass:[rootNav class]]) {
        self.window.rootViewController = rootNav;

        /*
        [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{
            // todo: transition animation should not show viewController, but instead a blank initial controller or splash screen
        }];
         */
    }
    else {
        [(UINavigationController *)self.window.rootViewController popToRootViewControllerAnimated:YES];
    }
}

-(void)goToIntro {
    UIStoryboard *storyboard = self.window.rootViewController.storyboard;
    UINavigationController *rootNav = [storyboard instantiateViewControllerWithIdentifier:@"IntroViewController"];
    if (![self.window.rootViewController isKindOfClass:[rootNav class]]) {
        self.window.rootViewController = rootNav;
        /*
        [self.window.rootViewController dismissViewControllerAnimated:YES completion:^{
        }];
         */
    }
    else {
        [(UINavigationController *)self.window.rootViewController popToRootViewControllerAnimated:YES];
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

@end
