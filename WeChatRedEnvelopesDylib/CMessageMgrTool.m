
//
//  CMessageMgrTool.m
//  WeChatRedEnvelopesDylib
//
//  Created by 触手TV on 2017/11/30.
//  Copyright © 2017年 触手TV. All rights reserved.
//

#import "CMessageMgrTool.h"
#import <objc/message.h>

@implementation CMessageMgrTool


//解析消息体的那个nativeurl节点的字符串.xml格式懒得解析了再见吧
+(NSString *)getNativeurlString:(NSString *)oriString {
    
    NSArray *array = [oriString componentsSeparatedByString:@"<nativeurl><![CDATA["];
    NSString * string2 = [array objectAtIndex:1];
    NSArray *array2 = [string2 componentsSeparatedByString:@"]]></nativeurl>"];
    return array2[0];
}




+(id)getMMSerViceCenter {
    Class MMServiceCenter = objc_getClass("MMServiceCenter");
    
    if (MMServiceCenter) {
        return  [MMServiceCenter performSelector:@selector(defaultCenter)];
    } else {
        NSLog(@"sjk没有MMServiceCenter这个类");
        return nil;
        
    }
}

+(id)MMSerViceCenterGetService:(char*)className {
    if ([self getMMSerViceCenter]) {
        Class class1 = objc_getClass(className);
        if(class1){
            if([[self getMMSerViceCenter] respondsToSelector:@selector(getService:)]) {
              return   [[self getMMSerViceCenter] performSelector:@selector(getService:) withObject:class1];
                
            }else {
                NSLog(@"sjk mmsevicecenter 没有 getService方法");
                return nil;
            }
        }else {
            NSLog(@"CContactMgr 类没有获取到");
            return nil;
        }
        
    } else {
        NSLog(@"sjk MMSerViceCenterGetService没有获取到");
        return nil;
    }
    
}

+ (id)getVariableforClass:(id)classer var:(SEL) mother {
    
    if([classer respondsToSelector:mother] && classer) {
        
        return   [classer performSelector:mother];
        
    }else {
        NSLog(@"sjk mmsercenter 没有 get变量方法");
        return nil;
    }

}


+ (id)getClassVariableforClass:(char *)classname var:(SEL) mother param1:(id)param1 param2:(id)param2  {
    
    Class MMServiceCenter = objc_getClass(classname);
    
    if (MMServiceCenter) {
       return [MMServiceCenter performSelector:mother withObject:param1 withObject:param2];
        
    } else {
        NSLog(@"sjk没有这个类");
        return nil;
        
    }
}

+ (id)getHaveParameVariableforClass:(id)classer var:(SEL) mother param:(id)param {
    
    if([classer respondsToSelector:mother] && classer) {
        
        return   [classer performSelector:mother withObject:param];
        
    }else {
        NSLog(@"sjk mmsercenter 没有 get变量方法");
        return nil;
    }
    
}



@end
