//
//  HelloViewController.m
//  Blast
//
//  Created by Changhai Jiang on 13-12-7.
//
//

#import "HelloViewController.h"

@interface HelloViewController ()

@end

@implementation HelloViewController

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
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [NSTimer timerWithTimeInterval:3 target:self selector:@selector(nextPage) userInfo:nil repeats:false];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)nextPage
{
    NSLog(@"Next Page");
}

@end
