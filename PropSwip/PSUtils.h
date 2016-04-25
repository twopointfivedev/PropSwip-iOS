//
//  PSUtils.h
//  PropSwip
//
//  Created by Kinshuk  Kar on 4/5/16.
//  Copyright © 2016 Kinshuk Kar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define psIsEmptyString(x) [PSUtils isEmptyString:x]
#define psEmptyForNilString(x) [PSUtils emptyForNilString:x]

@interface PSUtils : NSObject

+ (NSString *) getDocumentsDirectory;

+ (NSString *) getDocumentsDirectoryPathForFile:(NSString *) file;

+ (BOOL) isEmptyString:(NSString*)string;

+ (NSString*) emptyForNilString:(NSString*)str;

+ (UIColor*) getThemeColor;

@end
