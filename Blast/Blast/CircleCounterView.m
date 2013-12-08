//
//  CircleCounterView.m
//  CircleCountDown
//
//  Created by Haoxiang Li on 11/25/11.
//  Copyright (c) 2011 DEV. All rights reserved.
//

#import "CircleCounterView.h"

#define kCircleSegs 30

@interface CircleCounterView ()
@property (nonatomic, retain) NSString *timeFormatString;

- (void)setup;
- (void)update:(id)sender;
- (void)updateTime:(id)sender;

@end

@implementation CircleCounterView
@synthesize numberColor = mNumberColor;
@synthesize numberFont = mNumberFont;
@synthesize circleColor = mCircleColor;
@synthesize circleBorderWidth = mCircleBorderWidth;
@synthesize timeFormatString = mTimeFormatString;
@synthesize circleIncre = mCircleIncre;
@synthesize circleTimeInterval = mCircleTimeInterval;
@synthesize delegate = mDelegate;
@synthesize outerColor = mOuterColor;

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}
                      
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)dealloc {
    
    self.numberFont = nil;
    self.numberColor = nil;
    self.circleColor = nil;
    self.circleBorderWidth = 0;
    self.timeFormatString = nil;
    
    [super dealloc];
}

- (void)drawRect:(CGRect)rect {

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    float radius = CGRectGetWidth(rect)/2.0f - self.circleBorderWidth/2.0f - 4;
    float angleOffset = M_PI_2;
    
    CGContextSetLineWidth(context, 1.0f);
    CGContextBeginPath(context);
    CGContextAddArc(context,
                    CGRectGetMidX(rect), CGRectGetMidY(rect),
                    radius,
                    0,
                    M_PI * 2,
                    0);
    CGContextSetStrokeColorWithColor(context, self.outerColor.CGColor);
    CGContextStrokePath(context);
    CGContextSetLineWidth(context, self.circleBorderWidth);
    if (self.circleIncre)
    {
        CGContextAddArc(context, 
                        CGRectGetMidX(rect), CGRectGetMidY(rect),
                        radius,
                        -angleOffset, 
                        (mCircleSegs + 1)/(float)kCircleSegs*M_PI*2 - angleOffset, 
                        0);
    }
    else
    {
        CGContextAddArc(context, 
                        CGRectGetMidX(rect), CGRectGetMidY(rect),
                        radius, 
                        (mCircleSegs + 1)/(float)kCircleSegs*M_PI*2 - angleOffset, 
                        2*M_PI - angleOffset, 
                        0);
    }
    CGContextSetStrokeColorWithColor(context, self.circleColor.CGColor);
    CGContextStrokePath(context);
    CGContextSetLineWidth(context, 1.0f);
    
    CGContextSetFillColorWithColor(context, self.numberColor.CGColor);
    NSString *numberText = [NSString stringWithFormat:self.timeFormatString, mTimeInSeconds];
    CGSize sz = [numberText sizeWithFont:self.numberFont];
    [numberText drawInRect:CGRectInset(rect, (CGRectGetWidth(rect) - sz.width)/2.0f, (CGRectGetHeight(rect) - sz.height)/2.0f) withFont:self.numberFont];
}

- (void)setup {
    
    mIsRunning = NO;
    
    //< Default Parameters
    self.numberColor = [UIColor whiteColor];
    self.numberFont = [UIFont fontWithName:@"Courier-Bold" size:20.0f];
    self.circleColor = [UIColor colorWithRed:255/255.0f green:198/255.0f blue:0.0f alpha:0.6];
    self.circleBorderWidth = 1;
    self.timeFormatString = @"%.0f";
    self.circleIncre = NO;
    self.circleTimeInterval = 1.0f;
    self.outerColor = [UIColor colorWithRed:221/255.0f green:247/255.0f blue:1.0f alpha:0.7];
    mTimeInSeconds = 0;
    mTimeInterval = 1;
    mCircleSegs = 0;
    self.backgroundColor = [UIColor clearColor];
}

#pragma mark - Public Methods
- (void)startWithSeconds:(float)seconds andInterval:(float)interval andTimeFormat:(NSString *)timeFormat {
    self.timeFormatString = timeFormat;
    [self startWithSeconds:seconds andInterval:interval];
}

- (void)startWithSeconds:(float)seconds andInterval:(float)interval {
    if (interval > seconds)
    {
        mTimeInterval = seconds/10.0f;
    }
    else
    {
        mTimeInterval = interval;
    }
    [self startWithSeconds:seconds];
}

- (void)startWithSeconds:(float)seconds {
    if (seconds > 0)
    {
        mTimeInSeconds = seconds;
        mIsRunning = YES;
        mCircleSegs = 0;
        [self update:nil];
        [self updateTime:nil];
    }
}

- (void)stop {
    mIsRunning = NO;
}

#pragma mark - Private Methods
- (void)update:(id)sender {
    if (mIsRunning)
    {
        mCircleSegs = (mCircleSegs + 1) % kCircleSegs;
        if (fabs(mTimeInSeconds) < 1e-4)
        {
            //< Finished
            mCircleSegs = (kCircleSegs - 1);
            mTimeInSeconds = 0;
            [self.delegate counterDownFinished:self];
        }
        else
        {
            [NSTimer scheduledTimerWithTimeInterval:self.circleTimeInterval/kCircleSegs
                                             target:self
                                           selector:@selector(update:) 
                                           userInfo:nil
                                            repeats:NO];
        }
        [self setNeedsDisplay];
    }
}

- (void)updateTime:(id)sender {
    if (mIsRunning)
    {
        mTimeInSeconds -= mTimeInterval;
        if (fabs(mTimeInSeconds) < 1e-4)
        {
            //< Finished
            mCircleSegs = (kCircleSegs - 1);
            mTimeInSeconds = 0;
            [self.delegate counterDownFinished:self];
        }
        else
        {            
            [NSTimer scheduledTimerWithTimeInterval:mTimeInterval
                                             target:self 
                                           selector:@selector(updateTime:)
                                           userInfo:nil
                                            repeats:NO];
        }
    }
}

@end
