//
//  OSLogAPI.m
//  Log
//
//  Created by L on 2018/9/5.
//  Copyright © 2018年 L. All rights reserved.
//

#import "OSLogAPI.h"
#import <UIKit/UIKit.h>

#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)


@implementation OSLogAPI

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)demo {
    
    
    // 线程安全的单例对象
    
    os_log_t log = os_log_create("com.", "network");
    
    os_log(log, "viewDidLoad");
    
    
    "%{time_t}d";
    "%{errno}d";
    "%.*P";
    "%{uuid_t}.16P";
    
    "%{public}@";
    "%{privare}d"
    
    "%{public, uuid_t}.16P";
    
    os_log_t general_log = os_log_create("com.apple.logging.example", "general");
    os_log_t time_log = os_log_create("com.apple.logging.example", "timestamp");
    
    os_log(general_log, "running example code");
    
    char *fileName = "ViewController.m";
    
    os_log_info(general_log, "processing file %{public}s", fileName);
    
    int fd = open(fileName, O_RDONLY);
    
    if (fd < 0) {
        os_log_error(general_log, "can't open file %{public}s - %{errno}d", fileName, errno);
    }
    
    struct stat sb;
    
    if (fstat(fd, &sb) < 0) {
        os_log_fault(general_log, "Failed to fstat %{public}s - %{errno}d", fileName, errno);
    }
    
    
    os_activity_t init_activity = os_activity_create("Init", OS_ACTIVITY_CURRENT, OS_ACTIVITY_FLAG_DEFAULT);
    
    os_activity_t verify_activity = os_activity_create("Verify", init_activity, OS_ACTIVITY_FLAG_DEFAULT);
    
    BOOL isReady = TRUE;
    
    if (isReady) {
        os_activity_scope(verify_activity);
    }
    
    os_activity_apply(init_activity, ^{
        
    });
    
    // os_log 是记录日志信息的基本细节
    // os_log_info 去获取额外的即时信息
    // os_log_debug 处理开发工程大量调试工作
    // os_log_error 错误出现是,收集额外的信息
    // os_log_fault 故障信息
    
}

@end
