//
//  NSString+FFNats.h
//  WebSocketApp
//
//  Created by Roben on 2022/1/1.
//

#import <Foundation/Foundation.h>
#import "FFNATSMacro.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSString (FFNats)
+(NSString *)ff_hashString;
+(NSString *)ff_uuid;
-(NSString *)ff_removePrefix:(NSString *)prefix;
-(NatsOperation)ff_getMessageType;
-(NSArray<NSString *> *)ff_parseOutMessages;
@end

NS_ASSUME_NONNULL_END
