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

//阅后即焚
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //加入if else只是一种避免出现这种方法缺失错误的预防办法，在这里可以不用加
    if ([self respondsToSelector:@selector(timeout)]) {
        [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(timeout) userInfo:nil repeats:NO];
    }
    else{
        NSLog(@"Error: seletor missing!");
    }
}

#pragma mark - Helper methods

- (void)timeout{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
