//
//  BlastNetworkClient.h
//  Blast
//
//  Created by Changhai Jiang on 14-1-21.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "AFHTTPSessionManager.h"

@interface BlastNetworkClient : AFHTTPSessionManager
+(instancetype) shareClient;
- (NSURLSessionDataTask *)postImageData:(UIImage*)images completion:( void (^)(id results, NSError *error) )completion;
- (NSURLSessionDataTask *)postBlast:(NSDictionary*)dict completion:(void (^)(id results, NSError *error) )completion;
- (NSURLSessionDataTask *)fetchBlastWithCLLocation:(CLLocation*)location bid:(NSString*)bid completion:(void (^)(id results, NSError *error) )completion;
- (NSURL*)generateImageURL:(NSString*)key;
@end
