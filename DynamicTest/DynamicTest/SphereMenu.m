//
//  SphereMenu.m
//  SphereMenu
//
//  Created by willie_wei on 15-2-3.
//  Copyright (c) 2015年 WCC. All rights reserved.
//

#import "SphereMenu.h"

static const CGFloat kAngleOffset = M_PI_2 / 2;
static const CGFloat kSphereLength = 80;
static const float kSphereDamping = 0.3;

@interface SphereMenu () <UICollisionBehaviorDelegate>

@property (assign, nonatomic) NSUInteger count ;
@property (strong, nonatomic) UIImageView *start;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableArray *positions;

// animator and behaviors
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UICollisionBehavior *collision;
@property (strong, nonatomic) UIDynamicItemBehavior *itemBehavior;
@property (strong, nonatomic) NSMutableArray *snaps;
@property (strong, nonatomic) NSMutableArray *taps;

@property (strong, nonatomic) UITapGestureRecognizer *tapOnStart;

@property (strong, nonatomic) id<UIDynamicItem> bumper;
@property (assign, nonatomic) BOOL expanded;

@end


@implementation SphereMenu

- (instancetype)initWithStartPoint:(CGPoint)startPoint startImage:(UIImage *)startImage submenuImages:(NSArray *)images
{
    if (self = [super init]) {
        
        self.bounds = CGRectMake(0, 0, startImage.size.width, startImage.size.height);
        self.center = startPoint;
        
        self.images = images;
        self.count = self.images.count;
        self.start = [[UIImageView alloc] initWithImage:startImage];
        self.start.userInteractionEnabled = YES;
        self.tapOnStart = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                  action:@selector(startTapped:)];
        [self.start addGestureRecognizer:self.tapOnStart];
        [self addSubview:self.start];
    }
    return self;
}

- (void)commonSetup
{
    self.items = [NSMutableArray array];
    self.positions = [NSMutableArray array];
    self.snaps = [NSMutableArray array];
    self.taps = [NSMutableArray array];
    
    // setup the items
    for (int i = 0; i < self.count; i++) {
        UIImageView *item = [[UIImageView alloc] initWithImage:self.images[i]];
        item.userInteractionEnabled = YES;
        [self.superview addSubview:item];
        
        CGPoint position = [self centerForSphereAtIndex:i];
        item.center = self.center;
        [self.positions addObject:[NSValue valueWithCGPoint:position]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [item addGestureRecognizer:tap];
        [self.taps addObject:tap];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panned:)];
        [item addGestureRecognizer:pan];
        
        [self.items addObject:item];
    }
    
    [self.superview bringSubviewToFront:self];
    
    // setup animator and behavior
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview];
    
    // 初始化碰撞行为
    self.collision = [[UICollisionBehavior alloc] initWithItems:self.items];
    self.collision.translatesReferenceBoundsIntoBoundary = YES;
    self.collision.collisionDelegate = self;
    
    // 初始化捕捉行为
    for (int i = 0; i < self.count; i++) {
        UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.items[i] snapToPoint:self.center];
        snap.damping = kSphereDamping;
        [self.snaps addObject:snap];
    }
    
    // 初始化辅助动态行为
    self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:self.items];
    self.itemBehavior.allowsRotation = NO;
    self.itemBehavior.elasticity = 1.2;
    self.itemBehavior.density = 0.5;
    self.itemBehavior.angularResistance = 5;
    self.itemBehavior.resistance = 10;
    self.itemBehavior.elasticity = 0.8;
    self.itemBehavior.friction = 0.5;
}

- (void)didMoveToSuperview
{
    [self commonSetup];
}

- (void)removeFromSuperview
{
    for (int i = 0; i < self.count; i++) {
        [self.items[i] removeFromSuperview];
    }
    
    [super removeFromSuperview];
}

// 获取捕捉点
- (CGPoint)centerForSphereAtIndex:(int)index
{
    CGFloat firstAngle = M_PI + (M_PI_2 - kAngleOffset) + index * kAngleOffset;
    CGPoint startPoint = self.center;
    CGFloat x = startPoint.x + cos(firstAngle) * kSphereLength;
    CGFloat y = startPoint.y + sin(firstAngle) * kSphereLength;
    CGPoint position = CGPointMake(x, y);
    return position;
}

- (void)tapped:(UITapGestureRecognizer *)gesture
{
    NSUInteger index = [self.taps indexOfObject:gesture];
    if ([self.delegate respondsToSelector:@selector(sphereDidSelected:)]) {
        [self.delegate sphereDidSelected:(int)index];
    }
    
    [self shrinkSubmenu];
}

- (void)startTapped:(UITapGestureRecognizer *)gesture
{
    [self.animator removeBehavior:self.collision];
    [self.animator removeBehavior:self.itemBehavior];
    [self removeSnapBehaviors];
    
    if (self.expanded) {
        [self shrinkSubmenu];
    } else {
        [self expandSubmenu];
    }
    
    self.expanded = !self.expanded;
}

- (void)expandSubmenu
{
    for (int i = 0; i < self.count; i++) {
        [self snapToPostionsWithIndex:i];
    }
}

- (void)shrinkSubmenu
{
    for (int i = 0; i < self.count; i++) {
        [self snapToStartWithIndex:i];
    }
}

- (void)panned:(UIPanGestureRecognizer *)gesture
{
    UIView *touchedView = gesture.view;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [self.animator removeBehavior:self.itemBehavior];
        [self.animator removeBehavior:self.collision];
        [self removeSnapBehaviors];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        touchedView.center = [gesture locationInView:self.superview];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        self.bumper = touchedView;
        //添加碰撞行为
        [self.animator addBehavior:self.collision];
        NSUInteger index = [self.items indexOfObject:touchedView];
        
        if (index != NSNotFound) {
            [self snapToPostionsWithIndex:index];
        }
    }
}

// 碰撞行为代理
- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2
{
    //添加辅助动态行为
    [self.animator addBehavior:self.itemBehavior];
    
    if (item1 != self.bumper) {
        NSUInteger index = (int)[self.items indexOfObject:item1];
        if (index != NSNotFound) {
            [self snapToPostionsWithIndex:index];
        }
    }
    
    if (item2 != self.bumper) {
        NSUInteger index = (int)[self.items indexOfObject:item2];
        if (index != NSNotFound) {
            [self snapToPostionsWithIndex:index];
        }
    }
}

//添加捕捉行为
- (void)snapToStartWithIndex:(NSUInteger)index
{
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.items[index] snapToPoint:self.center];
    snap.damping = kSphereDamping;
    UISnapBehavior *snapToRemove = self.snaps[index];
    self.snaps[index] = snap;
    [self.animator removeBehavior:snapToRemove];
    [self.animator addBehavior:snap];
}

//添加捕捉行为
- (void)snapToPostionsWithIndex:(NSUInteger)index
{
    id positionValue = self.positions[index];
    CGPoint position = [positionValue CGPointValue];
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:self.items[index] snapToPoint:position];
    snap.damping = kSphereDamping;
    UISnapBehavior *snapToRemove = self.snaps[index];
    self.snaps[index] = snap;
    [self.animator removeBehavior:snapToRemove];
    [self.animator addBehavior:snap];
}

//移除捕捉行为
- (void)removeSnapBehaviors
{
    [self.snaps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.animator removeBehavior:obj];
    }];
}

@end