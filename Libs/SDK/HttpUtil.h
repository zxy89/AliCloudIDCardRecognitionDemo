/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "SignUtil.h"


/**
 * Http工具类
 */
@interface HttpUtil : NSObject

@property (nonatomic, strong) NSURLSession *requestSession;
+ (instancetype) instance;

/**
 *
 * 以GET的方法发送HTTP请求
 *
 * @param path
 * 类似：/v2/getUserInfo/[userId]
 *
 * @param pathParams
 * Api定义中的path参数键值对，SDK会将本字典中的value替换掉path中的动态参数
 * 比如 path=/v2/getUserInfo/[userId]，pathParams 字典中包含 key:userId , value:10000003
 * 发送的请求中的path会变成/v2/getUserInfo/10000003
 *
 * @param queryParams
 * Api定义中的query参数键值对
 * SDK会将字典中的所有键值对拼接到path后，比如path=/v2/getUserInfo/10000003 ，半参数包含key:sex , value:boy
 * 发送的请求中的path会变成/v2/getUserInfo/10000003?sex=boy
 *
 * @param headerParams
 * Api定义中的header参数键值对
 *
 * @param completionBlock 回调函数
 */
-(void)       httpGet:(NSString *) path
           pathParams:(NSDictionary *) pathParams
          queryParams:(NSDictionary*) queryParams
         headerParams:(NSMutableDictionary*) headerParams
      completionBlock:(void (^)(NSData * , NSURLResponse * , NSError *))completionBlock;


/**
 *
 * 以POST的方法发送HTTP请求
 * 请求Body为表单数据
 *
 * @param path
 * 类似：/v2/getUserInfo/[userId]
 *
 * @param pathParams
 * Api定义中的path参数键值对，SDK会将本字典中的value替换掉path中的动态参数
 * 比如 path=/v2/getUserInfo/[userId]，pathParams 字典中包含 key:userId , value:10000003
 * 发送的请求中的path会变成/v2/getUserInfo/10000003
 *
 * @param queryParams
 * Api定义中的query参数键值对
 * SDK会将字典中的所有键值对拼接到path后，比如path=/v2/getUserInfo/10000003 ，半参数包含key:sex , value:boy
 * 发送的请求中的path会变成/v2/getUserInfo/10000003?sex=boy
 *
 * @param headerParams
 * Api定义中的header参数键值对
 *
 * @param formParams
 * Api定义中的form参数键值对
 *
 * @param completionBlock 回调函数
 */
-(void)      httpPost:(NSString *) path
           pathParams:(NSDictionary *) pathParams
          queryParams:(NSDictionary*) queryParams
           formParams:(NSDictionary *) formParams
         headerParams:(NSMutableDictionary*) headerParams
      completionBlock:(void (^)(NSData * , NSURLResponse * , NSError *))completionBlock;



/**
 *
 * 以POST的方法发送HTTP请求
 * 请求Body为Byte数组
 *
 * @param path
 * 类似：/v2/getUserInfo/[userId]
 *
 * @param pathParams
 * Api定义中的path参数键值对，SDK会将本字典中的value替换掉path中的动态参数
 * 比如 path=/v2/getUserInfo/[userId]，pathParams 字典中包含 key:userId , value:10000003
 * 发送的请求中的path会变成/v2/getUserInfo/10000003
 *
 * @param queryParams
 * Api定义中的query参数键值对
 * SDK会将字典中的所有键值对拼接到path后，比如path=/v2/getUserInfo/10000003 ，半参数包含key:sex , value:boy
 * 发送的请求中的path会变成/v2/getUserInfo/10000003?sex=boy
 *
 * @param headerParams
 * Api定义中的header参数键值对
 *
 * @param body
 * 在body中传输的Byte数组
 *
 * @param completionBlock 回调函数
 */
-(void)      httpPost:(NSString *) path
           pathParams:(NSDictionary *) pathParams
          queryParams:(NSDictionary*) queryParams
                 body:(NSData *) body
         headerParams:(NSMutableDictionary*) headerParams
      completionBlock:(void (^)(NSData * , NSURLResponse * , NSError *))completionBlock;




