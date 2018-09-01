//
//  SocketServer.m
//  SocketServer
//
//  Created by L on 2018/9/1.
//  Copyright © 2018年 L. All rights reserved.
//

#import "SocketServer.h"

@interface SocketServer ()<GCDAsyncUdpSocketDelegate>

@property (strong, nonatomic) GCDAsyncUdpSocket *socket;

@end

@implementation SocketServer

- (void)start {
    
    GCDAsyncUdpSocket *serviceScoket = [[GCDAsyncUdpSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, 0)];
    
    NSError *error = nil;
    [serviceScoket bindToPort:5288 error:&error];

    if (error == nil) {
        NSLog(@"开启成功");
        NSLog(@"%@", [serviceScoket localHost]);
        // 开始接收消息
        [serviceScoket beginReceiving:&error];
    }
    else {
        NSLog(@"开启失败");
    }
    
    self.socket = serviceScoket;
}

-(void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    
    // 接收到Log数据
    NSLog(@"debug >>>> %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
}

@end
