//
//  ContainerViewControllerTwo.m
//
//  Created by Lucas Lorenzo Pena on 7/29/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import "ContainerViewControllerTwo.h"

#define SegueIdentifierCorners @"Corners"
#define SegueIdentifierConnects @"Connects"

@interface ContainerViewControllerTwo ()

@property (strong, nonatomic) NSString *currentSegueIdentifier;
@property (strong, nonatomic) CornersView *cVC;
@property (strong, nonatomic) ConnectsUserFeed *cuF;
@property (assign, nonatomic) BOOL transitionInProgress;


@end

@implementation ContainerViewControllerTwo
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
    self.currentSegueIdentifier = SegueIdentifierCorners;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Instead of creating new VCs on each seque we want to hang on to existing
    // instances if we have it. Remove the second condition of the following
    // two if statements to get new VC instances instead.
    if (([segue.identifier isEqualToString:SegueIdentifierCorners]) && !self.cVC) {
        self.cVC = segue.destinationViewController;
    }
    
    if (([segue.identifier isEqualToString:SegueIdentifierConnects]) && !self.cuF) {
        self.cuF = segue.destinationViewController;
    }
    
    // If we're going to the first view controller.
    if ([segue.identifier isEqualToString:SegueIdentifierCorners]) {
        // If this is not the first time we're loading this.
        if (self.childViewControllers.count > 0) {
            [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.cVC];
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
    else if ([segue.identifier isEqualToString:SegueIdentifierConnects]) {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.cuF];
    }
    /*else if ([segue.identifier isEqualToString:SegueIdentifierM]) {
        [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.maF];
    }*/
    
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
        if ([self.currentSegueIdentifier  isEqual: SegueIdentifierCorners]) {
            self.transitionInProgress = NO;
            return;
        }
        self.currentSegueIdentifier = SegueIdentifierCorners;
    }
    if ([numSwitch  isEqual: @2])
    {
        if ([self.currentSegueIdentifier  isEqual: SegueIdentifierConnects]) {
            self.transitionInProgress = NO;
            return;
        }
        self.currentSegueIdentifier = SegueIdentifierConnects;
    }
    /*if ([numSwitch  isEqual: @3])
    {
        if ([self.currentSegueIdentifier  isEqual: SegueIdentifierM]) {
            self.transitionInProgress = NO;
            return;
        }
        self.currentSegueIdentifier = SegueIdentifierM;
    }*/
    
    
    //self.currentSegueIdentifier = ([self.currentSegueIdentifier isEqualToString:SegueIdentifierV]) ? SegueIdentifierC : SegueIdentifierV;
    [self performSegueWithIdentifier:self.currentSegueIdentifier sender:nil];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 
 }*/

@end
