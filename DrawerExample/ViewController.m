//
//  ViewController.m
//  DrawerExample
//
//  Created by Marc Nieto on 9/2/16.
//  Copyright © 2016 KandidProductions. All rights reserved.
//

#import "ViewController.h"
#import "DrawerView.h"

static const CGFloat rawWidth = 375.0;
static const CGFloat rawHeight = 667.0;
static const CGFloat menuOffsetX = 40.0;

@interface ViewController () <UIGestureRecognizerDelegate, DrawerViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *statusBarView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBarAttributes;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (strong, nonatomic) UIView *drawerStatusBarView;
@property (strong, nonatomic) DrawerView *drawerView;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property BOOL menuToggled;

@end

@implementation ViewController {
    CGFloat widthOfView;
    CGFloat heightOfView;
    CGPoint originalCenter;
    CGFloat originalX;
    CGPoint originalMenuCenter;
    CGFloat drawerViewWidth;
    BOOL markCompleteOnSwipeRelease;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setupLayout];
    [self setupLeftBarButton];
    [self setupDrawerView];
    [self setupGesture];
    
    self.menuToggled = NO;
}

#pragma mark - Setup

- (void)setupLayout {
    /* Screen Bounds */
    widthOfView = self.view.bounds.size.width;
    heightOfView = self.view.bounds.size.height;
    CGFloat heightOfStatusBar = UIApplication.sharedApplication.statusBarFrame.size.height;
    
    /* UI framing */
    [self.contentView setFrame:CGRectMake(0, 0, widthOfView, heightOfView)];
    [self.statusBarView setFrame:CGRectMake(0, 0, widthOfView, heightOfStatusBar)];
    [self.navBar setFrame:CGRectMake(0, heightOfStatusBar, widthOfView, 45.0)];
    [self.imageView setFrame:[self makeLayoutRectFromRawFrame:self.imageView.frame]];
    [self.label setFrame:[self makeLayoutRectFromRawFrame:self.label.frame]];
    
    self.imageView.center = self.contentView.center;
    self.imageView.layer.cornerRadius = self.imageView.frame.size.height / 2;
    self.imageView.layer.borderColor = [UIColor grayColor].CGColor;
    self.imageView.layer.borderWidth = 0.5;
    self.imageView.layer.masksToBounds = YES;
    
    self.label.text = @"Click the drawer button or swipe right to engage the menu";
    [self.label sizeToFit];
    self.label.center = CGPointMake(widthOfView / 2, self.label.center.y);
    
    self.imageView.hidden = YES;
    
    self.navBarAttributes.title = @"Kandid Diner";
    
    self.drawerStatusBarView = [[UIView alloc] initWithFrame:self.statusBarView.frame];
    self.drawerStatusBarView.backgroundColor = [UIColor colorWithRed:38.0/255 green:38.0/255 blue:38.0/255 alpha:1.0];
    [self.contentView insertSubview:self.drawerStatusBarView belowSubview:self.statusBarView];
}

- (void)setupLeftBarButton {
    /* Left Drawer Button Setup */
    UIButton *leftDrawerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 18, 22)];
    [leftDrawerButton setBackgroundImage:[self defaultMenuImage] forState:UIControlStateNormal];
    [leftDrawerButton addTarget:self action:@selector(toggleLeftDrawer)
               forControlEvents:UIControlEventTouchUpInside];
    [leftDrawerButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *leftDrawerBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftDrawerButton];
    self.navBarAttributes.leftBarButtonItem = leftDrawerBarButton;
}

- (void)setupDrawerView {
    /* Setup Drawer View */
    self.drawerView = [[DrawerView alloc] initWithFrame:CGRectMake(0, 0, 0.75 * self.contentView.frame.size.width, self.contentView.frame.size.height)];
    
    drawerViewWidth = 0.75 * self.contentView.frame.size.width;
    [self.drawerView setFrame:CGRectMake(-40, 0, drawerViewWidth, self.contentView.frame.size.height)];
    
    self.drawerView.delegate = self;
    [self.view insertSubview:self.drawerView belowSubview:self.contentView];
}

- (void)setupGesture {
    /* Pan Gesture Setup */
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandler:)];
    self.panGestureRecognizer.delegate = self;
    [self.contentView addGestureRecognizer:self.panGestureRecognizer];
}

