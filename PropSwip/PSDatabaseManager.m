//
//  PSDatabaseManager.m
//  PropSwip
//
//  Created by Kinshuk  Kar on 4/5/16.
//  Copyright © 2016 Kinshuk Kar. All rights reserved.
//

#import "PSDatabaseManager.h"
#import "FMDatabase+Extras.h"
#import "PSDatabaseQueue.h"
#import "PSConstants.h"
#import "PSUtils.h"
#import "PSKeyStoreItem.h"

static PSDatabaseManager* sharedInstance;

@interface PSDatabaseManager ()

@property (nonatomic, assign)   BOOL                isInitialized;
@property (readonly)            FMDatabase          *propswipDB;
@property (readonly)            PSDatabaseQueue     *propswipDaoQueue;
@property (nonatomic, strong)   NSMutableDictionary *dataStoreMap;

@end

@implementation PSDatabaseManager

+ (PSDatabaseManager *)shared
{
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id) init
{
    if (sharedInstance) {
        NSException *exception = [[NSException alloc] initWithName:@"PSDatabaseManager" reason:@"Attempt to create more than one instances of the Database Manager. You must use the method shared to get the instance." userInfo:nil];
        [exception raise];
    }
    
    self = [super init];
    if (self) {
        _isInitialized = NO;
    }
    
    return self;
}

- (void) initializeDatabase
{
    if (!_isInitialized) {
        
        _propswipDB = [PSDatabaseManager createDatabaseWithName:PROPSWIP_DB_NAME];
        _propswipDaoQueue = [PSDatabaseQueue queueForDatabase:_propswipDB];
        
        _dataStoreMap = [[NSMutableDictionary alloc] init];
        [self populateDataStoreMap];
        
        _isInitialized = YES;
    }
}

+ (FMDatabase *)createDatabaseWithName:(NSString *)databaseName {
    
    NSString *writableDBPath = [PSUtils getDocumentsDirectoryPathForFile:databaseName];
    FMDatabase *theDB = [PSDatabaseManager databaseWithPath:writableDBPath];
    if (!theDB)
    {
        //DDLogError(@"Unable to open or create database at path: %@", writableDBPath);
        return nil;
    }
    
    [theDB setLogsErrors:YES];
    [theDB setShouldCacheStatements:YES];
    
    [PSDatabaseManager upgradeDatabaseSchemaIfRequred:theDB];
    
    return theDB;
}

+ (FMDatabase *) databaseWithPath:(NSString *)dBPath
{
    FMDatabase *theDB = [FMDatabase databaseWithPath:dBPath];
    if ([theDB open])
    {
        if ([theDB executeUpdate:PS_DB_EXISTENCE_TESTER]) {
            return theDB;
        }
        else {
            //DDLogError(@"FATAL: Database existence check failed. errorCode:{%d}, errorMsg:{%@}", \
            [theDB lastErrorCode], [theDB lastErrorMessage]);
        }
    }
    else
    {
        //DDLogError(@"FATAL:Could not open data base from path: %@", dBPath);
    }
    
    return nil;
}

+ (void) upgradeDatabaseSchemaIfRequred:(FMDatabase *)theDB {
    
    int version = [theDB queryUserVersion];    
    if (version == PS_CURRENT_SCHEMA_VERSION)
    {
        //DDLogInfo(@"Schema already upto-date at version %d.", version);
        return;
    }
    
    //DDLogInfo(@"Database version is not latest. [Old: %d] [New: %ld]. Need to create/upgrade.", version, (long)RL_CURRENT_SCHEMA_VERSION);
    
    NSArray *upgradeSqls = [PSDatabaseManager getSchemaUpgradeSqlsFromVersion:version];
    
    if(upgradeSqls != nil && [upgradeSqls count] > 0)
    {
        BOOL bErrorInUpdate = FALSE;
        for(NSString *strUpdateQuery in upgradeSqls)
        {
            if ([theDB executeUpdate:strUpdateQuery])
            {
                //DDLogError(@"Update sql: %@  executed successfully", strUpdateQuery);
            }
            else {
                //DDLogError(@"Error in update sql: %@", strUpdateQuery);
                bErrorInUpdate = YES;
                break;
            }
        }
        
        if(!bErrorInUpdate)
        {
            NSString *strSchemaUpdate = [NSString stringWithFormat:@"%@%d",@"PRAGMA user_version =",(int)PS_CURRENT_SCHEMA_VERSION];
            [theDB executeUpdate:strSchemaUpdate];
        }
        else
        {
            //DDLogError(@"Error while creating database for schema version %ld", (long)RL_CURRENT_SCHEMA_VERSION);
            [theDB rollback];
        }
    }
    
    return;
}

