//
//  CreatePosts.m
//
//  Created by Lucas L. Pena on 6/10/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, LLC. All rights reserved.
//

#import "CreatePosts.h"

@interface CreatePosts ()

@end

@implementation CreatePosts
{
    UIColor* teal;
    BOOL createSwitch;
    CreatePairUp *cpu;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    teal = [[UIColor alloc]
                    initWithRed: 47/255.0
                    green:      190/255.0
                    blue:       190/255.0
                    alpha:      1.0];
    CGRect popupFrame;
    popupFrame.origin = self.view.frame.origin;
    popupFrame.size = CGSizeMake(283.5, 450);
    self.view.frame = popupFrame;
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.view.layer.borderWidth = 2.0f;
    PairUpAd *newObject = [[PairUpAd alloc] init];
    [[UserSingleton singleUser] setMyPairUpAd:newObject];
    [UserSingleton singleUser].myPairUpAd.active = YES;
}

- (void) viewDidAppear:(BOOL)animated
{
    [self displayPairView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissPopup {
    [self dismissPopupViewControllerAnimated:YES completion:^(void){
        NSLog(@"Post Created"); }];
}

- (void) displayPairView
{
    cpu = [[CreatePairUp alloc]initWithFrame:CGRectMake(2, 0, 280, 455)];
    [self.view addSubview:cpu];
}

@end
