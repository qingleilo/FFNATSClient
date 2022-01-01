//
//  FFNatsSubject.h
//  WebSocketApp
//
//  Created by Roben on 2021/12/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FFNatsSubject : NSObject

/// 唯一标识
@property(nonatomic,copy)NSString *Id;
@property(nonatomic,copy)NSString *subject;
@property(nonatomic,copy)NSString *queue;
@property(nonatomic,copy)NSString *descriptionString;

- (instancetype)initWithSubject:(NSString *)subject;
- (instancetype)initWithSubject:(NSString *)subject
                             Id:(NSString *)Id;

@end

NS_ASSUME_NONNULL_END


