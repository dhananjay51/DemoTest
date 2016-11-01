//
//  SignUPVC.m
//  Tracker
//
//  Created by vikas on 7/19/16.
//  Copyright © 2016 Aaravee. All rights reserved.
//

#import "SignUPVC.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "IQDropDownTextField.h"
#import "Serverhit.h"
#import "DefindUrl.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "CommonAction.h"
@interface SignUPVC ()
{
    IQKeyboardReturnKeyHandler *returnKeyHandler;
    IBOutlet IQDropDownTextField *dropDownTextField;
    
     NSString *logintype;
    BOOL LoginChecking;
    
     }

@end

@implementation SignUPVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LoginChecking=NO;
    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    [returnKeyHandler setLastTextFieldReturnKeyType:UIReturnKeyDone];
    [dropDownTextField setCustomPreviousTarget:self action:@selector(previousAction:)];
    [dropDownTextField setCustomNextTarget:self action:@selector(nextAction:)];
    [dropDownTextField setCustomDoneTarget:self action:@selector(doneAction:)];
    // Do any additional setup after loading the view.
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
-(IBAction)Addcheckmark:(UIButton*)sender{
    if (sender.tag==100) {
        
         empbtn.selected=YES;
         adminbtn.selected=NO;
          logintype=@"0";
        LoginChecking=YES;
    }
    else{
        empbtn.selected=NO;
        adminbtn.selected=YES;
        logintype=@"1";
        LoginChecking=YES;
        
        
    }
}

-(IBAction)SignUP:(id)sender{
    
    
    [self Signup];
    
    
// [self performSegueWithIdentifier:@"revealviewsegue" sender:nil];
}

-(void)Signup{
    
    
    NSString *emailReg = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailReg];
    
    if (name.text.length<=0) {
        [self alertview:@"Please Enter name"];
        return;

    }
    
     else if ([email.text length]<=0)  {
        
        [self alertview:@"Please Enter Email Id"];
         return;

    }
    else if([emailTest evaluateWithObject:email.text] == NO)
    {
        [self alertview:@"Please Enter Valid Email Id"];
        return;

    }
    else if ([mobileno.text length]<=0)  {
        
        [self alertview:@"Please Enter MobileNumber"];
        return;


    }
    
    else if (mobileno.text.length<10)
    {
         [self alertview:@"Please Enter Valid mobile number"];
        return;

    }
    
    
    else if ([password.text length]<=0){
        [self alertview:@"Please Enter Password"];
        return;

    }
    
    
    
    else if ([regeisterkey.text length]<=0){
        [self alertview:@"Please Enter Registerkey"];
        return;

        
    }
    
    
[self Regiseter];
   
    
}
-(void)alertview:(NSString*)msg
{
    UIAlertView*alert=[[UIAlertView alloc]initWithTitle:nil message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alert show];
    [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:0.50f];
}
-(void)dismissAlert:(UIAlertView *) alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
    
}

-(void)Regiseter{
    
    if ([[AppDelegate getDelegate] connected])
    {
        
    
[MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
    UIDevice *device = [UIDevice currentDevice];
    
    NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
    NSMutableDictionary *params=[[ NSMutableDictionary alloc]init];
    
    [params setValue:name.text forKey:@"userName"];
    [params setValue:email.text forKey:@"userEmail"];
    [params setValue: mobileno.text forKey:@"userMobileNumber"];
    [params setValue:password.text forKey:@"userPassword"];
    [params setValue:regeisterkey.text forKey:@"registrationCode"];
     [params setValue:currentDeviceId forKey:@"device_id"];
    
   
    
    [params setValue:@"0" forKey:@"login_type"];
        
        NSURL *strURL ;

    /*if ([logintype isEqualToString:@"1"]) {
        strURL = [NSURL URLWithString:@"http://www.eventsbyideation.com/v1/indextrackmzapp.php/adminsignup"];
    }
    else{
        strURL = [NSURL URLWithString:SIgnUpEmpUrl];
    }
    */
   
    
        strURL = [NSURL URLWithString:SIgnUpEmpUrl];

    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:strURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
      NSError *error;
      NSData *json = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
    
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
         
       
         NSDictionary *datadict=[ dictionary valueForKey:@"data"];
         NSString * registerkey=[datadict valueForKey:@"registration_key"];

         NSString *mess=[ dictionary valueForKey:@"message"];
         
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
                 NSUserDefaults *Registerkey = [NSUserDefaults standardUserDefaults];
                 [Registerkey setObject:registerkey forKey:@"registerkey"];
                 [Registerkey synchronize];
                 

                 [AppDelegate getDelegate].userdetaildict=datadict;
                // [self performSegueWithIdentifier:@"admin" sender:nil];
                 
                 
                 
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
                 
                 //[AppDelegate getDelegate].userdetaildict=datadict;
                 
                 NSMutableDictionary *emepdetaildict=[[NSMutableDictionary alloc]init];
                 [emepdetaildict setObject:email.text forKey:@"userEmail"];
                 [emepdetaildict setObject:password.text forKey:@"password"];
                 
                 
                 //[AppDelegate getDelegate].userdetaildict=datadict;
                 
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


         
         
        /* if (statuscode==0)
         {
             NSUserDefaults *TokenId = [NSUserDefaults standardUserDefaults];
             [TokenId setObject:tokenid forKey:@"TokenId"];
             [TokenId synchronize];
             NSUserDefaults *Registerkey = [NSUserDefaults standardUserDefaults];
             [Registerkey setObject:registerkey forKey:@"registerkey"];
             [Registerkey synchronize];
             


            [self performSegueWithIdentifier:@"revealviewsegue" sender:nil];
             
             
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
          0. 77, 64
         
        */

-(IBAction)Backbtn:(UIButton*)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end

