//
//  PopoverView.h
//  ResizeTable
//
//  Created by Liu Zhen on 12/18/14.
//  Copyright (c) 2014 Liu Zhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopoverView : UIView

@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) CGSize arrowSize;

- (void)showFromView:(UIView *)view animated:(BOOL)animated;
- (void)showFromView:(UIView *)view animated:(BOOL)animated willDismiss:(void (^)(void))dismissHandler;

//右侧导航按钮的位置大概为：CGRectMake(366, 6, 39, 30)
- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated;
- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated willDismiss:(void (^)(void))dismissHandler;

- (void)addTitle:(NSString *)title image:(UIImage *)image handler:(void (^)(void))handler;

- (void)dismiss;

@end
