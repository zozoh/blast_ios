//
//  PGRequest.m
//  Pingoo
//
//  Created by Steven Gao on 13-10-4.
//  Copyright (c) 2013年 Steven Gao. All rights reserved.
//

#import "PGRequest.h"
#import "PGUtility.h"

NSString *const PGBasePath = @"http://";

static NSString *const kGetHTTPMethod = @"GET";
static NSString *const kPostHTTPMethod = @"POST";


@implementation PGRequest

@synthesize url = _url;
@synthesize connection = _connection;
@synthesize responseText = _responseText;
@synthesize error = _error;
@synthesize delegate = _delegate;

@synthesize parameters = _parameters;
@synthesize restMethod = _restMethod;
@synthesize httpMethod = _httpMethod;
@synthesize body = _body;
@synthesize header = _header;

- (id) init{
    
    return [self initWithParams:nil restMethod:nil httpMethod:nil];
}

-(id)initWithParams:(NSDictionary *)parameters restMethod:(NSString *)restMethod httpMethod:(NSString *)httpMethod
{
    if (self = [super init]) {
        if (!httpMethod) {
            httpMethod = kGetHTTPMethod;
        }
        
        self.httpMethod = httpMethod;
        self.restMethod = restMethod;
        
        self.parameters = [[NSMutableDictionary alloc]init];
        if (parameters) {
            [self.parameters addEntriesFromDictionary:parameters];
        }
        
        self.header = nil;
        self.body = nil;
    }
    return self;
}
-(id)initWithParams:(NSDictionary *)parameters restMethod:(NSString *)restMethod httpMethod:(NSString *)httpMethod httpHeader:(NSDictionary*)header httpBody:(NSData*)body
{
    if (self = [super init]) {
        if (!httpMethod) {
            httpMethod = kGetHTTPMethod;
        }
        
        self.httpMethod = httpMethod;
        self.restMethod = restMethod;
        
        self.parameters = [[NSMutableDictionary alloc]init];
        if (parameters) {
            [self.parameters addEntriesFromDictionary:parameters];
        }
        
        self.header = [[NSMutableDictionary alloc]init];
        if (header) {
            [self.header addEntriesFromDictionary:header];
        }
        

        if (body) {
            self.body = body;
        }
    }
    return self;
}

-(void)dealloc
{
    NSLog(@"PGRequest dealloc");
}

-(PGRequestConnection *)startWithCompletionHandler:(PGRequestHandler)handler
{
    PGRequestConnection *connection = [[PGRequestConnection alloc]init];
    [connection addRequest:self completionHandler:handler];
    [connection start];
    return connection;
}

-(PGRequestConnection *)startWithCompletionHandler:(PGRequestHandler)handler withHost:(NSString*)host
{
    PGRequestConnection *connection = [[PGRequestConnection alloc]init];
    [connection addRequest:self completionHandler:handler];
    [connection start];
    return connection;
}

+ (NSString *)serializeURL:(NSString *)baseUrl params:(NSDictionary *)params
{
    return [self serializeURL:baseUrl params:params httpMethod:kGetHTTPMethod];
}

+(NSString *)serializeURL:(NSString *)baseUrl params:(NSDictionary *)params httpMethod:(NSString *)httpMethod
{
    NSURL *parsedURL = [NSURL URLWithString:baseUrl];
    NSString* queryPrefix = parsedURL.query ? @"&" :@"?";
    
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in [params keyEnumerator]) {
        id value = [params objectForKey:key];
        if ([value isKindOfClass:[UIImage class]]
            ||[value isKindOfClass:[NSData class]]) {
            if ([httpMethod isEqualToString:kGetHTTPMethod]) {
                NSLog(@"can not use GET to upload a file");
            }
            
        }
        NSString* escaped_value = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, /* allocator */(__bridge CFStringRef)[params objectForKey:key],NULL, /* charactersToLeaveUnescaped */(CFStringRef)@"!*'();:@&=$,/?%#[]",kCFStringEncodingUTF8);
        [pairs addObject:[NSString stringWithFormat:@"%@=%@",key,escaped_value]];
    }
    NSString *query = [pairs componentsJoinedByString:@"&"];
    return [NSString stringWithFormat:@"%@%@%@",baseUrl,queryPrefix,query];
}
+(PGRequest*)requestForBlastWithLongitude:(float)log latitude:(float)lat
{
    return [PGRequest requestForBlastWithLongitude:log latitude:lat bid:nil];
}

+(PGRequest*)requestForBlastWithLongitude:(float)log latitude:(float)lat bid:(id)bid
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[NSString stringWithFormat:@"%f",log ] forKey:@"lon"];
    [params setObject:[NSString stringWithFormat:@"%f",lat ] forKey:@"lat"];
    [params setObject:@"10" forKey:@"n"];
    if(bid){
        [params setObject:bid forKey:@"bid"];
    }
    
    return [[PGRequest alloc]initWithParams:params restMethod:@"/api/blasts" httpMethod:@"GET" ];
}

+(PGRequest*)requestForPostImageData:(UIImage*)image{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    NSMutableDictionary *header = [[NSMutableDictionary alloc]init];
    [header setObject:@"image/jpeg" forKey:@"Content-Type"];
    
    NSMutableData *bodyData = [NSMutableData data];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    if (imageData) {
        [bodyData appendData:[NSData dataWithData:imageData]];
    }
    return [[PGRequest alloc]initWithParams:params restMethod:@"/api/blasts/photo_upload" httpMethod:@"POST" httpHeader:header httpBody:bodyData] ;
}

+(PGRequest*)requestForBlast:(NSDictionary *)dict
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *header = [[NSMutableDictionary alloc]init];
    [header setObject:@"application/json" forKey:@"Content-Type"];
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    return [[PGRequest alloc]initWithParams:params restMethod:@"/api/blasts/new" httpMethod:@"POST" httpHeader:header httpBody:body] ;
    
}

+(PGRequest*)requestForBlastGraph:(NSDictionary *)dict
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *header = [[NSMutableDictionary alloc]init];
    [header setObject:@"application/json" forKey:@"Content-Type"];
    NSData *body = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    return [[PGRequest alloc]initWithParams:params restMethod:@"/api/blasts/graph" httpMethod:@"POST" httpHeader:header httpBody:body] ;
}



+(PGRequest*)requestForReBlast:(NSDictionary *)dict
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *header = [[NSMutableDictionary alloc]init];
    [header setObject:@"application/json" forKey:@"Content-Type"];
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    return [[PGRequest alloc]initWithParams:params restMethod:@"/api/blasts/reblast" httpMethod:@"POST" httpHeader:header httpBody:body] ;
    
}

+(PGRequest*)requestForUserName:(NSString*)uuid
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *header = [[NSMutableDictionary alloc]init];
    [header setObject:@"application/json" forKey:@"Content-Type"];
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:@{@"uid": uuid} options:0 error:nil];
    return [[PGRequest alloc]initWithParams:params restMethod:@"/api/signup" httpMethod:@"POST" httpHeader:header httpBody:body] ;
    
}


@end


