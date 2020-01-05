//
//  HySRWebSocketFactory.m
//  DemoCode
//
//  Created by Hy on 2017/1/3.
//  Copyright © 2017 Hy. All rights reserved.
//

#import "HySRWebSocketFactory.h"
#import "HySRWebSocketClient.h"
#import "HySRWebSocketServer.h"


@interface HySRWebSocketFactory ()
@property (nonatomic,copy) NSString *ip;
@property (nonatomic,copy) NSString *port;
@property (nonatomic,strong) id<HySocketClientProtocol> cSocket;
@property (nonatomic,strong) id<HySocketServerProtocol> sSocket;
@property (nonatomic,strong) NSMutableDictionary<NSString *, id<HySocketClientProtocol>> *clientSocketDic;
@end


@implementation HySRWebSocketFactory

+ (instancetype (^)(NSString *ip, NSString *port))socketFactory {
    return ^(NSString *ip, NSString *port){
        HySRWebSocketFactory *factory = [[self alloc] init];
        factory.ip = ip;
        factory.port = port;
        return factory;
    };
}

- (id<HySocketClientProtocol>(^)(NSString *ID))client {
    return ^ id<HySocketClientProtocol>(NSString *ID){
        
        if (!ID.length) { return nil;}
        
        id<HySocketClientProtocol> socket = [self.clientSocketDic objectForKey:ID];
        if (!socket) {
            socket = HySRWebSocketClient.socket(self.ip, self.port);
            socket.ID = ID;
            [self.clientSocketDic setObject:socket forKey:ID];
        }
        return socket;
    };
}

- (id<HySocketServerProtocol>)server {
    return nil;
//    if (!self.sSocket) {
//        self.sSocket = HySRWebSocketServer.socket(self.ip, self.port);
//    }
//    return self.sSocket;
}

- (NSMutableDictionary<NSString *,id<HySocketClientProtocol>> *)clientSocketDic {
    if (!_clientSocketDic){
        _clientSocketDic = @{}.mutableCopy;
    }
    return _clientSocketDic;
}


@end
