//
//  BlastFirstViewController.h
//  Blast
//
//  Created by Changhai Jiang on 13-12-7.
//
//

#import <UIKit/UIKit.h>

@interface BlastMainViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *contentTable;
- (IBAction)startPostBlast:(id)sender;
- (IBAction)showNext:(id)sender;

@end
