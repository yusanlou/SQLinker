//
//  SQSatemet.h
//  Sqlite3G
//
//  Created by BackNotGod on 2018/1/5.
//  Copyright © 2018年 terminus. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ConstraintStatement;
@interface SQSatemet : NSObject

typedef void (^SQContext)(SQSatemet*);
typedef SQSatemet* (^Maker)(id);
typedef void (^SQConstraintContext)(ConstraintStatement*);
typedef ConstraintStatement* (^Constrainer)(NSString*);


// condition
@property(nonatomic,strong,readonly)Maker where;
@property(nonatomic,strong,readonly)Maker select;

// constraint
@property(nonatomic,strong,readonly)Maker equalTo;
@property(nonatomic,strong,readonly)Maker notEqualTo;
@property(nonatomic,strong,readonly)Maker greaterThan;
@property(nonatomic,strong,readonly)Maker lessThan;
@property(nonatomic,strong,readonly)Maker inner;
@property(nonatomic,strong,readonly)Maker limit;

// logical operation
@property(nonatomic,strong,readonly)Maker and;
@property(nonatomic,strong,readonly)Maker or;
@property(nonatomic,strong,readonly)Maker with;
@property(nonatomic,strong,readonly)Maker as;

// summary
@property(nonatomic,strong,readonly)Maker count;
@property(nonatomic,strong,readonly)Maker groupBy;
@property(nonatomic,strong,readonly)Maker orderBy;
@property(nonatomic,strong,readonly)Maker like;
@property(nonatomic,strong,readonly)Maker hasSuffix;
@property(nonatomic,strong,readonly)Maker hasPrefix;


// descrb
@property(nonatomic,strong,readonly)SQSatemet* desc;
@property(nonatomic,strong,readonly)SQSatemet* asc;
@property(nonatomic,strong,readonly)SQSatemet* having;
@property(nonatomic,strong,readonly)SQSatemet* distinct;

// update
@property(nonatomic,strong,readonly)Maker set;

// other
@property(nonatomic,strong,readonly)Maker custom;


- (void)end;


//DDL
+ (NSString *)creatTable:(NSObject *)table constraint:(SQConstraintContext)constraint;

+ (NSString*)dropTable:(NSString*)table;

// DML
+ (NSString*)insertToTable:(NSObject*)data;

+ (NSString*)updateWithTable:(NSString*)table with:(SQContext)context;

+ (NSString*)deleteTable:(NSString*)table with:(SQContext)context;


#pragma mark - select
// DQL
+ (NSString*)selectFromTable:(NSString*)table with:(SQContext)context;


@end

@interface ConstraintStatement : NSObject

@property(nonatomic,strong,readonly)Constrainer notNull;
@property(nonatomic,strong,readonly)Constrainer unique;
//@property(nonatomic,strong,readonly)Constrainer primary;

@property(nonatomic,strong,readonly)Constrainer custum; // defalut value or other

@end

