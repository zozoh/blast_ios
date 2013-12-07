//
//  PGError.h
//  Pingoo
//
//  Created by Steven Gao on 13-10-8.
//  Copyright (c) 2013年 Steven Gao. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const PingooSDKDomain;
extern NSString *const PGErrorHTTPStatusCodeKey;
extern NSString *const PGErrorParsedJSONResponseKey;

typedef enum PGErrorCode {
    
    PGErrorInvalid = 0,
    
    PGErrorOperationCalcelled,
    
    PGErrorNonTextMimeTypeReturned,
    
    PGErrorProtocolMismatch,
    
} PGErrorCode;