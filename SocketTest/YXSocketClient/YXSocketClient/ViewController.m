//
//  ViewController.m
//  YXSocketClient
//
//  Created by Xue Yang on 2017/5/8.
//  Copyright © 2017年 Xue Yang. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"
@interface ViewController ()<GCDAsyncSocketDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textfield;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property(nonatomic,strong)GCDAsyncSocket *socket;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

//发送
- (IBAction)send:(id)sender {
    if (_textfield.text.length != 0) {
        NSData *data = [_textfield.text dataUsingEncoding:NSUTF8StringEncoding];
        [_socket writeData:data withTimeout:-1 tag:100];
    }
    
}
//连接
- (IBAction)connect:(id)sender {
    NSError *error = nil;
    [_socket connectToHost:@"127.0.0.1" onPort:8080 error:&error];
    if (error) {
        NSLog(@"error = %@",error);
    }
}

//delegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"连接成功");
    [_socket readDataWithTimeout:-1 tag:100];
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"客户端发送消息成功");
    [_socket readDataWithTimeout:-1 tag:100];
}
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"断开连接");
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    _message.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
@end
