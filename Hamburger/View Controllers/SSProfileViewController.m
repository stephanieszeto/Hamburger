//
//  SSProfileViewController.m
//  Hamburger
//
//  Created by Stephanie Szeto on 4/5/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "SSProfileViewController.h"
#import "TwitterClient.h"
#import "SSUser.h"
#import "UIImageView+AFNetworking.h"

#import "SSMentionsViewController.h"

@interface SSProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *background;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *numTweets;
@property (weak, nonatomic) IBOutlet UILabel *numFollowing;
@property (weak, nonatomic) IBOutlet UILabel *numFollowers;
@property (nonatomic, strong) TwitterClient *client;

@property (weak, nonatomic) IBOutlet UIImageView *screen;

@end

@implementation SSProfileViewController

- (SSProfileViewController *)initWithUser:(SSUser *)user {
    self = [super init];
    if (self) {
        self.client = [TwitterClient instance];
        self.user = user;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.client = [TwitterClient instance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set navigation bar colors
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.42 green:0.69 blue:0.95 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self setValues];
}

- (void)setValues {
    if (self.user) {
        SSUser *user = self.user;
        NSLog(@"num/tweets: %d", user.numTweets);
        NSLog(@"num/following: %d", user.numFollowing);
        NSLog(@"num/followers: %d", user.numFollowers);
        NSLog(@"background url: %@", user.backgroundURL);
        self.name.text = user.name;
        self.username.text = [NSString stringWithFormat:@"@%@", user.username];
        self.numTweets.text = [NSString stringWithFormat:@"%d", user.numTweets];
        self.numFollowing.text = [NSString stringWithFormat:@"%d", user.numFollowing];
        self.numFollowers.text = [NSString stringWithFormat:@"%d", user.numFollowers];
        [self.avatar setImageWithURL:user.avatarURL];
        [self.background setImageWithURL:user.backgroundURL];
    
        self.name.shadowColor = [UIColor blackColor];
        self.name.shadowOffset = CGSizeMake(-1.0f, 1.0f);
        self.username.shadowColor = [UIColor blackColor];
        self.username.shadowOffset = CGSizeMake(-1.0f, 1.0f);
        
//        if (!user.backgroundURL) {
//            self.name.textColor = [UIColor blackColor];
//            self.username.textColor = [UIColor blackColor];
//        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Private methods

- (void)loadUser {
    [self.client userWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"user response: %@", responseObject);
        NSDictionary *json = responseObject;
        NSDictionary *userDictionary = @{@"name" : json[@"name"],
                                         @"screen_name" : json[@"screen_name"],
                                         @"profile_image_url" : json[@"profile_image_url"],
                                         @"profile_banner_url" : json[@"profile_banner_url"],
                                         @"friends_count" : json[@"friends_count"],
                                         @"followers_count" : json[@"followers_count"],
                                         @"statuses_count" : json[@"statuses_count"]};
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:userDictionary forKey:@"currentUser"];
        [defaults synchronize];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: no user response");
    }];
}

@end
