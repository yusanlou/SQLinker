//
//  Absorber.m
//  Sqlite3G
//
//  Created by BackNotGod on 2018/1/4.
//  Copyright © 2018年 terminus. All rights reserved.
//

#import "Absorber.h"
#import <objc/runtime.h>

typedef struct larva {
    const char* _Nonnull type;
    const char* _Nonnull body;
    struct larva* next;
}larva;

static NSArray* ignores;

@interface Absorber (){
    struct larva* header;
    struct larva* current;
    unsigned int outCount;
}

@end

@implementation Absorber

- (instancetype)initWithModelName:(NSString *)modelName{
    return [self initWithModelClass:NSClassFromString(modelName)];
}

- (instancetype)initWithModelClass:(id)modelClass
{
    self = [super init];
    if (self) {
        
        if (!ignores) {
            ignores = @[@"hash",@"superclass",@"debugDescription",@"description"];
        }
        
        [self absorbModel:modelClass];
        
    }
    return self;
}

- (void)absorbModel:(id)modelClass{
    
    objc_property_t* properties = class_copyPropertyList([modelClass class], &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        struct larva * node = [self absorb:property];
        if (node == NULL) {
            continue;
        }
        if (header) {
            current->next = node;
            current = current->next;
        }else{
            current = node;
            header = current;
        }
    }
    free(properties);
}

- (NSDictionary<NSString *,Typer *> *)nameType{
    if (!_nameType) {
        NSMutableDictionary* temp = [NSMutableDictionary dictionaryWithCapacity:outCount];
        for (struct larva* node = header; node != NULL; node = node->next) {
            Typer* type = [[Typer alloc] initWithChar:node->type];
            [temp setObject:type forKey:[NSString stringWithCString:node->body encoding:NSUTF8StringEncoding]];
        }
        _nameType = [temp copy];
    }
    return _nameType;
}

-(struct larva* )absorb:(objc_property_t)property{
    
    struct larva* node = (larva*) malloc(sizeof(larva));
    
    memset(node, 0, sizeof(*node));
    
    node->body = property_getName(property);
    node->type = property_getAttributes(property);
    if ([ignores containsObject:[NSString stringWithUTF8String:node->body]]) {
        return NULL;
    }
    return node;
}

-(void)destroy{
     
    for (struct larva* next = header; next != NULL; next = next->next) {
        free(next);
    }
}

- (void)dealloc
{
    [self destroy];
}

@end
