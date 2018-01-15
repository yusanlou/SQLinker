//
//  NSString+PropertyType.h
//  Sqlite3G
//
//  Created by BackNotGod on 2018/1/5.
//  Copyright © 2018年 terminus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PropertyType)

- (const char*)rawPropertyType;

- (NSString*)propertyStringType;


@end

