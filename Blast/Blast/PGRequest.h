//
//  PGRequest.h
//  Pingoo
//
//  Created by Steven Gao on 13-10-4.
//  Copyright (c) 2013年 Steven Gao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGRequestConnection.h"


@protocol PGRequestDelegate;






@interface PGRequest : NSObject{
}

@property(nonatomic,weak)id<PGRequestDelegate> delegate;
@property(nonatomic,strong)NSString* url;
@property(nonatomic,strong)NSURLConnection* connection;
@property(nonatomic,strong)NSMutableData* responseText;
@property(nonatomic,strong)NSError* error;


@property (nonatomic,strong)NSMutableDictionary *parameters;
@property (nonatomic,strong)NSMutableDictionary *header;
@property (nonatomic,strong)NSData *body;
@property (nonatomic,strong)NSString* restMethod;
@property (nonatomic,strong)NSString* httpMethod;


+(NSString *)serializeURL:(NSString *)baseUrl
                   params:(NSDictionary *)params;

+(NSString *)serializeURL:(NSString *)baseUrl
                   params:(NSDictionary *)params
               httpMethod:(NSString *)httpMethod;


-(id)init;
-(id)initWithParams:(NSDictionary*)parameters
         restMethod:(NSString*)restMethod
         httpMethod:(NSString*)httpMethod;

- (PGRequestConnection*)startWithCompletionHandler:(PGRequestHandler)handler;

+(PGRequest*)requestForBlastWithLongitude:(float)log
                                 latitude:(float)lat;

+(PGRequest*)requestForBlast:(NSDictionary *)dict;

+(PGRequest*)requestForPostImageData:(UIImage*)image;

@end


@protocol PGRequestDelegate <NSObject>

@optional

/**
 * Called just before the request is sent to the server.
 */

-(void)requestLoading:(PGRequest*)request;


/**
 * This callback gives you access to the raw response. It's called before
 * (void)request:(FBRequest *)request didLoad:(id)result,
 * which is passed the parsed response object.
 */

-(void)request:(PGRequest*)request
didReceiveResponse:(NSURLResponse*)response;

/**
 * Called when an error prevents the request from completing successfully.
 */

-(void)request:(PGRequest*)request
didFailWithError:(NSError*)error;

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array or a string, depending
 * on the format of the API response. If you need access to the raw response,
 * use:
 */

-(void)request:(PGRequest*)request didLoad:(id)result;

/**
 * Called when a request returns a response.
 *
 * The result object is the raw response from the server of type NSData
 */

-(void)request:(PGRequest*)request didLoadRawResponse:(NSData*)data;

@end




















