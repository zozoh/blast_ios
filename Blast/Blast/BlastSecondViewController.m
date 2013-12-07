//
//  BlastSecondViewController.m
//  Blast
//
//  Created by Changhai Jiang on 13-12-7.
//
//

#import "BlastSecondViewController.h"

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
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    self.imagezoomview.delegate = self.imagezoomview;
    self.imagezoomview.delegateForClick = self;
    self.view.alpha = 0;
    self.imagezoomview.imageView.image = self.image;
    self.imagezoomview.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 1;
    }];
}

- (IBAction)showMapView:(id)sender {
}

- (IBAction)blastAction:(id)sender {
}

-(void)MRZoomScrollViewClick:(id)sender
{
    BOOL isShow = !self.navigationController.navigationBarHidden;
    [[self navigationController] setNavigationBarHidden:isShow animated:YES];
}
@end
