//
//  SystemLog.m
//  Log
//
//  Created by L on 2018/8/31.
//  Copyright © 2018年 L. All rights reserved.
//

#import "SystemLog.h"

@interface SystemLog() {
    int origin;
}

@end

@implementation SystemLog

#pragma mark - NSLog 重定向
// 参考链接有更多的重定向方法

// 在Objective-c开发程序的时候，有专门的日志操作类NSLog，它将指定的输出
// 输出到stderr(标准错误(STDERR_FILENO): 默认输出到终端窗口）
// 我们可以利用Xcode的日志输出窗口，那么既然是要记录到具体日志文件，我们就想输出日志写入到具体的日志文件即可。

// NSLog重定向 把stderr(默认输出到终端窗口)的路径改为本地文件路径
- (void)logRedirect {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName =[NSString stringWithFormat:@"%@.log",[NSDate date]];
    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    // 记录重定向之前的描述
    origin = dup(STDERR_FILENO);
    
    // 这句话已经重定向了,现在NSLog都输出到文件中去了,
    freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding],"a+", stderr);
}

// 恢复重定向
- (void)recoverRedirect {
    // 在ios上可用的方式,还是得借助dup和dup2
    // dup和dup2也是两个非常有用的调用，它们的作用都是用来复制一个文件的描述符。
    // 它们经常用来重定向进程的stdin、stdout和stderr。
    
    //恢复原来的
    dup2(origin, STDERR_FILENO);
}

#pragma mark - ASL 信息获取

+ (NSMutableArray<SystemLogMessage *> *)allLogMessagesForCurrentProcess {
    
    // 创建查询对象
    asl_object_t query = asl_new(ASL_TYPE_QUERY);
    
    // 获取进程标识符(只获取当前App的信息,  ASL不过滤的话获取到的就是手机的所有运行信息)
    NSString *pidString = @([NSProcessInfo processInfo].processIdentifier).stringValue;
    
    // 设置查询的过滤条件
    asl_set_query(query, ASL_KEY_PID, [pidString UTF8String], ASL_QUERY_OP_EQUAL);
    
    aslresponse response = asl_search(NULL, query);
    aslmsg aslMessage = NULL;
    
    NSMutableArray *logMessages = [NSMutableArray array];
    
    while ((aslMessage = asl_next(response))) {
        [logMessages addObject:[SystemLogMessage logMessageFromASLMessage:aslMessage]];
    }
    asl_release(response);
    
    return logMessages;
}


+ (NSArray<SystemLogMessage *> *)allLogAfterTime:(double)time {
    
    NSMutableArray<SystemLogMessage *>  *allMsg = [self allLogMessagesForCurrentProcess];
    
    NSArray *filteredLogMessages = [allMsg filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SystemLogMessage *logMessage, NSDictionary *bindings) {
        return logMessage.timeInterval > time;
    }]];
    
    return filteredLogMessages;
    
}

@end

@implementation SystemLogMessage

+ (instancetype)logMessageFromASLMessage:(aslmsg)aslMessage {
    
    SystemLogMessage *logMessage = [[SystemLogMessage alloc] init];
    
    const char *timestamp = asl_get(aslMessage, ASL_KEY_TIME);
    if (timestamp) {
        NSTimeInterval timeInterval = [@(timestamp) integerValue];
        const char *nanoseconds = asl_get(aslMessage, ASL_KEY_TIME_NSEC);
        if (nanoseconds) {
            timeInterval += [@(nanoseconds) doubleValue] / NSEC_PER_SEC;
        }
        logMessage.timeInterval = timeInterval;
        logMessage.date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    }
    
    const char *sender = asl_get(aslMessage, ASL_KEY_SENDER);
    if (sender) {
        logMessage.sender = @(sender);
    }
    
    const char *messageText = asl_get(aslMessage, ASL_KEY_MSG);
    if (messageText) {
        logMessage.messageText = @(messageText);
    }
    
    const char *messageID = asl_get(aslMessage, ASL_KEY_MSG_ID);
    if (messageID) {
        logMessage.messageID = [@(messageID) longLongValue];
    }
    
    return logMessage;
}

- (BOOL)isEqual:(id)object {
    return [object isKindOfClass:[SystemLogMessage class]] && self.messageID == [object messageID];
}

- (NSUInteger)hash {
    return (NSUInteger)self.messageID;
}

@end
