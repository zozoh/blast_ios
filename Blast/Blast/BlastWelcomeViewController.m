//
//  BlastWelcomeViewController.m
//  Blast
//
//  Created by Changhai Jiang on 13-12-7.
//
//

#import "BlastWelcomeViewController.h"
#import "PGRequest.h"
#import "BlastAppDelegate.h"
#import "PGUtility.h"

@interface BlastWelcomeViewController ()
@property BOOL isDownloading;
@end

@implementation BlastWelcomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    NSString* userName = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    self.isDownloading = false;
    if(userName == nil){
        __weak BlastWelcomeViewController* sellf = self;
        self.isDownloading = true;
        PGRequest* request = [PGRequest requestForUserName: app.uniqueIdentifier];
        [request startWithCompletionHandler:^(PGRequestConnection *connection, id result, NSError *error) {
            NSDictionary* resultJson = result;
            if(!error){
                app.userName = resultJson[@"data"];
                [[NSUserDefaults standardUserDefaults] setObject:app.userName forKey:@"username"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                sellf.isDownloading = false;
                [NSTimer cancelPreviousPerformRequestsWithTarget:self selector:@selector(nextPage) object:nil];
                [sellf nextPage];
            }
        }];
    }else{
        app.userName = userName;
    }
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextPage) userInfo:nil repeats:false];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)nextPage
{
    if(!self.isDownloading)
        [self performSegueWithIdentifier:@"start" sender:self];
}

@end
