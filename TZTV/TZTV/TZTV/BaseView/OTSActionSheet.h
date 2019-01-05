//
//  OTSActionSheet.h
//  OneStoreFramework
//
//  Created by Aimy on 9/16/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OTSActionSheet;
/**
 *  actionSheet点击按钮之后的回调block
 *
 *  @param actionSheet   对象
 *  @param buttonIndex 点击的button的序号，从0开始
 */
typedef void(^OTSActionSheetBlock)(OTSActionSheet *actionSheet, NSInteger buttonIndex);

@interface OTSActionSheet : UIActionSheet

/**
 *  创建action sheet
 *
 *  @param aTitle                  标题
 *  @param aCancelButtonTitle      取消按钮
 *  @param aDestructiveButtonTitle 确定按钮
 *  @param aBlock                  回调block
 *
 *  @return actionSheet
 */
+ (instancetype)actionSheetWithTitle:(NSString *)aTitle cancelButtonTitle:(NSString *)aCancelButtonTitle destructiveButtonTitle:(NSString *)aDestructiveButtonTitle andCompleteBlock:(OTSActionSheetBlock)aBlock;

@end
