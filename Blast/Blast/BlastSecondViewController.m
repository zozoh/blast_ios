//
//  BlastSecondViewController.m
//  Blast
//
//  Created by Changhai Jiang on 13-12-7.
//
//

#import "BlastSecondViewController.h"
#import "CircleDownCounter.h"
#import "MyMapViewController.h"
#import "PGRequest.h"
#import "PGImageLoader.h"
#import "BlastAppDelegate.h"

@interface BlastSecondViewController ()

@end

@implementation BlastSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.imagezoomview.delegate = self.imagezoomview;
    self.imagezoomview.delegateForClick = self;
    self.view.alpha = 0;
    self.imagezoomview.imageView.image = self.image;
    CGSize size = self.image.size;
    CGSize outerSize =self.imagezoomview.bounds.size;
    self.imagezoomview.imageView.frame = CGRectMake(0, 0, outerSize.width, size.height / size.width * outerSize.width);
    self.imagezoomview.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 1;
    }];
    
    for (UIView* v in self.hideGroup) {
        v.hidden = YES;
    }
    if(self.currentData){
        NSTimeInterval time = [self.currentData[@"CountDown"] timeIntervalSince1970];
        [CircleDownCounter showCircleDownWithSeconds:[CircleDownCounter getCountDownFromData:time]
                                                  onView:self.timeCountDown
                                                withSize:CGSizeMake(66,66)
                                                 andType:CircleDownCounterTypeIntegerDecre];
        float time2 = [self.currentData[@"createTime"] floatValue] / 1000.0f;
        NSDate* date = [NSDate dateWithTimeIntervalSince1970: time2];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MM-dd"];
        self.createDate.text = [df stringFromDate:date];
        self.blastCount.text = [self.currentData[@"reblaNumber"] stringValue];
        self.blastContent.text = self.currentData[@"content"];
        self.posterName.text = self.currentData[@"owner"];
        self.location.text = [NSString stringWithFormat:@"%f,%f", [self.currentData[@"location"][0] floatValue], [self.currentData[@"location"][1] floatValue]];
        __weak BlastSecondViewController* selff = self;
        [[PGImageLoader sharedLoader] loadAvataImageWithId:self.currentData[@"owner"] imageType:0 completionHandler:^(UIImage *image, int imageType, NSError *error) {
            selff.headIcon.image = image;
//            self.avata.image = image;
        }];
    }
    
    self.title = self.currentData[@"content"];
}

- (IBAction)showMapView:(id)sender {
    MyMapViewController* mapController = [[self storyboard] instantiateViewControllerWithIdentifier:@"MapViewController"];
    mapController.data = self.currentData;
    [mapController loadBlastGraph:self.currentData[@"_id"]];
    [[self navigationController] pushViewController:mapController animated:YES];
}

- (IBAction)blastAction:(id)sender {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setObject:self.currentData[@"_id"] forKey:@"bid"];
    [dict setObject:app.userName forKey:@"me"];
    [dict setObject:[NSString stringWithFormat:@"%f", app.lastKnownLocation.coordinate.longitude] forKey:@"lon"];
    [dict setObject:[NSString stringWithFormat:@"%f", app.lastKnownLocation.coordinate.latitude] forKey:@"lat"];
    PGRequest* req = [PGRequest requestForReBlast:dict];
    [req startWithCompletionHandler:^(PGRequestConnection *connection, id result, NSError *error) {
        if(error){
            NSLog(@"Send Fail");
        }
        [self back:nil];
    }];
}

- (IBAction)back:(id)sender{
    [[self navigationController] popViewControllerAnimated:YES];
}

-(void)MRZoomScrollViewClick:(id)sender
{
    for (UIView* v in self.hideGroup) {
        v.hidden = !v.hidden;
    }
}
@end
