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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.navigationItem.title = @"Ribbit";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"Current user: %@", currentUser.username);
    }
    else{
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
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
@end
