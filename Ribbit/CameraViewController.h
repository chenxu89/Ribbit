//
//  CameraViewController.h
//  Ribbit
//
//  Created by 陈旭 on 15/9/4.
//  Copyright (c) 2015年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end
