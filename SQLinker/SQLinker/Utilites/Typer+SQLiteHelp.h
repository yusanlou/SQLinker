//
//  Typer+SQLiteHelp.h
//  Sqlite3G
//
//  Created by BackNotGod on 2018/1/10.
//  Copyright © 2018年 terminus. All rights reserved.
//

#import "Typer.h"
#import <sqlite3.h>

@interface Typer (SQLiteHelp)

+ (id)objectForSQType:(int)columnIdx stmt:(sqlite3_stmt*)stmt;

@end
