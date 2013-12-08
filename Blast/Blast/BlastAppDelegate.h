//
//  BlastAppDelegate.h
//  Blast
//
//  Created by Changhai Jiang on 13-12-7.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface BlastAppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocation *lastKnownLocation;
<<<<<<< HEAD
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (nonatomic, strong) NSString* uniqueIdentifier;
@property (nonatomic, strong) NSString* userName;
=======
@property (strong, nonatomic)
CLLocationManager* locationManager;
>>>>>>> 0e89d63e6c15af53d294f328c516529c65edc853
@end

extern BlastAppDelegate* app;
