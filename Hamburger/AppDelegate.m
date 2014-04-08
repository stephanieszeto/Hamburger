//
//  AppDelegate.m
//  Hamburger
//
//  Created by Stephanie Szeto on 4/5/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "AppDelegate.h"
#import "TwitterClient.h"
#import "SSMainViewController.h"
#import "SSLoginViewController.h"
#import "SSTweet.h"

@interface AppDelegate ()

@property (nonatomic, strong) UINavigationController *nvc;
@property (nonatomic, strong) SSLoginViewController *lvc;
@property (nonatomic, strong) SSMainViewController *mvc;
@property (nonatomic, strong) TwitterClient *client;

@end

@implementation NSURL (dictionaryFromQueryString)

- (NSDictionary *)dictionaryFromQueryString {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    NSArray *pairs = [[self query] componentsSeparatedByString:@"&"];
    
    for(NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dictionary setObject:val forKey:key];
    }
    return dictionary;
}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.lvc = [[SSLoginViewController alloc] init];
    self.mvc = [[SSMainViewController alloc] init];
    self.nvc = [[UINavigationController alloc] initWithRootViewController:self.mvc];
    self.window.rootViewController = self.nvc;
    NSLog(@"assigned root VC to navigation controller");
    
    self.client = [TwitterClient instance];
    if (![self.client isAuthorized]) {
        NSLog(@"please log in");
        [self.nvc pushViewController:self.lvc animated:NO];
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.scheme isEqualToString:@"cptwitter"]) {
        if ([url.host isEqualToString:@"oauth"]) {
            NSLog(@"Step 2: received access code");
            NSDictionary *parameters = [url dictionaryFromQueryString];
            if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
                self.client = [TwitterClient instance];
                [self.client fetchAccessTokenWithPath:@"/oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
                    // get access token
                    [self.client.requestSerializer saveAccessToken:accessToken];
                    NSLog(@"Step 3: received access token");
                    
                    // get current user
                    [self.client userWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        //NSLog(@"user response: %@", responseObject);
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
                    
                    // get timeline
                    [self.client timelineWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"successful timeline!");
                        
                        // populate models
                        NSArray *tweetsInJson = responseObject;
                        NSMutableArray *tweets = [NSMutableArray arrayWithCapacity:tweetsInJson.count];
                        for (NSDictionary *dictionary in tweetsInJson) {
                            SSTweet *tweet = [[SSTweet alloc] initWithDictionary:dictionary];
                            [tweets addObject:tweet];
                        }
                        NSLog(@"populated tweets");
                        
                        [self.nvc setNavigationBarHidden:NO animated:NO];
                        [self.mvc displayTimeline:tweets];
                        [self.nvc popToRootViewControllerAnimated:YES];
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Error: no timeline response");
                    }];
                } failure:^(NSError *error) {
                    NSLog(@"Error: no access token");
                }];
            }
        }
        return YES;
    }
    return NO;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
