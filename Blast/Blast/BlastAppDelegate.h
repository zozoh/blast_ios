//
//  BlastAppDelegate.h
//  Blast
//
//  Created by Changhai Jiang on 13-12-7.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^FetchResult)(id result);
@interface BlastAppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocation *lastKnownLocation;
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (nonatomic, strong) NSString* uniqueIdentifier;
@property (nonatomic, strong) NSString* userName;
- (void)fetchLastestBlast:(id)lastid block:(FetchResult)block;

@end


extern BlastAppDelegate* app;
