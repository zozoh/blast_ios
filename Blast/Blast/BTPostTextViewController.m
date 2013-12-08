//
//  BTPostTextViewController.m
//  Blast
//
//  Created by Steven Gao on 13-12-7.
//  Copyright (c) 2013年 Steven Gao. All rights reserved.
//

#import "BTPostTextViewController.h"
#import "PGRequest.h"

@interface BTPostTextViewController ()<UITextViewDelegate>

@property (nonatomic,strong)UIView *activityIndicatorView;
@property (nonatomic,strong)UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic,strong) UIImageView *zoneView;

@end

@implementation BTPostTextViewController

@synthesize postImage = _postImage;

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
    if (!self.textView) {
        self.textView = [[UITextView alloc]initWithFrame:CGRectMake(140, 100, 220, 60)];
        self.textView.contentInset = UIEdgeInsetsMake(-70, 5, 0, 0);
        self.textView.showsHorizontalScrollIndicator = NO;
        self.textView.showsVerticalScrollIndicator = NO;
        [self.textView.layer setCornerRadius:5];
        [self.textView setBackgroundColor:[UIColor whiteColor]];
        [self.textView becomeFirstResponder];
        
        self.textView.delegate = self;
        self.view.backgroundColor = [UIColor grayColor];
        //    self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:self.textView];
    }
    
    if (!self.imageView) {
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
//        self.imageView.image = self.postImage;
        [self.view addSubview:self.imageView];
    }
    
    
    if (!self.zoneView) {
        self.zoneView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 80, 320, 540)];
        UIImage *image = [UIImage imageNamed:@"zone.png"];
        self.zoneView.image = image;
        [self.view addSubview:self.zoneView];
    }
    
    self.view.backgroundColor = [UIColor colorWithRed:239 green:244 blue:244 alpha:1];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Send" style:UIBarButtonItemStyleBordered target:self action:@selector(onSend:)];


}

-(void)onSend:(id)sender
{
    [self startAnimatingPhotoLoadingIndicator];
    PGRequest *request = [PGRequest requestForPostImageData:self.postImage];
    [request startWithCompletionHandler:^(PGRequestConnection *connection, id result, NSError *error) {
        if (!error&&[result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)[(NSDictionary*)result objectForKey:@"data"];
            NSString *_id = [NSString stringWithFormat:@"%@",[dict objectForKey:@"_id"]];
            NSLog(@"id:%@",_id);
           
            NSLog(@"%@",dict);
            NSMutableDictionary *obj = [[NSMutableDictionary alloc]init];
            [obj setValue:_id forKey:@"picture"];
            [obj setValue:[NSNumber numberWithInt:300] forKey:@"live"];
            [obj setValue:[NSString stringWithFormat:@"[%f,%f]",113.317290f,23.134844f] forKey:@"location"];
            [obj setValue:[NSNumber numberWithInt:897] forKey:@"reblaNumber"];
            [obj setValue:self.textView.text forKey:@"content"];
            PGRequest *req = [PGRequest requestForBlast:obj];
            [req startWithCompletionHandler:^(PGRequestConnection *connection, id result, NSError *error) {
                if (!error && [result isKindOfClass:[NSDictionary class]]) {
                    [self stopAnimatingPhotoLoadingIndicator];
                    NSLog(@"%@",result);
                }
                else
                {
                    [self stopAnimatingPhotoLoadingIndicator];
                }
            }];
            
        }
        else
        {
            [self stopAnimatingPhotoLoadingIndicator];
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)startAnimatingPhotoLoadingIndicator
{
    CGRect cellBounds = self.view.bounds;
    if (!self.activityIndicatorView) {
        self.activityIndicatorView = [[UIView alloc]initWithFrame:self.view.bounds];
        self.activityIndicatorView.alpha = 0.2;
        self.activityIndicatorView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:self.activityIndicatorView];
        
        self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityIndicator.hidesWhenStopped = YES;

        self.activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin;
        [self.activityIndicatorView addSubview:self.activityIndicator];
        

        
    }
    self.activityIndicatorView.hidden = NO;
    self.activityIndicator.center = CGPointMake(CGRectGetMidX(cellBounds), CGRectGetMidY(cellBounds)*0.7);
    [self.activityIndicator startAnimating];
}

-(void)stopAnimatingPhotoLoadingIndicator{
    if (self.activityIndicatorView) {
        [self.activityIndicator stopAnimating];
        [self.activityIndicatorView setHidden:YES];
    }
}


#pragma mark TextViewDelegate

//fix IOS7 cusor outside bug
-(void)textViewDidChangeSelection:(UITextView *)textView
{
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        if ([textView.text characterAtIndex:textView.text.length-1] != ' ') {
            textView.text = [textView.text stringByAppendingString:@" "];
        }
        
        NSRange range0 = textView.selectedRange;
        NSRange range = range0;
        if (range0.location == textView.text.length) {
            range = NSMakeRange(range0.location - 1, range0.length);
        } else if (range0.length > 0 &&
                   range0.location + range0.length == textView.text.length) {
            range = NSMakeRange(range0.location, range0.length - 1);
        }
        if (!NSEqualRanges(range, range0)) {
            textView.selectedRange = range;
        }
    }
}


@end
