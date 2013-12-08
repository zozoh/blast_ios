//
//  BlastItemCell.m
//  Blast
//
//  Created by Changhai Jiang on 13-12-7.
//
//

#import "BlastItemCell.h"
#import "CircleDownCounter.h"
#import "PGImageLoader.h"
#import "BlastAppDelegate.h"
#import "PGRequest.h"

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
        NSTimeInterval time = [self.data[@"CountDown"] timeIntervalSince1970];
        [CircleDownCounter showCircleDownWithSeconds:[CircleDownCounter getCountDownFromData:time]
                                          onView:self.timeLabel
                                        withSize:CGSizeMake(66,66)
                                         andType:CircleDownCounterTypeIntegerDecre];
    }
}

-(void)reset
{
    NSNumber* lastTime = self.data[@"lastModified"];
    float time = ([lastTime floatValue] / 1000.f);
    NSDate* date = [NSDate dateWithTimeIntervalSince1970: time];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm"];
    self.receiveTime.text = [df stringFromDate:date];
    self.blastCount.text = [self.data[@"reblaNumber"] stringValue];
    self.caption.text = self.data[@"content"];
    // Load Small Pic;
    __weak BlastItemCell* selff = self;
    selff.smallpic.image = nil;
    [[PGImageLoader sharedLoader]loadImageWithId:self.data[@"picture"] imageType:0 completionHandler:^(UIImage *image, int imageType, NSError *error) {
        if (!error) {
            selff.smallpic.image = image;
            selff.smallImg = image;
        }
    }];
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

-(void)clickToBlast
{
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:self.data[@"_id"] forKey:@"bid"];
    [dict setObject:app.userName forKey:@"me"];
    [dict setObject:[NSString stringWithFormat:@"%f", app.lastKnownLocation.coordinate.longitude] forKey:@"lon"];
    [dict setObject:[NSString stringWithFormat:@"%f", app.lastKnownLocation.coordinate.latitude] forKey:@"lat"];
    PGRequest* req = [PGRequest requestForReBlast:dict];
    [req startWithCompletionHandler:^(PGRequestConnection *connection, id result, NSError *error) {
        if(error){
            NSLog(@"Send Fail");
        }
        
    }];

}

@end
