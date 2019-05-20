//
//  ESNetworkManager.h
//  I4U
//
//  Created by Darcy on 2019/4/15.
//  Copyright © 2019 CY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

#ifndef ESNetworkManager_h
#define ESNetworkManager_h

typedef void (^ESNetWordSuccess)(NSURLSessionDataTask * task, id responseObject);

typedef void (^ESNetWordFailure)(NSURLSessionDataTask * task, NSError * error);

typedef void (^ESNetWordResult)(id data, NSError *error);

typedef void (^ESUploadProgress)(float progress);

typedef void (^ESDownloadProgress)(float progress);

#endif

@class RACSignal;

@interface ESNetworkManager : NSObject

+ (NSURLSessionDataTask *)GET:(NSString *)hostString params:(NSDictionary *)params success:(ESNetWordSuccess)success failure:(ESNetWordFailure)failure;

+ (NSURLSessionDataTask *)POST:(NSString *)hostString params:(NSDictionary *)params success:(ESNetWordSuccess)success failure:(ESNetWordFailure)failure;

/**
 *  取消所有的网络请求
 */
+ (void)cancelAllRequest;

/**
 *  取消指定的url请求
 *
 *  @param requestType 该请求的请求类型
 *  @param string      该请求的完整url
 */

+ (void)cancelHttpRequestWithRequestType:(NSString *)requestType requestUrlString:(NSString *)string;


@end

@interface ESNetworkManager (RAC)

+ (RACSignal *)setUserLabelList:(NSDictionary *)dic;


@end


NS_ASSUME_NONNULL_END
