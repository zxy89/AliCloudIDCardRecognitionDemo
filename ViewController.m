//
//  ViewController.m
//  AliCloudIDCardRecognitionDemo
//
//  Created by 张兴业 on 2016/10/31.
//  Copyright © 2016年 zxy. All rights reserved.
//



#warning 使用时，请搜索以下两个关键字  将内容设置为阿里云账号中的对应值
/**
 
 //Api绑定的的AppKey，可以在“阿里云官网”->"API网关"->"应用管理"->"应用详情"查看
 APP_KEY
 
 //Api绑定的的AppSecret，用来做传输数据签名使用，可以在“阿里云官网”->"API网关"->"应用管理"->"应用详情"查看
 APP_SECRET
 
 */


#import "ViewController.h"
#import "PhotoTool.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *sex;

@property (weak, nonatomic) IBOutlet UILabel *birth;

@property (weak, nonatomic) IBOutlet UILabel *address;

@property (weak, nonatomic) IBOutlet UILabel *idCard;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
}
- (IBAction)take_photo:(UIButton *)sender {
    
    [[PhotoTool shareTool] openCameraWith:self finishHandle:^(UIImage *image) {
        
        [[PhotoTool shareTool] startRecWith:[[PhotoTool shareTool] compressOriginalImage:image toMaxDataSizeKBytes:1.5*1024] callBack:^(IDCardModel *model) {
            
            self.name.text = model.name;
            self.sex.text = model.sex;
            self.birth.text = model.birth;
            self.address.text = model.address;
            self.idCard.text = model.num;
            
        }];
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
