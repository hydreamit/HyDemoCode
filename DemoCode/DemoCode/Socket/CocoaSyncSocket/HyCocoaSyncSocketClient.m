//
//  HyCocoaSyncSocketClient.m
//  DemoCode
//
//  Created by Hy on 2017/12/27.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyCocoaSyncSocketClient.h"
#import "HySocketReConnect.h"
#import "HySocketMessage.h"
#import "HySocketHeartBeat.h"
#import "HyModelParser.h"
#import "GCDAsyncSocket.h"
#import "HySocketConnect.h"
#import "HyNetworkManager.h"


@interface HyCocoaSyncSocketClient () <GCDAsyncSocketDelegate>
@property (nonatomic,copy) NSString *ip;
@property (nonatomic,copy) NSString *port;
@property (nonatomic,strong) GCDAsyncSocket *gcdSocket;
@property (nonatomic,strong) id<HySocketConnectProtocol> connectObject;
@property (nonatomic,strong) id<HySocketHeartBeatProtocol> heartBeatObject;
@property (nonatomic,strong) id<HySocketReConnectProtocol> reConnectObject;
@property (nonatomic,copy) void(^recvMessageHandler)(id<HySocketMessageProtocol>);
@end


@implementation HyCocoaSyncSocketClient
@synthesize ID = _ID;

+ (instancetype (^)(NSString *ip, NSString *port))socket {
    return ^(NSString *ip, NSString *port){
        HyCocoaSyncSocketClient *instance = [[self alloc] init];
        instance.ip = ip;
        instance.port = port;
        return  instance;
    };
}

- (void)initSocket {
    self.gcdSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)connectWithCompletion:(void (^)(BOOL))completion {
    [self disConnect];
    [self initSocket];
    BOOL success = [self.gcdSocket connectToHost:self.ip onPort:[self.port intValue] error:nil];
    !completion ?: completion(success);
    [self connectObject];
}

- (void)disConnect {
    [self.heartBeatObject stop];
    [self.reConnectObject resetReConnectCount];
    [self clearSocket];
}

- (void)clearSocket {
    if (self.gcdSocket) {
        [self.gcdSocket disconnect];
        self.gcdSocket.delegate = nil;
        self.gcdSocket = nil;
    }
}

- (void)sendMessage:(NSObject<HySocketMessageProtocol> *)message {
    
    if (!message.content || !self.gcdSocket) { return; }
    
    message.sourceID = self.ID;
    NSString *messageJson = message.hy_modelToJSONString;
    NSData  *messageData = [messageJson dataUsingEncoding:NSUTF8StringEncoding];
    [self.gcdSocket writeData:messageData withTimeout:-1 tag:0];
}

- (void)recvMessageWithHandler:(void (^)(id<HySocketMessageProtocol> _Nonnull))handler {
    self.recvMessageHandler = [handler copy];
}

#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"连接成功,host:%@,port:%d",host,port);
    [self.gcdSocket readDataWithTimeout:-1 tag:0];
    [self.heartBeatObject start];
    [self.reConnectObject resetReConnectCount];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(nullable NSError *)err {
    NSLog(@"断开连接,host:%@,port:%d====%@",sock.localHost,sock.localPort,err);
    if (err) {
        if (HyNetworkManager.network.networkStatus == HyNetworStatusReachableViaWWAN ||
            HyNetworkManager.network.networkStatus == HyNetworStatusReachbleViaWiFi) {
            NSLog(@"其他原因关闭连接，开始重连...");
            [self.reConnectObject reConnect];
        }  else {
            NSLog(@"没网不重连");
            [self disConnect];
        }
    } else {
        NSLog(@"被用户关闭连接，不重连");
        [self disConnect];
    }
    
    [self.heartBeatObject stop];
}

- (void)socket:(GCDAsyncSocket*)sock didWriteDataWithTag:(long)tag {
    [self.gcdSocket readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {

    id message =
    [NSJSONSerialization JSONObjectWithData:data
                                    options:NSJSONReadingMutableContainers
                                      error:nil];
    
    if ([message isKindOfClass:NSDictionary.class]) {
       id<HySocketMessageProtocol> msg = [HySocketMessage hy_modelWithJSON:message];
        !self.recvMessageHandler ?: self.recvMessageHandler(msg);
    } else {
        !self.recvMessageHandler ?: self.recvMessageHandler(message);
    }

    NSLog(@"客户端%@收到消息:%@",self.ID, message);
    
    [self.gcdSocket readDataWithTimeout:-1 tag:0];
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
            [self clearSocket];
            [self initSocket];
            [self.gcdSocket connectToHost:self.ip onPort:[self.port intValue] error:nil];
        } countOutBlock:^{
            __strong typeof(_self) self = _self;
            [self clearSocket];
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
            if (!self.gcdSocket) {
                [self.reConnectObject reConnect];
            }
        } disConnectBlock:^{
            __strong typeof(_self) self = _self;
            if (self.gcdSocket) {
                [self disConnect];
            }
        }];
    }
    return _connectObject;
}

@end
