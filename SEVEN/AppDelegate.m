//
//  AppDelegate.m
//  SEVEN
//
//  Created by Bobby Ren on 7/2/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "FacebookHelper.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Parse setApplicationId:@"HBwUDQrOSWLhK7Lx2yNYviQ6xe8sJHeBMkpoX3Mm"
                  clientKey:@"Oqu48KsSu2fg8SFEJjoAElCIqaSPDpPqxW5QceBM"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    // facebook
    [PFFacebookUtils initializeFacebook];
    // if keep getting error com.facebook.sdk Code=2, must log out of facebook app and facebook setting on iphone, delete app, and try again

    PFUser *user = [PFUser currentUser];
#if 0
    if (user) {
        NSLog(@"Logged in");
        [self goToProfile];
    }
    else {
        NSLog(@"Not logged in");
    }
#endif

#if TESTING
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];

    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        DebugLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            DebugLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
#endif
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
    // check user info
    PFObject *facebookUser = [[PFUser currentUser] objectForKey:@"facebookFriend"];
    if (!facebookUser) {
        NSLog(@"No user!");
        [FacebookHelper getFacebookInfo];
    }

    UIStoryboard *storyboard = self.window.rootViewController.storyboard;
    UINavigationController *rootNav = [storyboard instantiateViewControllerWithIdentifier:@"MainNavigationController"];
    if (![self.window.rootViewController isKindOfClass:[rootNav class]]) {
        [UIView animateWithDuration:.5 animations:^{ // todo: animation not working
            self.window.rootViewController.view.alpha = 0;
        } completion:^(BOOL finished) {
            self.window.rootViewController = rootNav;
            rootNav.view.alpha = 0;
            [UIView animateWithDuration:.5 animations:^{
                rootNav.view.alpha = 1;
            }];
        }];
    }
    else {
        [(UINavigationController *)self.window.rootViewController popToRootViewControllerAnimated:YES];
    }
}

-(void)goToIntro {
    UIStoryboard *storyboard = self.window.rootViewController.storyboard;
    UINavigationController *rootNav = [storyboard instantiateViewControllerWithIdentifier:@"IntroViewController"];
    if (![self.window.rootViewController isKindOfClass:[rootNav class]]) {
        [UIView animateWithDuration:.5 animations:^{
            self.window.rootViewController.view.alpha = 0;
        } completion:^(BOOL finished) {
            self.window.rootViewController = rootNav;
            rootNav.view.alpha = 0;
            [UIView animateWithDuration:.5 animations:^{
                rootNav.view.alpha = 1;
            }];
        }];
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
