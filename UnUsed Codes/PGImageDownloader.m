//
//  PGImageDownloader.m
//  Pingoo
//
//  Created by Steven Gao on 13-10-11.
//  Copyright (c) 2013年 Steven Gao. All rights reserved.
//

#import "PGImageDownloader.h"



@implementation PGImageDownloader

@synthesize connection =_connection;
@synthesize completionHandler = _completionHandler;
@synthesize imageUrl = _imageUrl;
@synthesize imageType = _imageType;

-(void)dealloc
{
    NSLog(@"PGImageDownloader dealloc");
    [_connection cancel];
}

-(void)addImageUrl:(NSString *)imageUrl completionHandler:(PGImageDownloaderHandler)handler
{
    _completionHandler = handler;
    _imageUrl = imageUrl;
}

-(void)start
{
    PGURLConnectionHandler handler = ^(PGURLConnection *connection,
                                       NSError*error,
                                       NSURLResponse *response,
                                       NSData *responseData){
        [self completeWithResponse:response data:responseData orError:error];
    };
    
    NSMutableURLRequest *request;
    
    NSURL *url = [NSURL URLWithString:self.imageUrl];
    request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    
    [request setHTTPMethod:@"GET"];
    
    PGURLConnection *connection = [[PGURLConnection alloc]initWithRequest:request completionHandler:handler];
    _connection = connection;
}



-(void)cancel
{
    [self.connection cancel];
    self.connection = nil;
}



-(void)completeWithResponse:(NSURLResponse*)response
                       data:(NSData*)data
                    orError:(NSError*)error
{
    NSInteger statusCode;
    if (response) {
        NSAssert([response isKindOfClass:[NSHTTPURLResponse class]], @"Expected NSHTTPURLResponse,get %@",response);
        statusCode = ((NSHTTPURLResponse*)response).statusCode;
        if (!error && ![response.MIMEType hasPrefix:@"image"]) {
            error = [self errorWithStatusCode:0 message:@"Response is a non-image MIME type;"];
        }
        
    }
    else {
       error = [self errorWithStatusCode:0 message:@"Response is empty"]; 
    }
    
    UIImage * image = nil;
    if (!error) {
        image = [[UIImage alloc]initWithData:data];
    }
    if (self.completionHandler) {
            self.completionHandler(self,image,error);
    }
    
}

-(NSError *)errorWithStatusCode:(NSInteger)statusCode
                   message:(NSString*)message
{
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];

    
    if (message) {
        userInfo[NSLocalizedDescriptionKey] = message;
    }
    
    NSError *error = [[NSError alloc]initWithDomain:@"PGImageDownloader" code:0 userInfo:userInfo];
    return error;
}


@end









