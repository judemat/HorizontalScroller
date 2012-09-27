//
//  HSViewController.m
//  HorizontalScroller
//
//  Created by Jude Matsalla on 9/26/12.

/*
    Copyright (c) 2012 Jude Matsalla.

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
*/


#import "HSViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface HSViewController ()

@end

@implementation HSViewController

const float xPoint = 10.0f;
const float yPoint = 100.0f;
const float rightIndent = 20.0f;
const float scrollerHeight = 39.0f;
const float elementSpacing = 7.0f;
const float buttonGap = 40.0f;
const float maskWidth = 17.0f;

CAGradientLayer *maskLayer;
UIScrollView *buttonScrollView;
UIImageView *scrollerBackground;

- (void)viewDidLoad {
    
    [super viewDidLoad];

    // Dummy data for the scrolling buttons
    NSArray *buttonData = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15"];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"egg_shell"]];
    
    UIImage *scrollerBackgroundImage = [[UIImage imageNamed:@"scroller_background"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    scrollerBackground = [[UIImageView alloc] initWithFrame:CGRectMake(xPoint, yPoint, self.view.bounds.size.width - rightIndent, scrollerHeight)];
    scrollerBackground.image = scrollerBackgroundImage;
    [self.view addSubview:scrollerBackground];
    
    // Set up the scrollview
    buttonScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(xPoint, yPoint, self.view.bounds.size.width - rightIndent, scrollerHeight)];
    [buttonScrollView setDelegate:self];
    [buttonScrollView setBackgroundColor:[UIColor clearColor]];
    [buttonScrollView setCanCancelContentTouches:NO];
    buttonScrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    [buttonScrollView setShowsHorizontalScrollIndicator:NO];
    [buttonScrollView setShowsVerticalScrollIndicator:NO];
    buttonScrollView.scrollEnabled = YES;
    [buttonScrollView setContentSize:CGSizeMake((buttonData.count * buttonGap), [buttonScrollView bounds].size.height)];
    [buttonScrollView.layer setCornerRadius:5.0f];
    
    // Add gradient mask to the right side of buttonScrollView
    maskLayer = [CAGradientLayer layer];
    id outerColor = (id)[[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0] CGColor];
    id innerColor = (id)[[UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:0.0] CGColor];
        
    maskLayer.frame = CGRectMake(buttonScrollView.frame.size.width - maskWidth, 0, maskWidth, buttonScrollView.frame.size.height);
    maskLayer.startPoint = CGPointMake(1.0, 0.5);
    maskLayer.endPoint = CGPointMake(0, 0.5);
    maskLayer.colors = @[outerColor, innerColor];

    // Add buttons to the scrollview
    NSInteger scrollX = 6;
    
    for (NSString *buttonLabel in buttonData) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.frame = CGRectMake(scrollX, 5, 30, 30);
        [button setBackgroundColor:[UIColor darkGrayColor]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
        
        [button setTitle:buttonLabel forState:UIControlStateNormal];
        [button.layer setCornerRadius:3.0f];
        
        [buttonScrollView addSubview:button];
        
        scrollX += buttonGap;
    }
    
    [buttonScrollView.layer insertSublayer:maskLayer atIndex:buttonData.count];
        
    [self.view addSubview:buttonScrollView];
    
}

#pragma mark UIScrollView Delegate Method

- (void)scrollViewDidScroll:(UIScrollView *)sv {
    // Keep the mask layer on the right side as the content is scrolled
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    maskLayer.position = CGPointMake(sv.contentOffset.x + sv.frame.size.width - (maskWidth / 2), sv.frame.size.height / 2);
    [CATransaction commit];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    // Recalculate frame widths when the device is rotated
    
    buttonScrollView.frame = CGRectMake(xPoint, yPoint, self.view.bounds.size.width - rightIndent, scrollerHeight);
    scrollerBackground.frame = CGRectMake(xPoint, yPoint, self.view.bounds.size.width - rightIndent, scrollerHeight);
    maskLayer.frame = CGRectMake(buttonScrollView.frame.size.width - maskWidth, 0, maskWidth, buttonScrollView.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
