//
//  FFNatsSubject.m
//  WebSocketApp
//
//  Created by Roben on 2021/12/16.
//

#import "FFNatsSubject.h"
#import "FFNATSMacro.h"
#import "NSString+FFNats.h"

@implementation FFNatsSubject

- (instancetype)initWithSubject:(NSString *)subject
{
    self = [super init];
    if (self) {
        _subject = subject;
        _Id = [NSString ff_hashString];
    }
    return self;
}

- (instancetype)initWithSubject:(NSString *)subject
                             Id:(NSString *)Id;
{
    self = [super init];
    if (self) {
        _subject = subject;
        _Id = Id;
    }
    return self;
}

@end
