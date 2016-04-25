//
//  LoginViewController.m
//  PropSwip
//
//  Created by Kinshuk  Kar on 4/6/16.
//  Copyright © 2016 Kinshuk Kar. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "PSManager.h"

@interface LoginViewController () <FBSDKLoginButtonDelegate>

@property (nonatomic, strong) UIButton  *skipButton;
@property (nonatomic, strong) UILabel   *postMessageLabel;
@property (nonatomic, strong) FBSDKLoginButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginButton = [[FBSDKLoginButton alloc] init];
    self.skipButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.postMessageLabel  = [[UILabel alloc] initWithFrame:CGRectZero];

    self.loginButton.delegate = self;
    self.loginButton.readPermissions =
    @[@"public_profile", @"email", @"user_friends"];
    
    [self.postMessageLabel setText:@"We won't post without your permission."];
    self.postMessageLabel.numberOfLines = 0;
    self.postMessageLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.skipButton];
    [self.view addSubview:self.postMessageLabel];
    
    [self.skipButton addTarget:self action:@selector(skipClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.skipButton setTitle:@"Skip >" forState:UIControlStateNormal];
    [self.skipButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.loginButton.frame = CGRectMake(self.view.center.x - 100, self.view.center.y + 40, 200, 50);
    self.postMessageLabel.frame = CGRectMake(self.view.center.x - 135, self.view.center.y + 110, 270, 60);
    self.skipButton.frame = CGRectMake(self.view.center.x - 30, self.view.center.y + 220, 60, 40);
}

- (void) skipClicked
{
    [[PSManager sharedManager] userSkipped];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    NSLog(@"%@", [[FBSDKAccessToken currentAccessToken] tokenString]);
    
    [[PSManager sharedManager] userLoggedIn];
    
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    NSLog(@"Logged out");
}

- (BOOL)loginButtonWillLogin:(FBSDKLoginButton *)loginButton
{
    return YES;
}

@end
