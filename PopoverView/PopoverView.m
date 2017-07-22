//
//  PopoverView.m
//  ResizeTable
//
//  Created by Liu Zhen on 12/18/14.
//  Copyright (c) 2014 Liu Zhen. All rights reserved.
//

#import "PopoverView.h"
#import "PopoverItem.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@import Colours;

#define PopoverItemHeight   44
#define PopoverWidth        200
#define PopoverItemLeftMargin    9
#define PopoverItemRightMargin   9

@interface PopoverView () <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) CGRect arrowRect;
@property (nonatomic) CGRect contentRect;
@property (nonatomic, strong) NSMutableArray *popoverItems;
@property (nonatomic, weak) UIView *maskView;
@property (nonatomic, strong) UITableView *contentView;

@property (nonatomic,copy) void(^dismissHandler)();

@end

@implementation PopoverView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        self.popoverItems = [NSMutableArray array];
        self.arrowSize = CGSizeMake(10, 6);
        self.cornerRadius = 3;
        self.contentView = [[UITableView alloc] init];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.separatorColor = [UIColor colorWithRed: 0.1412 green: 0.1412 blue: 0.1412 alpha: 1.0];
        self.contentView.separatorInset = UIEdgeInsetsMake(0, PopoverItemLeftMargin, 0, PopoverItemRightMargin);
        self.contentView.showsVerticalScrollIndicator = YES;
        self.contentView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        self.contentView.alwaysBounceVertical = NO;

        self.contentView.delegate = self;
        self.contentView.dataSource = self;
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)showFromView:(UIView *)view animated:(BOOL)animated {
    
    //创建并显示mask
    UIView *mask = [self createMask];
    [mask addSubview:self];
    
    UIView *root = view.window.rootViewController.view;
    mask.frame = root.bounds;
    [root addSubview:mask];
    self.maskView = mask;
    
    CGRect rect = [mask convertRect:view.bounds fromView:view];
    [self updateContent:rect];
}

- (void)showFromView:(UIView *)view animated:(BOOL)animated willDismiss:(void (^)(void))dismissHandler
{
    self.dismissHandler = dismissHandler;
    [self showFromView:view animated:animated];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated {

    //创建并显示mask
    UIView *mask = [self createMask];
    [mask addSubview:self];
    
    UIView *root = view.window.rootViewController.view;
    mask.frame = root.bounds;
    [root addSubview:mask];
    self.maskView = mask;
    
    rect = [mask convertRect:rect fromView:view];
    [self updateContent:rect];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated willDismiss:(void (^)(void))dismissHandler
{
    self.dismissHandler = dismissHandler;
    
    [self showFromRect:rect inView:view animated:animated];
}
//创建mask
- (UIView *)createMask {
    
    //移除已经存在的maskView
    if (self.maskView) {
        [self.maskView removeFromSuperview];
    }
    
    UIView *mask = [[UIView alloc] init];
    mask.frame = [UIScreen mainScreen].bounds;
    mask.backgroundColor = [UIColor clearColor];
    
    //添加手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskTap:)];
    tapGesture.delegate = self;
    [mask addGestureRecognizer:tapGesture];
    return mask;
}

- (CGFloat)caculateWidthWithString:(NSString*)string;
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX , PopoverItemHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16] } context:nil];
    
    return rect.size.width;
}

//更新展示用的信息
- (void)updateContent:(CGRect)rect {

    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGFloat popoverWidth = PopoverWidth;
    
    for(PopoverItem *item in self.popoverItems) {
        CGFloat width = [self caculateWidthWithString:item.title] + 72;
        if(popoverWidth < width) {
            popoverWidth = width;
        }
    }
    //计算popover的位置及大小
    CGFloat height = MAX(1, [self.popoverItems count]) * PopoverItemHeight + self.cornerRadius*2 + self.arrowSize.height;
    CGFloat maxHeight = PopoverItemHeight * 5 + 4;//self.maskView.frame.size.height - CGRectGetMaxY(rect);
    height = MIN(height, maxHeight);
    self.frame = CGRectMake(0, 0, popoverWidth, height);

    CGPoint frameCenter = center;
    frameCenter.y += self.frame.size.height/2.0;
    
    //左右不小于5px
    frameCenter.x = MIN(self.maskView.frame.size.width - self.frame.size.width/2.0 - 5, frameCenter.x);
    frameCenter.x = MAX(5, frameCenter.x);
    
    //上下不小于5px
    frameCenter.y = MIN(self.maskView.frame.size.height - self.frame.size.height/2.0 - 5, frameCenter.y);
    frameCenter.y = MAX(5, frameCenter.y);
    
    self.center = frameCenter;
    
    //计算arrowRect
    CGPoint popoverCenter = [self convertPoint:center fromView:self.maskView];
    CGFloat arrowCenterX = popoverCenter.x;
    
    //左右不小于5px
    arrowCenterX = MIN(self.frame.size.width - self.arrowSize.width/2.0f - self.cornerRadius, arrowCenterX);
    arrowCenterX = MAX(self.cornerRadius + 5 , arrowCenterX);
    
    self.arrowRect = CGRectMake(arrowCenterX - self.arrowSize.width/2.0f, 0,
                                self.arrowSize.width, self.arrowSize.height);

    //计算contentRect
    self.contentRect = CGRectMake(self.bounds.origin.x, CGRectGetMaxY(self.arrowRect), self.bounds.size.width, self.bounds.size.height - self.arrowRect.size.height);
}

