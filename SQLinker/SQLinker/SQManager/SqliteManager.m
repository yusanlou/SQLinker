//
//  SqliteManager.m
//  Sqlite3G
//
//  Created by BackNotGod on 2018/1/4.
//  Copyright © 2018年 terminus. All rights reserved.
//

#import "SqliteManager.h"
#import <sqlite3.h>
#import "Model.h"
#import "SQSatemet.h"
#import "NSObject+BreakMaker.h"
#import "Typer+SQLiteHelp.h"
#import <pthread.h>
@interface SqliteManager (){
    sqlite3 * ppDb;
    NSString* fileName;
    NSString* dbPath;
    
    dispatch_queue_t writeSerialQueue;
    dispatch_queue_t readQueue;
    pthread_mutex_t p_lock;
}

@end

@implementation SqliteManager

+ (instancetype)shareManager{
    static dispatch_once_t onceToken;
    static SqliteManager* manager;
    dispatch_once(&onceToken, ^{
        manager = [[SqliteManager alloc] init];
        
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        writeSerialQueue = dispatch_queue_create("com.sqlite.wirte", DISPATCH_QUEUE_SERIAL);
        readQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    }
    return self;
}

- (instancetype)initWithName:(NSString*)dbName
{
    
    SqliteManager* manager = [SqliteManager shareManager];
    [manager setValue:dbName forKey:@"fileName"];
    [manager creatSQ];
    return manager;
}

- (void)dispatchRead:(void(^)(void))blcok{
    dispatch_async(readQueue, blcok);
}

- (void)dispatchWrite:(void(^)(void))block{
    dispatch_sync(writeSerialQueue, block);
}

- (void)creatSQ{
    
    if (ppDb) {
        return;
    }
    
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    dbPath = [NSString stringWithFormat:@"%@/%@.db",path,fileName];
    
    if (sqlite3_open([dbPath fileSystemRepresentation], &ppDb) == SQLITE_OK) {
        NSLog(@"数据库链接成功");
        pthread_mutex_init(&p_lock, NULL);
    }else{
        NSLog(@"数据库链接失败");
    }
    
}

- (void)closeSQ{
    if (sqlite3_close(ppDb)) {
        NSLog(@"数据库关闭");
        pthread_mutex_destroy(&p_lock);
    }
}


int sqlite3Callback(void *db , int cloums, char **values, char **sqlite3_column_names){
    
    
    
    return 0;
}

// excute
- (void)sqtableCreat:(NSString*)sql{
    char* errmsg;
    int res = sqlite3_exec(ppDb, sql.UTF8String, sqlite3Callback, NULL, &errmsg);
    if (res == SQLITE_OK) {
        NSLog(@"创建表成功");
    }else{
        NSLog(@"创建表失败 -- %s",errmsg);
    }
}

- (BOOL)insertSql:(NSString*)sql{
    __block char* errmsg = NULL;
    __block int res = 0;
    [self dispatchWrite:^{
        res = sqlite3_exec(ppDb, sql.UTF8String, sqlite3Callback, NULL, &errmsg);
    }];
    if (res == SQLITE_OK) {
        NSLog(@"插入数据成功");
        return YES;
    }else{
        NSLog(@"插入数据失败 -- %s",errmsg);
        return NO;
    }
}

- (NSArray*)selectSQ:(NSString*)sql table:(id)table{
    
    NSMutableArray* selectResult = [NSMutableArray array];

   
    sqlite3_stmt *stmt = nil;
    int res = sqlite3_prepare_v2(ppDb, sql.UTF8String, -1, &stmt, nil);
    if (res == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            id temp = [[[table class] alloc] init];
            for (int j = 0; j < sqlite3_data_count(stmt); j ++) {
                const char* name = sqlite3_column_name(stmt, j);
                id value = [Typer objectForSQType:j stmt:stmt];
                if ([[NSString stringWithUTF8String:name] isEqualToString:@"primary_id"]) {
                    continue;
                }
                [temp setValue:value forKey:[NSString stringWithUTF8String:name]];
            }
            [selectResult addObject:temp];
        }
    }
    sqlite3_finalize(stmt);
    return [selectResult copy];
}

- (void)selectSQAsync:(NSString*)sql table:(id)table complite:(void(^)(NSArray*))complite{
    [self dispatchRead:^{
        pthread_mutex_lock(&p_lock);
        NSMutableArray* selectResult = [NSMutableArray array];
        sqlite3_stmt *stmt = nil;
        int res = sqlite3_prepare_v2(ppDb, sql.UTF8String, -1, &stmt, nil);
        if (res == SQLITE_OK) {
            while (sqlite3_step(stmt) == SQLITE_ROW) {
                id temp = [[[table class] alloc] init];
                for (int j = 0; j < sqlite3_data_count(stmt); j ++) {
                    const char* name = sqlite3_column_name(stmt, j);
                    id value = [Typer objectForSQType:j stmt:stmt];
                    if ([[NSString stringWithUTF8String:name] isEqualToString:@"primary_id"]) {
                        continue;
                    }
                    [temp setValue:value forKey:[NSString stringWithUTF8String:name]];
                }
                [selectResult addObject:temp];
            }
        }
        sqlite3_finalize(stmt);
        pthread_mutex_unlock(&p_lock);
        complite([selectResult copy]);
    }];
}

-(void)deleteSQ:(NSString *)sql{
    __block char* errmsg = NULL;
    __block int res = 0;
    [self dispatchWrite:^{
        res = sqlite3_exec(ppDb, sql.UTF8String, sqlite3Callback, NULL, &errmsg);
    }];
    if (res == SQLITE_OK) {
        NSLog(@"删除数据成功");
    }else{
        NSLog(@"删除数据失败 -- %s",errmsg);
    }
}

- (void)updateSQ:(NSString*)sql{
    __block char* errmsg = NULL;
    __block int res = 0;
    [self dispatchWrite:^{
        res = sqlite3_exec(ppDb, sql.UTF8String, sqlite3Callback, NULL, &errmsg);
    }];
    if (res == SQLITE_OK) {
        NSLog(@"更新数据成功");
    }else{
        NSLog(@"更新数据失败 -- %s",errmsg);
    }
}

- (void)excuteSQL:(NSString *)sql, ...{
    va_list args;
    va_start(args, sql);
    sqlite3_stmt *stmt = nil;
    int rc = sqlite3_prepare_v2(ppDb, [sql UTF8String], -1, &stmt, 0);
    if (rc == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            
        }
    }
    
    sqlite3_finalize(stmt);
    va_end(args);
    
}



@end
