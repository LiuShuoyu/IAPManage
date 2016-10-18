
##IAPManage介绍

* 一句代码实现内购的支付， 自己封装了IAPManage类 。具体请看代码





## 代码

```objectivec
[[IAPManage  shareSingeleIAPManage] requestProductIdentifiers:KProductIdentifiers success:^(NSString *ProductIdentifiers, NSData *receiptData) {
NSLog(@"内购成功");

} failure:^(NSString *failStr, IAPPaymentTransactionFailState state) {

NSLog(@"failStr =%@",failStr);

}];


```

##有问题反馈
在使用中有任何问题，欢迎反馈给我，可以用以下联系方式跟我交流，谢谢大家， 欢迎star

* QQ 476804765
* Email:13281250969@163.com

