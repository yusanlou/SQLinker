//
//  Typer.h
//  Sqlite3G
//
//  Created by BackNotGod on 2018/1/5.
//  Copyright © 2018年 terminus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Typer : NSObject

@property(nonatomic,copy)NSString* SQType;
@property(nonatomic,copy)NSString* NSType;

- (instancetype)initWithChar:(const char*)string;




@end

