//  weibo: http://weibo.com/xiaoqing28
//  blog:  http://www.alonemonkey.com
//
//  WeChatRedEnvelopesDylib.m
//  WeChatRedEnvelopesDylib
//
//  Created by 触手TV on 2017/11/30.
//  Copyright (c) 2017年 触手TV. All rights reserved.
//

#import "WeChatRedEnvelopesDylib.h"
#import <CaptainHook/CaptainHook.h>
#import <UIKit/UIKit.h>
#import <Cycript/Cycript.h>
#import "CMessageMgrTool.h"
#import <objc/message.h>




static __attribute__((constructor)) void entry(){
    NSLog(@"\n               🎉!!！congratulations!!！🎉\n👍----------------insert dylib success----------------👍");
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        CYListenServer(6666);
    }];
    
}


CHDeclareClass(BaseMsgContentViewController)
//优化方法
CHOptimizedMethod(0, self, void, BaseMsgContentViewController,viewDidLoad){
    //get origin value
    CHSuper(0, BaseMsgContentViewController, viewDidLoad);
    
    //    NSLog(@"origin name is:%@",originName);
    
    //get property
    //    NSString* password = CHIvar(self,_password,__strong NSString*);
    //
    //    NSLog(@"password is %@",password);
    NSLog(@"viewdidloadforwechat");
    
    //change the value
    //    return @"AloneMonkey";
    
}



//CHDeclareClass(CMessageWrap)
//CHDeclareProperty(CMessageWrap, m_uiMessageType);
//CHMethod0(int, CMessageWrap, m_uiMessageType) {
////     CHSuper0(CMessageWrap, m_uiMessageType);
//
//    NSLog(@"类型打印 : %d",CHIvar(self, m_uiMessageType,  int));
//
//
//}
//







@class CMessageWrap,CContactMgr,CContact;
CHDeclareClass(CMessageMgr)
CHMethod2(void, CMessageMgr, AsyncOnAddMsg, id, message, MsgWrap, CMessageWrap*, msgWrap) {

    int type = CHIvar(msgWrap, m_uiMessageType, int);
    NSString * nsContent =  CHIvar(msgWrap, m_nsContent,__strong NSString*);
    NSLog(@"sjkfuck8 : %@",nsContent);
    NSString * nsFromUsr =  CHIvar(msgWrap, m_nsFromUsr,__strong NSString*);
    NSLog(@"sjkfuck7 : %@",nsFromUsr);

    if(type == 49){
        CContactMgr *contactManager = [CMessageMgrTool MMSerViceCenterGetService:"CContactMgr"];
        NSLog(@"sjkfuck1 : %@",contactManager);

        CContact *selfContact = [CMessageMgrTool getVariableforClass:contactManager var:@selector(getSelfContact)];
        NSLog(@"sjkfuck2 : %@",selfContact);
        NSLog(@"sjkfuck3 : %@",nsContent);
        if ([nsContent rangeOfString:@"wxpay://c2cbizmessagehandler/hongbao/receivehongbao"].location != NSNotFound) { // 红包
//            NSString *nativeUrl = [[msgWrap m_oWCPayInfoItem] m_c2cNativeUrl];
            NSString *nativeUrl1 = [CMessageMgrTool getNativeurlString:nsContent];
            NSLog(@"sjkwangzhi : %@",nativeUrl1);

            NSString *nativeUrl = [nativeUrl1 substringFromIndex:[@"wxpay://c2cbizmessagehandler/hongbao/receivehongbao?" length]];
            NSLog(@"sjkwangzhi2 : %@",nativeUrl);

//            NSDictionary *nativeUrlDict = [%c(WCBizUtil) dictionaryWithDecodedComponets:nativeUrl separator:@"&"];
            NSDictionary *nativeUrlDict = [CMessageMgrTool getClassVariableforClass:"WCBizUtil" var:@selector(dictionaryWithDecodedComponets: separator:) param1:nativeUrl param2:@"&"];
            NSLog(@"sjkwangzhi3 : %@",nativeUrlDict);

            NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
            [args setObject:nativeUrlDict[@"msgtype"] forKey:@"msgType"];
            [args setObject:nativeUrlDict[@"sendid"] forKey:@"sendId"];
            [args setObject:nativeUrlDict[@"channelid"] forKey:@"channelId"];
            [args setObject:[CMessageMgrTool getVariableforClass:selfContact var:@selector(getContactDisplayName)] forKey:@"nickName"];
            NSLog(@"sjkfuck4 : %@",[CMessageMgrTool getVariableforClass:selfContact var:@selector(getContactDisplayName)]);

            [args setObject:[CMessageMgrTool getVariableforClass:selfContact var:@selector(m_nsHeadImgUrl)] forKey:@"headImg"];
            NSLog(@"sjkfuck5 : %@",[CMessageMgrTool getVariableforClass:selfContact var:@selector(m_nsHeadImgUrl)]);

            [args setObject:nativeUrl1 forKey:@"nativeUrl"];
            [args setObject:@"7520841002@chatroom" forKey:@"sessionUserName"];
            NSLog(@"sjkfuck722 : %@",nsFromUsr);

//            [args setObject:@"sjk" forKey:@"jiker"];
            
            [CMessageMgrTool getHaveParameVariableforClass:[CMessageMgrTool MMSerViceCenterGetService:"WCRedEnvelopesLogicMgr"] var:@selector(OpenRedEnvelopesRequest:) param:args];
//            NSLog(@"sjkfuck6 : %@",[CMessageMgrTool getHaveParameVariableforClass:[CMessageMgrTool MMSerViceCenterGetService:"WCRedEnvelopesLogicMgr"] var:@selector(OpenRedEnvelopesRequest:) param:args]);
        }
        
    }
    CHSuper2(CMessageMgr, AsyncOnAddMsg, message, MsgWrap, msgWrap);

}