/* creates a drawer image asset */
- (UIImage *)defaultMenuImage {
    
    UIImage *defaultMenuImage = [[UIImage alloc] init];
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(18, 22), false, 0.0);
    
    [[UIColor whiteColor] setFill];
    
    [[UIBezierPath bezierPathWithRect:CGRectMake(0, 4, 18, 1)] fill];
    [[UIBezierPath bezierPathWithRect:CGRectMake(0, 5, 18, 1)] fill];
    [[UIBezierPath bezierPathWithRect:CGRectMake(0, 6, 18, 1)] fill];
    [[UIBezierPath bezierPathWithRect:CGRectMake(0, 10, 18, 1)] fill];
    [[UIBezierPath bezierPathWithRect:CGRectMake(0, 11, 18, 1)] fill];
    [[UIBezierPath bezierPathWithRect:CGRectMake(0, 12, 18, 1)] fill];
    [[UIBezierPath bezierPathWithRect:CGRectMake(0, 16, 18, 1)] fill];
    [[UIBezierPath bezierPathWithRect:CGRectMake(0, 17, 18, 1)] fill];
    [[UIBezierPath bezierPathWithRect:CGRectMake(0, 18, 18, 1)] fill];
    
    defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return defaultMenuImage;
}

/* helper for translating storyboard raw frames into phone-compatible frames */
- (CGRect)makeLayoutRectFromRawFrame:(CGRect)frame {
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

#pragma mark - DrawerView

/* open closes drawer */
-(void)toggleLeftDrawer {
    CGRect frame;
    CGRect menuFrame;
    CGFloat statusBarAlpha;
    
    if(!self.menuToggled){
        frame = CGRectMake(drawerViewWidth, 0, widthOfView, heightOfView);
        menuFrame = CGRectMake(0, 0, drawerViewWidth, self.contentView.frame.size.height);
        statusBarAlpha = 0.0;
        self.menuToggled = YES;
    }
    else {
        frame = CGRectMake(0, 0, widthOfView, heightOfView);
        menuFrame = CGRectMake(-1 * menuOffsetX, 0, drawerViewWidth, self.contentView.frame.size.height);
        statusBarAlpha = 1.0;
        self.menuToggled = NO;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.frame = frame;
        self.drawerView.frame = menuFrame;
        self.statusBarView.alpha = statusBarAlpha;
        
    } completion:^(BOOL finished) {
        [self.drawerView deselectAllCells];
    }];
}

/* reverts drawer back to original position. only called when the gesture has ended and the pan translation was insufficient enough to signal a full toggle of the drawer */
-(void)revertLeftDrawer {
    CGRect frame;
    CGRect menuFrame;
    CGFloat statusBarAlpha;
    
    if(self.menuToggled){
        frame = CGRectMake(drawerViewWidth, 0, widthOfView, heightOfView);
        menuFrame = CGRectMake(0, 0, drawerViewWidth, self.contentView.frame.size.height);
        statusBarAlpha = 0.0;
    }
    else {
        frame = CGRectMake(0, 0, widthOfView, heightOfView);
        menuFrame = CGRectMake(-1 * menuOffsetX, 0, drawerViewWidth, self.contentView.frame.size.height);
        statusBarAlpha = 1.0;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.frame = frame;
        self.drawerView.frame = menuFrame;
        self.statusBarView.alpha = statusBarAlpha;
        
    } completion:^(BOOL finished) {
        [self.drawerView deselectAllCells];
    }];
}

#pragma mark - DrawerView Delegate

- (void)didSelectItem:(NSString *)item
            withImage:(UIImage *)image {
    [self toggleLeftDrawer];
    
    self.label.text = item;
    self.imageView.image = image;
    
    self.label.center = CGPointMake(widthOfView / 2, self.label.center.y);
    
    self.imageView.hidden = NO;
}

#pragma mark - Gesture Delegate Methods

-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    return YES;
}

#pragma mark - Gesture Handling

- (void)panGestureHandler:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        originalCenter = self.contentView.center;
        originalX = CGRectGetMinX(self.contentView.frame);
        originalMenuCenter = self.drawerView.center;
        markCompleteOnSwipeRelease = NO;
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:self.contentView];
        
        if(self.menuToggled){
            if(translation.x < 0){
                self.contentView.center = CGPointMake(originalCenter.x + translation.x, originalCenter.y);
                
                CGFloat factor = fabs(translation.x) / drawerViewWidth;
                self.statusBarView.alpha = factor;
                
                self.drawerView.center = CGPointMake(originalMenuCenter.x + (-1 * menuOffsetX * factor), originalMenuCenter.y);
                markCompleteOnSwipeRelease = fabs(translation.x) >= widthOfView * 0.20;
            }
        }
        else {
            if(translation.x > 0){
                self.contentView.center = CGPointMake(originalCenter.x + translation.x, originalCenter.y);
                
                CGFloat factor = fabs(translation.x) / drawerViewWidth;
                self.statusBarView.alpha = 1 - factor;
                
                self.drawerView.center = CGPointMake(originalMenuCenter.x + (menuOffsetX * factor), originalMenuCenter.y);
                markCompleteOnSwipeRelease = fabs(translation.x) >= widthOfView * 0.20;
            }
        }
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if(!markCompleteOnSwipeRelease){
            [self revertLeftDrawer];
        }
        else {
            [self toggleLeftDrawer];
        }
    }
}

@end
