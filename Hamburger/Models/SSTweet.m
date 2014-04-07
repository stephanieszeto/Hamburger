//
//  SSTweet.m
//  Hamburger
//
//  Created by Stephanie Szeto on 4/5/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "SSTweet.h"
#import "SSUser.h"

@implementation SSTweet

- (SSTweet *)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        // initialize variables
        NSDictionary *input = dictionary;
        if (dictionary[@"retweeted_status"]) {
            input = dictionary[@"retweeted_status"];
            self.isRetweet = YES;
            self.retweeter = [[SSUser alloc] initWithDictionary:dictionary[@"user"]];
        } else {
            self.isRetweet = NO;
        }
        self.tweet = input[@"text"];
        self.time = input[@"created_at"];
        self.numRetweets = [input[@"retweet_count"] integerValue];
        self.numFavorites = [input[@"favorite_count"] integerValue];
        
        self.id = input[@"id"];
        self.user = [[SSUser alloc] initWithDictionary:input[@"user"]];
        self.tweetDictionary = dictionary;
        
        // add tweet to user's tweets
        [self.user addTweet:self];
    }
    
    return self;
}

@end
