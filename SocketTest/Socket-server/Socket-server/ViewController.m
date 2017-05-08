//
//  ViewController.m
//  Socket-server
//
//  Created by Xue Yang on 2017/5/8.
//  Copyright © 2017年 Xue Yang. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"
@interface ViewController()<GCDAsyncSocketDelegate>
@property (weak) IBOutlet NSTextField *textfield;
@property (weak) IBOutlet NSTextField *message;
@property(nonatomic,strong)GCDAsyncSocket *socket;
@property(nonatomic,strong)GCDAsyncSocket *latestSocket;
@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    _socket.delegate = self;
     NSError *error = nil;
    //设置接受端口
    //本机的默认host为127.0.0.1
    [_socket acceptOnPort:8080 error:&error];
    if (error) {
        NSLog(@"error = %@",error);
    }
}
- (IBAction)send:(id)sender {
    if (_textfield.stringValue.length != 0) {
        [_latestSocket writeData:[_textfield.stringValue dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:100];
    }
}

//delegate
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    if (!_latestSocket) {
        _latestSocket = newSocket;
        NSLog(@"newSocket = %@",newSocket);
        
    }
    //设置从客户端接收信息的超时时间
    [_latestSocket readDataWithTimeout:-1 tag:100];
}
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"host = %@,port = %d",host,port);
}


- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"From-Client = %@",str);
    //设置从客户端接收信息的超时时间
    [_latestSocket readDataWithTimeout:-1 tag:100];
    _message.stringValue = str;
    
}
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"服务端发送消息成功");
}

@end
