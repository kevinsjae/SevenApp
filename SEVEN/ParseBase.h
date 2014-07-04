//
//  ParseBase.h
//  snailGram
//
//  Created by Bobby Ren on 3/22/14.
//  Copyright (c) 2014 SnailGram. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "PFObjectFactory.h"

@interface ParseBase : NSObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * parseID;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * pfUserID;
@property (nonatomic) PFUser *user;

+(NSString *)className;
+(void)initParseObjectWithDictionary:(NSDictionary *)dictionary completion:(void(^)(id object))completion;
+(id)fromPFObject:(PFObject *)object;

-(PFObject *)pfObject;
-(void)setPfObject:(PFObject *)pfObject;

-(void)updateFromParse;
-(void)saveOrUpdateToParseWithCompletion:(void (^)(BOOL success))completion;
@end
