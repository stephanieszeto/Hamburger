//
//  SSTimelineViewController.m
//  Hamburger
//
//  Created by Stephanie Szeto on 4/5/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "SSTimelineViewController.h"
#import "SSMainViewController.h"
#import "SSLoginViewController.h"
#import "TwitterClient.h"
#import "SSTweet.h"
#import "SSTweetCell.h"

#import "SSProfileViewController.h"

@interface SSTimelineViewController ()

@property (nonatomic, strong) TwitterClient *client;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (void)onAvatarTap:(UITapGestureRecognizer *)tapGestureRecognizer;

@end

@implementation SSTimelineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.client = [TwitterClient instance];
        // timeline, mentions, tweets
        self.type = @[@"YES", @"NO", @"NO"];
        
        // get tweets
        [self loadTimeline];
    }
    return self;
}

- (SSTimelineViewController *)initWithArray:(NSMutableArray *)array {
    self = [super init];
    if (self) {
        self.client = [TwitterClient instance];
        self.type = @[@"YES", @"NO", @"NO"];
        self.tweets = array;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // assign table view's delegate, data source
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // add pull to refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    // register tweet cell
    UINib *tweetNib = [UINib nibWithNibName:@"SSTweetCell" bundle:nil];
    [self.tableView registerNib:tweetNib forCellReuseIdentifier:@"SSTweetCell"];
    
    [self loadTimeline];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadTimeline {
    //NSLog(@"%@", self.type);
    if ([self.type[1] isEqualToString:@"YES"]) {
        [self.client mentionsWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processJson:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: no mentions response");
            NSLog(@"%@", error.description);
        }];
    } else if ([self.type[0] isEqualToString:@"YES"]) {
        [self.client timelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processJson:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: no timeline response");
            NSLog(@"%@", error.description);
        }];
    } else if ([self.type[2] isEqualToString:@"YES"]) {
        [self.client tweetsWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processJson:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: no timeline response");
            NSLog(@"%@", error.description);
        }];
    }
}

# pragma mark - Private methods

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self loadTimeline];
    [refreshControl endRefreshing];
}

- (void)processJson:(NSArray *)responseObject {
    // populate models
    [self.tweets removeAllObjects];
    NSArray *tweetsInJson = responseObject;
    NSMutableArray *tweets = [NSMutableArray arrayWithCapacity:tweetsInJson.count];
    for (NSDictionary *dictionary in tweetsInJson) {
        SSTweet *tweet = [[SSTweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    self.tweets = tweets;
    [self.tableView reloadData];
}

- (void)onAvatarTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    NSLog(@"tapped on avatar");
    SSTweet *tweet = self.tweets[tapGestureRecognizer.view.tag];
    SSUser *user = tweet.user;
    UINavigationController *nvc = (UINavigationController *) [UIApplication sharedApplication].keyWindow.rootViewController;
    SSMainViewController *mvc = nvc.viewControllers[0];
    [mvc displayProfile:user];
}

# pragma mark - Table view methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SSTweet *tweet = self.tweets[indexPath.row];
    SSTweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SSTweetCell" forIndexPath:indexPath];
    [cell setValues:tweet];
    
    // add tap gesture recognizer for avatar
    cell.avatar.tag = indexPath.row;
    cell.avatar.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onAvatarTap:)];
    tapGestureRecognizer.delegate = self;
    [cell.avatar addGestureRecognizer:tapGestureRecognizer];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
