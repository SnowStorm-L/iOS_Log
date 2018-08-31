//
//  SystemLog.h
//  Log
//
//  Created by L on 2018/8/31.
//  Copyright © 2018年 L. All rights reserved.
//

#import <Foundation/Foundation.h>

// 参考链接 https://github.com/yohunl/TestLog

// 上面链接说 -> "NSLog默认的输出到了系统的 /var/log/syslog这个文件中,当然了,如果你的机器没有越狱,你是查看不了这个文件的"
// "在iOS真机设备上,使用ASL记录的log被缓存在一个文件中,直到设备被重启."

// 应该是用cydia安装了syslogd to /var/log/syslog 工具
// syslog把系统日志写入到/var/log/syslog文件里 然后才能看到

// 我找了台越狱的 iOS 9.3.5的iPad, 但是并没有验证他这个说法(NSLog的信息会缓存?)

// iOS 10 之前的NSLog (iOS 10 or 之后, ASL被弃用了)

// NSLog的描述

// Logs an error message to the Apple System Log facility.
// 将错误消息记录到Apple系统日志工具。
// Simply calls NSLogv, passing it a variable number of arguments.
// 只需调用NSLogv，向其传递可变数量的参数。

// Apple System Log(简称ASL, 苹果自己实现的输出日志的一套接口的API.)
// NSLog打印的消息会发送到手机的日志中

// 在终端使用brew安装 libimobiledevice 工具 连接手机 touchesBegan方法里面 NSLog XXX
// 终端使用命令 idevicesyslog 就可以看到  NSLog 在手机的运行信息中体现 (看图NSLog_In_iPhone.jpg)

#import <asl.h>

@interface SystemLogMessage: NSObject

+ (instancetype)logMessageFromASLMessage:(aslmsg)aslMessage;

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@property (nonatomic, copy) NSString *sender;
@property (nonatomic, copy) NSString *messageText;
@property (nonatomic, assign) long long messageID;

@end

@interface SystemLog : NSObject

@property NSString *path;

- (void)logRedirect;

- (void)recoverRedirect;

+ (NSArray<SystemLogMessage *> *)allLogAfterTime:(double)time;

+ (NSMutableArray<SystemLogMessage *> *)allLogMessagesForCurrentProcess;

@end
