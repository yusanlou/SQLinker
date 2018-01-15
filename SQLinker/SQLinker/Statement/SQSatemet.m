//
//  SQSatemet.m
//  Sqlite3G
//
//  Created by BackNotGod on 2018/1/5.
//  Copyright © 2018年 terminus. All rights reserved.
//

#import "SQSatemet.h"
#import "Absorber.h"
#import "NSObject+SQHelp.h"
#import "NSObject+BreakMaker.h"

static const NSString* primary = @"primary_id";

@interface ConstraintStatement ()

@property(nonatomic,strong)NSMutableArray* notNulls;
@property(nonatomic,strong)NSMutableArray* uniques;

@property(nonatomic,strong)NSMutableString* content;
@property(nonatomic,strong)NSString* primaryKey;

@end

@implementation ConstraintStatement

-(NSMutableArray *)notNulls{
    if (!_notNulls) {
        _notNulls = [[NSMutableArray alloc] initWithArray:@[]];
        
    }
    return _notNulls;
}

- (NSMutableArray *)uniques{
    if (!_uniques) {
        _uniques = [[NSMutableArray alloc] initWithArray:@[]];
    }
    return _uniques;
}

- (Constrainer)notNull{
    return ^ConstraintStatement*(NSString* param){
        [self.notNulls addObject:param];
        return self;
    };
}

- (Constrainer)primary{
    NSAssert(_primaryKey == nil, @"_primaryKey is one and only");
    return ^ConstraintStatement*(NSString* param){
        self.primaryKey = param;
        return self;
    };
}

- (Constrainer)unique{
    return ^ConstraintStatement*(NSString* param){
        [self.uniques addObject:param];
        return self;
    };
}

- (Constrainer)custum{
    return ^ConstraintStatement*(NSString* param){
        
        return self;
    };
}

@end


@interface SQSatemet()
@property(nonatomic,strong)NSMutableString* content;

@end

@implementation SQSatemet

#pragma mark - init
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - creat
+ (NSString *)creatTable:(NSObject *)table constraint:(SQConstraintContext)constraint{
    ConstraintStatement* statement = [[ConstraintStatement alloc] init];
    
    statement.content = [[NSMutableString alloc] initWithFormat:@"create table if not exists %@ (",[table stringFromClass]];
    Absorber* absorber = [[Absorber alloc] initWithModelName:NSStringFromClass([table class])];
    constraint(statement);
    [absorber.nameType enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, Typer * _Nonnull obj, BOOL * _Nonnull stop) {
        NSMutableString* constraints = [[NSMutableString alloc] initWithFormat:@"%@ %@ ",key,obj.SQType];
//        if ([statement.primaryKey isEqualToString:key]) {
//            [constraints appendString:@"PRIMARY KEY AUTOINCREMENT "];
//        }
        if ([statement.notNulls containsObject:key]) {
            [constraints appendString:@"NOT NULL "];
        }
        if ([statement.uniques containsObject:key]) {
            [constraints appendString:@"UNIQUE "];
        }
        
        [statement.content appendFormat:@"%@,",constraints];
    }];
    
    // 主键改为自动生成
    [statement.content appendFormat:@"%@ integer primary key autoincrement ",primary];
    
    [statement.content deleteCharactersInRange:NSMakeRange(statement.content.length-1, 1)];
    [statement.content appendFormat:@");"];
    NSString* ret = [statement.content copy];
    return ret;
}


+ (NSString *)dropTable:(NSString *)table
{
    SQSatemet* statement = [[SQSatemet alloc] init];
    statement.content = [[NSMutableString alloc] initWithFormat:@"drop table if exists %@",table];
    NSString* ret = [statement.content copy];
    return ret;
}

#pragma mark - insert
+(NSString *)insertToTable:(NSObject *)data{
    SQSatemet* statement = [[SQSatemet alloc] init];
    
    statement.content = [[NSMutableString alloc] initWithFormat:@"INSERT INTO %@ ",[data stringFromClass]];
    Absorber* absorber = [[Absorber alloc] initWithModelClass:data];
    
    NSMutableString* fields = [[NSMutableString alloc] initWithString:@"("];
    NSMutableString* values = [[NSMutableString alloc] initWithString:@"("];
    
    [absorber.nameType enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, Typer * _Nonnull obj, BOOL * _Nonnull stop) {
        
        if (![key isEqualToString:data.tableName]) {
            [fields appendFormat:@"%@,",key];
            if ([obj.SQType isEqualToString:@"TEXT"]) {
                [values appendFormat:@"'%@',",[data valueForKey:key]];
            }else{
                [values appendFormat:@"%@,",[data valueForKey:key]];
            }
        }
    }];

    [fields deleteCharactersInRange:NSMakeRange(fields.length-1, 1)];
    [fields appendFormat:@")"];
    [values deleteCharactersInRange:NSMakeRange(values.length-1, 1)];
    [values appendFormat:@");"];
    
    [statement.content appendFormat:@"%@ VALUES %@",fields,values];
    NSString* ret = [statement.content copy];
    return ret;
}

#pragma mark - update
+ (NSString *)updateWithTable:(NSString *)table with:(SQContext)context{
    SQSatemet* statement = [[SQSatemet alloc] init];
    
    statement.content = [[NSMutableString alloc] initWithFormat:@"UPDATE %@ ",table];
    context(statement);
    
    NSString* ret = [statement.content copy];
    return ret;
}


#pragma mark - delete
+ (NSString *)deleteTable:(NSString *)table with:(SQContext)context{
    SQSatemet* statement = [[SQSatemet alloc] init];
    
    statement.content = [[NSMutableString alloc] initWithFormat:@"DELETE FROM %@ ",table];
    context(statement);
    
    NSString* ret = [statement.content copy];
    return ret;
}

