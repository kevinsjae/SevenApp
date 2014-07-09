//
//  FacebookHelper.m
//  SEVEN
//
//  Created by Bobby Ren on 7/9/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "FacebookHelper.h"

@implementation FacebookHelper

+(void)updateFacebookUserInfo {
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // Store the current user's Facebook ID on the user
            [[PFUser currentUser] setObject:[result objectForKey:@"id"]
                                     forKey:@"facebookID"];
            [[PFUser currentUser] saveInBackground];
        }
    }];
}

+(void)checkForFacebookPermission:(NSString *)permission completion:(void(^)(BOOL hasPermission))completion  {
    [[FBRequest requestForGraphPath:@"me/permissions"] startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSLog(@"Permissions request results: %@", result);
        NSArray *permissions = (NSArray *)result[@"data"];
        for (NSDictionary *p in permissions) {
            if ([p[@"permission"] isEqualToString:permission]) {
                if ([p[@"status"] isEqualToString:@"granted"]) {
                    completion(YES);
                    return;
                }
                else {
                    completion(NO);
                    return;
                }
            }
        }
        completion(NO);
    }];
}

+(void)getFacebookUsersWithCompletion:(void(^)(id result, NSError *error))completion {
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (completion) {
            completion(result, error);
        }
    }];
}

+(void)requestFacebookPermission:(NSString *)permission completion:(void(^)(BOOL success, NSError *error))completion {
    [PFFacebookUtils linkUser:[PFUser currentUser] permissions:@[permission] block:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [FacebookHelper updateFacebookUserInfo];
        }
        else {
            [[FBSession activeSession] closeAndClearTokenInformation];
        }
        if (completion)
            completion(succeeded, error);
    }];
}

@end
