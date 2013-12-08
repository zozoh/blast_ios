//
//  BlastItemCell.h
//  Blast
//
//  Created by Changhai Jiang on 13-12-7.
//
//

#import <UIKit/UIKit.h>

@interface BlastItemCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *receiveTime;
@property (strong, nonatomic) IBOutlet UILabel *blastCount;
@property (strong, nonatomic) IBOutlet UIView *timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *caption;
@property (strong, nonatomic) IBOutlet UIImageView *smallpic;
@property (strong, nonatomic) IBOutlet UIButton *blastBtn;
@property (strong, nonatomic) NSDictionary* data;
@property (strong, nonatomic) UIImage* smallImg;
//@property (strong,nonatomic) IBOutlet UIButton *
-(void)startCountDown;
-(void)reset;
-(void)clickToBlast;
@end
