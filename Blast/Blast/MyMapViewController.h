//
//  HelloViewController.h
//  Blast
//
//  Created by Changhai Jiang on 13-12-7.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MyMapViewController : UIViewController <MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) NSDictionary* data;
- (IBAction)back:(id)sender;
@end
