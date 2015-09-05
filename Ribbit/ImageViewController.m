//
//  ImageViewController.m
//  Ribbit
//
//  Created by 陈旭 on 15/9/5.
//  Copyright (c) 2015年 陈旭. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //download image from parse.com
    PFFile *imageFile = [self.message objectForKey:@"file"];
    NSURL *imageFileUrl = [[NSURL alloc] initWithString:imageFile.url];
    NSData *imageData = [NSData dataWithContentsOfURL:imageFileUrl];
    self.imageView.image = [UIImage imageWithData:imageData];
    
    //Let's add a title for this view controller
    NSString *senderName = [self.message objectForKey:@"senderName"];
    self.navigationItem.title = senderName;
}


@end
