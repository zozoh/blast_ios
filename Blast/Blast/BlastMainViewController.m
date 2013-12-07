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
#import "PGRequest.h"
#import "PGUtility.h"

@interface BlastMainViewController ()
@property NSMutableArray* blastList;
@end

@implementation BlastMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.blastList = [NSMutableArray array];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:NO];
}

-(void) onTimer {
    [self fetchNewBlast];
}

-(void) networkProblem
{
    
}

-(void)fetchNewBlast
{
    float gap = 1;
    //If data Change; Add to new;
    PGRequest* request = [[PGRequest alloc] init];
    [request startWithCompletionHandler:^(PGRequestConnection *connection, id result, NSError *error) {
        if(error){
            [self networkProblem];
            return;
        }
        NSDictionary* jsonData = [PGUtility simpleJSONDecode:result error:&error];
        
        //Check current is top?
        NSIndexPath *firstVisibleIndexPath = [[self.contentTable indexPathsForVisibleRows] objectAtIndex:0];
        if(firstVisibleIndexPath.row == 0){
            [NSTimer cancelPreviousPerformRequestsWithTarget:self selector:@selector(onTimer) object:nil];
            [NSTimer scheduledTimerWithTimeInterval:gap target:self selector:@selector(onTimer) userInfo:nil repeats:NO];
        };

        NSMutableArray* all = [jsonData[@"data"] mutableCopy];
        if(all != nil && [all count] > 0)
        {
            [all addObjectsFromArray:self.blastList];
            self.blastList = all;
            [[self contentTable] reloadData];
        }
    }];
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
    // return [self.blastList count];
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlastItemCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BlastItem"];
    [cell startCountDown:300];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlastSecondViewController* controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"BlastShow"];
    controller.image = [(BlastItemCell*)[tableView cellForRowAtIndexPath:indexPath] smallpic].image;
    [[self navigationController] pushViewController:controller animated:NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSIndexPath *firstVisibleIndexPath = [[self.contentTable indexPathsForVisibleRows] objectAtIndex:0];
    if(firstVisibleIndexPath.row == 0){
        [self fetchNewBlast];
    }
}

@end