- (void)maskTap:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        [self dismiss];
    }
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    //画气泡背景
    CGContextSetRGBFillColor(context, 50.f / 255.f, 50.f / 255.f, 50.f / 255.f, 1);
    CGMutablePathRef path = CGPathCreateMutable();

    /*      p1
            / \
           /   \
     /p10-p0---p2----p3\
    p9                 p4
    |                   |
    p8                 p5
     \p7-------------p6/
     */
    
    CGPoint p0 = CGPointMake(CGRectGetMinX(self.arrowRect),                       CGRectGetMinY(self.contentRect));
    CGPoint p1 = CGPointMake(CGRectGetMidX(self.arrowRect),                       CGRectGetMinY(self.arrowRect));
    CGPoint p2 = CGPointMake(CGRectGetMaxX(self.arrowRect),                       CGRectGetMaxY(self.arrowRect));
    CGPoint p3 = CGPointMake(CGRectGetMaxX(self.contentRect) - self.cornerRadius, CGRectGetMinY(self.contentRect));
    CGPoint p4 = CGPointMake(CGRectGetMaxX(self.contentRect),                     CGRectGetMinY(self.contentRect) + self.cornerRadius);
    CGPoint p5 = CGPointMake(CGRectGetMaxX(self.contentRect),                     CGRectGetMaxY(self.contentRect) - self.cornerRadius);
    CGPoint p6 = CGPointMake(CGRectGetMaxX(self.contentRect) -self.cornerRadius,  CGRectGetMaxY(self.contentRect));
    CGPoint p7 = CGPointMake(CGRectGetMinX(self.contentRect) + self.cornerRadius, CGRectGetMaxY(self.contentRect));
    CGPoint p8 = CGPointMake(CGRectGetMinX(self.contentRect),                     CGRectGetMaxY(self.contentRect) - self.cornerRadius);
    CGPoint p9 = CGPointMake(CGRectGetMinX(self.contentRect),                     CGRectGetMinY(self.contentRect) + self.cornerRadius);
    CGPoint p10 =CGPointMake(CGRectGetMinX(self.contentRect) + self.cornerRadius, CGRectGetMinY(self.contentRect));
    
    CGPathMoveToPoint(path, NULL, p0.x, p0.y); //超始点在从箭头的左下角开始
    CGPathAddLineToPoint(path, NULL, p1.x, p1.y);
    CGPathAddLineToPoint(path, NULL, p2.x, p2.y);
    CGPathAddLineToPoint(path, NULL, p3.x, p3.y);
    CGPathAddArc(path, NULL, p3.x, p4.y, self.cornerRadius, 3*M_PI_2, 0, false);
    CGPathAddLineToPoint(path, NULL, p5.x, p5.y);
    CGPathAddArc(path, NULL, p6.x, p5.y, self.cornerRadius, 0, M_PI_2, false);
    CGPathAddLineToPoint(path, NULL, p7.x, p7.y);
    CGPathAddArc(path, NULL, p7.x, p8.y, self.cornerRadius, M_PI_2, M_PI, false);
    CGPathAddLineToPoint(path, NULL, p9.x, p9.y);
    CGPathAddArc(path, NULL, p10.x, p9.y, self.cornerRadius, M_PI, 3*M_PI_2, false);
    CGPathAddLineToPoint(path, NULL, p0.x, p0.y);
    CGPathCloseSubpath(path);
    CGContextAddPath(context, path);
    CGContextFillPath(context);
    CGPathRelease(path);
    
    CGContextRestoreGState(context);
}

- (void)layoutSubviews {
    self.contentView.frame = CGRectInset(self.contentRect, self.cornerRadius, self.cornerRadius);
}

- (void)dismiss {
    
    if(self.dismissHandler)
    {
        self.dismissHandler();
    }
    
    [self.maskView removeFromSuperview];
}

- (void)addTitle:(NSString *)title image:(UIImage *)image handler:(void (^)(void))handler {
    PopoverItem *item = [[PopoverItem alloc] init];
    item.title = title;
    item.icon = image;
    item.handler = handler;
    [self.popoverItems addObject:item];
    [self.contentView reloadData];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.popoverItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"PopoverItemCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0.530 alpha:0.220];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    PopoverItem *item = self.popoverItems[indexPath.row];
    cell.imageView.image = item.icon;
    cell.textLabel.text = item.title;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return PopoverItemHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PopoverItem *item = self.popoverItems[indexPath.row];
    if (item.handler) {
        item.handler();
    }
    [self dismiss];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint touchPoint = [gestureRecognizer locationInView:self];
    if (!CGRectContainsPoint(self.contentRect, touchPoint)) {
        return YES;
    }
    return NO;
}

@end
