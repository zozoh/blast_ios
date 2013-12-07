//
//  PGImageLoader.m
//  Pingoo
//
//  Created by Steven Gao on 13-10-11.
//  Copyright (c) 2013年 Steven Gao. All rights reserved.
//

#import "PGImageLoader.h"
#import "PGImageDownloader.h"
#import "PGUtility.h"

@implementation PGImageLoader

@synthesize cache = _cache;

-(id)init
{
    if (self = [super init]) {
        
        _cache = [[NSMutableDictionary alloc]initWithCapacity:300];
        _activeDownloaders = [[NSMutableDictionary alloc]initWithCapacity:300];
    }
    return self;
}

+(PGImageLoader*)sharedLoader
{
    static PGImageLoader *loader;
    if (!loader) {
        loader = [[PGImageLoader alloc]init];
        
    }
    return loader;
}

-(void)loadImageWithId:(NSString *)id imageType:(int)type completionHandler:(PGImageLoaderHandler)handler
{
    NSString *url = [NSString stringWithFormat:@"%@%@%@%@", PG_URL_PREFIX,PG_BASE_URL, @"/api/photo/",id ];
    [self loadImageWithURL:url imageType:type completionHandler:handler];
}

-(void)loadImageWithURL:(NSString *)url completionhandler:(PGImageLoaderHandler)handler
{
    [self loadImageWithURL:url imageType:0 completionHandler:handler];
}

-(void)loadImageWithURL:(NSString *)url imageType:(int)type completionHandler:(PGImageLoaderHandler)handler
{
    NSString *_url = url;
    int _type =type;
    PGImageLoaderHandler _handler = handler;
    
    if (!_url) {
        return;
    }
    
    UIImage *image = [_cache objectForKey:_url];
    if (image && _handler) {
        NSLog(@"fetch image from cache");
        _handler(image,type,nil);
        return;
    }
    
    PGImageDownloader *downloader = [_activeDownloaders objectForKey:url];
    if (downloader) {
        NSLog(@"downloader is pending");
        return;
    }
    
    downloader = [[PGImageDownloader alloc]init];
    [downloader addImageUrl:_url completionHandler:^(PGImageDownloader *sender, UIImage *image, NSError *error) {
        NSLog(@"fetch image from server");
        
        if (!error) {
            [self setImage:image forURL:url];
            if (_handler) {
                _handler(image,_type,error);
            }
        }
        [_activeDownloaders removeObjectForKey:_url];

    }];

    [_activeDownloaders setObject:downloader forKey:_url];
    
    
    [downloader start];
}

-(void)setImage:(UIImage*)image forURL:(NSString*)url
{
    @try {
//        if (_cache.count > 30) {
//            [_cache removeObjectForKey:[_cache allKeys][0] ];
//        }
        [_cache setObject:image forKey:url];
         
    }
    @catch (NSException *exception) {
        
    }

}

-(void)cancelDownloaderWithURL:(NSString *)url
{
    PGImageDownloader *downLoader = [_activeDownloaders objectForKey:url];
    if (downLoader) {
        [downLoader cancel];
    }
}


@end
