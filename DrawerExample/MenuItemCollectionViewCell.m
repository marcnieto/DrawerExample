//
//  MenuItemCollectionViewCell.m
//  DrawerExample
//
//  Created by Marc Nieto on 9/20/16.
//  Copyright © 2016 KandidProductions. All rights reserved.
//

#import "MenuItemCollectionViewCell.h"

static const CGFloat rawWidth = 240.0;
static const CGFloat rawHeight = 50.0;


@implementation MenuItemCollectionViewCell

- (void)setupLayout {
    [self.image setFrame:[self makeLayoutRectFromRawFrame:self.image.frame]];
    [self.label setFrame:[self makeLayoutRectFromRawFrame:self.label.frame]];
    
    [self.label sizeToFit];
    
    self.image.layer.cornerRadius = self.image.frame.size.width / 2;
    self.image.layer.masksToBounds = YES;
    
    CGFloat centerY = (int)(self.bounds.size.height / 2);
    self.image.center = CGPointMake(self.image.center.x, centerY);
    self.label.center = CGPointMake(self.label.center.x, centerY);
}

- (CGRect)makeLayoutRectFromRawFrame:(CGRect)frame {
    CGFloat widthOfView = self.frame.size.width;
    CGFloat heightOfView = self.frame.size.height;
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

- (void)select {
    self.backgroundColor = [UIColor colorWithRed:100.0f/255.0f
                                           green:100.0f/255.0f
                                            blue:100.0f/255.0f
                                           alpha:1.0f];;
}

- (void)deselect {
    self.backgroundColor = [UIColor colorWithRed:38.0f/255.0f
                                           green:38.0f/255.0f
                                            blue:38.0f/255.0f
                                           alpha:1.0f];;
}

@end
