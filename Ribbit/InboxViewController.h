//
//  InboxViewController.h
//  Ribbit
//
//  Created by 陈旭 on 15/9/3.
//  Copyright (c) 2015年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InboxViewController : UITableViewController

@property (nonatomic, strong) NSArray *messages;

- (IBAction)logout:(id)sender;

@end