CHDeclareClass(WCRedEnvelopesLogicMgr)
CHMethod1(void, WCRedEnvelopesLogicMgr, OpenRedEnvelopesRequest, NSMutableDictionary *, args) {
    CHSuper1(WCRedEnvelopesLogicMgr, OpenRedEnvelopesRequest, args);
    
    NSLog(@"sjk args go :%@",args);
    
    
}



//构造函数
CHConstructor{
    //负荷类
    CHLoadLateClass(BaseMsgContentViewController);
    //类钩子
    CHClassHook(0, BaseMsgContentViewController, viewDidLoad);
    
    
    CHLoadLateClass(CMessageMgr);
    CHClassHook2(CMessageMgr, AsyncOnAddMsg, MsgWrap);
    
    CHLoadLateClass(WCRedEnvelopesLogicMgr);
    CHClassHook1(WCRedEnvelopesLogicMgr, OpenRedEnvelopesRequest);
    
    
//    CHLoadLateClass(CMessageWrap);

//    CHClassHook0(CMessageWrap, m_uiMessageType);
//
}








//    if([CMessageMgrTool getVariableforClass:msgWrap var:@selector(m_uiMessageType)] == 49){
//        CContactMgr *contactManager = [CMessageMgrTool MMSerViceCenterGetService:"CContactMgr"];
//        CContact *selfContact = [CMessageMgrTool getVariableforClass:contactManager var:@selector(getSelfContact)];
//
//        if ([[CMessageMgrTool getVariableforClass:msgWrap var:@selector(m_nsContent)] rangeOfString:@"wxpay://c2cbizmessagehandler/hongbao/receivehongbao"].location != NSNotFound) { // 红包
//
//
//            NSString *nativeUrl = [CMessageMgrTool getVariableforClass:[CMessageMgrTool getVariableforClass:msgWrap var:@selector(m_oWCPayInfoItem)] var:@selector(m_oWCPayInfoItem)];
//            nativeUrl = [nativeUrl substringFromIndex:[@"wxpay://c2cbizmessagehandler/hongbao/receivehongbao?" length]];
//
////            NSDictionary *nativeUrlDict = [WCBizUtil dictionaryWithDecodedComponets:nativeUrl separator:@"&"];
//            NSDictionary *nativeUrlDict = [CMessageMgrTool getClassVariableforClass:"WCBizUtil" var:@selector(dictionaryWithDecodedComponets: separator:) param1:nativeUrl param2:@"&"];
//
//            NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
//            [args setObject:nativeUrlDict[@"msgtype"] forKey:@"msgType"];
//            [args setObject:nativeUrlDict[@"sendid"] forKey:@"sendId"];
//            [args setObject:nativeUrlDict[@"channelid"] forKey:@"channelId"];
//            [args setObject:[CMessageMgrTool getVariableforClass:selfContact var:@selector(getContactDisplayName)] forKey:@"nickName"];
//            [args setObject:[CMessageMgrTool getVariableforClass:selfContact var:@selector(m_nsHeadImgUrl)] forKey:@"headImg"];
//            [args setObject:nativeUrl forKey:@"nativeUrl"];
//            [args setObject:[CMessageMgrTool getVariableforClass:msgWrap var:@selector(m_nsFromUsr)] forKey:@"sessionUserName"];
//
//            [CMessageMgrTool getHaveParameVariableforClass:[CMessageMgrTool MMSerViceCenterGetService:"WCRedEnvelopesLogicMgr"] var:@selector(OpenRedEnvelopesRequest:) param:args];
//        }
//    }






