//
//  Model.h
//  Sqlite3G
//
//  Created by BackNotGod on 2018/1/4.
//  Copyright © 2018年 terminus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

@property(nonatomic,assign)NSInteger sex;
@property(nonatomic,strong)NSString* name;
@property(nonatomic,strong)NSNumber* num;
@property(nonatomic,assign)int age;
@property(nonatomic,strong)NSDate* birthday;

@property(nonatomic,assign)int ID;

@end
