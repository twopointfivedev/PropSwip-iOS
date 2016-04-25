//
//  PSConstants.m
//  PropSwip
//
//  Created by Kinshuk  Kar on 4/5/16.
//  Copyright © 2016 Kinshuk Kar. All rights reserved.
//

#import "PSConstants.h"

NSString * const PROPSWIP_DB_NAME               = @"propswip";
NSInteger  const PS_CURRENT_SCHEMA_VERSION      = 1;

NSString * const PROPSWIP_KVS_KEY_APP_VER       = @"ver";
NSString * const CURRENT_APP_VERSION            = @"1.0";
NSString * const PROPSWIP_SHOW_LOGIN_SCREEN     = @"slsc";

NSString * const PS_DB_EXISTENCE_TESTER         = @"CREATE TABLE IF NOT EXISTS existence_tester (col1 integer)";

NSString * const PS_V1_CREATE_TABLE_DATA_STORE  =
@"CREATE TABLE if not exists DataStore ( \
    id integer PRIMARY KEY AUTOINCREMENT, \
    key text UNIQUE, \
    value text default ''\
)";

NSString * const PS_V1_CREATE_TABLE_USER =
@"CREATE TABLE if not exists User ( \
    id integer PRIMARY KEY AUTOINCREMENT, \
    name text default '',\
    profilePicUrl text default '',\
    emailAddress text default '',\
    fbId text default '',\
    fbToken text default '',\
    mobileNumber text default '',\
    isUserLoggedIn integer default 0,\
    locLat text default '',\
    locLng text default ''\
)";