//
//  PGUtility.h
//  Pingoo
//
//  Created by Steven Gao on 13-10-8.
//  Copyright (c) 2013年 Steven Gao. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PG_BASE_URL @"10.10.0.61:8080"
//#define PG_BASE_URL @"1:5000"
#define PG_URL_PREFIX @"http://"
#define PG_USER_ID @"210"
@interface PGUtility : NSObject

+(NSString*)buildPingooUrlWithPre:(NSString *)pre;
+(NSString*)buildPingooUrlWithPre:(NSString *)pre
                         withPost:(NSString *)post;

+(NSString*)buildPictureUrlWithFullUrl:(NSString *)fullUrl
                          withPath:(NSString *)path;

+(id)simpleJSONDecode:(NSString*)jsonEncoding;
+(id)simpleJSONDecode:(NSString *)jsonEncoding
                error:(NSError**)error;
+(id)specificSuperViewforView :(UIView*) view class:(Class)dest;
+(id)specificNextResponderforView:(UIView *)view class:(Class)dest;



@end


