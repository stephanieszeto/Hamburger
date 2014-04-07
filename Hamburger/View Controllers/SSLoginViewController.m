//
//  SSLoginViewController.m
//  Hamburger
//
//  Created by Stephanie Szeto on 4/5/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "SSLoginViewController.h"
#import "TwitterClient.h"

@interface SSLoginViewController ()

@property (weak, nonatomic) IBOutlet UIView *labelBox;
- (IBAction)onLogin:(id)sender;

@end

@implementation SSLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set up background color
    self.labelBox.layer.borderWidth = 1.0f;
    self.labelBox.layer.borderColor = [[UIColor colorWithRed:0.42 green:0.69 blue:0.95 alpha:1.0] CGColor];
    
    // hide navigation bar
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onLogin:(id)sender {
    [[TwitterClient instance] login];
}

@end
