//
//  RequestManager.h
//  Tapp
//
//  Created by Arun Chauhan on 15/04/15.
//  Copyright (c) 2015 Manjeet. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void (^SuccessHandler)(id responseObject);
typedef void (^ErrorHandler)(NSError *error);

@interface RequestManager : NSObject <NSURLSessionDelegate>
{
    NSURLSessionConfiguration *configuration;
    NSURLSessionDataTask *postDataTask;
    NSURLSession *session;
}

+(id)sharedInstances;
-(void)headerMethod:(NSDictionary *)userDic serverUrl:(NSString *)userUrl;
-(void)commonMethod:(NSDictionary *)dictValues andserverURL:(NSString *)url success:(void (^)(NSDictionary *dict))success fail:(ErrorHandler)failure;




@end

