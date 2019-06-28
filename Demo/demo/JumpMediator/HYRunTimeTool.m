//
//  HYRunTimeTool.m
//  HYlesAssistant
//
//  Created by huangyi on 17/6/12.
//  Copyright © 2017年 huangyi. All rights reserved.
//

#import "HYRunTimeTool.h"
#import <objc/runtime.h>

@implementation HYRunTimeTool
+ (NSString *)stringWithClass:(Class)clazz{
    return [NSString stringWithCString:object_getClassName(clazz)
                              encoding:NSUTF8StringEncoding];
}

+ (Class)classWithString:(NSString *)string {
    return objc_getClass([string cStringUsingEncoding:NSUTF8StringEncoding]);
}

+ (BOOL)hasPropertyName:(NSString *)name atClass:(Class)clazz {
    return class_getProperty(clazz, [name cStringUsingEncoding:NSUTF8StringEncoding]) != NULL;
}

+ (BOOL)hasInstanceMethodForClass:(Class)clazz selector:(SEL)selector {
    return class_getInstanceMethod(clazz, selector) != nil;
}

+ (BOOL)hasClassMethodForClass:(Class)clazz selector:(SEL)selector {
    return class_getClassMethod(clazz, selector) != nil;
}

// 获取变量列表
+ (NSArray *)ivarListWithClass:(Class)cls {
    NSMutableArray *Ilist = [NSMutableArray array];
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(cls, &count);
    for (int i = 0; i<count; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        [Ilist addObject:key];
    }
    free(ivars);
    return Ilist;
}

// 获取属性列表
+ (NSArray *)propertyListWithClass:(Class)cls {
    NSMutableArray *Plist = [NSMutableArray array];
    unsigned int count = 0;
    objc_property_t *propertys = class_copyPropertyList(cls, &count);
    for (int i = 0; i<count; i++) {
        objc_property_t property = propertys[i];
        const char *name = property_getName(property);
        NSString *key = [NSString stringWithUTF8String:name];
        [Plist addObject:key];
    }
    free(propertys);
    return Plist;
}

// 获取方法列表
+ (NSArray *)methodListWithClass:(Class)cls {
    NSMutableArray *Mlist = [NSMutableArray array];
    unsigned int count = 0;
    Method *methods = class_copyMethodList(cls, &count);
    for (int i = 0; i<count; i++) {
        Method method = methods[i];
        NSString *name = NSStringFromSelector(method_getName(method));
        [Mlist addObject:name];
    }
    free(methods);
    return Mlist;
}

// 交换方法
+ (void)exchangeMethodWithClass:(Class)methodClass
                   systemMethod:(SEL)systemMethod
                   customMethod:(SEL)customMethod {
    
    Method beforMethod = class_getInstanceMethod(methodClass, systemMethod);
    Method afterMethod = class_getInstanceMethod(methodClass, customMethod);
    
    BOOL didAddMethod = class_addMethod(methodClass,
                                        systemMethod,
                                        method_getImplementation(afterMethod),
                                        method_getTypeEncoding(afterMethod));
    if (didAddMethod) {
        class_replaceMethod(methodClass,
                            systemMethod,
                            method_getImplementation(beforMethod),
                            method_getTypeEncoding(beforMethod));
    } else {
        method_exchangeImplementations(beforMethod, afterMethod);
    }
}

@end
