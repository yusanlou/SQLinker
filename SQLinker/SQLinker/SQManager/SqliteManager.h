//
//  SqliteManager.h
//  Sqlite3G
//
//  Created by BackNotGod on 2018/1/4.
//  Copyright © 2018年 terminus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SqliteManager : NSObject

+ (instancetype)shareManager;

- (instancetype)initWithName:(NSString*)dbName;
- (BOOL)insertSql:(NSString*)sql;
- (NSArray*)selectSQ:(NSString*)sql table:(id)table;
- (void)sqtableCreat:(NSString*)sql;
- (void)deleteSQ:(NSString*)sql;
- (void)updateSQ:(NSString*)sql;
- (void)selectSQAsync:(NSString*)sql table:(id)table complite:(void(^)(NSArray*))complite;
- (void)excuteSQL:(NSString *)sql, ...;

@end
