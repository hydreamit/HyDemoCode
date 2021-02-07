//
//  HySRWebSocketClient.m
//  DemoCode
//
//  Created by Hy on 2017/1/3.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HySRWebSocketClient.h"
#import "HySocketReConnect.h"
#import "HySocketMessage.h"
#import "HySocketHeartBeat.h"
#import "HyModelParser.h"
#import "SocketRocket.h"
#import "HySocketConnect.h"
#import "HyNetworkManager.h"


@interface HySRWebSocketClient ()<SRWebSocketDelegate>
@property (nonatomic,copy) NSString *ip;
@property (nonatomic,copy) NSString *port;
@property (nonatomic,strong) SRWebSocket *webSocket;
@property (nonatomic,strong) id<HySocketConnectProtocol> connectObject;
@property (nonatomic,strong) id<HySocketHeartBeatProtocol> heartBeatObject;
@property (nonatomic,strong) id<HySocketReConnectProtocol> reConnectObject;
@property (nonatomic,copy) void(^recvMessageHandler)(id<HySocketMessageProtocol>);
@end


@implementation HySRWebSocketClient
@synthesize ID = _ID;

+ (instancetype (^)(NSString *ip, NSString *port))socket {
    return ^(NSString *ip, NSString *port){
        HySRWebSocketClient *instance = [[self alloc] init];
        instance.ip = ip;
        instance.port = port;
        return  instance;
    };
}

- (void)initSocket {
    self.webSocket = [[SRWebSocket alloc]initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"ws://%@:%@", self.ip, self.port]]];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    queue.maxConcurrentOperationCount = 1;
    self.webSocket.delegate = self;
    [self.webSocket setDelegateOperationQueue:queue];
}

- (void)connectWithCompletion:(void (^)(BOOL))completion {
    [self disConnect];
    [self initSocket];
    [self.webSocket open];
    !completion ?: completion(YES);
    [self connectObject];
}

- (void)disConnect {
    [self.heartBeatObject stop];
    [self.reConnectObject resetReConnectCount];
    [self clearSocket];
}

- (void)clearSocket {
    if (self.webSocket) {
        [self.webSocket closeWithCode:1001 reason:@"用户主动断开"];
        self.webSocket.delegate = nil;
        self.webSocket = NULL;
    }
}

- (void)sendMessage:(NSObject<HySocketMessageProtocol> *)message {
    
    if (!message.content || !self.webSocket) { return; }
    
    message.sourceID = self.ID;
    NSString *messageJson = message.hy_modelToJSONString;
    NSData  *messageData = [messageJson dataUsingEncoding:NSUTF8StringEncoding];
    [self.webSocket send:messageData];
}

- (void)recvMessageWithHandler:(void (^)(id<HySocketMessageProtocol> _Nonnull))handler {
    self.recvMessageHandler = [handler copy];
}

#pragma mark - SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"open连接成功");
    [self.reConnectObject resetReConnectCount];
    [self.heartBeatObject start];
}

// open失败的时候调用
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"open连接失败.....\n%@",error);
    if (HyNetworkManager.network.networkStatus == HyNetworStatusReachableViaWWAN ||
        HyNetworkManager.network.networkStatus == HyNetworStatusReachbleViaWiFi) {
        [self.reConnectObject reConnect];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    id msg =
    [NSJSONSerialization JSONObjectWithData:message
                                    options:NSJSONReadingMutableContainers
                                      error:nil];
    
    if ([msg isKindOfClass:NSDictionary.class]) {
       id<HySocketMessageProtocol> msgResult = [HySocketMessage hy_modelWithJSON:msg];
        !self.recvMessageHandler ?: self.recvMessageHandler(msgResult);
    } else {
        !self.recvMessageHandler ?: self.recvMessageHandler(msg);
    }
    NSLog(@"客户端%@收到消息:%@",self.ID, msg);
}

//网络连接中断被调用
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {

    //如果是被用户自己中断的那么直接断开连接，否则开始重连
    if (code == 1001) {
        NSLog(@"被用户关闭连接，不重连");
        [self disConnect];
    }else{
        if (HyNetworkManager.network.networkStatus == HyNetworStatusReachableViaWWAN ||
            HyNetworkManager.network.networkStatus == HyNetworStatusReachbleViaWiFi) {
            NSLog(@"其他原因关闭连接，开始重连...");
            [self.reConnectObject reConnect];
        }
    }
    [self.heartBeatObject stop];
}

//sendPing的时候，如果网络通的话，则会收到回调，但是必须保证ScoketOpen，否则会crash
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
    NSLog(@"收到pong回调");
}

//将收到的消息，是否需要把data转换为NSString，每次收到消息都会被调用，默认YES
- (BOOL)webSocketShouldConvertTextFrameToString:(SRWebSocket *)webSocket {
    NSLog(@"webSocketShouldConvertTextFrameToString");
    return NO;
}

//pingPong
- (void)ping{
    if (self.webSocket) {
        [self.webSocket sendPing:nil];
    }
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
            [self.webSocket open];
        } countOutBlock:^{
            __strong typeof(_self) self = _self;
            if (self.webSocket) {
                [self clearSocket];
            }
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
            if (!self.webSocket) {
                [self.reConnectObject reConnect];
            }
        } disConnectBlock:^{
            __strong typeof(_self) self = _self;
            if (self.webSocket) {
                [self disConnect];
            }
        }];
    }
    return _connectObject;
}

@end
