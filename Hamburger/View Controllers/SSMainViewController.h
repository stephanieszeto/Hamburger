//
//  SSMainViewController.h
//  Hamburger
//
//  Created by Stephanie Szeto on 4/6/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSUser.h"

@interface SSMainViewController : UIViewController

- (void)displayTimeline:(NSMutableArray *)tweets;
- (void)displayProfile:(SSUser *)user;

@end
