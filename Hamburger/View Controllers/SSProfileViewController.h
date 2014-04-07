//
//  SSProfileViewController.h
//  Hamburger
//
//  Created by Stephanie Szeto on 4/5/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSUser.h"

@interface SSProfileViewController : UIViewController

@property (nonatomic, strong) SSUser *user;

- (SSProfileViewController *)initWithUser:(SSUser *)user;
- (void)setValues;
- (void)setUser:(SSUser *)user;

@end
