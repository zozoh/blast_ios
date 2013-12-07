//
//  BTCameraViewController.m
//  Blast
//
//  Created by Steven Gao on 13-12-7.
//  Copyright (c) 2013年 Steven Gao. All rights reserved.
//

#import "BTCameraViewController.h"
#import "BTPostTextViewController.h"

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
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        self.imageView.center = CGPointMake(160, 240);
        [self.view addSubview:self.imageView];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(onNext:)];
	[self pickMediaFromSource:UIImagePickerControllerSourceTypeCamera];
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
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType ];
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:NULL];
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
    [self.navigationController pushViewController:ctr animated:YES];
    
}

#pragma mark - Image Picker Controller delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
     UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;
    self.postImage = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [[self navigationController] popViewControllerAnimated:YES];
    }];
}

@end