#pragma mark - select
+ (NSString*)selectFromTable:(NSString *)table with:(SQContext)context{
    
    SQSatemet* statement = [[SQSatemet alloc] init];
    
    statement.content = [[NSMutableString alloc] initWithFormat:@"SELECT * FROM %@ ",table];
    context(statement);
    
    NSString* ret = [statement.content copy];
    return ret;
}

#pragma mark - condition
-(Maker)where{
    
    return ^SQSatemet*(id param){
        [_content appendFormat:@"WHERE %@ ",param];
        return self;
    };
}

- (Maker)select{
    return ^SQSatemet*(id param){
        if ([param conformsToProtocol:@protocol(NSFastEnumeration)]) {
            // remove '*'
            if ([_content hasPrefix:@"SELECT *"]) {
                [_content deleteCharactersInRange:NSMakeRange(7, 1)];
            }
            NSMutableString* tempStr = [NSMutableString string];
            [param enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [tempStr appendFormat:@"%@,",obj];
            }];
            [tempStr deleteCharactersInRange:NSMakeRange(tempStr.length-1, 1)];
            [_content insertString:[tempStr copy] atIndex:7]; // In the behind select
        }
        return self;
    };
}

- (Maker)set{
    return ^SQSatemet*(id param){
        [_content appendFormat:@"SET %@ ",param];
        return self;
    };
}

- (Maker)equalTo{
    return ^SQSatemet*(id param){
        [_content appendFormat:@"= %@ ",[self sqStr:param]];
        return self;
    };
}

- (Maker)notEqualTo{
    return ^SQSatemet*(id param){
        [_content appendFormat:@"!= %@ ",[self sqStr:param]];
        return self;
    };
}

- (Maker)greaterThan{
    return ^SQSatemet*(id param){
        [_content appendFormat:@"> %@ ",[self sqStr:param]];
        return self;
    };
}

- (Maker)lessThan{
    return ^SQSatemet*(id param){
        [_content appendFormat:@"< %@ ",[self sqStr:param]];
        return self;
    };
}

- (Maker)lessThanOrEqual{
    return ^SQSatemet*(id param){
        [_content appendFormat:@"<= %@ ",[self sqStr:param]];
        return self;
    };
}

- (Maker)greaterThanOrEqual{
    return ^SQSatemet*(id param){
        [_content appendFormat:@">= %@ ",[self sqStr:param]];
        return self;
    };
}

- (Maker)and{
    return ^SQSatemet*(id param){
        [_content appendFormat:@"AND %@ ",param];
        return self;
    };
}

- (Maker)with{
    return ^SQSatemet*(id param){
        [_content appendFormat:@", %@ ",param];
        return self;
    };
}

- (Maker)groupBy{
    return ^SQSatemet*(id param){
        [_content appendFormat:@"GROUP BY %@ ",param];
        return self;
    };
}

- (Maker)like{
    return ^SQSatemet*(id param){
        [_content appendFormat:@"LIKE '%@' ",param];
        return self;
    };
}

- (Maker)hasPrefix{
    return ^SQSatemet*(id param){
        [_content appendFormat:@"LIKE '%@%%' ",param];
        return self;
    };
}

- (Maker)hasSuffix{
    return ^SQSatemet*(id param){
        [_content appendFormat:@"LIKE '%%%@' ",param];
        return self;
    };
}

- (Maker)inner{
    
    return ^SQSatemet*(id param){
        if ([param conformsToProtocol:@protocol(NSFastEnumeration)]) {
            [_content appendString:@"IN ("];
            [param enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [_content appendFormat:@"%@,",obj];
            }];
            [_content deleteCharactersInRange:NSMakeRange(_content.length-1, 1)];
            [_content appendFormat:@") "];
        }
        return self;
    };
}

- (Maker)as{
    return ^SQSatemet*(id param){
        [_content appendFormat:@"AS %@ ",param];
        return self;
    };
}

- (Maker)or{
    return ^SQSatemet*(id param){
        [_content appendFormat:@"OR %@ ",param];
        return self;
    };
}

-(Maker)count{
    return ^SQSatemet*(id param){
        [_content insertString:[NSString stringWithFormat:@" COUNT (%@) ",param] atIndex:7];
        return self;
    };
}

-(Maker)orderBy{
    return ^SQSatemet*(id param){
        [_content appendFormat:@"ORDER by %@ ",param];
        return self;
    };
}

- (Maker)limit{
    return ^SQSatemet*(id param){
        [_content appendFormat:@"LIMIT %@ ",param];
        return self;
    };
}

- (Maker)custom{
    return ^SQSatemet*(id param){
        [_content appendFormat:@" %@ ",param];
        return self;
    };
}

- (SQSatemet*)desc{
    [_content appendFormat:@"DESC"];
    return self;
}

- (SQSatemet*)asc{
    [_content appendFormat:@"ASC"];
    return self;
}

-(SQSatemet *)having{
    [_content appendFormat:@"HAVING "];
    return self;
}

- (SQSatemet *)distinct{
    [_content insertString:[NSString stringWithFormat:@" Distinct "] atIndex:7];
    return self;
}

- (void)end{
    
    if ([_content hasSuffix:@" "]) {
        [_content deleteCharactersInRange:NSMakeRange(_content.length-1, 1)];
    }else if ([_content hasPrefix:@";"]){
        return;
    }
    
    return [_content appendFormat:@";"];
}

- (NSString*)sqStr:(id)param{
    if ([param isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"'%@'",param];
    }
    return [NSString stringWithFormat:@"%@",param];
}

@end



