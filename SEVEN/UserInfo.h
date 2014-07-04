//
//  UserInfo.h
//  SEVEN
//
//  Created by Bobby Ren on 7/4/14.
//  Copyright (c) 2014 SEVEN. All rights reserved.
//

#import "ParseBase.h"

typedef enum {
    MALE = 0,
    FEMALE,
    OTHER, // trans?
    BOTH // for seeking only, but could be used for bi?
} Gender;

@interface UserInfo : ParseBase

@property (nonatomic) NSString *email;
@property (nonatomic) NSNumber *gender;
@property (nonatomic) NSNumber *seeking;
@property (nonatomic) CLLocation *location;
@property (nonatomic) NSString *phone;

@end
