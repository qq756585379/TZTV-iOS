//
//  OTSDataNaviBtn.h
//  TZTV
//
//  Created by Luosa on 2016/11/8.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OTSDataNaviBtn : UIButton

@property(nonatomic,   copy) NSString *href;
@property(nonatomic, strong) NSArray  *items;

@end




//上下按钮
@interface OTSUpdownLayoutNaviBtn : OTSDataNaviBtn

@end
