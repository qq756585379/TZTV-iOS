//
//  CountDownBtn.m
//  TZTV
//
//  Created by Luosa on 2016/11/14.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "CountDownBtn.h"

@interface CountDownBtn()
@property (nonatomic, strong) NSTimer *countTimer;
@property (nonatomic, assign) NSInteger countNum;
@end

@implementation CountDownBtn

-(void)startCount
{
    if ([self.countTimer isValid]){
        [self stopCount];
    }
    self.countNum = 60;
    self.countTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSDefaultRunLoopMode];
}

-(void)countDown
{
    YJLog(@"%d",(int)self.countNum--);
    self.enabled = NO;
    [self setTitle:[NSString stringWithFormat:@"（%d）秒",(int)self.countNum--] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setBackgroundColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    if (self.countNum < 0) {
        [self stopCount];
    }
}

-(void)stopCount
{
    self.countNum=60;
    if (self.countTimer) {
        [self.countTimer invalidate];
    }
    self.countTimer=nil;
    self.enabled=YES;
    [self setTitle:@"重新获取" forState:UIControlStateNormal];
    [self setBackgroundColor:YJNaviColor forState:UIControlStateNormal];
    [self setTitleColor:HEXRGBCOLOR(0x333333) forState:UIControlStateNormal];
}

-(void)setHighlighted:(BOOL)highlighted
{
    
}

-(void)dealloc
{
    [self stopCount];
}

@end
