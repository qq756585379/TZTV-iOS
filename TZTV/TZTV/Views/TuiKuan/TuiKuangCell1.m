//
//  TuiKuangCell1.m
//  TZTV
//
//  Created by Luosa on 2016/12/7.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "TuiKuangCell1.h"

@implementation TuiKuangCell1

- (IBAction)btnClicked:(UIButton *)sender {
    if (sender==_chooseBtn1) {
        _chooseBtn1.selected=YES;
        _chooseBtn2.selected=NO;
        if (self.block) {
            self.block(@"退款");
        }
    }else if (sender==_chooseBtn2){
        _chooseBtn2.selected=YES;
        _chooseBtn1.selected=NO;
        if (self.block) {
            self.block(@"退货");
        }
    }
}

@end
