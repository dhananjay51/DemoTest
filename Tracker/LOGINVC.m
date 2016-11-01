//
//  ViewController.m
//  Tracker
//
//  Created by vikas on 7/19/16.
//  Copyright © 2016 Aaravee. All rights reserved.
//

#import "LOGINVC.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "IQDropDownTextField.h"
#import "GMDCircleLoader.h"
#import "Serverhit.h"
#import "DefindUrl.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "CommonAction.h"
#import "UpdateEmpLocation.h"


@interface LOGINVC (){
IQKeyboardReturnKeyHandler *returnKeyHandler;
IBOutlet IQDropDownTextField *dropDownTextField;
    int logintype;
}

@end

@implementation LOGINVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL   check= [[NSUserDefaults standardUserDefaults]
                   boolForKey:@"isLogedin"];
    if (check==YES) {
        NSDictionary *userdict= [[NSUserDefaults standardUserDefaults]
                                 objectForKey:@"Empdetail"];
        email.text=[userdict valueForKey:@"userEmail"];
        password.text=[userdict valueForKey:@"password"];
        
        
        [self performSegueWithIdentifier:@"emp" sender:nil];
    }
    

    
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    [returnKeyHandler setLastTextFieldReturnKeyType:UIReturnKeyDone];
    [dropDownTextField setCustomPreviousTarget:self action:@selector(previousAction:)];
    [dropDownTextField setCustomNextTarget:self action:@selector(nextAction:)];
    [dropDownTextField setCustomDoneTarget:self action:@selector(doneAction:)];
  
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}
-(void)previousAction:(UITextField*)textField
{
    NSLog(@"%@ : %@",textField,NSStringFromSelector(_cmd));
}

-(void)nextAction:(UITextField*)textField
{
    NSLog(@"%@ : %@",textField,NSStringFromSelector(_cmd));
}

-(void)doneAction:(UITextField*)textField
{
    NSLog(@"%@ : %@",textField,NSStringFromSelector(_cmd));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
- (void)stopCircleLoader {
    [GMDCircleLoader hideFromView:self.view animated:YES];
}
-(IBAction)Addcheckmark:(UIButton*)sender{
    if (sender.tag==100) {
        
        empbtn.selected=YES;
        adminbtn.selected=NO;
    }
    else{
        
        empbtn.selected=NO;
        adminbtn.selected=YES;
        
    }
}

-(IBAction)Signin:(UIButton*)sender{
   // [self performSegueWithIdentifier:@"revealviewsegue" sender:nil];
    
    

    if ([email.text length]<=0)  {
        
        [self alertview:@"Please Enter User Name"];
        
        return;
        
    }
    
    
    
    else if ([password.text length]<=0){
        [self alertview:@"Please Enter Password"];
        return;

    }
    
    
    
    [self  Login];
    
}

-(void)alertview:(NSString*)msg
{
    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:.50f];
}
-(void)dismissAlert:(UIAlertView *) alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    
}

-(void)Login{
    
    
    if ([[AppDelegate getDelegate] connected])  {
        
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    NSMutableDictionary *params=[[ NSMutableDictionary alloc]init];
        
       // email.text=@"cpy1@gmail.com";
   
       [params setValue:email.text forKey:@"userEmail"];
       [params setValue:password.text forKey:@"userPassword"];
    
    
    
      NSURL *strURL = [NSURL URLWithString:BaseURl LoginUrl];
    
    
    
     NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:strURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSError *error;
    NSData *json = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    
    [request setHTTPBody:json];

    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (data == nil)
         {
             
             UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"The network connection lost" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
              [MBProgressHUD hideHUDForView:self.view animated:YES];
             [msg show];
             
             return;
         }
         
         
         NSDictionary * dictionary = nil;
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         
         
            NSLog(@"results == %@",dictionary);
         
         NSString *mess=[ dictionary valueForKey:@"message"];
           NSDictionary *datadict=[ dictionary valueForKey:@"data"];
         
          NSString *type=[datadict valueForKey:@"UserType"];
         int status =[[ dictionary valueForKey:@"code"] intValue];
         
         if (status==0)
         {
             
             
             
        if ([type isEqualToString:@"Admin"]) {
             
            NSString * tokenid=[datadict valueForKey:@"authToken"];
           
            
            NSUserDefaults *TokenId = [NSUserDefaults standardUserDefaults];
            
            [TokenId setObject:tokenid forKey:@"TokenId"];
            
            [TokenId synchronize];
            
            if ([[[CommonAction alloc] init] isAdminLogin]){
                
               
                
                
            }
            [AppDelegate getDelegate].userdetaildict=datadict;
           /// [self performSegueWithIdentifier:@"admin" sender:nil];
            

         
         }
            
             
        else{
            
            NSString * registerkey=[datadict valueForKey:@"registration_key"];
            NSUserDefaults *Registerkey = [NSUserDefaults standardUserDefaults];
            [Registerkey setObject:registerkey forKey:@"registerkey"];
            
            [Registerkey synchronize];
            
            NSString * tokenid=[datadict valueForKey:@"authToken"];
            
            
            NSUserDefaults *TokenId = [NSUserDefaults standardUserDefaults];
            
            [TokenId setObject:tokenid forKey:@"TokenId"];
            
            [TokenId synchronize];
            NSMutableDictionary *emepdetaildict=[[NSMutableDictionary alloc]init];
            [emepdetaildict setObject:email.text forKey:@"userEmail"];
            [emepdetaildict setObject:password.text forKey:@"password"];
           

            [AppDelegate getDelegate].userdetaildict=datadict;
            
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isLogedin"];
            
             [[NSUserDefaults standardUserDefaults]setObject:emepdetaildict forKey:@"Empdetail"];
            [[NSUserDefaults standardUserDefaults]setObject:datadict forKey:@"Emp"];
            
            [self performSegueWithIdentifier:@"emp" sender:nil];
            
        }
      
         }
         
         else{
             
              [MBProgressHUD hideHUDForView:self.view animated:YES];
             
             
             UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Alert!!" message:mess delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             [msg show];
             
             return;
         }
         
     }];

}
    else{
         [SVProgressHUD showErrorWithStatus:@"No Internet connection"];
        
    }
    }
    

@end
