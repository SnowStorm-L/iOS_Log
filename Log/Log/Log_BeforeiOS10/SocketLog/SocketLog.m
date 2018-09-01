//
//  SocketLog.m
//  Log
//
//  Created by L on 2018/9/1.
//  Copyright © 2018年 L. All rights reserved.
//

#import "SocketLog.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <pthread.h>

static int sockfd;
static struct sockaddr_in toAddr;

static inline NSString* LogMessageString(NSString *string){
    
    return [NSString stringWithFormat:@"%@[5%d:5%d] %@"
            ,[[NSProcessInfo processInfo] processName]
            ,[[NSProcessInfo processInfo] processIdentifier]
            ,pthread_mach_thread_np(pthread_self())
            ,string];
}

static inline NSString* dateMessageString(NSString *string){
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"Y-M-d H:m:S.F"];
    NSString *date = [dateFormatter stringFromDate:[NSDate date]];
    
    return [NSString stringWithFormat:@"%@ %@",date ,string];
}

static inline void sendLog(NSString *message){
    if(sockfd > 0){
        size_t sendLen = 0;
        const char * pLog = [message UTF8String];
        size_t len = strlen(pLog);
        while (sendLen < len) {
            sendLen += sendto(sockfd,pLog+sendLen,len-sendLen,0,(struct sockaddr*)&toAddr,sizeof(toAddr));
        }
    }
}

#if defined(__cplusplus)||defined(c_plusplus)
extern "C"{
#endif
    
    void openlogv()
    {
        sockfd = socket(AF_INET,SOCK_DGRAM,IPPROTO_UDP);
        if(sockfd < 0)
            return ;
        
        memset(&toAddr,0,sizeof(toAddr));
        toAddr.sin_family = AF_INET;
        toAddr.sin_addr.s_addr=inet_addr(LOG_SERVER_IP);
        toAddr.sin_port = htons(LOG_SERVER_PORT);
    }
    
    void syslogv(NSString *format,...)
    {
        if(sockfd < 1){
            openlogv();
        }
        
        va_list arguments;
        va_start(arguments,format);
        NSString * fmtString = [[NSString alloc] initWithFormat: format arguments: arguments];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            NSString * message = LogMessageString(fmtString);
            sendLog(message);
            fprintf(stderr, "%s\n",dateMessageString(message).UTF8String);
        });
    }
    
    void closelogv()
    {
        close(sockfd);
        memset(&toAddr,0,sizeof(toAddr));
    }
    
#if defined(__cplusplus)||defined(c_plusplus)
}
#endif
