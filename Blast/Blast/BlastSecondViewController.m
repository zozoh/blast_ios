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
    self.imagezoomview.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 1;
    }];
    
    for (UIView* v in self.hideGroup) {
        v.hidden = YES;
    }
    if(self.currentData){
        long time = [self.currentData[@"lastModified"] longValue];
        [CircleDownCounter showCircleDownWithSeconds:[CircleDownCounter getCountDownFromData:time / 1000.f]
                                                  onView:self.timeCountDown
                                                withSize:CGSizeMake(66,66)
                                                 andType:CircleDownCounterTypeIntegerDecre];
        
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:[self.currentData[@"createTime"] longValue] / 1000.0f ];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        self.createDate.text = [df stringFromDate:date];
        self.blastCount = self.currentData[@"reblaNumber"];
        self.blastContent = self.currentData[@"content"];
        self.posterName = self.currentData[@"owner"];
    }
    
    self.title = @"Detail Pic";
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Trace" style:UIBarButtonItemStylePlain
                                                target:self action:@selector(showMapView:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
}

- (IBAction)showMapView:(id)sender {
    MyMapViewController* mapController = [[self storyboard] instantiateViewControllerWithIdentifier:@"MapViewController"];
    mapController.data = self.currentData;
    [[self navigationController] pushViewController:mapController animated:YES];
}

- (IBAction)blastAction:(id)sender {
}

-(void)MRZoomScrollViewClick:(id)sender
{
    for (UIView* v in self.hideGroup) {
        v.hidden = !v.hidden;
    }
}
@end
