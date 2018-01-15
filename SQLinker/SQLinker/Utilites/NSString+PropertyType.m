//
//  NSString+PropertyType.m
//  Sqlite3G
//
//  Created by BackNotGod on 2018/1/5.
//  Copyright © 2018年 terminus. All rights reserved.
//

#import "NSString+PropertyType.h"

@implementation NSString (PropertyType)

- (const char *)rawPropertyType{
    
    if ([self length] <= 0) {
        return NULL;
    }
    
    NSArray * attributes = [self componentsSeparatedByString:@","];
    NSString * typeAttribute = [attributes objectAtIndex:0];
    NSString * propertyType = [typeAttribute substringFromIndex:1];
    const char * rawPropertyType = [propertyType UTF8String];
    return rawPropertyType;
}

- (NSString *)propertyStringType{
    
    NSArray* strs = [self componentsSeparatedByString:@"\""];
    if (strs.count > 2) {
        return strs[1];
    }
    return @"";
}

@end
