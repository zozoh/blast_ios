//
//  BlastMainTableViewController.h
//  Blast
//
//  Created by Changhai Jiang on 13-12-8.
//
//

#import <UIKit/UIKit.h>

@interface BlastMainTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>

-(void)appendNewSelfPost:(NSDictionary*) data;

@end
