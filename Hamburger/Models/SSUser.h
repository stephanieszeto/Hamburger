//
//  SSUser.h
//  Hamburger
//
//  Created by Stephanie Szeto on 4/5/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SSTweet;

@interface SSUser : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic, strong) NSURL *avatarURL;
@property (nonatomic, strong) NSURL *backgroundURL;
@property (nonatomic) NSInteger numTweets;
@property (nonatomic) NSInteger numFollowing;
@property (nonatomic) NSInteger numFollowers;
@property (nonatomic, strong) NSDictionary *userDictionary;

- (SSUser *)initWithDictionary:(NSDictionary *)dictionary;
- (void)addTweet:(SSTweet *)tweet;


@end
