//
//  PGImageLoader.h
//  Pingoo
//
//  Created by Steven Gao on 13-10-11.
//  Copyright (c) 2013年 Steven Gao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PGImageLoader;

typedef void (^PGImageLoaderHandler)(UIImage*image,
                                     int imageType,
                                    NSError *error);

@interface PGImageLoader : NSObject {
//    NSMutableDictionary *_cache;
    NSMutableDictionary *_activeDownloaders;
}

@property (nonatomic,strong) NSMutableDictionary *cache;

+(PGImageLoader*)sharedLoader;
-(void)loadImageWithURL:(NSString*)url
         completionhandler:(PGImageLoaderHandler)handler;

-(void)loadImageWithURL:(NSString*)url
              imageType:(int)type
      completionHandler:(PGImageLoaderHandler)handler;

-(void)cancelDownloaderWithURL:(NSString*)url;

@end
