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
    self.user = self.pfObject[@"user"];
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

    [self.pfObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded)
            self.parseID = self.pfObject.objectId;
        if (completion)
            completion(succeeded);
    }];
}
@end
