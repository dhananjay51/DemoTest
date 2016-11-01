//
//  Serverhit.h
//  AfNetworkingDemo
//
//  Created by Abhishek Srivastava on 26/03/16.
//  Copyright © 2016 LoudShout. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Serverhit : NSObject
typedef void(^myCompletion)(NSDictionary *dictResponse);


-(void)Serverhit :(NSString *)Url :(myCompletion) compblock;
-(void)ServiceHitWithHttpString :( NSDictionary *)Dict :(NSString *)url :(myCompletion) compblock;

@end
