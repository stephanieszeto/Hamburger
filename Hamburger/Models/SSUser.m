//
//  SSUser.m
//  Hamburger
//
//  Created by Stephanie Szeto on 4/5/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "SSUser.h"

@implementation SSUser

- (SSUser *)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        self.username = dictionary[@"screen_name"];
        self.name = dictionary[@"name"];
        self.avatarURL = [NSURL URLWithString:dictionary[@"profile_image_url"]];
        self.backgroundURL = [NSURL URLWithString:dictionary[@"profile_banner_url"]];
        self.numTweets = [dictionary[@"statuses_count"] integerValue];
        self.numFollowing = [dictionary[@"friends_count"] integerValue];
        self.numFollowers = [dictionary[@"followers_count"] integerValue];
        self.tweets = [[NSMutableArray alloc] init];
        self.userDictionary = dictionary;
        
        //NSLog(@"input num/tweets: %d", dictionary[@"statuses_count"]);
        //NSLog(@"user num/tweets: %d", self.numTweets);
        //NSLog(@"user num/following: %d", self.numFollowing);
        //NSLog(@"user num/followers: %d", self.numFollowers);
        
    }
    
    return self;
}

- (void)addTweet:(SSTweet *)tweet {
    [self.tweets addObject:tweet];
}


@end
