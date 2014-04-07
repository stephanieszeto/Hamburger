//
//  SSTimelineViewController.m
//  Hamburger
//
//  Created by Stephanie Szeto on 4/5/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "SSTimelineViewController.h"
#import "SSLoginViewController.h"
#import "TwitterClient.h"
#import "SSTweet.h"
#import "SSTweetCell.h"

#import "SSProfileViewController.h"

@interface SSTimelineViewController ()

@property (nonatomic, strong) TwitterClient *client;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *menuView;

@end

@implementation SSTimelineViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Home";
        self.client = [TwitterClient instance];
        
        // get tweets
        [self loadTimeline];
    }
    return self;
}

- (SSTimelineViewController *)initWithArray:(NSMutableArray *)array {
    self = [super init];
    if (self) {
        self.title = @"Home";
        self.client = [TwitterClient instance];
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
    
    // set navigation bar colors
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.42 green:0.69 blue:0.95 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // add pull to refresh
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    // register tweet cell
    UINib *tweetNib = [UINib nibWithNibName:@"SSTweetCell" bundle:nil];
    [self.tableView registerNib:tweetNib forCellReuseIdentifier:@"SSTweetCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Private methods
- (void)refresh:(UIRefreshControl *)refreshControl {
    [self loadTimeline];
    [refreshControl endRefreshing];
}

- (void)loadTimeline {
    [self.client timelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: no timeline response");
        NSLog(@"%@", error.description);
    }];
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    SSTweet *tweet = self.tweets[indexPath.row];
    SSUser *user = tweet.user;
    SSProfileViewController *pvc = [[SSProfileViewController alloc] initWithUser:user];
    [self.navigationController pushViewController:pvc animated:YES];
}

@end
