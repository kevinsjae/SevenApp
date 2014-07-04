//
//  ParseBase.m
//  snailGram
//
//  Created by Bobby Ren on 3/22/14.
//  Copyright (c) 2014 SnailGram. All rights reserved.
//

#import "ParseBase.h"

@implementation ParseBase

+(NSString *)className {
    return NSStringFromClass(self);
}

+(id)fromPFObject:(PFObject *)object {
    ParseBase *newObject = [[self alloc] init];
    newObject.pfObject = object;
    [newObject updateFromParse];
    return newObject;
}

+(void)initParseObjectWithDictionary:(NSDictionary *)dictionary completion:(void(^)(id object))completion{
    PFObject *pfObject = [PFObject objectWithClassName:self.className];

    for (id key in dictionary) {
        pfObject[key] = dictionary[key];
    }
    [pfObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            ParseBase *object = [[[self class] alloc] init];
            object.pfObject = pfObject;

            completion(object);
        }
        else {
            completion(nil);
        }
    }];
}

-(void)updateFromParse {
    // refresh pfObject?
    self.createdAt = self.pfObject[@"createdAt"];
    self.updatedAt = self.pfObject[@"updatedAt"];
    self.parseID = self.pfObject[@"objectId"];
    PFUser *user = self.pfObject[@"user"];
    self.pfUserID = user.objectId;
    self.user = user;
}

#pragma mark Instance variable for category
// http://oleb.net/blog/2011/05/faking-ivars-in-objc-categories-with-associative-references/
// use associative reference in order to add a new instance variable in a category

-(PFObject *)pfObject {
    return objc_getAssociatedObject(self, PFObjectTagKey);
}

-(void)setPfObject:(PFObject *)pfObject {
    objc_setAssociatedObject(self, PFObjectTagKey, pfObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
