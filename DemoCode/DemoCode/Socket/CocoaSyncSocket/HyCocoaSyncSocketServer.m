//
//  HyCocoaSyncSocketServer.m
//  DemoCode
//
//  Created by Hy on 2017/12/27.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyCocoaSyncSocketServer.h"
#import "HyServerClientSocketObject.h"
#import "GCDAsyncSocket.h"
#import "HySocketMessage.h"
#import <MJExtension/MJExtension.h>
#import "HySocketHeartBeat.h"
#import "HySocketConnect.h"
#import "HyNetworkManager.h"


@interface HyCocoaSyncSocketServer () <GCDAsyncSocketDelegate>
@property (nonatomic,copy) NSString *ip;
@property (nonatomic,copy) NSString *port;
@property (nonatomic,strong) GCDAsyncSocket *gcdSocket;
@property (nonatomic,copy) void(^acceptHandler)(id);
@property (nonatomic,strong) id<HySocketConnectProtocol> connectObject;
@property (nonatomic,strong) id<HySocketHeartBeatProtocol> heartBeatObject;
@property (nonatomic,copy) void(^recvClientMessageHandler)(id<HySocketMessageProtocol>, id socket);
@property (nonatomic,strong) NSMutableArray<id<HyServerClientSocketProtocol>> *clientSocketObjects;
@end


@implementation HyCocoaSyncSocketServer

+ (instancetype (^)(NSString *ip, NSString *port))socket {
    return ^(NSString *ip, NSString *port){
        HyCocoaSyncSocketServer *instance = [[self alloc] init];
        instance.ip = ip;
        instance.port = port;
        instance.gcdSocket = [[GCDAsyncSocket alloc] initWithDelegate:instance delegateQueue:dispatch_get_main_queue()];
        return  instance;
    };
}

- (void)bindAndListenWithCompletion:(void(^_Nullable)(BOOL success))completion {
    [self.heartBeatObject stop];
    [self.heartBeatObject start];
    [self connectObject];
    
    NSError *error;
    BOOL success = [self.gcdSocket acceptOnInterface:self.ip port:[self.port intValue]  error:&error];
    !completion ?: completion(success);
}

- (void)acceptWithHandler:(void(^_Nullable)(id socket))hander {
    self.acceptHandler = [hander copy];
}

- (void)recvClientMessageWithHandler:(void(^_Nullable)(id<HySocketMessageProtocol>, id socket))handler {
    self.recvClientMessageHandler = [handler copy];
}

- (void)sendMessage:(NSObject<HySocketMessageProtocol> *)message {
    
    if (!message.content ||  !message.targetID) { return; }
    
    NSString *messageJson = message.mj_JSONString;
    NSData  *messageData = [messageJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *targetID = message.targetID;
    [self.clientSocketObjects enumerateObjectsUsingBlock:^(id<HyServerClientSocketProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([targetID isEqualToString:@"all"] || [targetID isEqualToString:obj.ID]) {
            [obj.clientSocket writeData:messageData withTimeout:-1 tag:0];
            if (![targetID isEqualToString:@"all"]) {
                *stop = YES;
            }
        }
    }];
}

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    
    NSLog(@"收到newSocket：%@",newSocket);
    
    !self.acceptHandler ?: self.acceptHandler(newSocket);
    
    HyServerClientSocketObject *object = [[HyServerClientSocketObject alloc]init];
    object.clientSocket = newSocket;
    object.updateTime = [NSDate date];
    [self.clientSocketObjects addObject:object];

    [newSocket readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag  {
    
    id<HyServerClientSocketProtocol> clientSocketObject = [self getClientBysocket:sock];
    
    if (!clientSocketObject) {
        [sock readDataWithTimeout:-1 tag:0];
        return;
    }
    
    NSDictionary *dict =
    [NSJSONSerialization JSONObjectWithData:data
                                    options:NSJSONReadingMutableContainers
                                      error:nil];

    id<HySocketMessageProtocol> message  = [HySocketMessage mj_objectWithKeyValues:dict];
    clientSocketObject.ID = message.sourceID;
    if (![self.clientSocketObjects containsObject:clientSocketObject]) {
        [self.clientSocketObjects addObject:clientSocketObject];
    }
    !self.recvClientMessageHandler ?: self.recvClientMessageHandler(message, sock);
    
    NSLog(@"服务器收到消息：%@", dict);
    
    if (![message.content isEqualToString:@"heartBeat"]) {
        NSString *targetID = message.targetID;
        [self.clientSocketObjects enumerateObjectsUsingBlock:^(id<HyServerClientSocketProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([targetID isEqualToString:@"all"] || [targetID isEqualToString:obj.ID]) {
                [obj.clientSocket writeData:data withTimeout:-1 tag:0];
            }
        }];
    }
   
    [sock readDataWithTimeout:-1 tag:0];
}

- (id<HyServerClientSocketProtocol> )getClientBysocket:(GCDAsyncSocket *)socket{
    for (id<HyServerClientSocketProtocol> object in self.clientSocketObjects) {
        if ([socket isEqual:object.clientSocket]) {
            object.updateTime = [NSDate date];
            return object;
        }
    }
    return nil;
}

- (NSMutableArray<id<HyServerClientSocketProtocol>> *)clientSocketObjects {
    if (!_clientSocketObjects){
        _clientSocketObjects = @[].mutableCopy;
    }
    return _clientSocketObjects;
}

- (id<HySocketHeartBeatProtocol>)heartBeatObject {
    if (!_heartBeatObject){
        _heartBeatObject = [[HySocketHeartBeat alloc] init];
        __weak typeof(self) _self = self;
        [_heartBeatObject performBlock:^{
            __strong typeof(_self) self = _self;
            NSDate *date = [NSDate date];
            NSMutableArray<id<HyServerClientSocketProtocol>> *mArray = @[].mutableCopy;
            [self.clientSocketObjects enumerateObjectsUsingBlock:^(id<HyServerClientSocketProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([date timeIntervalSinceDate:obj.updateTime] > 3 * 60) {
                   [obj.clientSocket disconnect];
                } else {
                    [mArray addObject:obj];
                }
            }];
            self.clientSocketObjects = mArray;
        }];
    }
    return _heartBeatObject;
}

- (id<HySocketConnectProtocol>)connectObject {
    if (!_connectObject){
        _connectObject = [[HySocketConnect alloc] init];
        __weak typeof(self) _self = self;
        [_connectObject connectBlock:^{
            __strong typeof(_self) self = _self;
            [self bindAndListenWithCompletion:nil];
        } disConnectBlock:^{

        }];
    }
    return _connectObject;
}
@end

