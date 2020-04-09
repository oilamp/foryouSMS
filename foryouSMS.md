/*
Title: foryouSMS
Description: foryouSMS
*/
<div class="outline">
[init](#a1)

[sendSMS](#a2)

[enterCode](#a3)
</div>

#**概述**

foryouSMS 封装了mob开放平台的SDK，集成了短信发送、校检验证码功能；账号注册验证,支付验证等；使用此模块之前需要先去http://mob.com/sms 注册获取appkey和appsecret，mob每天可以有10000条免费的短信。
    
<div id="a1"></div>
#**init**

foryouSMS模块初始化

init({params})

##params

appkey：

- 类型：字符串
- 描述：（可选项）从mob开放平台获取的 appkey，不可为空。

appsecret：

- 类型：字符串
- 描述：（可选项）从mob开放平台获取的 appsecret，不可为空。

##示例代码

```js
var sms = api.require('foryouSMS');
sms.init({
    appkey:'ae1c21f27cfe',
    appsecret:'0f512a626c51480fb69d0b9d43f939a9'
});
```

##可用性

iOS系统，Android系统

可提供的1.0.0及更高版本

<div id="a2"></div>
#**sendSMS**

获取短信验证码

sendSMS({params}, callback(ret, err))

##params

phone：

- 类型：字符串
- 描述：（可选项）接收短信手机号码。

##callback(ret, err)

ret：

- 类型：JSON对象
- 内部字段：

```js
{
    status: true   //布尔型；true||false
}
```

err：

- 类型：JSON对象
- 内部字段：

```js
{
    code: -1    //数字类型；
                //错误码：
                //-1（未知错误）
                //-2（phone非法）
}
```

##示例代码

```js
var sms = api.require('foryouSMS');
sms.sendSMS({
	phone:"152****8629"
},function(ret,err){
	if(ret.status)
	{ 
		alert("短信发送成功！");
	}else{
		alert(err.code);
	}    		
});
```

##可用性

iOS系统，Android系统

可提供的1.0.0及更高版本

<div id="a3"></div>
#**enterCode**

校检短信验证码

enterCode({params}, callback(ret, err))

##params

code：

- 类型：字符串
- 描述：（可选项）接收到的短信验证码。

##callback(ret, err)

ret：

- 类型：JSON对象
- 内部字段：

```js
{
    status: true   //布尔型；true||false
}
```

err：

- 类型：JSON对象
- 内部字段：

```js
{
    code: -1    //数字类型；
                //错误码：
                //-1（验证码错误）
		//-3 (code非法)
}
```

##示例代码

```js
var sms = api.require('foryouSMS');
sms.enterCode({
	code:"1234"
},function(ret,err){
	if(ret.status)
	{ 
		alert("验证码正确！");
	}else{
		alert(err.code);
	}    		
});
```

##可用性

iOS系统，Android系统

可提供的1.0.0及更高版本

