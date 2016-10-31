//
//  PhotoTool.h
//  SuiXiLifeDoctor
//
//  Created by 张兴业 on 2016/10/28.
//  Copyright © 2016年 zxy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class IDCardHttp;
@class IDCards;
@class IDCardOutPuts;
@class IDCardOutputMulti;
@class IDCardOutputValue;
@class IDCardModel;

@interface PhotoTool : NSObject

+ (instancetype)shareTool;

- (void)openCameraWith:(UIViewController *)viewController finishHandle:(void(^)(UIImage *image))finishHandle;

- (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;

- (void)startRecWith:(NSData *)data callBack:(void(^)(IDCardModel *model))callBack;

@end

#pragma mark - 网络请求

@interface IDCardHttp: NSObject

+ (void)sendHttpPostWith:(NSString *)idcardStr result:(void(^)(BOOL isSuccess , id result))result;

@end

#pragma mark - 身份证model

@interface IDCards : NSObject

@property (nonatomic, strong) NSArray *outputs;

@end

@interface IDCardOutPuts : NSObject

@property (nonatomic, strong) IDCardOutputMulti *outputMulti;
@property (nonatomic, strong) IDCardOutputValue *outputValue;
@property (nonatomic, copy) NSString *outputLabel;

@end

@interface IDCardOutputMulti : NSObject



@end

@interface IDCardOutputValue : NSObject

@property (nonatomic, copy) NSString *dataValue;
@property (nonatomic, assign) double dataType;

@end

@interface IDCardModel : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *birth;
@property (nonatomic, strong) NSString *requestId;
@property (nonatomic, strong) NSString *success;
@property (nonatomic, strong) NSString *nationality;
@property (nonatomic, strong) NSString *num;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *configStr;

@end