//#define SAVESETTINGS(key, value) { \
//NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); \
//NSString *docDir = [paths objectAtIndex:0]; \
//if (!docDir){ return;} \
//NSMutableDictionary *dict = [NSMutableDictionary dictionary]; \
//NSString *path = [docDir stringByAppendingPathComponent:@"HBPluginSettings.txt"]; \
//[dict setObject:value forKey:key]; \
//[dict writeToFile:path atomically:YES]; \
//}
//
//
///**
// *  插件功能
// */
//static int const kCloseRedEnvPlugin = 0;
//static int const kOpenRedEnvPlugin = 1;
//static int const kCloseRedEnvPluginForMyself = 2;
//static int const kCloseRedEnvPluginForMyselfFromChatroom = 3;
//
////0：关闭红包插件
////1：打开红包插件
////2: 不抢自己的红包
////3: 不抢群里自己发的红包
//static int HBPliginType = 1;
//
//CHDeclareClass(CMessageMgr);
//
//CHMethod(2, void, CMessageMgr, AsyncOnAddMsg, id, arg1, MsgWrap, id, arg2)
//{
//    CHSuper(2, CMessageMgr, AsyncOnAddMsg, arg1, MsgWrap, arg2);
//    Ivar uiMessageTypeIvar = class_getInstanceVariable(objc_getClass("CMessageWrap"), "m_uiMessageType");
//    ptrdiff_t offset = ivar_getOffset(uiMessageTypeIvar);
//    unsigned char *stuffBytes = (unsigned char *)(__bridge void *)arg2;
//    NSUInteger m_uiMessageType = * ((NSUInteger *)(stuffBytes + offset));
//
//    Ivar nsFromUsrIvar = class_getInstanceVariable(objc_getClass("CMessageWrap"), "m_nsFromUsr");
//    id m_nsFromUsr = object_getIvar(arg2, nsFromUsrIvar);
//
//    Ivar nsContentIvar = class_getInstanceVariable(objc_getClass("CMessageWrap"), "m_nsContent");
//    id m_nsContent = object_getIvar(arg2, nsContentIvar);
//
//    switch(m_uiMessageType) {
//        case 1:
//        {
//            //普通消息
//            //红包插件功能
//            //0：关闭红包插件
//            //1：打开红包插件
//            //2: 不抢自己的红包
//            //3: 不抢群里自己发的红包
//            //微信的服务中心
//            Method methodMMServiceCenter = class_getClassMethod(objc_getClass("MMServiceCenter"), @selector(defaultCenter));
//            IMP impMMSC = method_getImplementation(methodMMServiceCenter);
//            id MMServiceCenter = impMMSC(objc_getClass("MMServiceCenter"), @selector(defaultCenter));
//            //通讯录管理器
//            id contactManager = ((id (*)(id, SEL, Class))objc_msgSend)(MMServiceCenter, @selector(getService:),objc_getClass("CContactMgr"));
//            id selfContact = objc_msgSend(contactManager, @selector(getSelfContact));
//
//            Ivar nsUsrNameIvar = class_getInstanceVariable([selfContact class], "m_nsUsrName");
//            id m_nsUsrName = object_getIvar(selfContact, nsUsrNameIvar);
//            BOOL isMesasgeFromMe = NO;
//            if ([m_nsFromUsr isEqualToString:m_nsUsrName]) {
//                //发给自己的消息
//                isMesasgeFromMe = YES;
//            }
//
//            if (isMesasgeFromMe)
//            {
//                if ([m_nsContent rangeOfString:@"打开红包插件"].location != NSNotFound)
//                {
//                    HBPliginType = kOpenRedEnvPlugin;
//                }
//                else if ([m_nsContent rangeOfString:@"关闭红包插件"].location != NSNotFound)
//                {
//                    HBPliginType = kCloseRedEnvPlugin;
//                }
//                else if ([m_nsContent rangeOfString:@"关闭抢自己红包"].location != NSNotFound)
//                {
//                    HBPliginType = kCloseRedEnvPluginForMyself;
//                }
//                else if ([m_nsContent rangeOfString:@"关闭抢自己群红包"].location != NSNotFound)
//                {
//                    HBPliginType = kCloseRedEnvPluginForMyselfFromChatroom;
//                }
//
//                SAVESETTINGS(@"HBPliginType", [NSNumber numberWithInt:HBPliginType]);
//            }
//        }
//            break;
//        case 49: {
//            // 49=红包
//
//            //微信的服务中心
//            Method methodMMServiceCenter = class_getClassMethod(objc_getClass("MMServiceCenter"), @selector(defaultCenter));
//            IMP impMMSC = method_getImplementation(methodMMServiceCenter);
//            id MMServiceCenter = impMMSC(objc_getClass("MMServiceCenter"), @selector(defaultCenter));
//            //红包控制器
//            id logicMgr = ((id (*)(id, SEL, Class))objc_msgSend)(MMServiceCenter, @selector(getService:),objc_getClass("WCRedEnvelopesLogicMgr"));
//            //通讯录管理器
//            id contactManager = ((id (*)(id, SEL, Class))objc_msgSend)(MMServiceCenter, @selector(getService:),objc_getClass("CContactMgr"));
//
//            Method methodGetSelfContact = class_getInstanceMethod(objc_getClass("CContactMgr"), @selector(getSelfContact));
//            IMP impGS = method_getImplementation(methodGetSelfContact);
//            id selfContact = impGS(contactManager, @selector(getSelfContact));
//
//            Ivar nsUsrNameIvar = class_getInstanceVariable([selfContact class], "m_nsUsrName");
//            id m_nsUsrName = object_getIvar(selfContact, nsUsrNameIvar);
//            BOOL isMesasgeFromMe = NO;
//            BOOL isChatroom = NO;
//            if ([m_nsFromUsr isEqualToString:m_nsUsrName]) {
//                isMesasgeFromMe = YES;
//            }
//            if ([m_nsFromUsr rangeOfString:@"@chatroom"].location != NSNotFound)
//            {
//                isChatroom = YES;
//            }
//            if (isMesasgeFromMe && kCloseRedEnvPluginForMyself == HBPliginType && !isChatroom) {
//                //不抢自己的红包
//                break;
//            }
//            else if(isMesasgeFromMe && kCloseRedEnvPluginForMyselfFromChatroom == HBPliginType && isChatroom)
//            {
//                //不抢群里自己的红包
//                break;
//            }
//
//            if ([m_nsContent rangeOfString:@"wxpay://"].location != NSNotFound)
//            {
//                NSString *nativeUrl = m_nsContent;
//                NSRange rangeStart = [m_nsContent rangeOfString:@"wxpay://c2cbizmessagehandler/hongbao"];
//                if (rangeStart.location != NSNotFound)
//                {
//                    NSUInteger locationStart = rangeStart.location;
//                    nativeUrl = [nativeUrl substringFromIndex:locationStart];
//                }
//
//                NSRange rangeEnd = [nativeUrl rangeOfString:@"]]"];
//                if (rangeEnd.location != NSNotFound)
//                {
//                    NSUInteger locationEnd = rangeEnd.location;
//                    nativeUrl = [nativeUrl substringToIndex:locationEnd];
//                }
//
//                NSString *naUrl = [nativeUrl substringFromIndex:[@"wxpay://c2cbizmessagehandler/hongbao/receivehongbao?" length]];
//
//                NSArray *parameterPairs =[naUrl componentsSeparatedByString:@"&"];
//
//                NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:[parameterPairs count]];
//                for (NSString *currentPair in parameterPairs) {
//                    NSRange range = [currentPair rangeOfString:@"="];
//                    if(range.location == NSNotFound)
//                        continue;
//                    NSString *key = [currentPair substringToIndex:range.location];
//                    NSString *value =[currentPair substringFromIndex:range.location + 1];
//                    [parameters setObject:value forKey:key];
//                }
//
//                //红包参数
//                NSMutableDictionary *params = [@{} mutableCopy];
//
//                [params setObject:parameters[@"msgtype"]?:@"null" forKey:@"msgType"];
//                [params setObject:parameters[@"sendid"]?:@"null" forKey:@"sendId"];
//                [params setObject:parameters[@"channelid"]?:@"null" forKey:@"channelId"];
//
//                id getContactDisplayName = objc_msgSend(selfContact, @selector(getContactDisplayName));
//                id m_nsHeadImgUrl = objc_msgSend(selfContact, @selector(m_nsHeadImgUrl));
//
//                [params setObject:getContactDisplayName forKey:@"nickName"];
//                [params setObject:m_nsHeadImgUrl forKey:@"headImg"];
//                [params setObject:[NSString stringWithFormat:@"%@", nativeUrl]?:@"null" forKey:@"nativeUrl"];
//                [params setObject:m_nsFromUsr?:@"null" forKey:@"sessionUserName"];
//
//                if (kCloseRedEnvPlugin != HBPliginType) {
//                    //自动抢红包
//                    ((void (*)(id, SEL, NSMutableDictionary*))objc_msgSend)(logicMgr, @selector(OpenRedEnvelopesRequest:), params);
//                }
//                return;
//            }
//
//            break;
//        }
//        default:
//            break;
//    }
//}
//
//
////构造函数
//CHConstructor{
//    CHLoadLateClass(CMessageMgr);
//    CHClassHook(2, CMessageMgr, AsyncOnAddMsg, MsgWrap);
//
//}
//
