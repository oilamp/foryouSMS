//
//  UZModuleDemo.m
//  UZModule
//
//  Created by kenny on 14-3-5.
//  Copyright (c) 2014年 APICloud. All rights reserved.
//

#import "UZSMS.h"
#import "UZAppDelegate.h"
#import "NSDictionaryUtils.h"
#import <SMS_SDK/SMSSDK.h>

@interface UZSMS ()
<UIAlertViewDelegate>
{
    NSInteger _cbId;
    NSString *_phone;
}

@end

@implementation UZSMS

- (id)initWithUZWebView:(UZWebView *)webView_ {
    if (self = [super initWithUZWebView:webView_]) {
        
    }
    return self;
}

- (void)dispose {
    //do clean
}

/**
 *  @from                    v0.0.1
 *  @brief                   初始化(Get verification code by SMS)
 *
 *  @param method            初始化短信模块的方法(The method of getting verificationCode)
 */
-(void)init:(NSDictionary *)paramsDict_ {
    NSString *appkey = [paramsDict_ stringValueForKey:@"appkey" defaultValue:nil];
    NSString *appSecret = [paramsDict_ stringValueForKey:@"appkey" defaultValue:nil];
    [SMSSDK registerApp:appkey withSecret:appSecret];
}

/**
 *  @from                    v0.0.1
 *  @brief                   发送验证码(Get verification code by SMS)
 *
 *  @param method            获取验证码的方法(The method of getting verificationCode)
 *  @param paramsDict_       电话号码(The phone number)
 */
- (void)sendSMS:(NSDictionary *)paramsDict_ {
    _phone = [paramsDict_ stringValueForKey:@"phone" defaultValue:nil];
    _cbId = [paramsDict_ integerValueForKey:@"cbId" defaultValue:-1];
    
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithCapacity:1];
    NSMutableDictionary *err = [NSMutableDictionary dictionaryWithCapacity:1];
    
    int errCode = -1;
    if (_phone == nil || 0 == _phone.length ) {
        errCode = -2;
        [ret setObject:[NSNumber numberWithBool:NO] forKey:@"status"];
        [err setObject:[NSNumber numberWithInt:errCode] forKey:@"code"];
        [self sendResultEventWithCallbackId:_cbId dataDict:ret errDict:err doDelete:YES];
        return;
    }
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
     //这个参数可以选择是通过发送验证码还是语言来获取验证码
                            phoneNumber:_phone
                                   zone:@"86"
                       customIdentifier:nil //自定义短信模板标识
                                 result:^(NSError *error)
     {
         if (!error)
         {
             [ret setObject:[NSNumber numberWithBool:YES] forKey:@"status"];
             [self sendResultEventWithCallbackId:_cbId dataDict:ret errDict:nil doDelete:YES];
         }
         else
         {
             [ret setObject:[NSNumber numberWithBool:NO] forKey:@"status"];
             [err setObject:[NSNumber numberWithInt:errCode] forKey:@"code"];
             [self sendResultEventWithCallbackId:_cbId dataDict:ret errDict:err doDelete:YES];
         }
         
     }];
    
}

/**
 *  @from                    v0.0.1
 *  @brief                   提交验证码(Get verification code by SMS)
 *
 *  @param method            提交验证码的方法(The method of getting verificationCode)
 *  @param paramsDict_       验证码@(The phone number)
 */
- (void)enterCode:(NSDictionary *)paramsDict_ {
    _cbId = [paramsDict_ integerValueForKey:@"cbId" defaultValue:-1];
    NSString *code = [paramsDict_ stringValueForKey:@"code" defaultValue:nil];
    NSMutableDictionary *ret = [NSMutableDictionary dictionaryWithCapacity:1];
    NSMutableDictionary *err = [NSMutableDictionary dictionaryWithCapacity:1];
    
    int errCode = -1;
    if (_phone == nil || 0 == _phone.length ) {
        errCode = -2;
        [ret setObject:[NSNumber numberWithBool:NO] forKey:@"status"];
        [err setObject:[NSNumber numberWithInt:errCode] forKey:@"code"];
        [self sendResultEventWithCallbackId:_cbId dataDict:ret errDict:err doDelete:YES];
        return;
    }
    
    if (code == nil || 0 == code.length ) {
        errCode = -3;
        [ret setObject:[NSNumber numberWithBool:NO] forKey:@"status"];
        [err setObject:[NSNumber numberWithInt:errCode] forKey:@"code"];
        [self sendResultEventWithCallbackId:_cbId dataDict:ret errDict:err doDelete:YES];
        return;
    }
    
    [SMSSDK  commitVerificationCode:code
     //传获取到的区号
                        phoneNumber:_phone
                               zone:@"86"
                             result:^(NSError *error)
     {
         
         if (!error)
         {
             [ret setObject:[NSNumber numberWithBool:YES] forKey:@"status"];
             [self sendResultEventWithCallbackId:_cbId dataDict:ret errDict:nil doDelete:YES];
         }
         else
         {
             [ret setObject:[NSNumber numberWithBool:NO] forKey:@"status"];
             [err setObject:[NSNumber numberWithInt:errCode] forKey:@"code"];
             [self sendResultEventWithCallbackId:_cbId dataDict:ret errDict:err doDelete:YES];
         }
         
     }];
    
}

@end
