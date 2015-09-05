//
//  InboxViewController.h
//  Ribbit
//
//  Created by 陈旭 on 15/9/3.
//  Copyright (c) 2015年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface InboxViewController : UITableViewController

@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) PFObject *selectedMessage;

- (IBAction)logout:(id)sender;

@end
