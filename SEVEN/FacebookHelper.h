//
//  FacebookHelper.h
//  SEVEN
//
//  Created by Bobby Ren on 7/9/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookHelper : NSObject

+(void)updateFacebookUserInfoWithCompletion:(void(^)(id result))completion;
+(void)checkForFacebookPermission:(NSString *)permission completion:(void(^)(BOOL hasPermission))completion;
+(void)getFacebookUsersWithCompletion:(void(^)(id result, NSError *error))completion;
+(void)requestFacebookPermission:(NSString *)permission completion:(void(^)(BOOL success, NSError *error))completion;

// a slightly different friends request
+(void)getFriendsWithCompletion:(void(^)(NSMutableArray *results, NSError *error))completion;

// for Seven
+(void)getFacebookFriends;
+(void)getFacebookInfo;

+(void)logout;
@end
