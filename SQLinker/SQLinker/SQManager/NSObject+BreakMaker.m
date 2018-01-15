//
//  NSObject+BreakMaker.m
//  Sqlite3G
//
//  Created by BackNotGod on 2018/1/5.
//  Copyright © 2018年 terminus. All rights reserved.
//

#import "NSObject+BreakMaker.h"
#import "NSObject+SQHelp.h"
#import "SqliteManager.h"
#import <objc/runtime.h>
#import <pthread.h>

static NSMutableDictionary* tableNames;
static pthread_mutex_t _lock;
static void *NSObjecttableNameKey = &NSObjecttableNameKey;


@implementation NSObject (BreakMaker)

- (void)setTableName:(NSString *)tableName{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        pthread_mutex_init(&_lock, NULL);
    });
    
    pthread_mutex_lock(&_lock);
    
    if (!tableNames) {
        tableNames = [NSMutableDictionary dictionary];
    }
    [tableNames setObject:tableName forKey:NSStringFromClass([self class])];
    pthread_mutex_unlock(&_lock);

}

- (NSString *)tableName{
    return [tableNames objectForKey:NSStringFromClass([self class])];
}

- (NSArray *)selectFormDB:(NSString *)dbName with:(SQContext)context{
    assert(![self isKindOfClass:[SQSatemet class]]);
    
    NSString* retStr = [SQSatemet selectFromTable:[self stringFromClass] with:context];
    
    SqliteManager* manager = [[SqliteManager alloc] initWithName:@"stu"];
    return [manager selectSQ:retStr table:self];
}

- (void)selectFormDBAsync:(NSString *)dbName with:(SQContext)context complite:(void (^)(NSArray *))complite{
    assert(![self isKindOfClass:[SQSatemet class]]);
    
    NSString* retStr = [SQSatemet selectFromTable:[self stringFromClass] with:context];
    
    SqliteManager* manager = [[SqliteManager alloc] initWithName:@"stu"];
    [manager selectSQAsync:retStr table:self complite:complite];
}

- (void)creatTableWithConstrain:(SQConstraintContext)constraint{
    assert(![self isKindOfClass:[SQSatemet class]]);
    NSString* retStr = [SQSatemet creatTable:self constraint:constraint];
    SqliteManager* manager = [[SqliteManager alloc] initWithName:@"stu"];
    [manager sqtableCreat:retStr];
}

- (BOOL)insert{
    
    NSString* retStr = [SQSatemet insertToTable:self];
    SqliteManager* manager = [[SqliteManager alloc] initWithName:@"stu"];
    return [manager insertSql:retStr];
}


- (void)deleteDataFormDB:(NSString *)dbName context:(SQContext)context{
    NSString* retStr = [SQSatemet deleteTable:[self stringFromClass] with:context];
    SqliteManager* manager = [[SqliteManager alloc] initWithName:dbName];
    [manager deleteSQ:retStr];
}

- (void)updateDataToDB:(NSString *)dbName context:(SQContext)context{
    NSString* retStr = [SQSatemet updateWithTable:[self stringFromClass] with:context];
    SqliteManager* manager = [[SqliteManager alloc] initWithName:dbName];
    [manager updateSQ:retStr];
}



@end

