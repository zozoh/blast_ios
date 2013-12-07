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
#import "BlastItemCell.h"

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

- (IBAction)showNext:(id)sender {
    UIViewController* mapController = [[self storyboard] instantiateViewControllerWithIdentifier:@"MapViewController"];
    [[self navigationController] pushViewController:mapController animated:YES];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlastItemCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BlastItem"];
    if(cell == nil){
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController* controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"BlastShow"];
    [[self navigationController] pushViewController:controller animated:NO];
}

@end
