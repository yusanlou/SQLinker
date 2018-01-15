# SQLinker



## Create

```
Model* model = [Model new];
[model creatTableWithConstrain:^(ConstraintStatement *make) {
}];
```



## Search sync

```
NSArray* res = [[Model new] selectFormDB:@"stu" with:^(SQSatemet *context) {
    [context.where(@"age").equalTo(@(i+1000)) end];
}];
```



## Search async

```objective-c
[[Model new] selectFormDBAsync:@"stu" with:^(SQSatemet *context) {
	[context.where(@"age").equalTo(@(i+1000)) end];
	} complite:^(NSArray *res) {
	NSLog(@"%@",[NSDate new]);
}];

```



## Delete

```objective-c
[[Model new] deleteDataFormDB:@"stu" context:^(SQSatemet *make) {
	[make.where(@"age").equalTo(@600) end];
}];
```



## Update

```
[[Model new] updateDataToDB:@"stu" context:^(SQSatemet *make) {
    [make.set(@"name").equalTo(@"ljj").where(@"name").equalTo(@"mubai") end];
}];
```



## Transaction

```
[SQTransaction transaction:^BOOL{
    for (int i =0; i< 100000; i++) {
        Model* mode1 = [Model new];
        mode1.age = i+100;
        mode1.sex = i%2;
        mode1.name = @"mubai";
        mode1.birthday = [NSDate new];
        mode1.num = [NSNumber numberWithInteger:i];
        if (![mode1 insert]) {
            return NO;
        }
    }
    return YES;
}];
```

