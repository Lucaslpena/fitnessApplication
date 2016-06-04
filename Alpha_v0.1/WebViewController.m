//
//  WebViewController.m
//
//
//  Created by Lorenzo Pena on 9/24/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *fullURL = self.webAddress;
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    [self.webView.scrollView setBounces:NO];
}

@end
