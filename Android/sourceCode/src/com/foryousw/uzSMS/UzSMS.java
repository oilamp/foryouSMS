/**
 * APICloud Modules
 * Copyright (c) 2014-2015 by APICloud, Inc. All Rights Reserved.
 * Licensed under the terms of the The MIT License (MIT).
 * Please see the license.html included with this distribution for details.
 */
package com.foryousw.uzSMS;

import org.json.JSONException;
import org.json.JSONObject;

import cn.smssdk.EventHandler;
import cn.smssdk.SMSSDK;
import com.uzmap.pkg.uzcore.UZWebView;
import com.uzmap.pkg.uzcore.uzmodule.UZModule;
import com.uzmap.pkg.uzcore.uzmodule.UZModuleContext;

public class UzSMS extends UZModule {
	public static boolean INITIALIZED = false;
	private UZModuleContext moduleContext;
	private	String phone = "";
	public UzSMS(UZWebView webView) {
		super(webView);
	}

	public void jsmethod_init(UZModuleContext moduleContext) {
		SMSSDK.initSDK(mContext, moduleContext.optString("appkey"), moduleContext.optString("appsecret"));
		initEvent();
	}
	
	public void jsmethod_sendSMS(UZModuleContext moduleContext) {
		this.moduleContext = moduleContext;
		phone = moduleContext.optString("phone");
		JSONObject ret = new JSONObject();
		JSONObject err = new JSONObject();
		if(phone == null || "".equals(phone))
		{	try {
				ret.put("status", false);
				err.put("code", -2);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			moduleContext.error(ret, err, false);
			return;
		}		
		SMSSDK.getVerificationCode("86",phone);
	}
	
	public void jsmethod_enterCode(UZModuleContext moduleContext) {
		this.moduleContext = moduleContext;
		String code = moduleContext.optString("code");
		JSONObject ret = new JSONObject();
		JSONObject err = new JSONObject();
		if(phone == null || "".equals(phone))
		{	try {
				ret.put("status", false);
				err.put("code", -2);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			moduleContext.error(ret, err, false);
			return;
		}		
		if(code == null || "".equals(code))
		{	try {
				ret.put("status", false);
				err.put("code", -3);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			moduleContext.error(ret, err, false);
			return;
		}		
		SMSSDK.submitVerificationCode("86", phone, code);
	}
	
	@Override
	protected void onClean() {
		// TODO Auto-generated method stub
		super.onClean();
		SMSSDK.unregisterAllEventHandler();
	}
	public void initEvent()
	{
		EventHandler eh=new EventHandler(){
			@Override
			public void afterEvent(int event, int result, Object data) {
				JSONObject ret = new JSONObject();
				JSONObject err = new JSONObject();
				if (result == SMSSDK.RESULT_COMPLETE) {
			        if (event == SMSSDK.EVENT_SUBMIT_VERIFICATION_CODE) {
			        	//提交验证码成功
			        	try {
			        		ret.put("status", true);
			        		ret.put("result", data);
						} catch (JSONException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
			        	moduleContext.success(ret, true);
			        }else if (event == SMSSDK.EVENT_GET_VERIFICATION_CODE){
			        	try {
			        		ret.put("status", true);
			        		ret.put("result", data);
						} catch (JSONException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
			        	moduleContext.success(ret, true);
			        	//获取验证码成功
			        }
				} else {
		        	try {
		        		ret.put("status", false);
		        		err.put("code", -1);
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}					
					moduleContext.error(ret, err, false);
				}
			}
		};
		SMSSDK.registerEventHandler(eh);
	}
}
