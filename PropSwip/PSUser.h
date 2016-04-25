//
//  PSUser.h
//  PropSwip
//
//  Created by Kinshuk  Kar on 4/20/16.
//  Copyright © 2016 Kinshuk Kar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSUser : NSObject

@property (nonatomic, strong) NSNumber  *userId;
@property (nonatomic, strong) NSString  *fbId;
@property (nonatomic, strong) NSString  *fbToken;
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *emailAddress;
@property (nonatomic, strong) NSString  *profilePicUrl;
@property (nonatomic, assign) BOOL      isLoggedIn;
@property (nonatomic, strong) NSString  *latitude;
@property (nonatomic, strong) NSString  *longitude;
@property (nonatomic, strong) NSString  *mobileNumber;

@end
