//
//  CMessageMgrTool.h
//  WeChatRedEnvelopesDylib
//
//  Created by 触手TV on 2017/11/30.
//  Copyright © 2017年 触手TV. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMessageMgrTool : NSObject
+(id)getMMSerViceCenter;
+(id)MMSerViceCenterGetService:(char*)className;

+ (id)getVariableforClass:(id)classer var:(SEL) mother;
//类方法调用参数
+ (id)getClassVariableforClass:(char *)classname var:(SEL) mother param1:(id)param1 param2:(id)param2;
//成员变量方法调用
+ (id)getHaveParameVariableforClass:(id)classer var:(SEL) mother param:(id)param;


+(NSString *)getNativeurlString:(NSString *)oriString;

@end
