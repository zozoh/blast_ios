//
//  PGRequestConnection.h
//  Pingoo
//
//  Created by Steven Gao on 13-10-8.
//  Copyright (c) 2013年 Steven Gao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PGRequestConnection;
@class PGRequest;

typedef void (^PGRequestHandler)(PGRequestConnection *connection,
                                 id result,
                                 NSError *error);


@interface PGRequestConnection : NSObject

-(id)init;

-(id)initWithTimeout:(NSTimeInterval)timeout;

@property(nonatomic,strong)NSMutableURLRequest *urlRequest;

@property(nonatomic,strong)NSHTTPURLResponse *urlResponse;

@property(nonatomic,strong)PGRequestHandler completionHandler;

-(void)addRequest:(PGRequest*)request
completionHandler:(PGRequestHandler)handler;

-(void)addRequest:(PGRequest *)request
completionHandler:(PGRequestHandler)handler
   batchEntryName:(NSString*)name;

-(void)start;

-(void)cancel;



@end
