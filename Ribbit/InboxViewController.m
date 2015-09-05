//
//  InboxViewController.m
//  Ribbit
//
//  Created by 陈旭 on 15/9/3.
//  Copyright (c) 2015年 陈旭. All rights reserved.
//

#import "InboxViewController.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"

@interface InboxViewController ()

@end

@implementation InboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Ribbit";
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"Current user: %@", currentUser.username);
    }
    else{
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query whereKey:@"recipientIds" equalTo:[[PFUser currentUser] objectId]];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else{
            // We found messages;
            self.messages = objects;
            [self.tableView reloadData];
            NSLog(@"Retrieved %lu messages", (unsigned long)[self.messages count]);
        }
    }];
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier isEqualToString:@"showLogin"]) {
        LoginViewController *loginViewController = segue.destinationViewController;
        //在登录页面和注册页面隐藏底部的tab bar
        [loginViewController setHidesBottomBarWhenPushed:YES];
        //在登录页面隐藏左上角的 back button
        loginViewController.navigationItem.hidesBackButton = YES;
    }
}

#pragma mark - Table view data source 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //显示发件人姓名
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
    cell.textLabel.text = [message objectForKey:@"senderName"];
    
    //在收件箱里显示图片或者视频图标
    NSString *fileType = [message objectForKey:@"fileType"];
    if ([fileType isEqualToString:@"image"]) {
        cell.imageView.image = [UIImage imageNamed:@"icon_image"];
    }
    else{
        cell.imageView.image = [UIImage imageNamed:@"icon_video"];
    }
    
    return cell;
}

@end
