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
#import "PGRequest.h"
#import "BlastAppDelegate.h"
#import "PGUtility.h"

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

- (void)loadBlastGraph:(id)bid
{
    NSDictionary* dict = @{@"bid": bid};
    PGRequest* req = [PGRequest requestForBlastGraph:dict];
    [req startWithCompletionHandler:^(PGRequestConnection *connection, id result, NSError *error) {
        NSArray* datalist = result;
        if(datalist == nil){
            NSString* s = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://10.10.0.109:3000/api/blasts/graph.json"] encoding:NSUTF8StringEncoding error:nil];
            datalist = [PGUtility simpleJSONDecode:s];
        }
        
        [self nextPage:datalist];
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    /*
     */
}

-(void)moveCenterToLocate:(NSArray*)locate size:(float)size
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [locate[1] floatValue];
    coordinate.longitude = [locate[0] floatValue];
    
    MKCoordinateRegion region;
    region.span.latitudeDelta = size;
    region.span.longitudeDelta = size;
    region.center = coordinate;
    // 设置显示位置(动画)
    [self.mapView setRegion:region animated:YES];
    // 设置地图显示的类型及根据范围进行显示
    [self.mapView regionThatFits:region];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)nextPage:(id)dataList
{
    int i = 0;
    int total = (int)[dataList[@"total"] integerValue];
    int sizeForDisp = (int)[dataList[@"size"] integerValue];
    for (NSDictionary* data in dataList[@"data"]){
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [data[@"location"][1] floatValue];
        coordinate.longitude = [data[@"location"][0] floatValue];
        
        SVAnnotation *annotation = [[SVAnnotation alloc] initWithCoordinate:coordinate];
        if(i == 0){
            annotation.title = [data[@"reblaNumber"] stringValue];
            annotation.pointSize =  20;
            [self moveCenterToLocate:data[@"location"] size:sizeForDisp];
        }else{
        }
        annotation.size = 20 + [data[@"reblaNumber"] integerValue] / 10;
        annotation.delay = 0.5 * i;
        [self.mapView addAnnotation:annotation];
        i++;
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
