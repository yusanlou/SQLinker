//
//  SQTransaction.m
//  Sqlite3G
//
//  Created by BackNotGod on 2018/1/11.
//  Copyright © 2018年 terminus. All rights reserved.
//

#import "SQTransaction.h"
#import <sqlite3.h>
#import "SqliteManager.h"
@interface SQTransaction (){
    
}

@end

@implementation SQTransaction

+ (void)transaction:(BOOL(^)(void))block{

    [[SqliteManager shareManager] excuteSQL:@"begin exclusive transaction"];
    
    if (block()) {
        [[SqliteManager shareManager] excuteSQL:@"commit transaction"];
    }else{
        [[SqliteManager shareManager] excuteSQL:@"rollback transaction"];
    }
    
}


@end
