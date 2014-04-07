//
//  SSMentionsViewController.m
//  Hamburger
//
//  Created by Stephanie Szeto on 4/5/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "SSMentionsViewController.h"
#import "TwitterClient.h"
#import "SSTweet.h"
#import "SSTweetCell.h"

@interface SSMentionsViewController ()

@property (nonatomic, strong) NSMutableArray *tweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TwitterClient *client;

@end

@implementation SSMentionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Mentions";
        self.client = [TwitterClient instance];
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
    UINib *nib = [UINib nibWithNibName:@"SSTweetCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"SSTweetCell"];
    
    // load mentions
    [self loadMentions];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Private methods

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self loadMentions];
    [refreshControl endRefreshing];
}

- (void)loadMentions {
    [self.client mentionsWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
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
        NSLog(@"Error: no mentions response");
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
}

@end
