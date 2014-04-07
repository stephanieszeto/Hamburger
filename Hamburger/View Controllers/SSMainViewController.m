//
//  SSMainViewController.m
//  Hamburger
//
//  Created by Stephanie Szeto on 4/6/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "SSMainViewController.h"
#import "SSTimelineViewController.h"
#import "SSLoginViewController.h"
#import "SSProfileViewController.h"
#import "TwitterClient.h"
#import "SSUser.h"

@interface SSMainViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *containerView;
@property (weak, nonatomic) IBOutlet UIImageView *menuView;
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) TwitterClient *client;

@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UIButton *timelineButton;
@property (weak, nonatomic) IBOutlet UIButton *mentionsButton;
@property (weak, nonatomic) IBOutlet UIButton *signOutButton;

- (void)onMenuButton:(id)sender;
- (void)onCustomPan:(UIPanGestureRecognizer *)panGestureRecognizer;

- (IBAction)onProfile:(id)sender;
- (IBAction)onTimeline:(id)sender;
- (IBAction)onMentions:(id)sender;
- (IBAction)onSignOut:(id)sender;

@end

@implementation SSMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.client = [TwitterClient instance];
        self.viewControllers = @[[[SSTimelineViewController alloc] init], [[SSProfileViewController alloc] init]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set navigation bar colors
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.42 green:0.69 blue:0.95 alpha:1.0];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    // add all subviews to container view
    UIView *timelineView = ((UIViewController *)self.viewControllers[0]).view;
    UIView *profileView = ((UIViewController *)self.viewControllers[1]).view;
    
    [self.containerView addSubview:timelineView];
    [self.containerView addSubview:profileView];
    
    // add menu button to navigation bar
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"menu-icon"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onMenuButton:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0, 0, 40, 31)];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    
    // set up, hide menu bar
    [self.menuView addSubview:self.profileButton];
    [self.menuView addSubview:self.timelineButton];
    [self.menuView addSubview:self.mentionsButton];
    [self.menuView addSubview:self.signOutButton];
    self.menuView.backgroundColor = [UIColor colorWithRed:0.42 green:0.69 blue:0.95 alpha:1.0];
    CGRect menu = self.menuView.frame;
    menu.origin.x = -320.0;
    self.menuView.frame = menu;
    
    // set up container view
    if ([self.client isAuthorized]) {
        self.title = @"Home";
        [self.containerView bringSubviewToFront:timelineView];
    }
    
    // define pan gesture recognizer
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onCustomPan:)];
    [self.containerView addGestureRecognizer:panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)displayTimeline:(NSMutableArray *)tweets {
    SSTimelineViewController *tvc = self.viewControllers[0];
    tvc.tweets = tweets;
    [self onTimeline:self];
}

- (void)displayProfile:(SSUser *)user {
    SSProfileViewController *pvc = self.viewControllers[1];
    pvc.user = user;
    [pvc setValues];
    [self.containerView bringSubviewToFront:pvc.view];
}

# pragma mark - Private methods

- (void)onMenuButton:(id)sender {
    CGRect destination = self.menuView.frame;
    if (destination.origin.x < 0) {
        destination.origin.x = 0;
    } else {
        destination.origin.x = -320;
    }
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.menuView.frame = destination;
    } completion:^(BOOL finished) {
        // do something
    }];
}

- (void)onCustomPan:(UIPanGestureRecognizer *)recognizer {
    static CGPoint originalCenter, translation;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        originalCenter = recognizer.view.center;
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        translation = [recognizer translationInView:self.view];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGRect menu = self.menuView.frame;
        if (originalCenter.x < translation.x) {
            menu.origin.x = 0;
        } else if (originalCenter.x > translation.x) {
            menu.origin.x = -320;
        }
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.menuView.frame = menu;
        } completion:^(BOOL finished) {
            // do something
        }];
    }
}

- (IBAction)onProfile:(id)sender {
    SSProfileViewController *profileVC = self.viewControllers[1];
    UIView *profile = profileVC.view;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [defaults objectForKey:@"currentUser"];
    SSUser *user = [[SSUser alloc] initWithDictionary:dictionary];
    profileVC.user = user;
    [profileVC setValues];
    [self.containerView bringSubviewToFront:profile];
    [self onMenuButton:self];
}

- (IBAction)onTimeline:(id)sender {
    self.title = @"Home";
    SSTimelineViewController *tvc = self.viewControllers[0];
    tvc.isMentions = NO;
    [tvc loadTimeline];
    UIView *timeline = tvc.view;
    [self.containerView bringSubviewToFront:timeline];
    [self onMenuButton:self];
}

- (IBAction)onMentions:(id)sender {
    self.title = @"Mentions";
    SSTimelineViewController *tvc = self.viewControllers[0];
    tvc.isMentions = YES;
    [tvc loadTimeline];
    UIView *mentions = tvc.view;
    [self.containerView bringSubviewToFront:mentions];
    [self onMenuButton:self];
}

- (IBAction)onSignOut:(id)sender {
    self.title = @"";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"currentUser"];
    SSTimelineViewController *tvc = self.viewControllers[0];
    [tvc.tweets removeAllObjects];
    
    SSLoginViewController *lvc = [[SSLoginViewController alloc] init];
    [self.navigationController pushViewController:lvc animated:YES];
    [self onMenuButton:self];
}
@end
