//
//  PGRequestConnection.m
//  Pingoo
//
//  Created by Steven Gao on 13-10-8.
//  Copyright (c) 2013年 Steven Gao. All rights reserved.
//

#import "PGRequestConnection.h"
#import "PGError.h"
#import "PGURLConnection.h"
#import "PGRequest.h"
#import "PGUtility.h"

//URL construction constants
NSString *const kApiURLPrefix = @"http://";


static const NSTimeInterval kDefaultTimeout = 90.0;


typedef enum PGRequestConnectionState{
    kStateCreated,
    kStateSerialized,
    kStateStarted,
    kStateCompleted,
    kStateCancelled,
}PGRequestConnectionState;

@interface PGRequestConnection ()


@property (nonatomic ,strong) PGURLConnection *connection;
//@property (nonatomic,strong) NSMutableArray *requests;
@property (nonatomic) PGRequestConnectionState state;
@property (nonatomic) NSTimeInterval timeout;
@property (nonatomic,strong) NSMutableURLRequest *internalUrlRequest;
@property (nonatomic,strong) PGRequest *deprecatedRequest;
@property (nonatomic) unsigned long requestStartTime;

@end




@implementation PGRequestConnection

@synthesize completionHandler = _completionHandler;

-(NSMutableURLRequest*)urlRequest
{
    
    if (self.internalUrlRequest) {
        NSMutableURLRequest *request = self.internalUrlRequest;
        return request;
    } else {
        return [self requestWithSingleRequest:self.deprecatedRequest timeout:_timeout];
    }
}

-(void)setUrlRequest:(NSMutableURLRequest *)urlRequest
{
    NSAssert((self.state == kStateCreated)||(self.state == kStateSerialized), @"Cannot set urlRequest after starting or calcelling");
    self.state = kStateSerialized;
    self.internalUrlRequest = urlRequest;
}

#pragma mark - lifetime

-(id)init
{
    return [self initWithTimeout:kDefaultTimeout];
}

-(id)initWithTimeout:(NSTimeInterval)timeout
{
    if (self = [super init]) {
        _timeout = timeout;
        _state = kStateCreated;
        
    }
    return self;
}
-(void)dealloc
{
    NSLog(@"PGRequestConnection dealloc");
    [_connection cancel];
    
    
}
#pragma mark public methods

- (void)addRequest:(PGRequest *)request
 completionHandler:(PGRequestHandler)handler
{
    
    [self addRequest:request completionHandler:handler batchEntryName:nil];
}

-(void)addRequest:(PGRequest *)request completionHandler:(PGRequestHandler)handler batchEntryName:(NSString *)name
{
    
    _completionHandler = handler;
    _deprecatedRequest = request;
    
}
-(void)start
{
    [self startWithCacheIdentity:nil skipRoundtripIfCached:NO];
}

-(void)cancel
{
    self.state = kStateCancelled;
    [self.connection cancel];
    self.connection = nil;
}
#pragma mark -private methods

-(void)startWithCacheIdentity:(NSString*)cacheIdentity
        skipRoundtripIfCached:(BOOL)skipRoundtripCached
{
    
    
        NSMutableURLRequest *request = nil;
        
        if (!request) {
            request = self.urlRequest;
        }
        
        NSAssert((self.state == kStateCreated) || (self.state == kStateSerialized),
                 @"Cannot call start again after calling start or cancel.");
        
        self.state = kStateStarted;
        
        PGURLConnectionHandler handler = ^(PGURLConnection *connection,
                                           NSError *error,
                                           NSURLResponse *response,
                                           NSData *responseData){
            [self completeWithResponse:response data:responseData orError:error];
        };
        

        [self startURLConnectionWithRequest:request skipRoundTripIfCache:NO completionHandler:handler];
        
    
}

-(void)startURLConnectionWithRequest:(NSURLRequest*)request
                skipRoundTripIfCache:(BOOL)skipRoundTripIfCached
                   completionHandler:(PGURLConnectionHandler)handler
{
    PGURLConnection *connection = [[PGURLConnection alloc]initWithRequest:request completionHandler:handler];
    self.connection = connection;
    
}

//
// Generates a NSURLRequest based on the contents of self.requests, and sets
// options on the request. Chooses between URL-based request for a single request

