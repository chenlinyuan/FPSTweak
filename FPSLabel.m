//
//  FPSLabel.m
//  DynamicEmoji
//
//  Created by chen diyu on 17/1/3.
//  Copyright © 2017年 alas743k. All rights reserved.
//

#import "FPSLabel.h"

@implementation FPSLabel
{
    CADisplayLink *link;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.adjustsFontSizeToFitWidth = YES;
        link = [CADisplayLink displayLinkWithTarget:self selector:@selector(showFPS)];
        [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1-.618];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(log)]];
    }
    return self;
}

- (void)log {
    NSLog(@"%@",[NSThread callStackSymbols]);
}
    
- (void)showFPS {
//    NSLog(@"dida");
    static NSInteger _count = 0;
    static NSTimeInterval _lastTime = 0;
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    self.text = [NSString stringWithFormat:@"%.0f",MIN(60., round(fps))];
    CGFloat progress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    self.textColor = color;
}

+ (instancetype)sharedInstance {
    static FPSLabel *fpsLabel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fpsLabel = [[FPSLabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    });
    return fpsLabel;
}

//+ (void)hide {
//    FPSLabel *fpsLabel = [FPSLabel sharedInstance];
//    UIWindow *window = (UIWindow *)fpsLabel.superview;
//    if (window) {
//        [fpsLabel removeFromSuperview];
//        window.hidden = YES;
//        window = nil;
//    }
//}

+ (UIWindow *)displayWindow {
    static UIWindow *window = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 20, 20, 20)];
        window.windowLevel = INT_MAX;
        window.rootViewController = [[UIViewController alloc] init];
        window.userInteractionEnabled = YES;
        [window setHidden:NO];
    });
    return window;
}


+ (void)show {
//    [self hide];
    [[self displayWindow] addSubview:[FPSLabel sharedInstance]];
}

- (void)dealloc {
    [link invalidate];
    link = nil;
    [super dealloc];
}

@end
