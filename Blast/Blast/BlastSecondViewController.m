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
    self.view.alpha = 0;
    self.imagezoomview.imageView = [[UIImageView alloc] initWithImage:self.image];
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 1;
    }];
}

- (IBAction)showMapView:(id)sender {
}

- (IBAction)blastAction:(id)sender {
}
@end
