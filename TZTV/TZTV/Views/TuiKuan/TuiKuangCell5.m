//
//  TuiKuangCell5.m
//  TZTV
//
//  Created by Luosa on 2016/12/7.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "TuiKuangCell5.h"

@implementation TuiKuangCell5


- (IBAction)btn1Click:(UIButton *)sender {
    if (self.block) {
        self.block(2);
    }
}
- (IBAction)btn2Click:(UIButton *)sender {
    if (self.block) {
        self.block(1);
    }
}
- (IBAction)btn3Click:(UIButton *)sender {
    if (self.block) {
        self.block(0);
    }
}

-(void)setImages:(NSArray *)images{
    images=images;
    if (images.count==0) {
        _smallView1.hidden=YES;
        _smallView2.hidden=YES;
        _smallView3.hidden=YES;
    }else if (images.count==1){
        _smallView1.hidden=YES;
        _smallView2.hidden=YES;
        _smallView3.hidden=NO;
        [_btn3 setImage:images[0] forState:UIControlStateNormal];
    }else if (images.count==2){
        _smallView1.hidden=YES;
        _smallView2.hidden=NO;
        _smallView3.hidden=NO;
        [_btn2 setImage:images[1] forState:UIControlStateNormal];
        [_btn3 setImage:images[0] forState:UIControlStateNormal];
    }else if (images.count==3){
        _smallView1.hidden=NO;
        _smallView2.hidden=NO;
        _smallView3.hidden=NO;
        [_btn1 setImage:images[2] forState:UIControlStateNormal];
        [_btn2 setImage:images[1] forState:UIControlStateNormal];
        [_btn3 setImage:images[0] forState:UIControlStateNormal];
    }
}

@end
