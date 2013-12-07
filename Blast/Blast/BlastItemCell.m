//
//  BlastItemCell.m
//  Blast
//
//  Created by Changhai Jiang on 13-12-7.
//
//

#import "BlastItemCell.h"
#import "CircleDownCounter.h"

@implementation BlastItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)startCountDown
{
    if(self.data){
        long time = [self.data[@"lastModified"] longValue];
        [CircleDownCounter showCircleDownWithSeconds:[CircleDownCounter getCountDownFromData:time / 1000.f]
                                          onView:self.timeLabel
                                        withSize:CGSizeMake(66,66)
                                         andType:CircleDownCounterTypeIntegerDecre];
    }
}

-(void)reset
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[self.data[@"lastModified"] longValue] / 1000.0f ];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    self.receiveTime.text = [df stringFromDate:date];
    self.blastCount = self.data[@"reblaNumber"];
    self.caption = self.data[@"content"];
    // Load Small Pic;
}

-(UIImage*)getGrayImage:(UIImage*)sourceImage
{
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,width,height,8,0,colorSpace,kCGImageAlphaNone);
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        return nil;
    }
    
    CGContextDrawImage(context,CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    
    return grayImage;
}


@end