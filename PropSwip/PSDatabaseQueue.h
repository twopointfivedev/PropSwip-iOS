//
//  PSDatabaseQueue.h
//  PropSwip
//
//  Created by Kinshuk  Kar on 4/5/16.
//  Copyright © 2016 Kinshuk Kar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase+Extras.h"

@interface PSDatabaseQueue : NSObject
{
    FMDatabase          *_db;
    dispatch_queue_t    _queue;
}

+ (id)queueForDatabase:(FMDatabase*)db;

- (id)initForDatabase:(FMDatabase*)db;

- (id)query:(void (^)(FMDatabase *db, id *res))block;

- (BOOL)executeRet:(BOOL (^)(FMDatabase *db))block;

- (void)execute:(void (^)(FMDatabase *db))block;

- (BOOL)executeInTxn:(void (^)(FMDatabase *db, BOOL *rollback))block;

- (BOOL)executeInDeferredTxn:(void (^)(FMDatabase *db, BOOL *rollback))block;

@end
