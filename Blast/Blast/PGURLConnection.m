//
//  PGURLConnection.m
//  Pingoo
//
//  Created by Steven Gao on 13-10-8.
//  Copyright (c) 2013年 Steven Gao. All rights reserved.
//

#import "PGURLConnection.h"
#import "PGError.h"

@interface PGURLConnection ()

@property (nonatomic,strong) NSURLConnection *connection;
@property (nonatomic,strong) NSMutableData *data;
@property (nonatomic,copy) PGURLConnectionHandler handler;
@property (nonatomic,strong) NSURLResponse *response;

-(void)invokeHander:(PGURLConnectionHandler)handler
              error:(NSError*) error
           response:(NSURLResponse *)response
       responseData:(NSData*)responseData;


@end



@implementation PGURLConnection

@synthesize  connection = _connection;
@synthesize  data = _data;
@synthesize  handler = _handler;
@synthesize  response = _response;


#pragma mark - Lifecycle

-(PGURLConnection *)initWithURL:(NSURL *)url
              completionHandler:(PGURLConnectionHandler)handler
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    return [self initWithRequest:request completionHandler:handler];
}

-(PGURLConnection *)initWithRequest:(NSURLRequest *)request
                  completionHandler:(PGURLConnectionHandler)handler
{
    if (self = [super init]) {
        
   // Add url cache
    _connection = [[NSURLConnection alloc]initWithRequest:request
                                                 delegate:self];
    
    _data = [[NSMutableData alloc] init];
    
    //should log message
    
    self.handler = handler;
    }
    return self;
}
-(void)dealloc
{
    NSLog(@"PGURLConnection dealloc");
}
-(void) invokeHander:(PGURLConnectionHandler)handler
               error:(NSError *)error
            response:(NSURLResponse *)response
        responseData:(NSData *)responseData
{
    if (handler != nil) {
        handler(self,error,response,responseData);
    }
}

-(void) cancel
{
    [self.connection cancel];
    if (self.handler == nil) {
        return;
    }
    
    NSError *error = [[NSError alloc]initWithDomain:PingooSDKDomain
                                               code:PGErrorOperationCalcelled
                                           userInfo:nil];
    
    @try {
        [self invokeHander:self.handler error:error response:nil responseData:nil];
    }

    @finally {
        return;
    }
}

-(void)connection:(NSURLConnection*)connection
didReceiveResponse:(NSURLResponse *)response
{
    self.response = response;
    [self.data setLength:0];
}

- (void)connection:(NSURLConnection*)connection
    didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

-(void)connection:(NSURLConnection*)connection
 didFailWithError:(NSError *)error
{
    @try {
        [self invokeHander:self.handler error:error response:nil responseData:nil];
    }
    @finally {
        self.handler = nil;
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //Cache this data
    
    @try {
        [self invokeHander:self.handler error:nil response:self.response responseData:self.data];
    }
    @finally {
        self.handler = nil;
    }
}


@end





























