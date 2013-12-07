//
//  BlastSecondViewController.h
//  Blast
//
//  Created by Changhai Jiang on 13-12-7.
//
//

#import <UIKit/UIKit.h>
#import "MRZoomScrollView.h"

@interface BlastSecondViewController : UIViewController<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *createDate;
@property (strong, nonatomic) IBOutlet UILabel *blastCount;
@property (strong, nonatomic) IBOutlet UILabel *location;
@property (strong, nonatomic) IBOutlet MRZoomScrollView *imagezoomview;
@property (strong, nonatomic) UIImage* image;
- (IBAction)showMapView:(id)sender;
- (IBAction)blastAction:(id)sender;

@end
