//
//  XYAlertController.m
//  SuiXiLifeDoctor
//
//  Created by 张兴业 on 2016/10/28.
//  Copyright © 2016年 zxy. All rights reserved.
//

#import "XYAlertController.h"

@implementation XYAlertController
#pragma mark - 没有取消按钮
+ (UIAlertController *)alertTitle:(NSString *)title
                     alertMessage:(NSString *)message
                   preferredStyle:(UIAlertControllerStyle)preferredStyle
                cancleActionTitle:(NSString *)cancleTitle
               confirmActionTitle:(NSString *)confirmTitle
                   viewController:(UIViewController *)viewController
                     cancleHandle:(void(^)(UIAlertAction *cancle))cancleActionHandle
                    confirmHandle:(void(^)(UIAlertAction *confirm))confirmActionHandle{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    
    if (cancleTitle) {
        [alertController addAction:[UIAlertAction actionWithTitle:cancleTitle style:UIAlertActionStyleDefault handler:cancleActionHandle]];
    }
    if (confirmTitle) {
        [alertController addAction:[UIAlertAction actionWithTitle:confirmTitle style:UIAlertActionStyleDefault handler:confirmActionHandle]];
    }

    [viewController presentViewController:alertController animated:YES completion:nil];
    
    return alertController;
}

@end
