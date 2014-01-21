//
//  PGImageDownloader.h
//  Pingoo
//
//  Created by Steven Gao on 13-10-11.
//  Copyright (c) 2013年 Steven Gao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGURLConnection.h"


@class PGImageDownloader;
typedef void (^PGImageDownloaderHandler)(PGImageDownloader*sender,
                                         UIImage*image,
                                         NSError *error);






@interface PGImageDownloader : NSObject {
    NSMutableData* result;
   
    
}

@property (nonatomic,strong) PGURLConnection *connection;
@property (nonatomic,strong) PGImageDownloaderHandler completionHandler;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic) int imageType;

-(void)addImageUrl:(NSString*)imageUrl
 completionHandler:(PGImageDownloaderHandler)handler;

-(void)start;
-(void)cancel;




@end
