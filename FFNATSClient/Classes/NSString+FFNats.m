//
//  NSString+FFNats.m
//  WebSocketApp
//
//  Created by Roben on 2022/1/1.
//

#import "NSString+FFNats.h"

@implementation NSString (FFNats)

+(NSString *)ff_hashString
{
    NSString *uuid = [NSString ff_uuid];
    return [uuid substringToIndex:8];
}

+(NSString *)ff_uuid
{
    return [NSUUID.UUID.UUIDString stringByTrimmingCharactersInSet: NSCharacterSet.punctuationCharacterSet];
}

-(NSString *)ff_removePrefix:(NSString *)prefix
{
    if ([self hasPrefix:prefix]) {
        return [self substringFromIndex:prefix.length];
    }
    return self;
}

-(NatsOperation)ff_getMessageType
{
    
    if (self.length <= 2) return nil;
    NSString *firstCharacter = [self substringToIndex:1].uppercaseString;
    BOOL(^isOperation)(NatsOperation no) = ^(NatsOperation no){
        NSUInteger l = no.length;
        if (self.length <= 1) return NO;
        NSString *operation = [self substringToIndex:l].uppercaseString;
        if (![operation isEqualToString:no]) return NO;
        return YES;
    };
    if ([firstCharacter isEqualToString:@"C"]) {
        if (isOperation(NatsOperationConnect)) { return NatsOperationConnect; }
        return nil;
    }else if ([firstCharacter isEqualToString:@"S"]){
        if (isOperation(NatsOperationSubscribe)) { return NatsOperationSubscribe; }
        return nil;
    }else if ([firstCharacter isEqualToString:@"U"]){
        if (isOperation(NatsOperationUnsubscribe)) { return NatsOperationUnsubscribe; }
        return nil;
    }else if ([firstCharacter isEqualToString:@"M"]){
        if (isOperation(NatsOperationMessage)) { return NatsOperationMessage; }
        return nil;
    }else if ([firstCharacter isEqualToString:@"I"]){
        if (isOperation(NatsOperationInfo)) { return NatsOperationInfo; }
        return nil;
    }else if ([firstCharacter isEqualToString:@"+"]){
        if (isOperation(NatsOperationOk)) { return NatsOperationOk; }
        return nil;
    }else if ([firstCharacter isEqualToString:@"-"]){
        if (isOperation(NatsOperationError)) { return NatsOperationError; }
        return nil;
    }else if ([firstCharacter isEqualToString:@"P"]){
        if (isOperation(NatsOperationPing)) { return NatsOperationPing; }
        if (isOperation(NatsOperationPong)) { return NatsOperationPong; }
        if (isOperation(NatsOperationPublish)) { return NatsOperationPublish; }
        return nil;
    }else{
        return nil;
    }
    
}

-(NSArray *)ff_parseOutMessages
{
    
    NSMutableArray<NSString *> *messages = [NSMutableArray array];
    NSArray *lines = [self componentsSeparatedByString:@"\n"];
    BOOL isMessageFlag = NO;
    NSString *lastLine = @"";
    for (NSString *line in lines) {
        if (isMessageFlag) {
            [messages addObject:[NSString stringWithFormat:@"%@%@",lastLine,line]];
            isMessageFlag = NO;
            continue;
        }
        lastLine = line;
        NatsOperation type = [line ff_getMessageType];
        if (type == nil) {continue;};
        if ([type isEqualToString:NatsOperationMessage]) {
            isMessageFlag = YES;
        } else {
            [messages addObject:line];
        }
       
    }
    NSLog(@"----\n%@",messages);
    return messages;

}

@end
