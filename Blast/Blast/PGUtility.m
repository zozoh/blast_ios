//
//  PGUtility.m
//  Pingoo
//
//  Created by Steven Gao on 13-10-8.
//  Copyright (c) 2013年 Steven Gao. All rights reserved.
//

#import "PGUtility.h"

@implementation PGUtility


+(NSString*)buildPingooUrlWithPre:(NSString *)pre
{
    return [PGUtility buildPingooUrlWithPre:pre withPost:nil];
}

+(NSString*)buildPingooUrlWithPre:(NSString *)pre withPost:(NSString *)post
{
    NSString *domain = PG_BASE_URL;
    return [NSString stringWithFormat:@"%@%@%@",pre,domain,post ? :@""];
}

+(NSString*)buildPictureUrlWithFullUrl:(NSString *)fullUrl withPath:(NSString *)path
{
    NSArray *array = [fullUrl componentsSeparatedByString:@"/"];
    NSString *result = [NSString stringWithFormat:@"%@%@%@%@",PG_URL_PREFIX,PG_BASE_URL,path,array.lastObject];
    return result;
}

+(id)simpleJSONDecode:(NSString *)jsonEncoding
{
    return [PGUtility simpleJSONDecode:jsonEncoding error:nil];
}
+(id)simpleJSONDecode:(NSString *)jsonEncoding error:(NSError *__autoreleasing *)error
{
    NSData *data = [jsonEncoding dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        return [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
    }
    return nil;
}

+(id)specificSuperViewforView :(UIView*) view class:(Class)dest
{
    id ret = view;
    while (!ret || ![ret isKindOfClass:dest]) {
        ret = ((UIView*)ret).superview;
    } 
    return ret;
}

+(id)specificNextResponderforView:(UIView *)view class:(Class)dest
{
    id ret = view;
    
    while (!ret || ![ret isKindOfClass:dest]){
        ret = ((UIResponder*)ret).nextResponder;
    }
    return ret;
}

@end

