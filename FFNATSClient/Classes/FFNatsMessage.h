//
//  FFNatsMessage.h
//  WebSocketApp
//
//  Created by Roben on 2021/12/16.
//

#import <Foundation/Foundation.h>
#import "FFNatsSubject.h"
NS_ASSUME_NONNULL_BEGIN

@interface FFNatsMessage : NSObject
/// message body
@property(nonatomic,copy)NSString *payload;

@property(nonatomic,assign)uint32_t byteCount;

@property(nonatomic,strong)FFNatsSubject *subject;
/// 没用到
@property(nonatomic,strong)FFNatsSubject *replySubject;
/// 暂时无用
@property(nonatomic,copy)NSString *mid;

- (instancetype)initWithPayload:(NSString *)payload
                           nsub:(FFNatsSubject *)nsub;

+(NSString *)ping;
+(NSString *)pong;

/// 获取订阅消息json
/// @param subject 订阅的主题
/// @param sid  订阅主题唯一标识（本地）
+(NSString *)subscribe:(NSString *)subject
                   sid:(NSString *)sid;

+(NSString *)unsubscribe:(NSString *)sid;


/// 发布
/// @param payload 内容/json string
/// @param subject 主题
+(NSString *)publish:(NSString *)payload
             subject:(NSString *)subject;

/// receive NATS josn message
/// @param message message description
+(FFNatsMessage *)parse:(NSString *)message;

@end

NS_ASSUME_NONNULL_END

