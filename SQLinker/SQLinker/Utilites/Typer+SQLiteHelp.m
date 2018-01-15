//
//  Typer+SQLiteHelp.m
//  Sqlite3G
//
//  Created by BackNotGod on 2018/1/10.
//  Copyright © 2018年 terminus. All rights reserved.
//

#import "Typer+SQLiteHelp.h"
@implementation Typer (SQLiteHelp)

+ (id)objectForSQType:(int)columnIdx stmt:(sqlite3_stmt*)stmt{
    id returnValue = nil;
    switch (sqlite3_column_type(stmt, columnIdx)) {
            
        case SQLITE_NULL:
            return nil;
        case SQLITE_INTEGER:
            returnValue = [NSNumber numberWithLongLong:sqlite3_column_int64(stmt, columnIdx)];
            break;
        case SQLITE_FLOAT:
            returnValue = [NSNumber numberWithDouble:sqlite3_column_double(stmt, columnIdx)];
            break;
        case SQLITE_BLOB:
            return [self blobForSQType:columnIdx stmt:stmt];
        default:
            return [self stringForSQType:columnIdx stmt:stmt];
            break;
    }
    if (returnValue == nil) {
        return [NSNull null];
    }
    return returnValue;
}

+ (id)blobForSQType:(int)columnIdx stmt:(sqlite3_stmt*)stmt{
    const char *dataBuffer = sqlite3_column_blob(stmt, columnIdx);
    int dataSize = sqlite3_column_bytes(stmt, columnIdx);
    if (dataBuffer == NULL) {
        return nil;
    }
    return [NSData dataWithBytes:(const void *)dataBuffer length:(NSUInteger)dataSize];
}

+ (id)stringForSQType:(int)columnIdx stmt:(sqlite3_stmt*)stmt{
    const char *c = (const char *)sqlite3_column_text(stmt, columnIdx);
    return [NSString stringWithUTF8String:c];
}

@end
