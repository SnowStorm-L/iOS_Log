//
//  main.m
//  SocketServer
//
//  Created by L on 2018/9/1.
//  Copyright © 2018年 L. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketServer.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        NSLog(@"Hello, World!");
    
        SocketServer *socketServier = [[SocketServer alloc]init];
        
        [socketServier start];
        
        [[NSRunLoop mainRunLoop]run];//目的让服务器不停止
        
        
    }
    return 0;
}
