//
//  BTCameraViewController.m
//  Blast
//
//  Created by Steven Gao on 13-12-7.
//  Copyright (c) 2013年 Steven Gao. All rights reserved.
//

#import "BTCameraViewController.h"
#import "BTPostTextViewController.h"
#import "BlastNetworkClient.h"
#import "UIImageView+AFNetworking.h"

@interface BTCameraViewController ()

@property (nonatomic,strong) UIImageView *imageView;

@property (nonatomic,strong)UIImage *postImage;

@end

@implementation BTCameraViewController

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
    if (!self.imageView) {
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 600)];
        self.imageView.center = CGPointMake(160, 240);
        [self.view addSubview:self.imageView];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(onNext:)];
	[self pickMediaFromSource:UIImagePickerControllerSourceTypeCamera];
    
    self.imageView.image = nil;
    [self.imageView cancelImageRequestOperation];
    
    NSURL *imageURL = [[BlastNetworkClient shareClient] generateImageURL:@"46b6e47637f8ec0090ddebadcecff49d215be3fa"];
    [self.imageView setImageWithURL:imageURL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)pickMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType ];
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]&&[mediaTypes count]>0) {

        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        
        UIView *overlayView = [[UIView alloc]initWithFrame:picker.view.frame];
        overlayView.backgroundColor = [UIColor grayColor];
        [overlayView.layer setOpacity:0.5];
        
        [self presentViewController:picker animated:NO completion:NULL];
    }
    else {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"Error accessing media"
                                   message:@"Device doesn’t support that media source."
                                  delegate:nil
                         cancelButtonTitle:@"Dismiss"
                         otherButtonTitles:nil];
        [alert show];
    }
}

-(void)onNext:(id)sender
{
    BTPostTextViewController *ctr = [[BTPostTextViewController alloc]init];
    ctr.postImage = self.postImage;
    
    [self.navigationController pushViewController:ctr animated:YES];
//    [self.navigationController popToViewController:self animated:NO];
    
}

#pragma mark - Image Picker Controller delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
     UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = chosenImage;
    self.postImage = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:NO completion:^{
        [self performSelector:@selector(pop:) withObject:self afterDelay:0.2f];
    }];
    
}

-(void)pop:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype =kCATransitionFromRight;
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    
    [[self navigationController] popViewControllerAnimated:YES];
}

@end






