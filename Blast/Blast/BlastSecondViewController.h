//
//  BlastSecondViewController.h
//  Blast
//
//  Created by Changhai Jiang on 13-12-7.
//
//

#import <UIKit/UIKit.h>
#import "MRZoomScrollView.h"

@interface BlastSecondViewController : UIViewController<UIScrollViewDelegate, ZoomScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *createDate;
@property (strong, nonatomic) IBOutlet UILabel *blastCount;
@property (strong, nonatomic) IBOutlet UILabel *location;
@property (strong, nonatomic) IBOutlet MRZoomScrollView *imagezoomview;
@property (strong, nonatomic) IBOutlet UIView *timeCountDown;
@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) NSDictionary* currentData;
@property (strong, nonatomic) IBOutlet UIImageView *headIcon;
@property (strong, nonatomic) IBOutlet UILabel *posterName;
@property (strong, nonatomic) IBOutlet UILabel *blastContent;
@property (strong, nonatomic) UIImage* smallImg;
- (IBAction)showMapView:(id)sender;
- (IBAction)blastAction:(id)sender;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *hideGroup;
- (IBAction)back:(id)sender;
@end
