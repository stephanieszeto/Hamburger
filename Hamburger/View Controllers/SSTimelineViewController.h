//
//  SSTimelineViewController.h
//  Hamburger
//
//  Created by Stephanie Szeto on 4/5/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSTimelineViewController : UIViewController < UITableViewDataSource, UITableViewDelegate >

@property (nonatomic, strong) NSMutableArray *tweets;

- (SSTimelineViewController *)initWithArray:(NSMutableArray *)array;
- (void)setTweets:(NSMutableArray *)tweets;

@end
