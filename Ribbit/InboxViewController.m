//
//  InboxViewController.m
//  Ribbit
//
//  Created by 陈旭 on 15/9/3.
//  Copyright (c) 2015年 陈旭. All rights reserved.
//

#import "InboxViewController.h"
#import "LoginViewController.h"
#import "ImageViewController.h"

@interface InboxViewController ()

@end

@implementation InboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //And let's first allocate that movie player in our viewDidLoad method.That way, we can reuse the same one for all the videos in the inbox.
    self.moviePlayer = [[MPMoviePlayerController alloc] init];
    
    self.navigationItem.title = @"Ribbit";
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"Current user: %@", currentUser.username);
    }
    else{
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
            //NSLog(@"Retrieved %lu messages", (unsigned long)[self.messages count]);
        }
    }];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectedMessage = [self.messages objectAtIndex:indexPath.row];
    NSString *fileType = [self.selectedMessage objectForKey:@"fileType"];
    if ([fileType isEqualToString:@"image"]) {
        [self performSegueWithIdentifier:@"showImage" sender:self];
    }
    else{
        //File type is video
        PFFile *videoFile = [self.selectedMessage objectForKey:@"file"];
        NSURL *fileUrl = [NSURL URLWithString:videoFile.url];
        self.moviePlayer.contentURL = fileUrl;
        [self.moviePlayer prepareToPlay];
        
        //Right now it comes up with a blank screen before the video starts playing.We can display a thumbnail from the video instead
        [self.moviePlayer requestThumbnailImagesAtTimes:@[@0] timeOption:MPMovieTimeOptionNearestKeyFrame];
        
        // moviePlayer is a view, Add it to the view controller so we can see it
        [self.view addSubview:self.moviePlayer.view];
        [self.moviePlayer setFullscreen:YES animated:YES];//全屏播放，必须在addSubview之后
    }
    
    //Delete it!
    NSMutableArray *recipientIds = [NSMutableArray arrayWithArray:[self.selectedMessage objectForKey:@"recipientIds"]];
    //Let's log these recipients because we're going to watch them get deleted.
    NSLog(@"Recipients: %@", recipientIds);
    
    if ([recipientIds count] == 1) {
        //Last recipient - delete!
        [self.selectedMessage deleteInBackground];
    }
    else{
        // Remove the recipient and save it
        [recipientIds removeObject:[[PFUser currentUser] objectId]];
        [self.selectedMessage setObject:recipientIds forKey:@"recipientIds"];
        [self.selectedMessage saveInBackground];
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
    else if([segue.identifier isEqualToString:@"showImage"]){
        LoginViewController *loginViewController = segue.destinationViewController;
        //在登录页面和注册页面隐藏底部的tab bar
        [loginViewController setHidesBottomBarWhenPushed:YES];
        
        ImageViewController *imageViewController = (ImageViewController *)segue.destinationViewController;
        imageViewController.message = self.selectedMessage;
    }
}

@end
