//
//  ShowPictureVC.m
//  TZTV
//
//  Created by Luosa on 2016/12/29.
//  Copyright © 2016年 Luosa. All rights reserved.
//

#import "ShowPictureVC.h"

@interface ShowPictureVC ()
@property (nonatomic, strong) UIScrollView *scrollew;
@end

@implementation ShowPictureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"精彩推荐";
    self.view.backgroundColor=kWhiteColor;
    self.scrollew=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-64)];
    [self.view addSubview:self.scrollew];
    
    UIImage *image=[UIImage imageNamed:_imageName];
    CGFloat pictureH = ScreenW * image.size.height / image.size.width;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, pictureH)];
    imageView.image=image;
    [self.scrollew addSubview:imageView];
    self.scrollew.contentSize=CGSizeMake(ScreenW,pictureH);
}

@end
