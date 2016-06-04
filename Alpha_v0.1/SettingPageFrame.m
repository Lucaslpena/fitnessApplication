//
//  SettingPageFrame.m
//
//
//  Created by Lorenzo Pena on 9/24/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import "SettingPageFrame.h"

@implementation SettingPageFrame

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self sideAction:self];
    [[self navigationController] setNavigationBarHidden:YES];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.settingHeader.font = [UIFont fontWithName:@"Lato-Regular" size:18];

    [self.scrollViewContent setDelegate:self];
    if (([UserSingleton singleUser].tutorial % 2) == 1) {
        [UserSingleton singleUser].tutorial = [UserSingleton singleUser].tutorial - 1;
        [self initContentScroll];
    }
    else {
        self.scrollViewContent.hidden = YES;
        [self.scrollViewContent removeFromSuperview];
        self.pageControlContent.hidden = YES;
        [self.pageControlContent removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Side Bar
- (IBAction)sideAction:(id)sender
{
    [self.realSideBarButton addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - Scroll View
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollViewContent.frame.size.width;
    int page = floor((self.scrollViewContent.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControlContent.currentPage = page;
}
- (IBAction)changePage:(id)sender { //ContentScrollView
    CGRect frame;
    frame.origin.x = self.scrollViewContent.frame.size.width * self.pageControlContent.currentPage;
    frame.origin.y = 0;
    frame.size = self.scrollViewContent.frame.size;
    [self.scrollViewContent scrollRectToVisible:frame animated:YES];
    self.pageControlBeingUsed = YES;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([scrollView tag] == 1)
        self.pageControlBeingUsed = NO;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView tag] == 1)
        self.pageControlBeingUsed = NO;
}
-(void) initContentScroll
{
    for (int i = 0; i < 1; i++) {
        CGRect frame;
        frame.origin.x = self.scrollViewContent.frame.size.width * i;
        frame.origin.y = 0;
        frame.size = self.scrollViewContent.frame.size;
        UIView *subview = [[UIView alloc] initWithFrame:frame];
        subview.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        
        if (i ==0)
        {
            UIImageView *holderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 570)];
            [holderView setImage:[UIImage imageNamed:@"settings-0"]];
            [subview addSubview:holderView];
            [holderView sendSubviewToBack:subview];
            
            UIButton *exitButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 420, 260, 90)];
            [exitButton addTarget:self action:@selector(removePopup) forControlEvents:UIControlEventTouchUpInside];
            [subview addSubview:exitButton];
        }
        [self.scrollViewContent addSubview:subview];
    }
    
    self.scrollViewContent.contentSize = CGSizeMake(self.scrollViewContent.frame.size.width * 1, self.scrollViewContent.frame.size.height);
    self.pageControlBeingUsed = NO;
    CGRect frame = self.scrollViewContent.frame;
    frame.origin.x = frame.size.width * 0;
    frame.origin.y = 0;
    [self.scrollViewContent scrollRectToVisible:frame animated:YES];
}
-(void)removePopup
{
    [self.scrollViewContent removeFromSuperview];
}
@end
