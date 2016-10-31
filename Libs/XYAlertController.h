//
//  XYAlertController.h
//  SuiXiLifeDoctor
//
//  Created by 张兴业 on 2016/10/28.
//  Copyright © 2016年 zxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYAlertController : NSObject
#pragma mark - 没有取消按钮
+ (UIAlertController *)alertTitle:(NSString *)title
                     alertMessage:(NSString *)message
                   preferredStyle:(UIAlertControllerStyle)preferredStyle
                cancleActionTitle:(NSString *)cancleTitle
               confirmActionTitle:(NSString *)confirmTitle
                   viewController:(UIViewController *)viewController
                     cancleHandle:(void(^)(UIAlertAction *cancle))cancleActionHandle
                    confirmHandle:(void(^)(UIAlertAction *confirm))confirmActionHandle;
@end
