//
//  BlastFirstViewController.m
//  Blast
//
//  Created by Changhai Jiang on 13-12-7.
//
//

#import "BlastMainViewController.h"
#import "BlastSecondViewController.h"
#import "BTCameraViewController.h"

@interface BlastMainViewController ()

@end

@implementation BlastMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startPostBlast:(id)sender {
    BTCameraViewController *control = [[BTCameraViewController alloc] init];
    [self.navigationController pushViewController:control animated:NO];
    [self imgSlideInFromLeft: control.view];
}

-(void) imgSlideInFromLeft:(UIView *)vew
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromLeft;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
}

@end
