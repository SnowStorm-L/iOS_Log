//
//  ViewController.m
//  Log
//
//  Created by L on 2018/8/31.
//  Copyright © 2018年 L. All rights reserved.
//

#import "ViewController.h"
//#import "HttpServerLogger.h"

// 导入即可使用, 把NSLog的内容通过udp socket发送出去
// 接收的服务端 请看 SocketServer 工程
//#import "SocketLog.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    [HttpServerLogger.shared startServer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"1111111");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
