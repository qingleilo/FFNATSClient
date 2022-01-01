//
//  FFNatsClient.h
//  WebSocketApp
//
//  Created by Roben on 2021/12/16.
//

#import <Foundation/Foundation.h>
#import <SocketRocket/SocketRocket.h>
#import "FFNATSMacro.h"
@class FFNatsSubject;
NS_ASSUME_NONNULL_BEGIN

extern NSString * const kNatsDidOpenNotificationKey;
extern NSString * const kNatsDidCloseNotificationKey;
extern NSString * const kNatsDidReceiveMessageNotificationKey;

@interface FFNatsClient : NSObject
/** 获取连接状态 */
@property(nonatomic,assign,readonly)SRReadyState socketReadyState;

@property(nonatomic,copy)void(^statusHandle)(NatsStatus status);

+(instancetype)sharedClient;

/// 链接
/// @param urlString url全地址
-(void)connect:(NSString *)urlString;

/// 断开链接
-(void)disconnect;

-(void)reconnect;

/// 订阅
/// @param subject subject description
-(FFNatsSubject *)subscribe:(NSString *)subject;

/// 订阅
/// @param nsubject nsubject
-(void)subscribeWithNatsSubject:(FFNatsSubject *)nsubject;

/// 取消订阅
/// @param nsubject 取消订阅的主题模型
-(void)unsubscribe:(FFNatsSubject *)nsubject;

/// 发送消息
/// @param payload 内容
/// @param nsub 主题模型
-(void)publish:(NSString *)payload
            to:(FFNatsSubject *)nsub;
@end

NS_ASSUME_NONNULL_END

