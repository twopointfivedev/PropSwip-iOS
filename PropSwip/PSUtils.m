//
//  PSUtils.m
//  PropSwip
//
//  Created by Kinshuk  Kar on 4/5/16.
//  Copyright © 2016 Kinshuk Kar. All rights reserved.
//

#import "PSUtils.h"

@implementation PSUtils

+(NSString *) getDocumentsDirectory
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [pathArray objectAtIndex:0];
    return documentsDirectory;
}

+ (NSString *) getDocumentsDirectoryPathForFile:(NSString *) file
{
    NSString *absolutePath = @"";
    NSString *docDir = [self getDocumentsDirectory];
    if(psIsEmptyString(file) == false)
    {
        absolutePath = [NSString stringWithFormat:@"%@/%@",docDir,file];
    }
    return absolutePath;
}

+ (BOOL) isEmptyString:(NSString*)string
{
    if (string == nil) return YES;
    if ([string isKindOfClass:[NSNull class]]) return YES;
    
    NSString *trimmedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return ([trimmedString length] == 0);
}

+ (UIColor*) getThemeColor
{
    return [UIColor colorWithRed:42.0f/255.0f green:62.0f/255.0f blue:82.0f/255.0f alpha:1.0f];
}

+ (NSString*) emptyForNilString:(NSString*)str
{
    return str == nil ? @"" : str;
}

@end
