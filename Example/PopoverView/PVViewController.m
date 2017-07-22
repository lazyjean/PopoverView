//
//  PVViewController.m
//  PopoverView
//
//  Created by 刘真 on 07/22/2017.
//  Copyright (c) 2017 刘真. All rights reserved.
//

#import "PVViewController.h"

@import PopoverView;

@interface PVViewController ()

@end

@implementation PVViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"title";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)show:(id)sender {
    PopoverView *popover = [[PopoverView alloc] init];
    [popover addTitle:@"Demo1" image:nil handler:^{
        NSLog(@"Demo1");
    }];
    
    [popover addTitle:@"Demo2" image:nil handler:^{
        NSLog(@"Demo2");
    }];
     
    [popover showFromView:self.navigationController.navigationBar animated:YES willDismiss:^{
        
    }];
}
@end
