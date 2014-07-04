//
//  UserInfo.m
//  SEVEN
//
//  Created by Bobby Ren on 7/4/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

-(void)updateFromParse {
    [super updateFromParse];

    self.email = self.pfObject[@"email"];
    self.gender = self.pfObject[@"gender"];
    self.seeking = self.pfObject[@"seeking"];
    self.location = self.pfObject[@"location"];
    self.phone = self.pfObject[@"phone"];

    self.parseID = self.pfObject.objectId;

    // user will be already included in self.pfObject[@"user"]
}

-(void)saveOrUpdateToParseWithCompletion:(void (^)(BOOL success))completion {
    if (self.email)
        self.pfObject[@"email"] = self.email;
    if (self.gender)
        self.pfObject[@"gender"] = self.gender;
    if (self.seeking)
        self.pfObject[@"seeking"] = self.seeking;
    if (self.location)
        self.pfObject[@"location"] = self.location;
    if (self.phone)
        self.pfObject[@"phone"] = self.phone;

    // add user to pfObject - adds as a relationship
    if (self.user) {
        self.pfObject[@"user"] = self.user;
        self.pfObject[@"pfUserID"] = self.user.objectId;
    }

    [self.pfObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
            self.parseID = self.pfObject.objectId;
        if (completion)
            completion(succeeded);
    }];
}
@end
