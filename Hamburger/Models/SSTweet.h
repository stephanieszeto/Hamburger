//
//  SSTweet.h
//  Hamburger
//
//  Created by Stephanie Szeto on 4/5/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSUser.h"

@interface SSTweet : NSObject

@property (nonatomic, strong) NSString *tweet;
@property (nonatomic, strong) NSString *time;
@property (nonatomic) NSInteger numRetweets;
@property (nonatomic) NSInteger numFavorites;
@property (nonatomic) BOOL isRetweet;
@property (nonatomic, strong) SSUser *user;
@property (nonatomic, strong) SSUser *retweeter;
@property (nonatomic) NSNumber *id;
@property (nonatomic, strong) NSDictionary *tweetDictionary;

- (SSTweet *)initWithDictionary:(NSDictionary *)dictionary;

@end