+ (NSArray *) getSchemaUpgradeSqlsFromVersion:(int)version {
    
    NSMutableArray *upgradeSqls = [[NSMutableArray alloc] init];
    switch (version+1)
    {
        case 0 :
        case 1 :
        {
            [upgradeSqls addObject:PS_V1_CREATE_TABLE_DATA_STORE];
            [upgradeSqls addObject:PS_V1_CREATE_TABLE_USER];
        }
            
        default:
            break;
    }
    
    return upgradeSqls;
}

- (NSString*) getValueForKey:(NSString*)key
{
    if(_dataStoreMap != nil) {
        NSString *value = [_dataStoreMap objectForKey:key];
        return value;
    }else {
        return nil;
    }
}

- (BOOL) putValue:(NSString*)value forKey:(NSString*)key
{
    if ([key length] < 1)
        return NO;
    
    BOOL ret = NO;
    if ([_dataStoreMap objectForKey:key] == nil) {
        
        PSKeyStoreItem *item = [[PSKeyStoreItem alloc] init];
        item.key = key;
        item.value = value;
        
        NSString *query = @"INSERT INTO DataStore (key, value) VALUES (?, ?)";
        ret = [_propswipDaoQueue executeRet:^BOOL(FMDatabase *db) {
            return [db executeUpdate:query, item.key, item.value];
        }];
        
    } else {
        
        PSKeyStoreItem *entry = [_propswipDaoQueue query:^(FMDatabase *db, id *res) {
            
            PSKeyStoreItem *item = nil;
            FMResultSet *rs = [db executeQuery:@"SELECT id, key, value FROM DataStore where key = ?", key];
            BOOL entryAvailable = [rs next];
            
            if (entryAvailable) {
                item = [[PSKeyStoreItem alloc] init];
                item.itemId = @([rs intForColumn:@"id"]);
                item.key = [rs stringForColumn:@"key"];
                item.value = [rs stringForColumn:@"value"];
            }
            
            *res = item;
        }];
        
        
        NSString *query = @"UPDATE DataStore SET value = ? where id = ?";
        ret = [_propswipDaoQueue executeRet:^BOOL(FMDatabase *db) {
            return [db executeUpdate:query, value, entry.itemId];
        }];
    }
    
    if(ret) {
        
        value = (value == nil) ? @"" : value;
        [_dataStoreMap setObject:value forKey:key];
    }
    
    return ret;
}

- (void) populateDataStoreMap
{
    NSArray *entries = [_propswipDaoQueue query:^(FMDatabase *db, id *res) {
        
        NSMutableArray *entrs = [[NSMutableArray alloc] init];
        FMResultSet *rs = [db executeQuery:@"SELECT id, key, value FROM DataStore"];
        while([rs next]) {
            
            PSKeyStoreItem *item = [[PSKeyStoreItem alloc] init];
            item.itemId = @([rs intForColumn:@"id"]);
            item.key = [rs stringForColumn:@"key"];
            item.value = [rs stringForColumn:@"value"] ? [rs stringForColumn:@"value"] : @"";
            
            [entrs addObject:item];
        }
        
        *res = [entrs copy];
    }];
    
    for (PSKeyStoreItem *item in entries) {
        [_dataStoreMap setObject:item.value forKey:item.key];
    }
}


@end