/**
 *
 * 以PUT的方法发送HTTP请求
 * 请求Body为Byte数组
 *
 * @param path
 * 类似：/v2/getUserInfo/[userId]
 *
 * @param pathParams
 * Api定义中的path参数键值对，SDK会将本字典中的value替换掉path中的动态参数
 * 比如 path=/v2/getUserInfo/[userId]，pathParams 字典中包含 key:userId , value:10000003
 * 发送的请求中的path会变成/v2/getUserInfo/10000003
 *
 * @param queryParams
 * Api定义中的query参数键值对
 * SDK会将字典中的所有键值对拼接到path后，比如path=/v2/getUserInfo/10000003 ，半参数包含key:sex , value:boy
 * 发送的请求中的path会变成/v2/getUserInfo/10000003?sex=boy
 *
 * @param headerParams
 * Api定义中的header参数键值对
 *
 * @param body
 * 在body中传输的byte数组
 *
 * @param completionBlock 回调函数
 */
-(void)      httpPut:(NSString *) path
           pathParams:(NSDictionary *) pathParams
          queryParams:(NSDictionary*) queryParams
                 body:(NSData *)  body
         headerParams:(NSMutableDictionary*) headerParams
      completionBlock:(void (^)(NSData * , NSURLResponse * , NSError *))completionBlock;



/**
 *
 * 以DELETE的方法发送HTTP请求
 *
 * @param path
 * 类似：/v2/getUserInfo/[userId]
 *
 * @param pathParams
 * Api定义中的path参数键值对，SDK会将本字典中的value替换掉path中的动态参数
 * 比如 path=/v2/getUserInfo/[userId]，pathParams 字典中包含 key:userId , value:10000003
 * 发送的请求中的path会变成/v2/getUserInfo/10000003
 *
 * @param queryParams
 * Api定义中的query参数键值对
 * SDK会将字典中的所有键值对拼接到path后，比如path=/v2/getUserInfo/10000003 ，半参数包含key:sex , value:boy
 * 发送的请求中的path会变成/v2/getUserInfo/10000003?sex=boy
 *
 * @param headerParams
 * Api定义中的header参数键值对
 *
 * @param completionBlock 回调函数
 */
-(void)    httpDelete:(NSString *) path
           pathParams:(NSDictionary *) pathParams
          queryParams:(NSDictionary*) queryParams
         headerParams:(NSMutableDictionary*) headerParams
      completionBlock:(void (^)(NSData * , NSURLResponse * , NSError *))completionBlock;

@end




@interface HttpUtil (private)


/**
 *
 * 生成带签名的Http请求对象
 *
 * @param method
 * Http请求方法，比如@“GET”,@"POST"等
 *
 * @param path
 * 类似：/v2/getUserInfo/[userId]
 *
 * @param pathParams
 * Api定义中的path参数键值对，SDK会将本字典中的value替换掉path中的动态参数
 * 比如 path=/v2/getUserInfo/[userId]，pathParams 字典中包含 key:userId , value:10000003
 * 发送的请求中的path会变成/v2/getUserInfo/10000003
 *
 * @param queryParams
 * Api定义中的query参数键值对
 * SDK会将字典中的所有键值对拼接到path后，比如path=/v2/getUserInfo/10000003 ，半参数包含key:sex , value:boy
 * 发送的请求中的path会变成/v2/getUserInfo/10000003?sex=boy
 *
 * @param headerParams
 * Api定义中的header参数键值对
 *
 * @param formParams
 * Api定义中的form参数键值对
 *
 * @param body
 * 在body中传输的byte数组
 */
+ (NSURLRequest *) buildRequest:(NSString *) protocol
                         method:(NSString*) method
                           host:(NSString*) host
                           path:(NSString*) path
                     pathParams:(NSDictionary *) pathParams
                    queryParams:(NSDictionary*) queryParams
                     formParams:(NSDictionary *) formParams
                           body:(NSData *) body
             requestContentType:(NSString *) requestContentType
              acceptContentType:(NSString *) acceptContentType
                   headerParams:(NSMutableDictionary*) headerParams;

/**
 *  拼接参数串
 */
+(NSString *) buildParamsString:(NSDictionary *) params;

/**
 *  将path中的参数用pathParams中的值替换
 */
+(NSString *) combinePathParam: (NSString *) path
                    pathParams: (NSDictionary *) pathParams;

/**
 * 对BODY进行MD5加密
 **/
+(NSString *) md5: (NSData *) data;
@end