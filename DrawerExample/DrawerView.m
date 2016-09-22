//
//  DrawerView.m
//  DrawerExample
//
//  Created by Marc Nieto on 9/4/16.
//  Copyright © 2016 KandidProductions. All rights reserved.
//

#import "DrawerView.h"
#import "MenuItemCollectionViewCell.h"

static const CGFloat kCellPadding = 0.0;
static const CGFloat rawWidth = 280.0;
static const CGFloat rawHeight = 667.0;

static NSString * const kCellIdentifier = @"MenuItemCollectionViewCell";

@implementation DrawerView {
    NSArray *images;
    NSArray *titles;
    NSMutableArray *cells;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(!self){
        return nil;
    }
    
    [[NSBundle mainBundle] loadNibNamed:@"DrawerView" owner:self options:nil];
    self.contentView.bounds = self.bounds;
    [self.contentView.layer setFrame:frame];
    [self addSubview:self.contentView];
    
    [self setupView];
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self){
        return nil;
    }
    
    [[NSBundle mainBundle] loadNibNamed:@"DrawerView" owner:self options:nil];
    self.contentView.bounds = self.bounds;
    [self addSubview:self.contentView];
    
    [self setupView];
    
    return self;
}

#pragma mark - setup views

-(void)setupView {
    images = [NSArray arrayWithObjects:@"cheeseburger", @"chickennuggets", @"frenchfries", @"salad", @"icecream", @"cookies", @"donuts", @"cheesecake", nil];
    titles = [NSArray arrayWithObjects:@"Cheeseburger", @"Chicken Nuggets", @"French Fries", @"Salad", @"Ice Cream", @"Cookies", @"Donuts", @"Cheesecake", nil];
    cells = [NSMutableArray array];
    
    [self setupLayout];
    [self setupCollectionView];
}

- (void)setupLayout {
    [self.headerLabel setFrame:[self makeLayoutRectFromRawFrame:self.headerLabel.frame]];
    [self.separator setFrame:[self makeLayoutRectFromRawFrame:self.separator.frame]];
    [self.collectionView setFrame:[self makeLayoutRectFromRawFrame:self.collectionView.frame]];
    
    CGFloat centerX = self.center.x;
    self.headerLabel.center = CGPointMake(centerX, 50);
    
    /* 1px separator adjustment */
    [self.separator setFrame:CGRectMake(self.separator.frame.origin.x, self.separator.frame.origin.y, self.separator.frame.size.width, 1.0)];
}

- (CGRect)makeLayoutRectFromRawFrame:(CGRect)frame {
    CGFloat widthOfView = self.contentView.bounds.size.width;
    CGFloat heightOfView = self.contentView.bounds.size.height;
    CGFloat layoutWidth = rawWidth;
    CGFloat layoutHeight = rawHeight;
    CGFloat x = frame.origin.x;
    CGFloat y = frame.origin.y;
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    
    CGFloat newX = (int)((x/layoutWidth) * widthOfView);
    CGFloat newY = (int)((y/layoutHeight) * heightOfView);
    CGFloat newWidth = (int)((width/layoutWidth) * widthOfView);
    CGFloat newHeight = (int)((height/layoutHeight) * heightOfView);
    
    return CGRectMake(newX, newY, newWidth, newHeight);
}

-(void)setupCollectionView
{

    UICollectionView *collectionView = self.collectionView;
    
    [collectionView registerNib:[UINib nibWithNibName:@"MenuItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:kCellIdentifier];
    
    collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [flowLayout setMinimumLineSpacing:kCellPadding];
    
    [collectionView setCollectionViewLayout:flowLayout];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
}

#pragma mark - collectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return titles.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItemCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    
    UIImage *image = [UIImage imageNamed:[images objectAtIndex:indexPath.row]];
    
    cell.image.image = image;
    cell.label.text = [titles objectAtIndex:indexPath.row];
    
    [cell setupLayout];
    [cells addObject:cell];
    
    return cell;
}

#pragma mark - collectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MenuItemCollectionViewCell *cell = [cells objectAtIndex:indexPath.row];
    [cell select];
    
    id <DrawerViewDelegate>delegate = self.delegate;
    
    if([delegate respondsToSelector:@selector(didSelectItem:withImage:)]) {
        [delegate didSelectItem:cell.label.text withImage:cell.image.image];
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (CGRectGetWidth(collectionView.bounds));
    CGFloat height = (int)(CGRectGetHeight(collectionView.bounds) / titles.count);
    
    return CGSizeMake(width, height);
}

#pragma mark - helpers

-(void)deselectAllCells
{
    for(MenuItemCollectionViewCell *cell in cells) {
        [cell deselect];
    }
}

@end
