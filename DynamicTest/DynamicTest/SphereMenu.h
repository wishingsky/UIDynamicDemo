//
//  SphereMenu.h
//  SphereMenu
//
//  Created by willie_wei on 15-2-3.
//  Copyright (c) 2015年 WCC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SphereMenuDelegate <NSObject>

- (void)sphereDidSelected:(int)index;

@end

@interface SphereMenu : UIView

@property (weak, nonatomic) id<SphereMenuDelegate> delegate;

- (instancetype)initWithStartPoint:(CGPoint)startPoint
                        startImage:(UIImage *)startImage
                     submenuImages:(NSArray *)images;

@end
