//
//  ForgotVC.m
//  Tracker
//
//  Created by Macbook Pro on 07/09/16.
//  Copyright © 2016 Aaravee. All rights reserved.
//

#import "ForgotVC.h"
#import "Serverhit.h"
#import "DefindUrl.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AppDelegate.h"
#import "SVProgressHUD.h"


@interface ForgotVC ()

@end

@implementation ForgotVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30.0f/255.0f green:160.0f/255.0f blue:67.0f/255.0f alpha:1.0f]];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)ConfirmReject:(NSString*)Status{
    
    if ([[AppDelegate getDelegate] connected])
    {
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
       // [tempDict setObject:rosterid forKey:@"roster_id"];
        //[tempDict setValue:Status forKey:@"status"];
        NSString *TokenId = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"TokenId"];
        NSURL *strURL;
        
        if ([Status isEqualToString:@"Confirmed"]) {
            strURL = [NSURL URLWithString:BaseURl ConfirmUrl];
        }
        else{
            strURL = [NSURL URLWithString:BaseURl RejectUrl];
        }
        
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:strURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [request addValue:TokenId forHTTPHeaderField:@"Auth"];
        
        NSError *error;
        NSData *json = [NSJSONSerialization dataWithJSONObject:nil options:0 error:&error];
        
        [request setHTTPBody:json];
        
        
        
        
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
         {
             if (data == nil)
             { [MBProgressHUD hideHUDForView:self.view animated:YES];
                 
                 UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"The network connection lost" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 
                 [msg show];
                 
                 return;
             }
             
             
             NSDictionary * dictionary = nil;
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
             dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             
             
             NSLog(@"results == %@",dictionary);
             int code=[[ dictionary valueForKey:@"code"] intValue];
             NSString *mess=[ dictionary valueForKey:@"message"];
             
             
             
             
             if (code==0)
             {
                 
                 UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Alert!!" message:mess delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 
                 [msg show];
                 
             }
             
             
             else{
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 
             }
             
             
             
         }];
        
    }
    else{
        
        [SVProgressHUD showErrorWithStatus:@"No Internet connection"];
        
    }
    
}

@end
