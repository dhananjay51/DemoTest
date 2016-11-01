//
//  addattendanceVC.m
//  Tracker
//
//  Created by Macbook Pro on 17/08/16.
//  Copyright © 2016 Aaravee. All rights reserved.
//

#import "HomeVC.h"
#import "MBProgressHUD.h"
#import "DefindUrl.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "RosterCell.h"
#import "SWRevealViewController.h"
 #import <CoreLocation/CoreLocation.h>
#import "CommonAction.h"
#import "UpdateEmpLocation.h"
#import "AddttenceCell.h"
#import "MapVC.h"
#import <Toast/UIView+Toast.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
@interface HomeVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *addttedencearr;
}
@end

@implementation HomeVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    

    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30.0f/255.0f green:160.0f/255.0f blue:67.0f/255.0f alpha:1.0f]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    

    
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationItem.title=@"AttedanceList";
    
     _sidebarButton.target = self.revealViewController;
     _sidebarButton.action = @selector(revealToggle:);
    
      [addttdeancetable registerNib:[UINib nibWithNibName:@"AddttenceCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    
    
         
     
    
    
    
       [self custemerlistWebservice];
    
    // Do any additional setup after loading the view.
}



 - (void)didReceiveMemoryWarning {
     
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [addttedencearr count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddttenceCell   * cell = (AddttenceCell *)[addttdeancetable dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSArray *nib;
    
    if (cell == nil)
    {
        nib = [[NSBundle mainBundle]loadNibNamed:@"AddttenceCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *tempdict=[ addttedencearr objectAtIndex:indexPath.row];
    NSString *companyname=[ tempdict valueForKey:@"COMPANY"];
    NSString  *Customername=[tempdict valueForKey:@"CUSTOMERNAME"];
    
    NSString * centername=[ tempdict valueForKey:@"TaskName"];
    
    NSString * date=[ tempdict valueForKey:@"date"];
    NSString * dateto=[ tempdict valueForKey:@"date_to"];
    NSString *timefrom=[tempdict valueForKey:@"time_from"];
    NSString *timeto =[tempdict valueForKey:@"time_to" ];
    NSString * hour=[ tempdict valueForKey:@"total_hours"];
    NSString * address=[ tempdict valueForKey:@"address"];
    int off=[[ tempdict  valueForKey:@"off_btn_status"] intValue];
    int mark =[[ tempdict  valueForKey:@"mark_btn_status"] intValue];

    if (off==1) {
        
        cell.Clouckoout.adjustsImageWhenHighlighted = NO;
        cell.Clouckoout.alpha = 0.5;

            }
    
    else{
        cell.Clouckoout.enabled=YES;

        
        
    }
    
    if (mark==1) {
        
        cell.Clockin.alpha = 0.5;
        
        cell.Clouckoout.adjustsImageWhenHighlighted = NO;

    
    }
    else{
         cell.Clockin.enabled=YES;
       
    }

    cell.customerName.text=Customername;
    cell.companyName.text=companyname;
    cell.CenterName.text=centername;
    [AppDelegate getDelegate].appbtn= cell.Clouckoout;
    [AppDelegate getDelegate].appbtn= cell.Clockin;
    cell.date.text= [ NSString stringWithFormat:@"%@""-%@", date, dateto];
    cell.Time.text=[ NSString stringWithFormat:@"%@""-%@", timefrom, timeto];
    
    cell.Hour.text=hour;
    cell.location.text=address;
        
    cell.Clockin.buttonIndexPath=indexPath;
     cell.Clouckoout.buttonIndexPath=indexPath;
    cell.Collingtbtn.buttonIndexPath=indexPath;
  
    
    
   ;
    [cell.Clockin addTarget:self action:@selector(clockinbnt:event:) forControlEvents:UIControlEventTouchUpInside];
    [cell.Collingtbtn addTarget:self action:@selector(Callingbnt:event:) forControlEvents:UIControlEventTouchUpInside];
     [cell.Clouckoout addTarget:self action:@selector(clockout:event:) forControlEvents:UIControlEventTouchUpInside];
    [AppDelegate getDelegate].clockinbtn=cell.Clockin;
    [AppDelegate getDelegate].clockoutbtn=cell.Clouckoout;

     
     return cell;
}





-(IBAction)clockinbnt:(id)sender event:(id)event
{
    CustomButton *btn = (CustomButton *)sender;
    NSIndexPath *indexPath = btn.buttonIndexPath;
    NSDictionary *tempdict =[addttedencearr  objectAtIndex:indexPath.row];
    
    int mark =[[ tempdict  valueForKey:@"mark_btn_status"] intValue];
    
    if (mark==1) {
        [self Message:@"You have already clocked In."];
        return;

    }
  
    UIAlertView *alter=[[ UIAlertView alloc]initWithTitle:@"" message:@"You are Clocked In to your duty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alter show];

    NSString *customer=[ tempdict valueForKey:@"customer_site_id"];
    NSString *destinationlat=[ tempdict valueForKey:@"latitude"];
    NSString *destinationlog=[ tempdict valueForKey:@"longitude"];
    NSString *rosterId=[ tempdict valueForKey:@"roster_id"];
    NSString *companyname=[ tempdict valueForKey:@"COMPANY"];
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:customer forKey:@"customer_id"];
    [prefs setObject:destinationlat forKey:@"latitude"];
    [prefs setObject:destinationlog forKey:@"longitude"];
    [prefs setObject:rosterId forKey:@"rosterId"];
    [prefs setObject:companyname forKey:@"companyname"];
    
    [prefs synchronize];
   
    if ([[[CommonAction alloc] init] isEmployeeLogin]){
        [[UpdateEmpLocation shareInstance] updateLocation:nil];
        [ AppDelegate getDelegate].clockinbtn.alpha = 0.5;
        [ AppDelegate getDelegate].clockinbtn.enabled=NO;
        
         [ self custemerlistWebservice];
        
    }
    
    
}

-(IBAction)clockout:(id)sender event:(id)event
{
    CustomButton *btn = (CustomButton *)sender;
    NSIndexPath *indexPath = btn.buttonIndexPath;
    NSDictionary *tempdict =[addttedencearr  objectAtIndex:indexPath.row];
    int off=[[ tempdict  valueForKey:@"off_btn_status"] intValue];
    
   
    NSString *destinationlat=[ tempdict valueForKey:@"latitude"];
    NSString *destinationlog=[ tempdict valueForKey:@"longitude"];
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:destinationlat forKey:@"latitude"];
    [prefs setObject:destinationlog forKey:@"longitude"];
    
    [prefs synchronize];

    
    if (off==1) {
        [self Message:@"You have already clocked out."];
        return;
    }
    
    else{
        [self Message:@"Please clock in to start your duty"];

        
    }
[self Clockout:tempdict];
    
    
}

-(IBAction)Callingbnt:(id)sender event:(id)event
{
    CustomButton *btn = (CustomButton *)sender;
    NSIndexPath *indexPath = btn.buttonIndexPath;
    NSDictionary *tempdict =[addttedencearr  objectAtIndex:indexPath.row];
    MapVC *vc=[ self.storyboard instantiateViewControllerWithIdentifier:@"MapVC"];
    //vc.tempdict= tempdict;
    NSString *destinationlat=[ tempdict valueForKey:@"latitude"];
    NSString *destinationlog=[ tempdict valueForKey:@"longitude"];
    NSString *address=[ tempdict valueForKey:@"address"];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:destinationlat forKey:@"latitude"];
    [prefs setObject:destinationlog forKey:@"longitude"];
    [prefs setObject:address forKey:@"address"];

    
    [prefs synchronize];
    

    
    [ self.navigationController pushViewController:vc animated:YES];
   
}


-(void)custemerlistWebservice

{
    
   if ([[AppDelegate getDelegate] connected])
    {
        
        
      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        
        NSString *TokenId = [[NSUserDefaults standardUserDefaults]
                             
                             stringForKey:@"TokenId"];
        
        NSURL *strURL=[NSURL URLWithString:BaseURl AttendencelistUrl];
        
        
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:strURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
        
        [request setHTTPMethod:@"GET"];
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request addValue:TokenId forHTTPHeaderField:@"Auth"];
        
        
        
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
         {
             if (data == nil)
             {[MBProgressHUD hideHUDForView:self.view animated:YES];
                 
                 UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"The network connection lost" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 
                 [msg show];
                 
                 return;
             }
             
             
             NSDictionary * dictionary = nil;
             
             
             dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             
             NSLog(@"results == %@",dictionary);
             
             addttedencearr=[ dictionary valueForKey:@"data"];
             
              if (addttedencearr.count==0)
             {
                 
                 
                 
                 
             }
             
             
              else{
                   
                 [addttdeancetable reloadData];
                 
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             }
             
         }];
        
    }
     else{
             [SVProgressHUD showErrorWithStatus:@"No Internet connection"];
    }
    
}



-(void)Clockout:(NSDictionary*)LocatopnDict


{
    
    
if ([[AppDelegate getDelegate] connected])
{
    NSMutableDictionary * tempDict;
    
    tempDict=[[ NSMutableDictionary alloc]init];
    
    NSString *customer=[ LocatopnDict valueForKey:@"customer_site_id"];
    NSString *destinationlat=[ LocatopnDict valueForKey:@"latitude"];
    NSString *destinationlog=[ LocatopnDict valueForKey:@"longitude"];
    NSString *companyname=[ LocatopnDict valueForKey:@"COMPANY"];
    NSString * rosterId=[ LocatopnDict valueForKey:@"roster_id"];
    
    
  
    
    [tempDict setObject:destinationlat forKey:@"lattitude"];
    
    [tempDict setValue:destinationlog forKey:@"longitude"];
    
    
    [tempDict setObject:customer forKey:@"customer_site_id"];
    
    [tempDict setObject:@"3" forKey:@"LoginStatus"];
     [tempDict setObject:companyname forKey:@"company_name"];
     [tempDict setObject:rosterId forKey:@"roster_id"];
    
    NSString * ip=[self getIPAddress];
    NSString* Identifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString]; // IOS 6+
    NSLog(@"output is : %@", Identifier);
    [tempDict setObject:ip forKey:@"ip_in"];
    [tempDict setObject:Identifier forKey:@"imei_in"];
    
      NSString *TokenId = [[NSUserDefaults standardUserDefaults]
                         stringForKey:@"TokenId"];
    
    
   

    
    NSURL *strURL = [NSURL URLWithString:@"http://www.eventsbyideation.com/v1/indextrackmzapp.php/addattendanceclickout"];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:strURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:TokenId forHTTPHeaderField:@"Auth"];
    
    NSError *error;
    NSData *json = [NSJSONSerialization dataWithJSONObject:tempDict options:0 error:&error];
    
    [request setHTTPBody:json];
    
    
    
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         if (data == nil)
         {
             
             UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Alert!!" message:@"The network connection lost" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
             
             [msg show];
             
             return;
         }
         
         
         NSDictionary * dictionary = nil;
         
         
         dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
         
         
         NSLog(@"results == %@",dictionary);
         int code=[[ dictionary valueForKey:@"code"] intValue];
         
         
         
         
         
         if  (code==0)
         {
             
             [ self custemerlistWebservice];
             
             UIAlertView *alter=[[ UIAlertView alloc]initWithTitle:@"" message:@"You are Clocked Out from your duty." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
              [alter show];
             
             
             

             
         }
         
         
         
         else{
             
             
             
         }
         
         
         
     }];
    
}


}

-(void)Message:(NSString*)mess{
    // Make toast with a duration and position
    [self.navigationController.view makeToast:mess
                                     duration:1.0
                                     position:CSToastPositionBottom];
    
    
}

- (NSString *)getIPAddress {
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}

@end
