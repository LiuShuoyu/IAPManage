//
//  IAPManage.m
//  IAPManageDemo
//
//  Created by d.x.c on 16/10/17.
//  Copyright © 2016年 zhixun. All rights reserved.
//

#import "IAPManage.h"

static IAPManage *iapManger =nil;

@interface IAPManage ()<SKProductsRequestDelegate,SKPaymentTransactionObserver>

@property (copy,nonatomic) Failure   failureBlock;
@property (copy,nonatomic) Success   successBlock;

@end
@implementation IAPManage

+ (instancetype) shareSingeleIAPManage
{
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        iapManger =[[IAPManage alloc] init];
    });
    return iapManger;
    
}

- (void)requestProductIdentifiers:(NSString *)ProductIdentifiers
                          success:(Success)successBlock
                          failure:(Failure)failureBlock

{
    if (_successBlock != successBlock) {
        _successBlock = successBlock;
    }
    if (_failureBlock != failureBlock) {
        _failureBlock = failureBlock;
    }
    
    if (ProductIdentifiers.length>0)
    {
        SKProductsRequest *productRequest = [[SKProductsRequest alloc]initWithProductIdentifiers:[NSSet setWithObject:ProductIdentifiers]];
        productRequest.delegate = self;
        [productRequest start];
    }
    else
    {
        _failureBlock(@"商品ID为空",IAPPaymentRequestFail);
    }
    
    
    
}


#pragma mark SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *productArray =response.products;
    if (productArray.count>0 )
    {
        SKProduct *product =[productArray firstObject];
        if ([SKPaymentQueue canMakePayments])
        {
            SKPayment *payment = [SKPayment paymentWithProduct:product];
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        }
        else
        {
            _failureBlock(@"用户设置禁止应用内付费购买.商品信息",IAPPaymentNotCanMakePayment);
        }
    }
    else
    {
        _failureBlock(@"无法获取到商品信息",IAPPaymentRequestFail);

    }
    
    
}
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing: //商品添加进列表
                NSLog(@"商品被添加进购买列表");
                break;
            case SKPaymentTransactionStatePurchased://交易成功
            {
                NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
                NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                _successBlock(transaction.payment.productIdentifier,receiptData);
            }
            break;
            case SKPaymentTransactionStateFailed://交易失败
                _failureBlock(@"支付失败",IAPPaymentTransactionStateFailed);
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];

                break;
            case SKPaymentTransactionStateRestored://已购买过该商品
                break;
            case SKPaymentTransactionStateDeferred://交易延迟
                break;
            default:
                break;
        }
    }
}

@end
