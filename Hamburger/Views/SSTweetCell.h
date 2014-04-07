//
//  SSTweetCell.h
//  Hamburger
//
//  Created by Stephanie Szeto on 4/5/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSTweet.H"

@interface SSTweetCell : UITableViewCell

@property (nonatomic, strong) SSTweet *tweet;

@property (weak, nonatomic) IBOutlet UIImageView *avatar;

- (void)setValues:(SSTweet *)tweet;

@end
