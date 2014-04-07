//
//  SSMenuViewController.m
//  Hamburger
//
//  Created by Stephanie Szeto on 4/6/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "SSMenuViewController.h"
#import "SSLoginViewController.h"
#import "SSTimelineViewController.h"
#import "SSProfileViewController.h"
#import "SSMentionsViewController.h"

@interface SSMenuViewController ()

@property (weak, nonatomic) IBOutlet UIView *background;

- (IBAction)onProfileButton:(id)sender;
- (IBAction)onHomeTimelineButton:(id)sender;
- (IBAction)onMentionsButton:(id)sender;
- (IBAction)onSignOutButton:(id)sender;

@end

@implementation SSMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // do something
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set background color
    self.background.backgroundColor = [UIColor colorWithRed:0.42 green:0.69 blue:0.95 alpha:1.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onProfileButton:(id)sender {
    NSLog(@"menu: clicked on profile button");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [defaults objectForKey:@"currentUser"];
    SSUser *user = [[SSUser alloc] initWithDictionary:dictionary];
    SSProfileViewController *pvc = [[SSProfileViewController alloc] initWithUser:user];
    [self.navigationController pushViewController:pvc animated:YES];
    NSLog(@"transitioned to profile");
}

- (IBAction)onHomeTimelineButton:(id)sender {
    NSLog(@"menu: clicked on timeline button");
    SSTimelineViewController *tvc = [[SSTimelineViewController alloc] init];
    [self.navigationController pushViewController:tvc animated:YES];
    NSLog(@"transitioned to timeline");
}

- (void)onMentionsButton:(id)sender {
    NSLog(@"menu: clicked on mentions button");
    SSMentionsViewController *mvc = [[SSMentionsViewController alloc] init];
    [self.navigationController pushViewController:mvc animated:YES];
    NSLog(@"transitioned to mentions");
}

- (void)onSignOutButton:(id)sender {
    NSLog(@"menu: clicked on sign out button");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"currentUser"];
    //[self.tweets removeAllObjects];
    
    SSLoginViewController *lvc = [[SSLoginViewController alloc] init];
    [self.navigationController pushViewController:lvc animated:YES];
    NSLog(@"transitioned to log-in");
}
@end
