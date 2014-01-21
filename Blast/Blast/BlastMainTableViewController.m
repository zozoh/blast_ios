//
//  BlastMainTableViewController.m
//  Blast
//
//  Created by Changhai Jiang on 13-12-8.
//
//

#import "BlastMainTableViewController.h"
#import "BlastSecondViewController.h"
#import "BlastItemCell.h"
#import "BlastAppDelegate.h"

@interface BlastMainTableViewController ()
@property (nonatomic,strong) NSMutableArray* blastList;
@property (nonatomic,strong) UIRefreshControl *refresh;
@property (nonatomic,strong) NSString* lastBid;
@end

@implementation BlastMainTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.blastList = [NSMutableArray array];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:NO];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    self.refresh = [[UIRefreshControl alloc] init];
    self.refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [self.refresh addTarget:self action:@selector(fetchNewBlast)
           forControlEvents:UIControlEventValueChanged];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    self.refreshControl = self.refresh;
}

- (void)stopRefresh
{
    [self.refreshControl endRefreshing];
}

-(void) onTimer {
    [self fetchNewBlast];
}

-(void) networkProblem
{
    
}

-(void)appendNewSelfPost:(NSDictionary*) data
{
    [self.blastList insertObject:data atIndex:0];
    [[self tableView] reloadData];
}

-(void)fetchNewBlast
{
    float gap = 1;
    //If data Change; Add to new;
    __weak BlastMainTableViewController* sellf = self;
    [app fetchLastestBlast:self.lastBid block:^(id result) {
        //Check current is top?
        if([sellf.blastList count] > 0){
            NSIndexPath *firstVisibleIndexPath = [[sellf.tableView indexPathsForVisibleRows] objectAtIndex:0];
            if(firstVisibleIndexPath.row == 0){
                [NSTimer cancelPreviousPerformRequestsWithTarget:sellf selector:@selector(onTimer) object:nil];
                [NSTimer scheduledTimerWithTimeInterval:gap target:sellf selector:@selector(onTimer) userInfo:nil repeats:NO];
            };
        }
        
        NSMutableArray* all = [NSMutableArray array];
        for (NSDictionary* data in result) {
            NSDictionary* dataAdd = [data mutableCopy];
            int val =  (arc4random() % 30);
            [dataAdd setValue:[NSDate dateWithTimeIntervalSinceNow: - val] forKey:@"CountDown"];
            BOOL isSame = false;
            for(NSDictionary* item in sellf.blastList){
                if([dataAdd[@"_id"] isEqualToString:item[@"_id"]]){
                    isSame = true;
                }
            }
            if(!isSame)
                [all addObject:dataAdd];
        }
        
        if(all != nil && [all count] > 0)
        {
            sellf.lastBid = [all firstObject][@"_id"];
            [all addObjectsFromArray:sellf.blastList];
            sellf.blastList = all;
            [[sellf tableView] reloadData];
        }
        
        [sellf performSelector:@selector(stopRefresh) withObject:nil afterDelay:2.5];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.blastList count];
    // return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlastItemCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BlastItem"];
    if(self.blastList && self.blastList.count > indexPath.row){
        cell.data = (NSDictionary*) self.blastList[indexPath.row];
        [cell reset];
    }
    [cell startCountDown];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlastSecondViewController* controller = [[self storyboard] instantiateViewControllerWithIdentifier:@"BlastShow"];
    controller.image = [(BlastItemCell*)[tableView cellForRowAtIndexPath:indexPath] smallImg];
    controller.currentData = [(BlastItemCell*)[tableView cellForRowAtIndexPath:indexPath] data];
    [[self navigationController] pushViewController:controller animated:NO];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if([self.blastList count] > 0){
        NSIndexPath *firstVisibleIndexPath = [[self.tableView indexPathsForVisibleRows] objectAtIndex:0];
        if(firstVisibleIndexPath.row == 0){
            [self fetchNewBlast];
            
        }
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
