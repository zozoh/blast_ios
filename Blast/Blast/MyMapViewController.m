//
//  HelloViewController.m
//  Blast
//
//  Created by Changhai Jiang on 13-12-7.
//
//

#import "MyMapViewController.h"
#import "SVPulsingAnnotationView.h"
#import "SVAnnotation.h"

@interface MyMapViewController ()

@end

@implementation MyMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = 23.134844f;
    coordinate.longitude = 113.317290f;

    MKCoordinateRegion region;
    region.span.latitudeDelta = 10;
    region.span.longitudeDelta = 10;
    region.center = coordinate;
    // 设置显示位置(动画)
    [self.mapView setRegion:region animated:YES];
    // 设置地图显示的类型及根据范围进行显示
    [self.mapView regionThatFits:region];
    
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextPage) userInfo:nil repeats:false];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)nextPage
{
    for (int i=0; i< 100; i++){
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = 23.134844f + 0.01 * i;
        coordinate.longitude = 113.317290f + 0.02 * i;
        
        SVAnnotation *annotation = [[SVAnnotation alloc] initWithCoordinate:coordinate];
        annotation.size = 20 + i * 2;
        annotation.delay = 0.5 * i;
        [self.mapView addAnnotation:annotation];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if([annotation isKindOfClass:[SVAnnotation class]]) {
        static NSString *identifier = @"currentLocation";
		SVPulsingAnnotationView *pulsingView = (SVPulsingAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
		
		if(pulsingView == nil) {
			pulsingView = [[SVPulsingAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            pulsingView.annotationColor = [UIColor colorWithRed:0.678431 green:0 blue:0 alpha:1];
            pulsingView.canShowCallout = NO;
        }
		return pulsingView;
    }
    return nil;
}

- (IBAction)back:(id)sender{
    [[self navigationController] popViewControllerAnimated:YES];
}


@end
