//
//  ESNetworkManager.m
//  I4U
//
//  Created by Darcy on 2019/4/15.
//  Copyright © 2019 CY. All rights reserved.
//

#import "ESNetworkManager.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <AFNetworking/AFNetworking.h>
#import <sys/utsname.h>

#define kTimeOutInterval 15

@implementation ESNetworkManager

+ (AFHTTPSessionManager *)shareSessionManager {
    static AFHTTPSessionManager *shareManager = nil;
    static dispatch_once_t onceToken;
    mWeakSelf
    dispatch_once(&onceToken, ^{
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:N_HostSiteMain]];
        [manager setSecurityPolicy:[weakSelf customSecurityPolicy]];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html", @"text/plain", @"text/json", @"text/javascript", @"application/json", @"application/xml"]];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.requestSerializer.timeoutInterval = kTimeOutInterval;
        shareManager = manager;
    });
    return shareManager;
}

+ (AFSecurityPolicy*)customSecurityPolicy {
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"avantouch" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    //    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    AFSecurityPolicy *securityPolicy;
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates = [NSSet setWithObjects:certData, nil];
    
    return securityPolicy;
}

+ (NSURLSessionDataTask *)GET:(NSString *)hostString
                       params:(NSDictionary *)params
                      success:(ESNetWordSuccess)success
                      failure:(ESNetWordFailure)failure {
    NSString *urlString = [NSString stringWithFormat:@"%@", hostString];
    if ([hostString hasPrefix:@"http"]) {
        
    } else {
        urlString = [NSString stringWithFormat:@"%@%@", N_HostSiteMain, hostString];
    }
    
    AFHTTPSessionManager *manager = [self shareSessionManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    return [manager GET:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *jsonError = nil;
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&jsonError];
        if ([responseDic isKindOfClass:[NSDictionary class]]) {
            success(task, responseObject);
        } else {
            success(task, responseObject);
        }
    } failure:failure];
    
}

+ (NSURLSessionDataTask *)POST:(NSString *)hostString
                        params:(NSDictionary *)params
                       success:(ESNetWordSuccess)success
                       failure:(ESNetWordFailure)failure {
    NSMutableDictionary *paramsDic = (params?:@{}).mutableCopy;
    NSString *urlString = [NSString stringWithFormat:@"%@",hostString];
    
    if ([hostString hasPrefix:@"http"]) {
    }else {
        urlString = [NSString stringWithFormat:@"%@%@", N_HostSiteMain, hostString];
    }
    AFHTTPSessionManager *manager = [self shareSessionManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //验证token
    return [manager POST:urlString
              parameters:paramsDic
                progress:nil
                 success:^(NSURLSessionDataTask * task, id responseObject){
                     NSError *jsonError = nil;
                     NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&jsonError];
                     if ([responseDic isKindOfClass:[NSDictionary class]]) {
                         //特殊错误码判断
                         success(task, responseObject);
                     } else {
                         success(task, responseObject);
                     }
                 } failure:failure];
}

#pragma mark - 取消所有的网络请求

+ (void)cancelAllRequest {
    [[self shareSessionManager].operationQueue cancelAllOperations];
}

#pragma mark - 取消指定的url请求/

+ (void)cancelHttpRequestWithRequestType:(NSString *)requestType requestUrlString:(NSString *)string {
    NSError * error;
    /**根据请求的类型 以及 请求的url创建一个NSMutableURLRequest---通过该url去匹配请求队列中是否有该url,如果有的话 那么就取消该请求*/
    NSString * urlToPeCanced = [[[[AFHTTPSessionManager manager].requestSerializer requestWithMethod:requestType URLString:string parameters:nil error:&error] URL] path];
    for (NSOperation * operation in [AFHTTPSessionManager manager].operationQueue.operations) {
        //如果是请求队列
        if ([operation isKindOfClass:[NSURLSessionTask class]]) {
            //请求的类型匹配
            BOOL hasMatchRequestType = [requestType isEqualToString:[[(NSURLSessionTask *)operation currentRequest] HTTPMethod]];
            //请求的url匹配
            BOOL hasMatchRequestUrlString = [urlToPeCanced isEqualToString:[[[(NSURLSessionTask *)operation currentRequest] URL] path]];
            //两项都匹配的话  取消该请求
            if (hasMatchRequestType&&hasMatchRequestUrlString) {
                [operation cancel];
            }
        }
    }
}
#pragma mark ---------------RAC+GET(POST)-------------------------

+ (RACSignal *)rac_GET:(NSString *)hostString
                params:(NSDictionary *)params {
    NSMutableDictionary *dictInputNew = [NSMutableDictionary dictionaryWithDictionary:params];
    [dictInputNew setValue:@"TS02" forKey:@"lang"];
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [self GET:hostString params:dictInputNew success:^(NSURLSessionDataTask *task, id responseObject) {
            NSError *jsonError = nil;
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&jsonError];
            if ([responseDic isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = responseDic[@"data"][@"status"];
                //                NSString *errorStatus = responseDic[@"data"][@"data"][@"status"];
                if (errorCode.integerValue == 0 ) {
                    [subscriber sendNext:responseDic];
                    [subscriber sendCompleted];
                } else {
                    [subscriber sendError:[NSError errorWithDomain:responseDic[@"data"][@"msg"] code:0 userInfo:@{NSLocalizedDescriptionKey: responseDic[@"data"][@"msg"]?: @"未知网络错误"}]];
                }
            }else{
                [subscriber sendError:jsonError];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [subscriber sendError:error];
        }];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    return signal;
    
}

+ (RACSignal *)rac_POST:(NSString *)hostString
                 params:(NSDictionary *)params {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [self POST:hostString params:params success:^(NSURLSessionDataTask *task, id responseObject) {
            NSError *jsonError = nil;
            NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&jsonError];
            if ([responseDic isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = responseDic[@"data"][@"ret"];
                NSString *errorStatus = responseDic[@"data"][@"data"][@"status"];
                if (errorCode.integerValue == 1 && errorStatus.integerValue == 0) {
                    [subscriber sendNext:responseDic];
                    [subscriber sendCompleted];
                } else {
                    NSLog(@"%@",hostString);
                    [subscriber sendError:[NSError errorWithDomain:responseDic[@"data"][@"data"][@"msg"] ?: @"" code:errorCode.integerValue userInfo:@{NSLocalizedDescriptionKey: responseDic[@"data"][@"data"][@"msg"]?: @"未知网络错误"}]];
                }
            }else{
                [subscriber sendError:jsonError];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSError *newError = [NSError errorWithDomain:error.localizedDescription code:error.code userInfo:@{NSLocalizedDescriptionKey: @"网络错误,请稍后重试"}];
            
            [subscriber sendError:newError];
        }];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    return signal;
}

//----------------------------业务层接口处理----------------------------
+ (RACSignal *)setUserLabelList:(NSDictionary *)dic {
    return [ESNetworkManager rac_GET:@"/api/user/center-info/" params:dic];
}


@end
