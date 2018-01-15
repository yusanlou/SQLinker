//
//  Absorber.h
//  Sqlite3G
//
//  Created by BackNotGod on 2018/1/4.
//  Copyright © 2018年 terminus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Typer.h"

@interface Absorber : NSObject

@property(nonatomic,strong)NSDictionary<NSString*,Typer*>* nameType;

- (instancetype)initWithModelClass:(id)modelClass;

- (instancetype)initWithModelName:(NSString*)modelName;

@end
