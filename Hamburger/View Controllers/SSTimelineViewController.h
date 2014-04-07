//
//  SSTimelineViewController.h
//  Hamburger
//
//  Created by Stephanie Szeto on 4/5/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSTimelineViewController : UIViewController < UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate >

@property (nonatomic, strong) NSMutableArray *tweets;
@property (nonatomic) BOOL isMentions;

- (SSTimelineViewController *)initWithArray:(NSMutableArray *)array;
- (void)setTweets:(NSMutableArray *)tweets;
- (void)loadTimeline;

@end
