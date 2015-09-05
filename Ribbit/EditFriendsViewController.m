//
//  EditFriendsViewController.m
//  Ribbit
//
//  Created by 陈旭 on 15/9/4.
//  Copyright (c) 2015年 陈旭. All rights reserved.
//

#import "EditFriendsViewController.h"

@interface EditFriendsViewController ()

@end

@implementation EditFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //从parse获取所有user数据-username，将其显示在EditFriend界面
    PFQuery *query = [PFUser query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else{
            self.allUsers = objects;
            [self.tableView reloadData];
        }
    }];
    
    self.currentUser = [PFUser currentUser];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.allUsers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    if ([self isFriend:user]) {
        //add checkmark
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        //clear checkmark
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate

//将选中的用户user添加到朋友关系friendsRelation中
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    PFRelation *friendsRelation = [self.currentUser relationForKey:@"friendsRelation"];
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    
    if ([self isFriend:user]) {
    //if user tapped is a friend, remove them
        //1.Remove the checkmark
        cell.accessoryType = UITableViewCellAccessoryNone;
        //2.Remove from the array of friends(本地)
        //不能直接用[self.friends removeObject:user];因为user和friend在云端保存中可能不完全相同，这里我也搞的不是太清楚
        for (PFUser *friend in self.friends) {
            if ([friend.objectId isEqualToString:user.objectId]) {
                [self.friends removeObject:friend];
                break;
            }
        }
        
        //3.Remove from the backend（云端）
        [friendsRelation removeObject:user];
    
    }else{
    //else if user tapped is not a friend, add them
        //1.Add the checkmark
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        //2.Add to the array of friends(本地)
        [self.friends addObject:user];
        //3.Add to the backend（云端）
        [friendsRelation addObject:user];
    }
    
    //云端更新，用block为了异步
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeded, NSError *error){
        if (error) {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
    }];

}

#pragma mark - Helper methods

//判断每个user是否已经是friend
- (BOOL)isFriend:(PFUser *)user{
    for (PFUser *friend in self.friends) {
        if ([friend.objectId isEqualToString:user.objectId]) {
            return YES;
        }
    }
    return NO;
}



@end
