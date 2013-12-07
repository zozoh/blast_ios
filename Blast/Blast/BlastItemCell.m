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

- (void)startCountDown:(int) time
{
    [CircleDownCounter showCircleDownWithSeconds:time
                                          onView:self.timeLabel
                                        withSize:CGSizeMake(66,66)
                                         andType:CircleDownCounterTypeIntegerDecre];
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
