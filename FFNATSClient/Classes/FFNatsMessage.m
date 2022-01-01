//
//  FFNatsMessage.m
//  WebSocketApp
//
//  Created by Roben on 2021/12/16.
//

#import "FFNatsMessage.h"
#import "FFNATSMacro.h"
#import "NSString+FFNats.h"

@implementation FFNatsMessage

- (instancetype)initWithPayload:(NSString *)payload
                           nsub:(FFNatsSubject *)nsub
{
    self = [super init];
    if (self) {
        _payload = payload;
        _subject = nsub;
        _mid = [NSString ff_hashString];
    }
    return self;
}


+(NSString *)publish:(NSString *)payload
             subject:(NSString *)subject
{
    //    guard let data = payload.data(using: String.Encoding.utf8) else { return "" }
    NSData *data = [payload dataUsingEncoding:NSUTF8StringEncoding];
    if (data == nil) return @"";
    return [NSString stringWithFormat:@"%@ %@ %ld \r\n%@\r\n",NatsOperationPublish,subject,data.length,payload];
//    return "\(NatsOperation.publish.rawValue) \(subject) \(data.count)\r\n\(payload)\r\n"
}

+(NSString *)subscribe:(NSString *)subject
                   sid:(NSString *)sid
{
    return [NSString stringWithFormat:@"%@ %@ %@ %@\r\n",NatsOperationSubscribe,subject,@"",sid];
//    return "\(NatsOperation.subscribe.rawValue) \(subject) \(queue) \(sid)\r\n"
}

+(NSString *)unsubscribe:(NSString *)sid
{
    return [NSString stringWithFormat:@"%@ %@\r\n",NatsOperationUnsubscribe,sid];
}

+(NSString *)pong
{
    return [NSString stringWithFormat:@"%@\r\n",NatsOperationPong];
}

+(NSString *)ping
{
    return [NSString stringWithFormat:@"%@\r\n",NatsOperationPing];
}

+(FFNatsMessage *)parse:(NSString *)message
{
    
    NSLog(@"Parsing message: %@",message);
    NSArray *components = [message componentsSeparatedByCharactersInSet:NSCharacterSet.newlineCharacterSet];

    if (components.count <= 0) { return nil ;}
    NSString *payload = components[1];
    NSArray *header = [[components[0] ff_removePrefix:NatsOperationMessage] componentsSeparatedByCharactersInSet:NSCharacterSet.whitespaceCharacterSet];

    if (header.count <= 0) return nil;
    NSString *subject;
    NSString *sid;
    uint32_t byteCount;
    NSString *replySubject;
    switch (header.count) {
        case 3:
            subject = header[0];
            sid = header[1];
            byteCount = [header[2] unsignedIntValue];
            replySubject = nil;
            break;
        case 4:
            subject = header[0];
            sid = header[1];
            byteCount = [header[3] unsignedIntValue];
            replySubject = nil;
            break;
        case 5:
            subject = header[1];
            sid = header[2];
            byteCount = [header[4] unsignedIntValue];
            replySubject = nil;
            break;
        default:
            break;
    }
    FFNatsSubject *nsub = [[FFNatsSubject alloc] initWithSubject:subject Id:sid];
    FFNatsMessage *natsMessage = [[FFNatsMessage alloc] initWithPayload:payload nsub:nsub];
    return natsMessage;
}
@end

/**
 internal static func publish(payload: String, subject: String) -> String {
     guard let data = payload.data(using: String.Encoding.utf8) else { return "" }
     return "\(NatsOperation.publish.rawValue) \(subject) \(data.count)\r\n\(payload)\r\n"
 }
 internal static func subscribe(subject: String, sid: String, queue: String = "") -> String {
     return "\(NatsOperation.subscribe.rawValue) \(subject) \(queue) \(sid)\r\n"
 }
 internal static func unsubscribe(sid: String) -> String {
     return "\(NatsOperation.unsubscribe.rawValue) \(sid)\r\n"
 }
 internal static func pong() -> String {
     return "\(NatsOperation.pong.rawValue)\r\n"
 }
 internal static func ping() -> String {
     return "\(NatsOperation.ping.rawValue)\r\n"
 }
 internal static func connect(config: [String:Any]) -> String {
     guard let data = try? JSONSerialization.data(withJSONObject: config, options: []) else { return "" }
     guard let payload = data.toString() else { return "" }
     return "\(NatsOperation.connect.rawValue) \(payload)\r\n"
 }
 
 internal static func parse(_ message: String) -> NatsMessage? {
     
     logger.debug("Parsing message: \(message)")
     
     let components = message.components(separatedBy: CharacterSet.newlines).filter { !$0.isEmpty }
     
     if components.count <= 0 { return nil }
     
     let payload = components[1]
     let header = components[0]
         .removePrefix(NatsOperation.message.rawValue)
         .components(separatedBy: CharacterSet.whitespaces)
         .filter { !$0.isEmpty }
     
     let subject: String
     let sid: String
     let byteCount: UInt32?
     let replySubject: String?
     
     switch (header.count) {
     case 3:
         subject = header[0]
         sid = header[1]
         byteCount = UInt32(header[2])
         replySubject = nil
         break
     case 4:
         subject = header[0]
         sid = header[1]
         replySubject = nil
         byteCount = UInt32(header[3])
         break
     default:
         return nil
     }
     
     return NatsMessage(
         payload: payload,
         byteCount: byteCount,
         subject: NatsSubject(subject: subject, id: sid),
         replySubject: replySubject == nil ? nil : NatsSubject(subject: replySubject!)
     )
     
 }
 */
