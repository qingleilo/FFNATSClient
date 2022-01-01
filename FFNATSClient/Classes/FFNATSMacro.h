//
//  FFNATSMacro.h
//  WebSocketApp
//
//  Created by Roben on 2021/12/16.
//

#import <UIKit/UIKit.h>

//typedef NS_ENUM(NSUInteger, NatsEvent) {
//    NatsEventConnected,
//    NatsEventDisconnected,
//    NatsEventResponse,
//    NatsEventError,
//    NatsEventDropped,
//    NatsEventReconnecting,
//    NatsEventInformed,
//};

typedef NS_ENUM(NSUInteger, NatsStatus) {
    NatsStatusConnected,
    NatsStatusError,
    NatsStatusDisconnected,
};

typedef NSString *NatsOperation NS_STRING_ENUM;
FOUNDATION_EXPORT NatsOperation const _Nullable NatsOperationConnect;
FOUNDATION_EXPORT NatsOperation const _Nullable NatsOperationSubscribe;
FOUNDATION_EXPORT NatsOperation const _Nullable NatsOperationUnsubscribe;
FOUNDATION_EXPORT NatsOperation const _Nullable NatsOperationPublish;
FOUNDATION_EXPORT NatsOperation const _Nullable NatsOperationMessage;
FOUNDATION_EXPORT NatsOperation const _Nullable NatsOperationInfo;
FOUNDATION_EXPORT NatsOperation const _Nullable NatsOperationOk;
FOUNDATION_EXPORT NatsOperation const _Nullable NatsOperationError;
FOUNDATION_EXPORT NatsOperation const _Nullable NatsOperationPing;
FOUNDATION_EXPORT NatsOperation const _Nullable NatsOperationPong;


@interface FFNATSMacro : NSObject

@end


