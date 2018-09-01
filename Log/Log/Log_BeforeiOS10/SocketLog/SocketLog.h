//
//  SocketLog.h
//  Log
//
//  Created by L on 2018/9/1.
//  Copyright © 2018年 L. All rights reserved.
//

#import <Foundation/Foundation.h>

#if defined(__cplusplus)||defined(c_plusplus)
extern "C"{
#endif
    
    void openlogv(void);
    void syslogv(NSString *format,...);
    void closelogv(void);
    
#if defined(__cplusplus)||defined(c_plusplus)
}
#endif

#define NSLog(fmt, args... ) syslogv(fmt, ##args)
#define LOG_SERVER_IP       "0.0.0.0"
#define LOG_SERVER_PORT     5288
