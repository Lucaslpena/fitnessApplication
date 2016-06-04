//
//  ContainerViewController.m
//  Alpha_v0.1
//
//  Created by Lucas L. Pena on 4/15/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, LLC. All rights reserved.
//

#import "ContainerViewController.h"

#define SegueIdentifierP @"PairUp"
#define SegueIdentifierM @"MyAds"

#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE

@interface ContainerViewController ()

@property (strong, nonatomic) NSString *currentSegueIdentifier;
@property (strong, nonatomic) PairUpFeed *puF;
@property (strong, nonatomic) MyAdsFeed *maF;
@property (assign, nonatomic) BOOL transitionInProgress;


@end

@implementation ContainerViewController

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
    self.transitionInProgress = NO;
    self.currentSegueIdentifier = SegueIdentifierP;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Instead of creating new VCs on each seque we want to hang on to existing
    // instances if we have it. Remove the second condition of the following
    // two if statements to get new VC instances instead.

    if (([segue.identifier isEqualToString:SegueIdentifierP]) && !self.puF) {
        self.puF = segue.destinationViewController;
    }
    
    if (([segue.identifier isEqualToString:SegueIdentifierM]) && !self.maF) {
        self.maF = segue.destinationViewController;
    }
    
    // If we're going to the first view controller.
    if ([segue.identifier isEqualToString:SegueIdentifierP]) {
        // If this is not the first time we're loading this.
        if (self.childViewControllers.count > 0) {
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.puF];
        }
        else {
            // If this is the very first time we're loading this we need to do
            // an initial load and not a swap.
            [self addChildViewController:segue.destinationViewController];
            UIView* destView = ((UIViewController *)segue.destinationViewController).view;
            destView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            destView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.view addSubview:destView];
            [segue.destinationViewController didMoveToParentViewController:self];
        }
    }
    // By definition the second view controller will always be swapped with the
    // first one.
    else if ([segue.identifier isEqualToString:SegueIdentifierM]) {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.maF];
    }
    
}

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController
{
    toViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    
    [self transitionFromViewController:fromViewController toViewController:toViewController duration:0.5 options:UIViewAnimationOptionCurveEaseOut animations:nil completion:^(BOOL finished) {
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
        self.transitionInProgress = NO;
    }];
}

- (void)swapViewControllers:(NSNumber *) numSwitch
{
    if (self.transitionInProgress) {
        return;
    }
    
    self.transitionInProgress = YES;
    if ([numSwitch  isEqual: @1])
    {
        if ([self.currentSegueIdentifier  isEqual: SegueIdentifierP]) {
            self.transitionInProgress = NO;
            return;
        }
        self.currentSegueIdentifier = SegueIdentifierP;
    }
    if ([numSwitch  isEqual: @2])
    {
        if ([self.currentSegueIdentifier  isEqual: SegueIdentifierM]) {
            self.transitionInProgress = NO;
            return;
        }
        self.currentSegueIdentifier = SegueIdentifierM;
    }
    
    
    //self.currentSegueIdentifier = ([self.currentSegueIdentifier isEqualToString:SegueIdentifierV]) ? SegueIdentifierC : SegueIdentifierV;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}*/

@end
