//
//  PGURLConnection.h
//  Pingoo
//
//  Created by Steven Gao on 13-10-8.
//  Copyright (c) 2013年 Steven Gao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PGURLConnection;
typedef void (^PGURLConnectionHandler)(PGURLConnection *connection,
                                       NSError *error,
                                       NSURLResponse *response,
                                       NSData *responseData);



@interface PGURLConnection : NSObject

-(PGURLConnection*)initWithURL:(NSURL  *)URL
             completionHandler:(PGURLConnectionHandler) handler;


-(PGURLConnection*)initWithRequest:(NSURLRequest *)request
                 completionHandler:(PGURLConnectionHandler)handler;

-(void)cancel;


@end
