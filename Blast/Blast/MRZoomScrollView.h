//
//  MRZoomScrollView.h
//  ScrollViewWithZoom
//
//  Created by xuym on 13-3-27.
//  Copyright (c) 2013年 xuym. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZoomScrollViewDelegate;

@interface MRZoomScrollView : UIScrollView <UIScrollViewDelegate>
{
    UIImageView *imageView;
}

@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, assign) id<ZoomScrollViewDelegate> delegateForClick;
@end

@protocol ZoomScrollViewDelegate <NSObject>
-(void) MRZoomScrollViewClick:(id)sender;
@end