//
//  FacebookHelper.m
//  SEVEN
//
//  Created by Bobby Ren on 7/9/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "FacebookHelper.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation FacebookHelper

+(void)updateFacebookUserInfoWithCompletion:(void(^)(id result))completion {
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            PFUser *user = [PFUser currentUser];
            NSString *name = result[@"name"];
            NSString *fbId = result[@"id"];
            NSString *email = result[@"email"];

            if (name)
                user[@"name"] = name;
            if (fbId)
                user[@"fbId"] = fbId;
            if (email)
                user[@"email"] = email;
            [user saveInBackground];

            if (completion)
                completion(result);
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
            [FacebookHelper updateFacebookUserInfoWithCompletion:nil];
        }
        else {
            [[FBSession activeSession] closeAndClearTokenInformation];
        }
        if (completion)
            completion(succeeded, error);
    }];
}

+(void)getFriendsWithCompletion:(void(^)(NSMutableArray *results, NSError *error))completion {
    // picture retries a profile in the form of {picture: {data: {url:""}}}
    // installed returns 1 if the user has the facebook Pact app installed
    NSString *graphPath = @"me/friends?limit=5000&fields=name,picture,id,installed,last_name";
    //    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error){
    [FBRequestConnection startWithGraphPath:graphPath completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error){
            NSMutableArray *results = [NSMutableArray array];
            if ([result objectForKey:@"data"]){
                NSArray *array = [result objectForKey:@"data"];
                for (NSDictionary *friend in array){
                    NSMutableDictionary *friendDict = [[NSMutableDictionary alloc] initWithDictionary:friend];
                    NSNumber * fbID = [friendDict objectForKey:@"id"];
                    NSString * name = [friendDict objectForKey:@"name"];
                    if (!fbID || !name) {
                        continue;
                    }
                    [results addObject:friendDict];
                }
            }
            if (completion) {
                completion(results, nil);
            }
        }
        else {
            DebugLog(@"Could not get facebook friends! error: %@", error);
            if (completion) {
                completion(nil, error);
            }
        }

    }];
}

@end
