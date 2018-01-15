//
//  SQTransaction.h
//  Sqlite3G
//
//  Created by BackNotGod on 2018/1/11.
//  Copyright © 2018年 terminus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SQTransaction : NSObject

+ (void)transaction:(BOOL(^)(void))block;

@end
