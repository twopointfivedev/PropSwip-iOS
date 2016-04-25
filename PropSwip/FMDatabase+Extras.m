//
//  FMDatabase+Extras.m
//  Hidee
//
//  Created by KK on 25/07/15.
//  Copyright (c) 2015 Shalya Softech Private Limited. All rights reserved.
//

#import "FMDatabase+Extras.h"
#if FMDB_SQLITE_STANDALONE
#import <sqlite3/sqlite3.h>
#else
#import <sqlite3.h>
#endif

@implementation FMDatabase (Extras)

- (int)queryUserVersion
{
    int retVersion = 0;
    
    if (_isExecutingStatement) {
       // [self warnInUse];
        return retVersion;
    }
    
    _isExecutingStatement = YES;
    
    NSString *strSql = @"PRAGMA user_version;";
    
    int rc                  = 0x00;;
    sqlite3_stmt *pStmt     = 0x00;;
    
    if (_traceExecution && strSql) {
        NSLog(@"%@ executeQuery: %@", self, strSql);
    }
    rc = sqlite3_prepare_v2(_db, [strSql UTF8String], -1, &pStmt, 0);
    if (SQLITE_OK == rc) {
        while(sqlite3_step(pStmt) == SQLITE_ROW) {
            retVersion = sqlite3_column_int(pStmt, 0);
            NSLog(@"%s: version %d", __FUNCTION__, retVersion);
        }
        //NSLog(@"%s: the databaseVersion is: %d", __FUNCTION__, retVersion);
    }
    else {
        if (_logsErrors) {
            NSLog(@"DB Error: %d \"%@\"", [self lastErrorCode], [self lastErrorMessage]);
            NSLog(@"DB Query: %@", strSql);
            
#ifndef NS_BLOCK_ASSERTIONS
            if (_crashOnErrors) {
                NSAssert2(false, @"DB Error: %d \"%@\"", [self lastErrorCode], [self lastErrorMessage]);
            }
#endif
        }
    }
    
    sqlite3_finalize(pStmt);
    _isExecutingStatement = NO;
    
    return retVersion;
}


@end
