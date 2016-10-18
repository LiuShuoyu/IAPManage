//
//  IAPManage.h
//  IAPManageDemo
//
//  Created by d.x.c on 16/10/17.
//  Copyright © 2016年 zhixun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

typedef NS_ENUM(NSInteger,IAPPaymentTransactionFailState)
{
    IAPPaymentRequestFail =0,        //请求ProductIdentifiers失败
    IAPPaymentNotCanMakePayment ,    //设置了权限， 不能发起支付
    IAPPaymentTransactionStateFailed //支付失败
};

typedef void (^Failure)(NSString *failStr ,IAPPaymentTransactionFailState state );
typedef void (^Success)(NSString *ProductIdentifiers ,NSData *receiptData );

@interface IAPManage : NSObject



+ (instancetype) shareSingeleIAPManage;

- (void)requestProductIdentifiers:(NSString *)ProductIdentifiers
                          success:(Success)successBlock
                          failure:(Failure)failureBlock;

@end
