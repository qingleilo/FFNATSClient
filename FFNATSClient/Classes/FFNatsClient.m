//
//  FFNatsClient.m
//  WebSocketApp
//
//  Created by Roben on 2021/12/16.
//

#import "FFNatsClient.h"
#import "FFNatsMessage.h"
#import "NSString+FFNats.h"

NSString * const kNatsDidOpenNotificationKey           = @"kNatsDidOpenNotificationKey";
NSString * const kNatsDidCloseNotificationKey          = @"kNatsDidCloseNotificationKey";
NSString * const kNatsDidReceiveMessageNotificationKey = @"kNatsDidReceiveMessageNotificationKey";

@interface FFNatsClient()<SRWebSocketDelegate>
@property(nonatomic,strong)SRWebSocket *socket;
@property(nonatomic,copy)NSString *urlString;
@end

@implementation FFNatsClient{
    NSTimeInterval reconnectTime;
}

+ (instancetype)sharedClient{
    static FFNatsClient *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[FFNatsClient alloc] init];
    });
    return _manager;
}

-(void)connect:(NSString *)urlString{
    //如果是同一个url return
    if (self.socket) return;
    if (!urlString) return;
    self.urlString = urlString;
    self.socket = [[SRWebSocket alloc] initWithURLRequest:
                   [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
    NSLog(@"请求的websocket地址：%@",self.socket.url.absoluteString);
    //SRWebSocketDelegate 协议
    self.socket.delegate = self;
    //开始连接
    [self.socket open];
}

-(void)disconnect{
    if (self.socket){
        [self.socket close];
        self.socket = nil;
//        self.urlString = nil;
    }
    [self.socket close];
}

-(FFNatsSubject *)subscribe:(NSString *)subject
{
    FFNatsSubject *nsub = [[FFNatsSubject alloc] initWithSubject:subject];
    [self subscribeWithNatsSubject:nsub];
    return nsub;
}

-(void)subscribeWithNatsSubject:(FFNatsSubject *)nsub
{
    NSString *msg = [FFNatsMessage subscribe:nsub.subject sid:nsub.Id];
    [self sendMessage: msg];
}

-(void)unsubscribe:(FFNatsSubject *)nsub
{
    NSString *msg = [FFNatsMessage unsubscribe:nsub.Id];
    [self sendMessage: msg];
}

-(void)publish:(NSString *)payload
            to:(FFNatsSubject *)nsub
{
    NSString *msg = [FFNatsMessage publish:payload subject:nsub.subject];
    [self sendMessage:msg];
}

-(void)sendMessage:(NSString *)str
{
    NSError *error;
    [self.socket sendString:str error:&error];
}

#pragma mark - 处理接收到的数据
-(void)channelReadComplete:(NSString *)msg
{
 
    NSArray *messages = [msg ff_parseOutMessages];
    for (NSString *message in messages) {
        NatsOperation type = [message ff_getMessageType];
        if (type == nil) return;
        if ([type isEqualToString:NatsOperationPing]) {
            NSLog(@"####接收到ping");
            [self sendMessage:[FFNatsMessage pong]];
        }else if ([type isEqualToString:NatsOperationOk]){
            NSLog(@"####接收到ok");
        }else if ([type isEqualToString:NatsOperationError]){
            NSLog(@"####接收到error");
            //TODO:这个时候已断开连接
        }else if ([type isEqualToString:NatsOperationMessage]){
            NSLog(@"####接收到msg");
            [self handleIncomingMessage:message];
        }else if ([type isEqualToString:NatsOperationInfo]){
            NSLog(@"####接收到info");
        }else{
            NSLog(@"####接收到other");
        }
    }
    
}


//处理收到的msg
-(void)handleIncomingMessage:(NSString *)msg
{
    FFNatsMessage *message = [FFNatsMessage parse:msg];
    NSLog(@"####接收到msg\n%@",message.payload);
    [[NSNotificationCenter defaultCenter] postNotificationName:kNatsDidReceiveMessageNotificationKey object:message];
}

-(void)reconnect
{
    [self disconnect];
    //超过一分钟就不再重连 所以只会重连5次 2^5 = 64
    if (reconnectTime > 64) {
        //您的网络状况不是很好，请检查网络后重试
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(reconnectTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.socket = nil;
        [self connect:self.urlString];
        NSLog(@"重连");
    });
    
    //重连时间2的指数级增长
    if (reconnectTime == 0) {
        reconnectTime = 2;
    } else {
        reconnectTime *= 2;
    }
}


#pragma mark - SRWebSocket
-(SRReadyState)socketReadyState
{
    return self.socket.readyState;
}

#pragma mark - SRWebSocketDelegate
/**
 Called when a frame was received from a web socket.

 @param webSocket An instance of `SRWebSocket` that received a message.
 @param string    Received text in a form of UTF-8 `String`.
 */
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessageWithString:(NSString *)string{
    if (webSocket == self.socket) {
        NSLog(@"-------\n%@",string);
        [self channelReadComplete:string];
    }
}

#pragma mark Status & Connection

/**
 Called when a given web socket was open and authenticated.

 @param webSocket An instance of `SRWebSocket` that was open.
 */
- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    reconnectTime = 0;
    if (webSocket == self.socket) {
        NSLog(@"************************** socket 连接成功************************** ");
        !self.statusHandle?:self.statusHandle(NatsStatusConnected);
        [[NSNotificationCenter defaultCenter] postNotificationName:kNatsDidOpenNotificationKey object:nil];
    }
}

/**
 Called when a given web socket encountered an error.

 @param webSocket An instance of `SRWebSocket` that failed with an error.
 @param error     An instance of `NSError`.
 */
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"%s",__func__);
    if (webSocket == self.socket) {
        NSLog(@"************************** socket 连接失败************************** ");
        !self.statusHandle?:self.statusHandle(NatsStatusError);
        _socket = nil;
        //连接失败就重连
        [self reconnect];
    }
}

/**
 Called when a given web socket was closed.

 @param webSocket An instance of `SRWebSocket` that was closed.
 @param code      Code reported by the server.
 @param reason    Reason in a form of a String that was reported by the server or `nil`.
 @param wasClean  Boolean value indicating whether a socket was closed in a clean state.
 */
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(nullable NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"%s",__func__);
    if (webSocket == self.socket) {
        NSLog(@"************************** socket连接断开************************** ");
        NSLog(@"被关闭连接，code:%ld,reason:%@,wasClean:%d",(long)code,reason,wasClean);
        [self disconnect];
        !self.statusHandle?:self.statusHandle(NatsStatusDisconnected);
        [[NSNotificationCenter defaultCenter] postNotificationName:kNatsDidCloseNotificationKey object:nil];
    }
}

@end



