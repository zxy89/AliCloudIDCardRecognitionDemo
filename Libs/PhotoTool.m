//
//  PhotoTool.m
//  SuiXiLifeDoctor
//
//  Created by 张兴业 on 2016/10/28.
//  Copyright © 2016年 zxy. All rights reserved.
//

#import "PhotoTool.h"
#import <MobileCoreServices/MobileCoreServices.h>

typedef void(^CallBack)();

@interface PhotoTool()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) UIImagePickerController *pickerController;

@property (copy, nonatomic) CallBack callback;

@end

@implementation PhotoTool

+ (instancetype)shareTool{
    static PhotoTool *shareTool = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareTool = [[self alloc] init];
    });
    
    return shareTool;
}
#pragma mark 开始拍照
- (void)openCameraWith:(UIViewController *)viewController finishHandle:(void(^)(UIImage *image))finishHandle{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        self.callback = finishHandle;
        
        _pickerController = [[UIImagePickerController alloc] init];
        _pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        _pickerController.delegate = self;
        _pickerController.showsCameraControls = YES;
        
        //[imagePicker.view setBackgroundColor:[UIColor blackColor]];
        [viewController presentViewController:_pickerController animated:YES completion:nil];
    }
    else
    {
        [XYAlertController alertTitle:@"提示"
                         alertMessage:@"由于您的设备暂不支持摄像头，您无法使用该功能!"
                       preferredStyle:UIAlertControllerStyleAlert
                    cancleActionTitle:nil
                   confirmActionTitle:@"确认"
                       viewController:viewController
                         cancleHandle:nil
                        confirmHandle:nil];
    }
}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image;
//    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    UIImageOrientation orientation = [image imageOrientation];
    
    CGImageRef imRef = [image CGImage];
    int texWidth = (int)CGImageGetWidth(imRef);
    int texHeight = (int)CGImageGetHeight(imRef);
    
    float imageScale = 1.0;
    
    if(orientation == UIImageOrientationUp && texWidth < texHeight)
        image = [UIImage imageWithCGImage:imRef scale:imageScale orientation: UIImageOrientationLeft];
    else if((orientation == UIImageOrientationUp && texWidth > texHeight) || orientation == UIImageOrientationRight)
        image = [UIImage imageWithCGImage:imRef scale:imageScale orientation: UIImageOrientationUp];
    else if(orientation == UIImageOrientationDown)
        image = [UIImage imageWithCGImage:imRef scale:imageScale orientation: UIImageOrientationDown];
    else if(orientation == UIImageOrientationLeft)
        image = [UIImage imageWithCGImage:imRef scale:imageScale orientation: UIImageOrientationUp];
    
    NSLog(@"originalImage width = %f height = %f",image.size.width,image.size.height);
    
    //currentTag = 0;
    [LCProgressHUD showLoading:@"正在识别请稍后..."];
    [picker dismissViewControllerAnimated:YES completion:^{
        
        self.callback(image);
        
    }];
}
#pragma mark 图片压缩
- (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    return data;
}
#pragma mark 身份证识别
- (void)startRecWith:(NSData *)data callBack:(void(^)(IDCardModel *model))callBack
{
    
    NSData *sendImageData = data;
    
    dispatch_source_t timer=dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, 0ull*NSEC_PER_SEC), DISPATCH_TIME_FOREVER, 1ull*NSEC_PER_SEC);
    
    dispatch_source_set_event_handler(timer, ^{
        
        NSString *imageStr = [sendImageData base64EncodedStringWithOptions:0];
        
        [IDCardHttp sendHttpPostWith:imageStr result:^(BOOL isSuccess, id result) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (isSuccess) {
                    
                    [LCProgressHUD showMessage:@"success!"];
                    
                    NSData *data = [result dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    
                    NSLog(@"阿里云身份证识别 --- %@",dic);
                    
                    IDCards *base = [IDCards mj_objectWithKeyValues:dic];
                    
                    IDCardOutPuts *outputs = base.outputs[0];
                    
                    IDCardOutputValue *value = outputs.outputValue;
                    
                    NSData *datas = [value.dataValue dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSDictionary *dics = [NSJSONSerialization JSONObjectWithData:datas options:NSJSONReadingMutableContainers error:nil];
                    
                    IDCardModel *model = [IDCardModel mj_objectWithKeyValues:dics];
                    
                    callBack(model);
                    
                }else{
                    
                    NSLog(@"阿里云身份证识别 --- %@",result);
                    
                    [LCProgressHUD showFailure:@"获取身份证信息失败!"];
                }
                
            });
            
        }];
        
        dispatch_source_cancel(timer);
    });
    
    dispatch_source_set_cancel_handler(timer, ^{
        NSLog(@"cancel");
    });
    //启动
    dispatch_resume(timer);
}
#pragma mark - 获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
#pragma mark - 网络请求
@implementation IDCardHttp

+ (void)sendHttpPostWith:(NSString *)idcardStr result:(void(^)(BOOL isSuccess , id result))result{
    
    NSString * postPath = @"/rest/160601/ocr/ocr_idcard.json";
    
    NSString *dataStr = [NSString stringWithFormat:@"{\"inputs\":[{\"image\":{\"dataType\":50,\"dataValue\":\"%@\"},\"configure\":{\"dataType\":50,\"dataValue\":\"{\\\"side\\\":\\\"face\\\"}\"}}]}",idcardStr];
    
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    //定义PathParameter
    NSMutableDictionary *getPathParams = [[NSMutableDictionary alloc] init];
    
    //    //定义QueryParameter
    NSMutableDictionary *getQueryParams = [[NSMutableDictionary alloc] init];
    //
    //定义HeaderParameter
    NSMutableDictionary *getHeaderParams = [[NSMutableDictionary alloc] init];
    
    
    [[HttpUtil instance] httpPost:postPath
                       pathParams:getPathParams
                      queryParams:getQueryParams
                             body:data
                     headerParams:getHeaderParams
                  completionBlock:^(NSData * _Nullable body , NSURLResponse * _Nullable response, NSError * _Nullable error) {
                      NSLog(@"%@",body);
                      NSLog(@"Response object: %@" , response);
                      NSString *bodyString = [[NSString alloc] initWithData:body encoding:NSUTF8StringEncoding];
                      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                      if (httpResponse.statusCode == 200) {
                          result(YES,bodyString);
                      }else{
                          result(NO,bodyString);
                      }
                  }];
    
    
}

/**
 *  Http Post Bytes调用使用，其中query/header/body中的值可以中文
 *  注意pathparameter不允许中文
 */

@end

#pragma mark - 身份证model
@implementation IDCards

+ (NSDictionary *)mj_objectClassInArray{
    
    return @{
             @"outputs":@"IDCardOutPuts"
             };
    
}

@end

@implementation IDCardOutPuts

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"outputMulti":@"IDCardOutputMulti",
             @"outputValue":@"IDCardOutputValue"
             };
}

@end

@implementation IDCardOutputMulti



@end

@implementation IDCardOutputValue



@end

@implementation IDCardModel



@end
