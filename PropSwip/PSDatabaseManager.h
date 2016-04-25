//
//  PSDatabaseManager.h
//  PropSwip
//
//  Created by Kinshuk  Kar on 4/5/16.
//  Copyright © 2016 Kinshuk Kar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PSDatabaseManager : NSObject

+ (PSDatabaseManager *)shared;

- (void) initializeDatabase;

// Data store related methods
- (NSString*) getValueForKey:(NSString*)key;

- (BOOL) putValue:(NSString*)value forKey:(NSString*)key;

@end
