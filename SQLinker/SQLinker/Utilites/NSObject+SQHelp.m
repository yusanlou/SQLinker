//
//  NSObject+SQHelp.m
//  Sqlite3G
//
//  Created by BackNotGod on 2018/1/8.
//  Copyright © 2018年 terminus. All rights reserved.
//

#import "NSObject+SQHelp.h"
#import "NSObject+BreakMaker.h"
@implementation NSObject (SQHelp)

- (NSString*)stringFromClass{
    
    if (self.tableName) {
        return self.tableName;
    }
    
    return NSStringFromClass([self class]);
}

@end
