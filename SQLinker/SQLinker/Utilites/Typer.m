//
//  Typer.m
//  Sqlite3G
//
//  Created by BackNotGod on 2018/1/5.
//  Copyright © 2018年 terminus. All rights reserved.
//

#import "Typer.h"
#import "NSString+PropertyType.h"
#import "NSObject+SQHelp.h"
@implementation Typer

- (instancetype)initWithChar:(const char *)string{
    if (self = [super init]) {
        [self makeTypeWithChar:string];
    }
    return self;
}

- (void)makeTypeWithChar:(const char *)string{

    if (strlen(string) < 2) {
        return;
    }
    
    NSString * typeString = [NSString stringWithUTF8String:string];
    const char * rawPropertyType = [typeString rawPropertyType];
    
    // 基本类型
    if (strcmp(rawPropertyType, @encode(float)) == 0) {
        self.SQType = @"REAL";
        self.NSType = @"CGFloat";
    }else if ((strcmp(rawPropertyType, @encode(int)) == 0)){
        self.SQType = @"INTEGER";
        self.NSType = @"NSInteger";
    }else if (strcmp(rawPropertyType, @encode(double)) == 0){
        self.SQType = @"REAL";
        self.NSType = @"double";
    }else if (strcmp(rawPropertyType, @encode(NSInteger)) == 0){
        self.SQType = @"INTEGER";
        self.NSType = @"NSInteger";
    }else if (strcmp(rawPropertyType, @encode(NSUInteger)) == 0){
        self.SQType = @"INTEGER";
        self.NSType = @"NSInteger";
    }
    // 非基本类型
    else if ([typeString hasPrefix:@"T@"]){
        self.NSType = [typeString propertyStringType];
        if ([self.NSType length] > 0) {
            // 只考虑
            if ([self.NSType isEqualToString:[NSString stringFromClass]]) {
                self.SQType = @"TEXT";
            }else if ([self.NSType isEqualToString:[NSDate stringFromClass]]){
                self.SQType = @"TEXT";
            }else if ([self.NSType isEqualToString:[NSNumber stringFromClass]]){
                self.SQType = @"REAL";
            }else{
                self.SQType = @"TEXT";
            }
        }
    }
   
}

@end
