//
//  ViewController.m
//  AliCloudIDCardRecognitionDemo
//
//  Created by 张兴业 on 2017/3/14.
//  Copyright © 2017年 zxy. All rights reserved.
//

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
