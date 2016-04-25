//
//  PSManager.h
//  PropSwip
//
//  Created by Kinshuk  Kar on 4/2/16.
//  Copyright © 2016 Kinshuk Kar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PSManager : NSObject

+ (id)sharedManager;

- (void) applicationDidBecomeActive:(UIApplication *)application;

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

- (void) userLoggedIn;

- (void) userSkipped;

- (BOOL) toShowLoginScreen;

- (UIViewController*) getInitialViewController;

@end
