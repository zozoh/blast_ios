//
//  BlastNetworkClient.m
//  Blast
//
//  Created by Changhai Jiang on 14-1-21.
//
//

#import "BlastNetworkClient.h"

@implementation BlastNetworkClient

+(instancetype) shareClient
{
    static BlastNetworkClient* _sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[BlastNetworkClient alloc] initWithBaseURL:[NSURL URLWithString:APP_BASE_URL]];
    });
    return _sharedClient;
}

- (NSURLSessionDataTask *)postImageData:(UIImage*)images completion:(void (^)(id results, NSError *error) )completion
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *header = [[NSMutableDictionary alloc]init];
    [header setObject:@"image/jpeg" forKey:@"Content-Type"];
    
    NSMutableData *bodyData = [NSMutableData data];
    NSData *imageData = UIImageJPEGRepresentation(images, 1.0);
    if (imageData) {
        [bodyData appendData:[NSData dataWithData:imageData]];
    }
    
    return [[BlastNetworkClient shareClient] POST:@"/api/blasts/photo_upload" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithHeaders:header body:bodyData];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
}

- (NSURLSessionDataTask *)postBlast:(NSDictionary*)dict completion:(void (^)(id results, NSError *error) )completion
{
    return [[BlastNetworkClient shareClient] POST:@"/api/blasts/new" parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
}
- (NSURLSessionDataTask *)fetchBlastWithCLLocation:(CLLocation*)location bid:(NSString*)bid completion:(void (^)(id results, NSError *error) )completion
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[NSString stringWithFormat:@"%f", location.coordinate.longitude ] forKey:@"lon"];
    [params setObject:[NSString stringWithFormat:@"%f",location.coordinate.latitude ] forKey:@"lat"];
    [params setObject:@"10" forKey:@"n"];
    if(bid){
        [params setObject:bid forKey:@"bid"];
    }
    
    return [[BlastNetworkClient shareClient] GET:@"/api/blasts/new" parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        completion(nil, error);
    }];
}

- (NSURL*)generateImageURL:(NSString*)key
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", APP_BASE_URL, @"/api/photo/",key]];
}
- (NSURL*)generateAvataURL:(NSString*)key
{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", APP_BASE_URL, @"/api/avatar?unm=",key]];
}

@end
