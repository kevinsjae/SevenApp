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

#pragma mark Helper functions specific to Seven
+(void)getFacebookFriends {
    [FacebookHelper getFriendsWithCompletion:^(NSMutableArray *results, NSError *error) {
        NSLog(@"Results: %lu error: %@", (unsigned long)[results count], error);
        NSMutableArray *fbIds = [NSMutableArray array];
        NSMutableDictionary *namesDict = [NSMutableDictionary dictionary];
        NSMutableDictionary *installedDict = [NSMutableDictionary dictionary];
        NSMutableDictionary *firstnameDict = [NSMutableDictionary dictionary];
        for (NSDictionary *dict in results) {
            NSString *fbId = dict[@"id"];
            NSString *name = dict[@"name"];
            NSNumber *installed = dict[@"installed"];
            NSString *firstName = dict[@"first_name"];
            if (!installed)
                installed = @NO;

            if (fbId)
                [fbIds addObject:fbId];
            if (name)
                namesDict[fbId] = name;
            if (installed)
                installedDict[fbId] = installed;
            if (firstName)
                firstnameDict[fbId] = firstName;

            NSLog(@"id %@ name %@ installed %@", fbId, name, installed);
        }

        PFQuery *query = [PFQuery queryWithClassName:@"FacebookFriend"];
        [query setLimit:9999];
        [query whereKey:@"fbId" containedIn:fbIds];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            PFRelation *connections = [[PFUser currentUser] relationForKey:@"connections"];

            // if a FacebookFriend already exists, add it to this user's connections and remove them from the list
            for (PFObject *object in objects) {
                [connections addObject:object];

                NSString *foundID = object[@"fbId"];
                [fbIds removeObject:foundID];
            }

            // create friend objects for all new facebook friends
            for (NSNumber *fbId in fbIds) {
                PFObject *friend = [PFObject objectWithClassName:@"FacebookFriend"];
                friend[@"fbId"] = fbId;

                if (namesDict[fbId])
                    friend[@"name"] = namesDict[fbId];
                if (firstnameDict[fbId])
                    friend[@"firstName"] = firstnameDict[fbId];
                friend[@"installed"] = installedDict[fbId];
                [friend saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    [connections addObject:friend];
                }];
            }


            [[PFUser currentUser] saveEventually];

            NSLog(@"Found %lu total facebook friends, %lu existing, %lu new connections", (unsigned long)results.count, (unsigned long)objects.count, fbIds.count);
        }];
    }];
}

+(void)getFacebookInfo {
    [FacebookHelper updateFacebookUserInfoWithCompletion:^(id result) {
        PFUser *user = [PFUser currentUser];
        // Store the current user's Facebook ID on the user
        NSString *name = result[@"name"];
        NSString *fbId = result[@"id"];
        NSString *email = result[@"email"];
        NSString *firstName = result[@"first_name"];

        if (name)
            user[@"name"] = name;
        if (fbId)
            user[@"fbId"] = fbId;
        if (email)
            user[@"email"] = email;
        if (firstName)
            user[@"firstName"] = firstName;
        [user saveInBackground];

        PFQuery *query = [PFQuery queryWithClassName:@"FacebookFriend"];
        [query whereKey:@"fbId" equalTo:fbId];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            PFObject *fbObject = nil;
            if ([objects count]) {
                fbObject = objects[0];
            }
            else {
                fbObject = [PFObject objectWithClassName:@"FacebookFriend"];
            }

            // create friend object for self
            if (fbId)
                fbObject[@"fbId"] = fbId;
            if (name)
                fbObject[@"name"] = name;
            fbObject[@"installed"] = @YES;
            if (firstName)
                fbObject[@"firstName"] = firstName;
            [fbObject saveInBackgroundWithBlock:nil];
            
            user[@"facebookFriend"] = fbObject;
            [user saveInBackground];
        }];
    }];
}

+(void)logout {
    // does this really log us out?
    [[FBSession activeSession] closeAndClearTokenInformation];
}

@end
