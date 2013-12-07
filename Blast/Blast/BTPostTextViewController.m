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
        self.textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 70, 300, 200)];
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Send" style:UIBarButtonItemStyleBordered target:self action:@selector(onSend:)];


}

-(void)onSend:(id)sender
{
    self.postImage = [UIImage imageNamed:@"123.jpg"];
    PGRequest *request = [PGRequest blastWithImageData:self.postImage text:self.textView.text userID:@"121"];
    [request startWithCompletionHandler:^(PGRequestConnection *connection, id result, NSError *error) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = (NSDictionary*)result;
            NSString *_id = [NSString stringWithFormat:@"%@",[dict objectForKey:@"_id"]];
            NSString *_url = [NSString stringWithFormat:@"%@",[dict objectForKey:@"url"]];
            
            NSMutableDictionary *obj = [[NSMutableDictionary alloc]init];
            [obj setValue:_id forKey:@"_id"];
            [obj setValue:_url forKey:@"picurl"];
            [obj setValue:[NSNumber numberWithInt:300] forKey:@"live"];
            [obj setValue:[NSString stringWithFormat:@"[%f,%f]",113.317290f,23.134844f] forKey:@"location"];
            [obj setValue:[NSNumber numberWithInt:897] forKey:@"reblaNumber"];
            [obj setValue:@"hello" forKey:@"content"];
            PGRequest *req = [PGRequest requestForBlast:obj];
            [req startWithCompletionHandler:^(PGRequestConnection *connection, id result, NSError *error) {
                
            }];
            
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
