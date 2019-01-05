//
//  SuggestionsVC.m
//  klxc
//
//  Created by sctto on 16/4/1.
//  Copyright © 2016年 sctto. All rights reserved.
//

#import "SuggestionsVC.h"

@interface SuggestionsVC () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField    *TelTF;
@property (weak, nonatomic) IBOutlet UITextView     *contentTextView;
@end

@implementation SuggestionsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contentTextView.delegate=self;
    self.contentTextView.dataDetectorTypes = UIDataDetectorTypeAll;
    
//    UITextView *textview = [[UITextView alloc] initWithFrame:CGRectMake(20, 10, 280, 30)];
//    textview.backgroundColor=[UIColor whiteColor]; //背景色
//    textview.scrollEnabled = NO;    //当文字超过视图的边框时是否允许滑动，默认为“YES”
//    textview.editable = YES;        //是否允许编辑内容，默认为“YES”
//    textview.delegate = self;       //设置代理方法的实现类
//    textview.font=[UIFont fontWithName:@"Arial" size:18.0]; //设置字体名字和字体大小;
//    textview.returnKeyType = UIReturnKeyDefault;//return键的类型
//    textview.keyboardType = UIKeyboardTypeDefault;//键盘类型
//    textview.textAlignment = NSTextAlignmentLeft; //文本显示的位置默认为居左
//    textview.dataDetectorTypes = UIDataDetectorTypeAll; //显示数据类型的连接模式（如电话号码、网址、地址等）
//    textview.textColor = [UIColor blackColor];
//    textview.text = @"UITextView详解";//设置显示的文本内容
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self cancelFirstResponse];
}

#pragma mark - 提交反馈
- (IBAction)submitBtnClicked:(UIButton *)sender
{
    if ([self.contentTextView.text isEqualToString:@""]||[self.contentTextView.text isEqualToString:@"有什么意见和建议，尽管来咆哮吧~"]) {
        [MBProgressHUD showError:@"请输入反馈内容!"];
        return;
    }
    if (![_TelTF.text isPhoneNo]) {
        [MBProgressHUD showError:@"请输入正确的联系方式!"];
        return;
    }
    [MBProgressHUD showToast:@"意见反馈成功，我们会及时处理，谢谢"];
    [self.navigationController popViewControllerAnimated:YES];
}

//将要开始编辑
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.contentTextView.text=@"";
    return YES;
}

//将要结束编辑
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.contentTextView.text=@"有什么意见和建议，尽管来咆哮吧~";
    return YES;
}

//开始编辑
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}

//结束编辑
- (void)textViewDidEndEditing:(UITextView *)textView{
    
}

//控制输入文字的长度和内容，可通调用以下代理方法实现
//内容将要发生改变编辑
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    if (range.location>=100){
//        //控制输入文本的长度
//        return  NO;
//    }
//    if ([text isEqualToString:@"\n"]) {
//        //禁止输入换行
//        return NO;
//    }else{
//        return YES;
//    }
//}

//有时候我们要控件自适应输入的文本的内容的高度，只要在textViewDidChange的代理方法中加入调整控件大小的代理即可
//内容发生改变编辑
- (void)textViewDidChange:(UITextView *)textView{
    //计算文本的高度
//    CGSize constraintSize;
//    constraintSize.width = textView.frame.size.width-16;
//    constraintSize.height = MAXFLOAT;
//    CGSize sizeFrame =[textView.text sizeWithFont:textView.font
//                                constrainedToSize:constraintSize
//                                    lineBreakMode:UILineBreakModeWordWrap];
//    
//    //重新调整textView的高度
//    textView.frame = CGRectMake(textView.frame.origin.x,textView.frame.origin.y,textView.frame.size.width,sizeFrame.height+5);
}

//焦点发生改变
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    
}

@end
