//
//  NSObject+BreakMaker.h
//  Sqlite3G
//
//  Created by BackNotGod on 2018/1/5.
//  Copyright © 2018年 terminus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQSatemet.h"
@interface NSObject (BreakMaker)

@property(nonatomic,strong)NSString* tableName;

- (NSArray*)selectFormDB:(NSString*)dbName with:(SQContext)context;
- (void)selectFormDBAsync:(NSString*)dbName with:(SQContext)context complite:(void(^)(NSArray*))complite;

- (BOOL)insert;

- (void)creatTableWithConstrain:(SQConstraintContext)constraint;

- (void)deleteDataFormDB:(NSString *)dbName context:(SQContext)context;

- (void)updateDataToDB:(NSString *)dbName context:(SQContext)context;

@end
