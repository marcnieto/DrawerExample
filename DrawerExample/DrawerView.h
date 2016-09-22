//
//  DrawerView.h
//  DrawerExample
//
//  Created by Marc Nieto on 9/4/16.
//  Copyright © 2016 KandidProductions. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DrawerViewDelegate <NSObject>

- (void)didSelectItem:(NSString *)item
            withImage:(UIImage *)image;

@end

@interface DrawerView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak, nonatomic) id <DrawerViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (weak, nonatomic) IBOutlet UIView *separator;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

-(void)deselectAllCells;

@end
