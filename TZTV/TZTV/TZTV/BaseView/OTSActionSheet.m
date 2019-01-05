//
//  OTSActionSheet.m
//  OneStoreFramework
//
//  Created by Aimy on 9/16/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//

#import "OTSActionSheet.h"

@interface OTSActionSheet () <UIActionSheetDelegate>

@property (nonatomic, copy) OTSActionSheetBlock block;

@end

@implementation OTSActionSheet

+ (instancetype)actionSheetWithTitle:(NSString *)aTitle cancelButtonTitle:(NSString *)aCancelButtonTitle destructiveButtonTitle:(NSString *)aDestructiveButtonTitle andCompleteBlock:(OTSActionSheetBlock)aBlock{
    if (!aCancelButtonTitle) {
        aCancelButtonTitle = @"取消";
    }
    if (!aDestructiveButtonTitle) {
        aDestructiveButtonTitle = @"确定";
    }
    OTSActionSheet *actionSheet = [[self alloc] initWithTitle:aTitle delegate:nil cancelButtonTitle:aCancelButtonTitle destructiveButtonTitle:aDestructiveButtonTitle otherButtonTitles:nil];
    actionSheet.delegate = actionSheet;
    actionSheet.block = aBlock;
    return actionSheet;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.block) {
        self.block((OTSActionSheet *)actionSheet, buttonIndex);
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
