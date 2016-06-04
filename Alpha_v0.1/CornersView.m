//
//  CornersView.m
//
//  Created by Lucas Lorenzo Pena on 7/29/14.
//  Copyright (c) 2014 Lucas Lorenzo Pena, All rights reserved.
//

#import "CornersView.h"

@interface CornersView ()

@end

@implementation CornersView {
    NSMutableArray *cornerList;
    NSMutableDictionary *selectedDict;
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
    [self.navigationController setNavigationBarHidden:YES];
    cornerList = [[NSMutableArray alloc] initWithCapacity:1];
    [cornerList addObject:@"add group"];
    [[PFUser currentUser] refresh];
    [cornerList addObjectsFromArray: [PFUser currentUser][@"conerArray"] ];
    self.connectsCollectionView.backgroundColor = [UIColor colorWithWhite:1 alpha:.0];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 507)];
    backgroundImage.image = [UIImage imageNamed:@"bph_1136"];
    backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    [[PFUser currentUser] refresh];
    [cornerList addObjectsFromArray: [PFUser currentUser][@"cornerArray"] ];
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

#pragma mark Collection View Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [cornerList count];
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CornerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImage *image;
    NSString *cornerTitle = [[NSString alloc] init];
    if ([cornerList[indexPath.row] isKindOfClass:[NSString class]])
    {
        image = [UIImage imageNamed:@"friends_grey"];
        cell.backgroundColor = [UIColor lightGrayColor];
        cell.alpha = .87f;
        cornerTitle = @"Add Corner";
        //sNSArray *empty;
        //[cell generateCircles:empty];
    }
    else
    {
//UIImage *small = [UIImage imageWithCGImage:original.CGImage scale:0.25 orientation:original.imageOrientation];
        NSString *title = [(NSMutableDictionary *)cornerList[indexPath.row] objectForKey:@"name"];
        NSString *activity = [(NSMutableDictionary *)cornerList[indexPath.row] objectForKey:@"activity"];
        if (!activity) {
            activity = @"Teal_U";
        }
        image = [UIImage imageNamed:activity];
        cornerTitle = title;
        cell.backgroundColor = [UIColor colorWithWhite:1 alpha:.8];
        NSArray *givenUsers = [cornerList[indexPath.row] objectForKey:@"users"];
        [PFObject fetchAllIfNeeded:givenUsers];
        int limit = givenUsers.count;
        if (limit > 10)
                limit = 9;
        CGFloat Xrange = 20;
        CGFloat Yrange = 100;
        for (int i = 0; i < limit; ++i)
        {
            CGRect frame = CGRectMake(Xrange, Yrange, 20, 20);
            UIImageView *circle = [[UIImageView alloc] initWithFrame:frame];
            circle.image = [UIImage imageNamed:@"NoPicture"];
            circle.layer.cornerRadius = circle.frame.size.height/2;
            circle.layer.masksToBounds = YES;
            circle.layer.borderWidth = 0;
            //[givenUsers[i] fetch];
            //PFFile *profilePic = givenUsers[i][@"profilePic"];
            //NSData * data =[profilePic getData];
            //circle.image = [UIImage imageWithData:data];
            circle.contentMode = UIViewContentModeScaleAspectFit;
            Xrange += 25;
            if (i == 4)
            {
                Xrange = 20;
                Yrange += 25;
            }
            [cell addSubview:circle];
        }
    }
    cell.cornerName.text = cornerTitle;
    cell.cornerName.textColor = [UIColor colorWithRed:0/255.0 green:57/255.0 blue:77/255.0 alpha:1.0];
    cell.cornerName.font = [UIFont fontWithName:@"Lato-Bold" size:14];
    cell.activityImage.image = image;
    cell.activityImage.alpha= 1;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cornerList[indexPath.row] isKindOfClass:[NSString class]]) {
        [self performSegueWithIdentifier:@"viewDetail-Create" sender:self];
    }else{
        selectedDict = [[NSMutableDictionary alloc] initWithDictionary:[cornerList objectAtIndex:indexPath.row]];
        [self performSegueWithIdentifier:@"viewDetail-Modify" sender:self];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"viewDetail-Create"]) {
        
    }
    else if ([[segue identifier] isEqualToString:@"viewDetail-Modify"]) {
        CornersDetailViewController *cDVC = [segue destinationViewController];
        [cDVC setCornerObject:selectedDict];
    }
}
@end