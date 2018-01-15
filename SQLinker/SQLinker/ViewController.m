//
//  ViewController.m
//  SQLinker
//
//  Created by BackNotGod on 2018/1/15.
//  Copyright © 2018年 terminus. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+BreakMaker.h"
#import "Model.h"
#import "SqliteManager.h"
#import "SQTransaction.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
// Do any additional setup after loading the view, typically from a nib.

// -----------+-----------+-----------+-----------+-----------+-----------
//    Model* model = [Model new];
//    [model creatTableWithConstrain:^(ConstraintStatement *make) {
//
//    }];
// -----------+-----------+-----------+-----------+-----------+-----------
//    NSLog(@"%@",[NSDate new]);
//    [SQTransaction transaction:^BOOL{
//        for (int i =0; i< 100000; i++) {
//            Model* mode1 = [Model new];
//            mode1.age = i+100;
//            mode1.sex = i%2;
//            mode1.name = @"mubai";
//            mode1.birthday = [NSDate new];
//            mode1.num = [NSNumber numberWithInteger:i];
//            if (![mode1 insert]) {
//                return NO;
//            }
//        }
//        return YES;
//    }];
//    NSLog(@"%@",[NSDate new]);
// -----------+-----------+-----------+-----------+-----------+-----------
//    [[Model new] deleteDataFormDB:@"stu" context:^(SQSatemet *make) {
//        [make.where(@"age").equalTo(@600) end];
//    }];
//    NSLog(@"%@",[NSDate new]);
//    // -----------+-----------+-----------+-----------+-----------+-----------
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        for (int i = 0; i < 1000; i++) {
//            //            NSArray* res = [[Model new] selectFormDB:@"stu" with:^(SQSatemet *context) {
//            //                [context.where(@"age").equalTo(@(i+1000)) end];
//            //            }];
//
//            [[Model new] selectFormDBAsync:@"stu" with:^(SQSatemet *context) {
//                [context.where(@"age").equalTo(@(i+1000)) end];
//            } complite:^(NSArray *res) {
//                NSLog(@"%@",[NSDate new]);
//            }];
//        }
//    });


//    [res enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"%@",obj);
//    }];
//    NSLog(@"%@",[NSDate new]);
// -----------+-----------+-----------+-----------+-----------+-----------
//    [[Model new] updateDataToDB:@"stu" context:^(SQSatemet *make) {
//        [make.set(@"name").equalTo(@"ljj").where(@"name").equalTo(@"mubai") end];
//    }];
//
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
