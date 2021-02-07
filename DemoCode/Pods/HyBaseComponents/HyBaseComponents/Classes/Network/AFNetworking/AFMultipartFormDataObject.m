//
//  AFMultipartFormDataObject.m
//  DemoCode
//
//  Created by Hy on 2017/11/29.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "AFMultipartFormDataObject.h"

@interface AFMultipartFormDataObject ()
@property (nonatomic,strong) id<AFMultipartFormData> fromData;
@end

@implementation AFMultipartFormDataObject

+ (instancetype)object:(id<AFMultipartFormData>)fromData {
    AFMultipartFormDataObject *instance = [[self alloc] init];
    instance.fromData = fromData;
    return instance;
}

- (BOOL)appendPartWithFileURL:(NSURL *)fileURL
                         name:(NSString *)name
                        error:(NSError * _Nullable __autoreleasing *)error {
   return [self.fromData appendPartWithFileURL:fileURL name:name error:error];
}

- (BOOL)appendPartWithFileURL:(NSURL *)fileURL
                         name:(NSString *)name
                     fileName:(NSString *)fileName
                     mimeType:(NSString *)mimeType
                        error:(NSError * _Nullable __autoreleasing *)error {
    return [self.fromData appendPartWithFileURL:fileURL name:name fileName:fileName mimeType:mimeType error:error];
}

- (void)appendPartWithInputStream:(nullable NSInputStream *)inputStream
                             name:(NSString *)name
                         fileName:(NSString *)fileName
                           length:(int64_t)length
                         mimeType:(NSString *)mimeType {
    [self.fromData appendPartWithInputStream:inputStream name:name fileName:fileName length:length mimeType:mimeType];
}

- (void)appendPartWithFileData:(NSData *)data
                          name:(NSString *)name
                      fileName:(NSString *)fileName
                      mimeType:(NSString *)mimeType {
    [self.fromData appendPartWithFileData:data name:name fileName:fileName mimeType:mimeType];
}

- (void)appendPartWithFormData:(NSData *)data
                          name:(NSString *)name {
    [self.fromData appendPartWithFormData:data name:name];
}


- (void)appendPartWithHeaders:(nullable NSDictionary <NSString *, NSString *> *)headers
                         body:(NSData *)body {
    [self.fromData appendPartWithHeaders:headers body:body];
}

- (void)throttleBandwidthWithPacketSize:(NSUInteger)numberOfBytes
                                  delay:(NSTimeInterval)delay {
    [self.fromData throttleBandwidthWithPacketSize:numberOfBytes delay:delay];
}

@end
