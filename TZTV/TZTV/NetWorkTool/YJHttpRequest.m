//
//  YJHttpRequest.m
//  YJWeibo-oc
//
//  Created by sctto on 16/3/23.
//  Copyright © 2016年 sctto. All rights reserved.
//

#import "YJHttpRequest.h"
#import "AFNetworking.h"
#import "Reachability.h"

@interface YJHttpRequest ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) AFHTTPSessionManager *manager2;
@end

@implementation YJHttpRequest

HMSingletonM(Manager)

- (AFHTTPSessionManager *)manager{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
        // 请求https
        //_manager.securityPolicy.allowInvalidCertificates = YES;
        //设置请求格式
        //_manager.requestSerializer=[AFJSONRequestSerializer serializer];//申明请求的数据是json类型
        // 设置响应格式
        //_manager.responseSerializer=[AFHTTPResponseSerializer serializer];//不解析
        
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];//设置json解析
        _manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",@"text/css", @"application/x-javascript",nil];
        _manager.requestSerializer.timeoutInterval = 3;
    }
    return _manager;
}

-(AFHTTPSessionManager *)manager2{
    if (!_manager2) {
        _manager2 = [AFHTTPSessionManager manager];
        _manager2.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain",@"text/css", @"application/x-javascript",nil];
        _manager2.responseSerializer=[AFHTTPResponseSerializer serializer];//不解析
    }
    return _manager2;
}

- (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    [self.manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        YJLog(@"%lf",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure(error);
    }];
}

- (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    [self.manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        YJLog(@"%lf",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure(error);
    }];
}

- (void)createAnUploadTask:(NSString *)urlStr imageData:(NSData *)imageData andParameters:(NSDictionary *)paramDic success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{

    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
    } error:nil];
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [self.manager2
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      
                      //                      dispatch_async(dispatch_get_main_queue(), ^{
                      //                          //Update the progress view
                      //                          [progressView setProgress:uploadProgress.fractionCompleted];
                      //                      });
                  }completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          YJLog(@"%@",error);
                          if (failure) failure(error);
                      } else {
                          id backData=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                          if (success) success(backData);
                      }
                  }];
    [uploadTask resume];
}

+ (void)createAnUploadTask:(NSString *)urlStr imageData:(NSData *)imageData andParameters:(NSDictionary *)paramDic success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
//    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
//    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
//    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
//    [manager POST:urlStr parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        NSInputStream *stream=[[NSInputStream alloc] initWithData:imageData];
//        uint8_t buf[1024];
//        NSInteger len=[stream read:buf maxLength:sizeof(buf)];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat = @"yyyyMMddHHmmss";
//        NSString *str = [formatter stringFromDate:[NSDate date]];
//        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
//        [formData appendPartWithInputStream:stream name:@"file" fileName:fileName length:len mimeType:@"image/jpeg"];
//        [formData appendPartWithFileData:imageData name:@"pic" fileName:@"pic.jpg" mimeType:@"application/octet-stream"];
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        id backData=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        success(backData);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(error);
//    }];
}

/**多图上传*/
- (void)createMultiUploadTask:(NSString *)urlStr imageData:(NSArray *)imageArray compressionRatio:(float)ratio andParameters:(NSDictionary *)paramDic success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        for (int i=0;i<imageArray.count;i++) {
            NSString *fileName = [NSString stringWithFormat:@"%@%d.png",str,i];
            NSData *imageData;
            if (ratio > 0.0f && ratio < 1.0f) {
                imageData = UIImageJPEGRepresentation(imageArray[i], ratio);
            }else{
                imageData = UIImageJPEGRepresentation(imageArray[i], 1.0f);
            }
            [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
        }
    } error:nil];
    
    NSURLSessionUploadTask *uploadTask;
    self.manager.responseSerializer=[AFHTTPResponseSerializer serializer];//不解析
    uploadTask = [self.manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      
                  }completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          failure(error);
                      } else {
                          id backData=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                          success(backData);
                      }
                  }];
    [uploadTask resume];
}

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure{
//        NSString *backData=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSString *jsonString = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSUTF8StringEncoding];
//        NSString *backData1=[jsonString substringToIndex:jsonString.length-1];
//        NSInteger subStringLocation=[backData1 rangeOfString:@"callback("].location;
//        NSString *backData2=[backData1 substringFromIndex:subStringLocation+9];
//        NSData *data=[backData2 dataUsingEncoding:NSUTF8StringEncoding];
//        id backData=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
}



//–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
/**
 *  多图上传
 */
//-(void)startMultiPartUploadTaskWithURL:(NSString *)url imagesArray:(NSArray *)images parameterOfimages:(NSString *)parameter parametersDict:(NSDictionary *)parameters compressionRatio:(float)ratio succeedBlock:(void (^)(NSDictionary *dict))succeedBlock failedBlock:(void (^)(NSError *error))failedBlock{
//    if (images.count == 0) {
//        return;
//    }
//    for (int i = 0; i < images.count; i++) {
//        if (![images[i] isKindOfClass:[UIImage class]]) {
//            NSLog(@"images中第%d个元素不是UIImage对象",i+1);
//        }
//    }
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    //以下三项manager的属性根据需要进行配置
//    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html" @"text/json" @"text/javascript" @"text/plain"];
//    //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        int i = 0;
//        NSDate *date = [NSDate date];
//        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//        [formatter setDateFormat:@"yyyy年MM月dd日"];
//        NSString *dateString = [formatter stringFromDate:date];
//        
//        for (UIImage *image in images) {
//            NSString *fileName = [NSString stringWithFormat:@"%@%d.png",dateString,i];
//            NSData *imageData;
//            if (ratio > 0.0f && ratio < 1.0f) {
//                imageData = UIImageJPEGRepresentation(image, ratio);
//            }else{
//                imageData = UIImageJPEGRepresentation(image, 1.0f);
//            }
//            [formData appendPartWithFileData:imageData name:parameter fileName:fileName mimeType:@"image/jpg/png/jpeg"];
//        }
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSString * newStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        
//        //        NSArray *array = [newStr componentsSeparatedByString:@".png"];
//        NSMutableArray *array = [newStr componentsSeparatedByString:@"SystemFile"];
//        NSLog(@"999999---%@",array);
//        for (int i = 0; i<array.count; i++) {
//            if ([self isBlankString:array[i]]==YES){
//                [array removeObjectAtIndex:i];
//                
//            }
//        }
//        //        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        succeedBlock(dict);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (error) {
//            failedBlock(error);
//        }
//    }];
//}

/*
 * @brief 判断网络状态
 * @return YES 有网, NO无网
 */
- (BOOL)isNetWorkConnectAvailiable{
    BOOL isNet = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:{
            isNet = NO;
            NSLog(@"无网络连接");
            break;
        }
        case ReachableViaWiFi:{
            isNet = YES;
            NSLog(@"WIFI连接");
            break;
        }
        case ReachableViaWWAN:{
            isNet = YES;
            NSLog(@"WWAN连接");
            break;
        }
        default:
            break;
    }
    return isNet;
}

@end
