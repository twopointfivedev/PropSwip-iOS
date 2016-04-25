//
//  PSDatabaseQueue.m
//  PropSwip
//
//  Created by Kinshuk  Kar on 4/5/16.
//  Copyright © 2016 Kinshuk Kar. All rights reserved.
//

#import "PSDatabaseQueue.h"

@implementation PSDatabaseQueue

+ (id) queueForDatabase:(FMDatabase*)db
{
    return [[self alloc] initForDatabase:db];
}

- (id)initForDatabase:(FMDatabase*)db
{
    self = [super init];
    if (self != nil)
    {
        _db = db;
        _queue = dispatch_queue_create([[NSString stringWithFormat:@"hideeDaoQueue.%@", [db databasePath]] UTF8String], NULL);
    }
    return self;
}

- (id)query:(void (^)(FMDatabase *db, id *res))block
{
    __block id _res;
    dispatch_sync(_queue, ^() {
        block(_db, &_res);
    });
    return _res;
}

- (BOOL)executeRet:(BOOL (^)(FMDatabase *db))block
{
    __block BOOL retVal = NO;
    dispatch_sync(_queue, ^() {
        retVal = block(_db);
    });
    
    return retVal;
}

- (void)execute:(void (^)(FMDatabase *db))block
{
    dispatch_sync(_queue, ^() {
        block(_db);
    });
}

- (BOOL)executeTxn:(BOOL)useDeferred withBlock:(void (^)(FMDatabase *db, BOOL *rollback))block
{
    __block BOOL shouldRollback = NO, txnBegun;
    dispatch_sync(_queue, ^()
                  {
                      if (useDeferred)
                          txnBegun = [_db beginDeferredTransaction];
                      else
                          txnBegun = [_db beginTransaction];
                      
                      block(_db, &shouldRollback);
                      
                      if (shouldRollback)
                          [_db rollback];
                      else
                          [_db commit];
                  });
    
    return !shouldRollback;
}

- (BOOL)executeInTxn:(void (^)(FMDatabase *db, BOOL *rollback))block
{
    return [self executeTxn:NO withBlock:block];
}

- (BOOL)executeInDeferredTxn:(void (^)(FMDatabase *db, BOOL *rollback))block
{
    return [self executeTxn:YES withBlock:block];
}

@end
