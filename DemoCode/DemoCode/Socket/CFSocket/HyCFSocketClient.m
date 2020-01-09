//
//  HyCFSocketClient.m
//  DemoCode
//
//  Created by Hy on 2017/12/26.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyCFSocketClient.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import "HySocketReConnect.h"
#import "HySocketMessage.h"
#import "HySocketHeartBeat.h"
#import "HyModelParser.h"
#import "HySocketConnect.h"
#import "HyNetworkManager.h"


@interface HyCFSocketClient ()
@property (nonatomic,copy) NSString *ip;
@property (nonatomic,copy) NSString *port;
@property (nonatomic, assign) int cSocket;
@property (nonatomic,assign,getter=isConnected) BOOL connected;
@property (nonatomic,strong) id<HySocketConnectProtocol> connectObject;
@property (nonatomic,strong) id<HySocketHeartBeatProtocol> heartBeatObject;
@property (nonatomic,strong) id<HySocketReConnectProtocol> reConnectObject;
@property (nonatomic,copy) void(^recvMessageHandler)(id<HySocketMessageProtocol>);
@end


@implementation HyCFSocketClient
@synthesize ID = _ID;

+ (instancetype (^)(NSString *ip, NSString *port))socket {
    return ^(NSString *ip, NSString *port){
        HyCFSocketClient *instance = [[self alloc] init];
        instance.ip = ip;
        instance.port = port;
        int cSocket = socket(AF_INET, SOCK_STREAM, 0);
        instance.cSocket = cSocket;
        return cSocket == -1 ? nil : instance;
    };
}

- (void)connectWithCompletion:(void(^)(BOOL success))completion {
    if (self.isConnected) { return; }
    [self.reConnectObject resetReConnectCount];
    [self autoConnectWithCompletion:completion];
    [self connectObject];
}

- (void)autoConnectWithCompletion:(void(^)(BOOL success))completion {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
                 
           struct sockaddr_in socketAddr;
           socketAddr.sin_family = AF_INET;
           socketAddr.sin_port   = htons([self.port integerValue]);

           struct in_addr socketIn_addr;
           socketIn_addr.s_addr  = inet_addr([self.ip UTF8String]);
           socketAddr.sin_addr     = socketIn_addr;

           int result = connect(self.cSocket, (const struct sockaddr *)&socketAddr, sizeof(socketAddr));

           self.connected = result == 0;
           
           dispatch_async(dispatch_get_main_queue(), ^{
               !completion ?: completion(self.isConnected);
           });
           
           if (self.isConnected) {
               
                NSLog(@"连接成功%@",@(self.cSocket));
               
               [self.reConnectObject resetReConnectCount];
               [self.heartBeatObject start];
               
               while (1) {
                   
                   uint8_t buffer[1024];
                   ssize_t recvLen = recv(self.cSocket, buffer, sizeof(buffer), 0);
                 
                   if (recvLen == 0) { continue; }
                   
                   NSData *data = [NSData dataWithBytes:buffer length:recvLen];
                   id msg =
                   [NSJSONSerialization JSONObjectWithData:data
                                                   options:NSJSONReadingMutableContainers
                                                     error:nil];
                   
                   NSLog(@"客户端%@收到消息:%@",self.ID, msg);
                   
                   dispatch_async(dispatch_get_main_queue(), ^{
                       if ([msg isKindOfClass:NSDictionary.class]) {
                          id<HySocketMessageProtocol> msgResult = [HySocketMessage hy_modelWithJSON:msg];
                           !self.recvMessageHandler ?: self.recvMessageHandler(msgResult);
                       } else {
                           !self.recvMessageHandler ?: self.recvMessageHandler(msg);
                       }
                   });
               }
               
           } else {
               if (HyNetworkManager.network.networkStatus == HyNetworStatusReachableViaWWAN ||
                   HyNetworkManager.network.networkStatus == HyNetworStatusReachbleViaWiFi) {
                   [self.reConnectObject reConnect];
               }
           }
       });
}

- (void)disConnect {
    
    [self.heartBeatObject stop];
    [self.reConnectObject resetReConnectCount];
    
    if (!self.isConnected) { return;}
    int result = close(self.cSocket);
    if (result != -1) { self.connected = NO;}
}

- (void)sendMessage:(NSObject<HySocketMessageProtocol> *)message {
    
    if (!message.content || !self.isConnected) { return; }
    
    message.sourceID = self.ID;
    NSString *messageJson = message.hy_modelToJSONString;
    const char *messageChar = messageJson.UTF8String;
    send(self.cSocket, messageChar, strlen(messageChar), 0);
}

- (void)recvMessageWithHandler:(void (^)(id<HySocketMessageProtocol> _Nonnull))handler {
    self.recvMessageHandler = [handler copy];
}

#pragma mark — getters and setters
- (id<HySocketHeartBeatProtocol>)heartBeatObject {
    if (!_heartBeatObject){
        _heartBeatObject = [[HySocketHeartBeat alloc] init];
        __weak typeof(self) _self = self;
        [_heartBeatObject performBlock:^{
            __strong typeof(_self) self = _self;
            id<HySocketMessageProtocol> message = HySocketMessage.message(@"heartBeat", nil, 0);
            message.sourceID = self.ID;
            [self sendMessage:message];
        }];
    }
    return _heartBeatObject;
}

- (id<HySocketReConnectProtocol>)reConnectObject {
    if (!_reConnectObject){
        _reConnectObject = [[HySocketReConnect alloc] init];
        __weak typeof(self) _self = self;
        [_reConnectObject reConnectBlock:^{
            __strong typeof(_self) self = _self;
            close(self.cSocket);
            [self autoConnectWithCompletion:nil];
        } countOutBlock:^{
            __strong typeof(_self) self = _self;
            close(self.cSocket);
        }];
    }
    return _reConnectObject;
}

- (id<HySocketConnectProtocol>)connectObject {
    if (!_connectObject){
        _connectObject = [[HySocketConnect alloc] init];
        __weak typeof(self) _self = self;
        [_connectObject connectBlock:^{
            __strong typeof(_self) self = _self;
            if (!self.isConnected) {
                [self.reConnectObject reConnect];
            }
        } disConnectBlock:^{
            __strong typeof(_self) self = _self;
            if (self.isConnected) {
               [self disConnect];
            }
        }];
    }
    return _connectObject;
}

@end
