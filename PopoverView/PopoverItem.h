//
//  PopoverItem.h
//  ResizeTable
//
//  Created by Liu Zhen on 12/18/14.
//  Copyright (c) 2014 Liu Zhen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PopoverItemHandler)(void);

@interface PopoverItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) PopoverItemHandler handler;
@property (nonatomic, strong) UIButton *itemButton;

@end
