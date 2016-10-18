//
//  ViewController.m
//  IAPManageDemo
//
//  Created by d.x.c on 16/10/17.
//  Copyright © 2016年 zhixun. All rights reserved.
//

#import "ViewController.h"
#import "IAPManage.h"

# warning  - 请填写公司的ProductID。  建议放在服务器上
#define KProductIdentifiers @""

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *iapBtn =({
        
                        UIButton *newBtn=[[UIButton  alloc] initWithFrame:self.view.frame];
                        [newBtn setTitle:@"点击购买" forState:UIControlStateNormal];
                        [newBtn addTarget:self action:@selector(requestProductIdentifiers) forControlEvents:UIControlEventTouchUpInside];
                        [newBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                        newBtn;
                        
                  });
    [self.view addSubview:iapBtn];
    

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - **************** 发起支付


-(void)requestProductIdentifiers
{
    [[IAPManage  shareSingeleIAPManage] requestProductIdentifiers:KProductIdentifiers success:^(NSString *ProductIdentifiers, NSData *receiptData) {
        NSLog(@"内购成功");
        
    } failure:^(NSString *failStr, IAPPaymentTransactionFailState state) {
        
        NSLog(@"failStr =%@",failStr);
        
    }];
}


@end
