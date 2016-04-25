//
//  PSManager.m
//  PropSwip
//
//  Created by Kinshuk  Kar on 4/2/16.
//  Copyright © 2016 Kinshuk Kar. All rights reserved.
//

#import "PSManager.h"
#import <Google/Analytics.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "PSDatabaseManager.h"
#import "PSConstants.h"
#import "PSUtils.h"
#import "PSUser.h"
#import "Reachability.h"

@interface PSManager ()

@property (nonatomic, strong)    Reachability           * reachabilityChecker;
@property (nonatomic, assign)    BOOL                   isInternetAvailable;

@end

@implementation PSManager

+ (id)sharedManager {
    
    static PSManager *sharedPropSwipManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPropSwipManager = [[self alloc] init];
    });
    return sharedPropSwipManager;
}

- (id)init {
    
    if (self = [super init]) {
        
        _reachabilityChecker = [Reachability reachabilityWithHostname:@"www.google.com"];
        _isInternetAvailable = NO;
        _reachabilityChecker.reachableBlock = ^(Reachability *reachability) {
            NSLog(@"Network is reachable.");
            _isInternetAvailable = YES;
        };
        
        _reachabilityChecker.unreachableBlock = ^(Reachability *reachability) {
            NSLog(@"Network is unreachable.");
            _isInternetAvailable = NO;
        };
        
        [_reachabilityChecker startNotifier];

    }
    return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[PSDatabaseManager shared] initializeDatabase];
    
    [self upgrade];
    
    [self setupStyle];
    
    [self initializeGoogleAnalytics];
    
    return YES;
}

- (void) applicationDidBecomeActive:(UIApplication *)application
{
    [FBSDKAppEvents activateApp];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];

    return handled;
}

- (void) initializeGoogleAnalytics
{
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;
    gai.logger.logLevel = kGAILogLevelVerbose;  // remove before app release
    [gai.defaultTracker setAllowIDFACollection:YES];
}

- (void) upgrade
{
    NSString *appVersion = [[PSDatabaseManager shared] getValueForKey:PROPSWIP_KVS_KEY_APP_VER];
    
    if ([appVersion length] < 1) {
        //New install
        [[PSDatabaseManager shared] putValue:@"YES" forKey:PROPSWIP_SHOW_LOGIN_SCREEN];

    }
    
    [[PSDatabaseManager shared] putValue:CURRENT_APP_VERSION forKey:PROPSWIP_KVS_KEY_APP_VER];
}

- (void) userLoggedIn
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields" : @"id,name,email"}];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        NSDictionary *userData = (NSDictionary *)result;
        [[PSDatabaseManager shared] putValue:@"NO" forKey:PROPSWIP_SHOW_LOGIN_SCREEN];
        NSLog(@"User data - %@", userData);
        
        NSString *fbId = psEmptyForNilString([userData objectForKey:@"id"]);
        NSString *name = psEmptyForNilString([userData objectForKey:@"name"]);
        NSString *email = psEmptyForNilString([userData objectForKey:@"email"]);
        
        PSUser *user = [[PSUser alloc] init];
        user.isLoggedIn = YES;
        user.fbToken = [[FBSDKAccessToken currentAccessToken] tokenString];
        user.fbId = fbId;
        user.emailAddress = email;
        user.name = name;
        
        [self getProfilePic:fbId];
    }];

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController =  [storyboard instantiateViewControllerWithIdentifier:@"PropSwipRootVCId"];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    keyWindow.rootViewController = viewController;

}

- (void) userSkipped
{
    [[PSDatabaseManager shared] putValue:@"NO" forKey:PROPSWIP_SHOW_LOGIN_SCREEN];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController =  [storyboard instantiateViewControllerWithIdentifier:@"PropSwipRootVCId"];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    keyWindow.rootViewController = viewController;
}

- (void) setupStyle
{
    UIColor *barBackgroundColor = [PSUtils getThemeColor];
    UIColor *barTintColor = [PSUtils getThemeColor];
    //[UIColor colorWithRed:0.27 green:0.37 blue:0.39 alpha:1.0];
    [[UINavigationBar appearance] setBarTintColor:barBackgroundColor];
    [[UINavigationBar appearance] setTintColor:barTintColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void) getProfilePic:(NSString*)fbid
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:[NSString stringWithFormat:@"/%@/picture/?type=large&redirect=false", fbid]
                                  parameters:nil
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        
        if (error == nil && result != nil) {
            
            NSDictionary *pictureData = [result objectForKey:@"data"];
            if (pictureData != nil && [pictureData[@"url"] length] > 0) {
            }
        }
    }];
}

- (BOOL) toShowLoginScreen
{
    NSString *showLoginScreen = [[PSDatabaseManager shared] getValueForKey:PROPSWIP_SHOW_LOGIN_SCREEN];
    return NO;
    if ([showLoginScreen isEqualToString:@"YES"]) {
        return YES;
    } else {
        return NO;
    }
}

- (UIViewController*) getInitialViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if ([self toShowLoginScreen]) {
        
        UIViewController *loginViewController =  [storyboard instantiateViewControllerWithIdentifier:@"loginVCId"];
        return loginViewController;
        
    } else {
        
        UIViewController *mainViewController =  [storyboard instantiateViewControllerWithIdentifier:@"PropSwipRootVCId"];
        return mainViewController;
    }
}


@end
