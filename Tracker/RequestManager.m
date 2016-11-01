//
//  RequestManager.m
//  Tapp
//
//  Created by Arun Chauhan on 15/04/15.
//  Copyright (c) 2015 Manjeet. All rights reserved.
//

#import "RequestManager.h"

@implementation RequestManager

NSMutableURLRequest *mutablerequest;
NSURLSession *session;

+(id)sharedInstances
{
    static RequestManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(void)headerMethod:(NSDictionary *)userDic serverUrl:(NSString *)userUrl
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:userDic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *encodedUrl = [userUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *baseURL = [NSURL URLWithString:encodedUrl];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",jsonString);
    mutablerequest = [NSMutableURLRequest requestWithURL:baseURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [mutablerequest setHTTPMethod:@"POST"];
    [mutablerequest setHTTPBody:jsonData];
    [mutablerequest setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
}

-(void)commonMethod:(NSDictionary *)dictValues andserverURL:(NSString *)url success:(void (^)(NSDictionary *dict))success fail:(ErrorHandler)failure
{
    [self headerMethod:dictValues serverUrl:url];
    configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    configuration.timeoutIntervalForRequest = 60.0;
    session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    postDataTask = [session dataTaskWithRequest:mutablerequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                    {
                        if(error == nil)
                        {
                            NSDictionary *result=[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                            if (result)
                            {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                success(result);
                                });
                            }
                            else
                            {// dhananjay singh
                               // dispatch_async(dispatch_get_main_queue(), ^{
                               // failure(failure);
                                //});
                            }
                        }
                        else
                        {
                           /// dispatch_async(dispatch_get_main_queue(), ^{
                           // failure(failure);
                              //  });
                        }
                    }];
    [postDataTask resume];
}



@end