-(NSMutableURLRequest *)requestWithSingleRequest:(PGRequest *)request
                                 timeout:(NSTimeInterval)timeout
{
    
    NSMutableURLRequest *result;

    NSURL *url = [NSURL URLWithString:[self urlStringForSingleRequest:request]];
        result = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:timeout];
        
    NSString *httpMethod = [request.httpMethod uppercaseString];
        [result setHTTPMethod:httpMethod];
    
    if (request.header) {
        for (NSString *field in request.header.allKeys) {
            [result setValue:request.header[field] forHTTPHeaderField:field];
        }
    }
    
    if (request.body) {
        [result setHTTPBody:request.body];
        
    }
    
    return result;
}


- (NSString *)urlStringForSingleRequest:(PGRequest *)request
{
    
    NSString *baseURL = nil;
    baseURL = [[PGUtility buildPingooUrlWithPre:kApiURLPrefix] stringByAppendingString:request.restMethod ? : @""];
    
    NSString *url = [PGRequest serializeURL:baseURL params:request.parameters httpMethod:request.httpMethod];
    return url;
}

#pragma mark -

-(id)parseJsonResponse:(NSData*)data error:(NSError**)error
{
    
    NSString *responseUTF8 = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    id result = nil;
    result = [self parseJsonOrOtherwise:responseUTF8 error:error];
    
    return result;
   
}

-(id)parseJsonOrOtherwise:(NSString*)utf8
                    error:(NSError**)error
{
    id parsed = nil;
    if (!(*error)) {
        parsed = [PGUtility simpleJSONDecode:utf8 error:error];
    }
    return parsed;
}

-(void)completeWithResponse:(NSURLResponse*)response
                       data:(NSData *)data
                    orError:(NSError *)error
{
    if (self.state != kStateCancelled) {
        NSAssert(self.state == kStateStarted,
                 @"Unexpected state %d in completeWithResponse",
                 self.state);
        self.state = kStateCompleted;
    }
    
    NSInteger statusCode;
    if (response) {
        NSAssert([response isKindOfClass:[NSHTTPURLResponse class]],
                 @"Expected NSHTTPURLResponse, got %@",
                 response);
        self.urlResponse = (NSHTTPURLResponse *)response;
        statusCode = self.urlResponse.statusCode;
        
        if (!error && [response.MIMEType hasPrefix:@"image"]) {
            error = [self errorWithCode:PGErrorNonTextMimeTypeReturned
                             statusCode:0
                                message:@"Response is a non-text MIME type; endpoints that return images and other "
                                    @"binary data should be fetched using NSURLRequest and NSURLConnection"];
            }

    } else {
        statusCode = 200;
    }
    id result;
    if (!error) {
        result = [self parseJsonResponse:data error:&error ];
        if (self.completionHandler) {
            self.completionHandler(self,result,error);
        }
        
    }
}




-(void)completeWithData:(NSData *)data
                result:(id)result
                orError:(NSError*)error
{
    
    if (![result isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    id<PGRequestDelegate> delegate = [self.deprecatedRequest delegate];
    
    if (!error) {
        if ([delegate respondsToSelector:@selector(request:didReceiveResponse:)]) {
            [delegate request:self.deprecatedRequest
           didReceiveResponse:self.urlResponse];
        }
        if ([delegate respondsToSelector:@selector(request:didLoadRawResponse:)]) {
            [delegate request:self.deprecatedRequest didLoadRawResponse:data];
        }
    }
    
    if (!error) {
        if ([delegate respondsToSelector:@selector(request:didLoad:)]) {
            [delegate request:self.deprecatedRequest didLoad:result];
        }
    } else {
        [self.deprecatedRequest setError:error];
        if ([delegate respondsToSelector:@selector(request:didFailWithError:)]) {
            [delegate request:self.deprecatedRequest didFailWithError:error];
        }
    }
//    [self deprecatedRequest setstate:]
}

-(NSError *)errorWithCode :(PGErrorCode)code
                statusCode:(NSInteger)statusCode
                   message:(NSString*)message
{
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc]init];
    [userInfo setObject:[NSNumber numberWithInteger:statusCode] forKey:PGErrorHTTPStatusCodeKey];
    
    if (message) {
        userInfo[NSLocalizedDescriptionKey] = message;
    }
    
    NSError *error = [[NSError alloc]initWithDomain:PingooSDKDomain code:code userInfo:userInfo];
    return error;
}

@end


