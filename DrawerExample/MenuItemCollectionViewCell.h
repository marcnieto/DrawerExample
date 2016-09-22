//
//  MenuItemCollectionViewCell.h
//  DrawerExample
//
//  Created by Marc Nieto on 9/20/16.
//  Copyright © 2016 KandidProductions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuItemCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *label;

-(void)setupLayout;
-(void)select;
-(void)deselect;

@end
