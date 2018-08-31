//
//  HttpServerLogger.h
//  Log
//
//  Created by L on 2018/8/31.
//  Copyright © 2018年 L. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpServerLogger : NSObject

+ (instancetype)shared;

- (void)startServer;

- (void)stopServer;

@end
