//
//  HyCFSocketServer.m
//  DemoCode
//
//  Created by Hy on 2017/12/26.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HyCFSocketServer.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import "HyServerClientSocketObject.h"
#import "HySocketMessage.h"
#import "HyModelParser.h"
#import "HySocketHeartBeat.h"


@interface HyCFSocketServer ()
@property (nonatomic,copy) NSString *ip;
@property (nonatomic,copy) NSString *port;
@property (nonatomic, assign) int sSocket;
@property (nonatomic,copy) void(^acceptHandler)(id);
@property (nonatomic,strong) id<HySocketHeartBeatProtocol> heartBeatObject;
@property (nonatomic,copy) void(^recvClientMessageHandler)(id<HySocketMessageProtocol>, id socket);
@property (nonatomic,strong) NSMutableArray<id<HyServerClientSocketProtocol>> *clientSocketObjects;
@end


@implementation HyCFSocketServer

+ (instancetype (^)(NSString *ip, NSString *port))socket {
    return ^(NSString *ip, NSString *port){
        HyCFSocketServer *instance = [[self alloc] init];
        instance.ip = ip;
        instance.port = port;
        int sSockets = socket(AF_INET, SOCK_STREAM, 0);
        instance.sSocket = sSockets;
        return sSockets == -1 ? nil : instance;
    };
}

- (void)bindAndListenWithCompletion:(void(^_Nullable)(BOOL success))completion {
    [self bindWithCompletion:^(BOOL success) {
        if (success) {
            [self listenWithCompletion:completion];
        } else {
            !completion ?: completion(NO);
        }
    }];
}

- (void)recvClientMessageWithHandler:(void(^_Nullable)(id<HySocketMessageProtocol>, id socket))handler {
    self.recvClientMessageHandler = [handler copy];
}

- (void)acceptWithHandler:(void(^_Nullable)(id socket))hander {
    self.acceptHandler = [hander copy];
}

- (void)bindWithCompletion:(void (^)(BOOL success))completion {

    struct sockaddr_in socketAddr;
    socketAddr.sin_family = AF_INET;
    socketAddr.sin_port   = htons([self.port integerValue]);

    struct in_addr socketIn_addr;
    socketIn_addr.s_addr  = inet_addr([self.ip UTF8String]);
    socketAddr.sin_addr     = socketIn_addr;
    
    bzero(&(socketAddr.sin_zero), 8);

    int bind_result = bind(self.sSocket, (const struct sockaddr *)&socketAddr, sizeof(socketAddr));
    
    !completion ?: completion(bind_result != -1);
}

- (void)listenWithCompletion:(void (^)(BOOL success))completion {
    
    int maxConnectCount = 100;
    int listen_result = listen(self.sSocket, maxConnectCount);
    BOOL success = listen_result != -1;
    !completion ?: completion(success);
    if (success) {
        [self accept];
        [self recv];
    }
}

- (void)accept {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (1) {
            
            struct sockaddr_in client_address;
            socklen_t address_len;
            int clientSocket = accept(self.sSocket, (struct sockaddr *)&client_address, &address_len);
                
            if (clientSocket != -1) {
                
                NSNumber *newSocket = [NSNumber numberWithInt:clientSocket];
                HyServerClientSocketObject *object = [[HyServerClientSocketObject alloc]init];
                object.clientSocket = newSocket;
                object.updateTime = [NSDate date];
                [self.clientSocketObjects addObject:object];
                !self.acceptHandler ?: self.acceptHandler(@(clientSocket));
                
                NSLog(@"收到newSocket：%@",newSocket);
            }
        }
    });
}

- (void)recv {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        while (1) {
            
            NSMutableArray<id<HyServerClientSocketProtocol>> *closeSockets = @[].mutableCopy;
            [self.clientSocketObjects enumerateObjectsUsingBlock:^(id<HyServerClientSocketProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                int clientSocket = [obj.clientSocket intValue];
                char buf[1024] = {0};
                long iReturn = recv(clientSocket, buf, 1024, 0);
                
                id<HyServerClientSocketProtocol> clientSocketObject = [self getClientBysocket:@(clientSocket)];
                
                if (iReturn > 0) {
                    
                    NSData *recvData  = [NSData dataWithBytes:buf length:iReturn];
                    NSDictionary *dict =
                    [NSJSONSerialization JSONObjectWithData:recvData
                                                    options:NSJSONReadingMutableContainers
                                                      error:nil];
                    NSObject<HySocketMessageProtocol> *message  = [HySocketMessage hy_modelWithJSON:dict];
                    const char *messageChar = message.hy_modelToJSONString.UTF8String;
                    
                    clientSocketObject.ID = message.sourceID;
                    if (![self.clientSocketObjects containsObject:clientSocketObject]) {
                        [self.clientSocketObjects addObject:clientSocketObject];
                    }
                    
                    NSLog(@"服务器收到消息：%@", dict);
                                        
                    if (![message.content isEqualToString:@"heartBeat"]) {
                        NSString *targetID = message.targetID;
                        [self.clientSocketObjects enumerateObjectsUsingBlock:^(id<HyServerClientSocketProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([targetID isEqualToString:@"all"] || [targetID isEqualToString:obj.ID]) {
                                send([obj.clientSocket intValue], messageChar, strlen(messageChar), 0);
                            }
                        }];
                    }
               
                    dispatch_async(dispatch_get_main_queue(), ^{
                        !self.recvClientMessageHandler ?: self.recvClientMessageHandler(message, @(clientSocket));
                    });
                    
                } else {
                    [closeSockets addObject:obj];
                }
            }];
            
            if (closeSockets.count) {
                [closeSockets enumerateObjectsUsingBlock:^(id<HyServerClientSocketProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self.clientSocketObjects removeObject:obj];
                }];
            }
        }
    });
}

- (void)sendMessage:(NSObject<HySocketMessageProtocol> *)message {
    
    if (!message.content ||  !message.targetID) { return; }
    
    NSString *messageJson = message.hy_modelToJSONString;
    const char *messageChar = messageJson.UTF8String;
    NSString *targetID = message.targetID;
    
    [self.clientSocketObjects enumerateObjectsUsingBlock:^(id<HyServerClientSocketProtocol>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([targetID isEqualToString:@"all"] || [targetID isEqualToString:obj.ID]) {
            send([obj.clientSocket intValue], messageChar, strlen(messageChar), 0);
            if (![targetID isEqualToString:@"all"]) {
                *stop = YES;
            }
        }
    }];
}

//- (void)closeWithCompletion:(void(^)(BOOL success))completion {
//
//    int result = close(self.sSocket);
//    BOOL success = result != -1;
//    !completion ?: completion(success);
//}

- (id<HyServerClientSocketProtocol>)getClientBysocket:(NSNumber *)socket{
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
                    close([obj.clientSocket intValue]);
                } else {
                    [mArray addObject:obj];
                }
            }];
            self.clientSocketObjects = mArray;
        }];
    }
    return _heartBeatObject;
}

@end
