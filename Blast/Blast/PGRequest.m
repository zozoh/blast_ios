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
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[NSString stringWithFormat:@"%f",log ] forKey:@"lon"];
    [params setObject:[NSString stringWithFormat:@"%f",lat ] forKey:@"lat"];
    [params setObject:@"1" forKey:@"n"];
    
    return [[PGRequest alloc]initWithParams:params restMethod:@"/api/blasts.json?" httpMethod:@"GET" ];
}

+(PGRequest*)blastWithImageData:(UIImage *)image text:(NSString *)text userID:(NSString *)userID
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    
    NSMutableDictionary *header = [[NSMutableDictionary alloc]init];
    [header setObject:@"image/jpeg" forKey:@"Content-Type"];
    
    NSMutableData *bodyData = [NSMutableData data];
//    [bodyData appendData:[NSData dataWithBytes:[str UTF8String] length:strlen([str UTF8String])]];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    if (imageData) {
        [bodyData appendData:[NSData dataWithData:imageData]];
    }
    return [[PGRequest alloc]initWithParams:params restMethod:@"/blast/o/write" httpMethod:@"POST" httpHeader:header httpBody:bodyData] ;
}

+(PGRequest*)requestForBlast:(NSDictionary *)dict
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *header = [[NSMutableDictionary alloc]init];
    [header setObject:@"application/json" forKey:@"Content-Type"];
    
    NSData *body = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    return [[PGRequest alloc]initWithParams:params restMethod:@"/blast/o/write" httpMethod:@"POST" httpHeader:header httpBody:body] ;
    
}

@end


