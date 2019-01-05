//
//  TuiKuangCell2.m
//  TZTV
//
//  Created by Luosa on 2016/12/7.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "TuiKuangCell2.h"

@implementation TuiKuangCell2

- (IBAction)btnClicked:(UIButton *)sender {
    if (self.block) {
        self.block();
    }
}

@end
