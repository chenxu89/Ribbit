//
//  ImageViewController.h
//  Ribbit
//
//  Created by 陈旭 on 15/9/5.
//  Copyright (c) 2015年 陈旭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ImageViewController : UIViewController

@property (nonatomic, strong) PFObject *message;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
