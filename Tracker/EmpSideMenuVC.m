//
//  EmpSideMenuVC.m
//  Tracker
//
//  Created by Macbook Pro on 19/08/16.
//  Copyright © 2016 Aaravee. All rights reserved.
//

#import "EmpSideMenuVC.h"
#import "MBProgressHUD.h"
#import "DefindUrl.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "SideCell.h"
#import "MBProgressHUD.h"
#import "DefindUrl.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "LOGINVC.h"
#import <Toast/UIView+Toast.h>


#import"SWRevealViewController.h"
@interface EmpSideMenuVC ()<UITableViewDelegate,UITableViewDataSource>

    {
        NSArray *menuarr;
        NSArray *menuimagearr;
    }

@end

@implementation EmpSideMenuVC

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    NSLog(@"%@", [AppDelegate getDelegate].userdetaildict);
    
    userimage.layer.cornerRadius = userimage.frame.size.height/2;
    userimage.clipsToBounds = YES;
    

  
    
    [self getprofile];
    
   
    menuarr=[ NSArray arrayWithObjects:@"HOME",@"ROSTER",@"ATTENDENCE",@"MAP",@"SETTING",@"LOGOUT",nil];
    
    menuimagearr=[NSArray arrayWithObjects:@"home.png",@"timesheet.png",@"timesheet.png",@"map.png",@"setting.png",@"profile.png", nil];
    
    [empsidetable registerNib:[UINib nibWithNibName:@"SideCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return menuarr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SideCell  * cell = (SideCell*)[empsidetable dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSArray *nib;
    
    if (cell == nil)
    {
        nib = [[NSBundle mainBundle]loadNibNamed:@"SideCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.manuname.text=[ menuarr objectAtIndex:indexPath.row];
    cell.menuimg.image=[UIImage imageNamed:[menuimagearr objectAtIndex:indexPath.row]];
    
    return cell;
}
  -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SWRevealViewController *revealController = self.revealViewController;
    
     if (indexPath.row==0){
     
      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     
     
     
     UIViewController *rear=[storyboard instantiateViewControllerWithIdentifier:@"addattendanceVC"];
     
     UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rear];
     
     [revealController pushFrontViewController:navigationController animated:YES];
     
     //[ self.navigationController popToRootViewControllerAnimated:YES];
     
     }
    
     else if  (indexPath.row==1){
         
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        
        
        UIViewController *rear=[storyboard instantiateViewControllerWithIdentifier:@"SnaplistVC"];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rear];
        
        [revealController pushFrontViewController:navigationController animated:YES];
        
    
    }
    
      
      
     else if   (indexPath.row==2){
         
         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         
         
         
         UIViewController *rear=[storyboard instantiateViewControllerWithIdentifier:@"AttendenceListVC"];
         
         UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rear];
         
         [revealController pushFrontViewController:navigationController animated:YES];
         
         
         
     }
      
    else if   (indexPath.row==3){
       
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        
        
        UIViewController *rear=[storyboard instantiateViewControllerWithIdentifier:@"MapVC"];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rear];
        
        [revealController pushFrontViewController:navigationController animated:YES];
        
    
        
    }
      
    else if(indexPath.row==4)  {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        
        
        UIViewController *rear=[storyboard instantiateViewControllerWithIdentifier:@"ProfileVC"];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rear];
        
        [revealController pushFrontViewController:navigationController animated:YES];
    }
         else{
        [self LogOut];

    }
    
}
-(void)LogOut
{
if ([[AppDelegate getDelegate] connected])
{
    NSMutableDictionary * tempDict;
    
    tempDict=[[ NSMutableDictionary alloc]init];
    
    
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    float lat1 = [prefs floatForKey :@"latitude"];
    float lon1 = [prefs  floatForKey:@"longitude"];
    NSString *custimerid = [prefs stringForKey:@"customer_id"];
    
    if (lat1==0.0) {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLogedin"];
        

        [self.navigationController popToRootViewControllerAnimated:YES];
         [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"Empdetail"];
        // return;
        
        
        return;
    }
    if (lon1==0.0) {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLogedin"];
        
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"Empdetail"];
        [self.navigationController popToRootViewControllerAnimated:YES];
                return;
        
        // return;
    }
    if (custimerid==nil) {
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLogedin"];
         [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"Empdetail"];

         [self.navigationController popToRootViewControllerAnimated:YES];
       
        return;
        
        
    }
    
    
    [tempDict setObject:[NSNumber numberWithDouble:lat1 ]forKey:@"lattitude"];
    
    [tempDict setValue:[NSNumber numberWithDouble:lon1] forKey:@"longitude"];
    
    
    [tempDict setObject:custimerid forKey:@"customer_site_id"];
    
    [tempDict setObject:@"2" forKey:@"LoginStatus"];
    
    
    
    NSString *TokenId = [[NSUserDefaults standardUserDefaults]
                         stringForKey:@"TokenId"];
    
    
    
    NSURL *strURL = [NSURL URLWithString:@"http://www.eventsbyideation.com/v1/indextrackmzapp.php/addattendance"];
    
    
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
             [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isLogedin"];
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"Empdetail"];
            
           [self.navigationController popToRootViewControllerAnimated:YES];
             
                      }
         
         
         else{
             
             
         }
         
         
         
     }];
    
}

}

-(void)getprofile{
    
    if ([[AppDelegate getDelegate] connected])
    {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        
        
        NSString *TokenId = [[NSUserDefaults standardUserDefaults]
                             
                             stringForKey:@"TokenId"];
        NSString *Url=@"http://www.eventsbyideation.com/v1/indextrackmzapp.php/profiledetails";
        
        
        
        
        NSString * strURL = [Url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        
        NSURL *url=[NSURL URLWithString:strURL];
        
        
        
        
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
        
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
             
             
             //emplistarr=[ dictionary valueForKey:@"data"];
             NSDictionary * userpriledict=[ dictionary valueForKey:@"data"];
             NSString * useremail=[ userpriledict valueForKey:@"email"];
             NSString * username=[ userpriledict valueForKey:@"name"];
            
             NSString * image=[ userpriledict valueForKey:@"profile_pic"];
             NSString * imageurl=[ NSString stringWithFormat:@"%@%@",@"http://www.eventsbyideation.com/v1/",image];
             
             empname.text= username;
             empemail.text=useremail;
             
             NSURL* url = [NSURL URLWithString:imageurl];
             NSURLRequest* request = [NSURLRequest requestWithURL:url];
             
             
             [NSURLConnection sendAsynchronousRequest:request
                                                queue:[NSOperationQueue mainQueue]
                                    completionHandler:^(NSURLResponse * response,
                                                        NSData * data,
                                                        NSError * error) {
                                        if (!error){
                                            userimage.image = [UIImage imageWithData:data];
                                        }
                                    }];
             
             
             
             
             
         }];
        
        
        
    }
    
    else{
        
        [self.navigationController.view makeToast:@"No Internet Connection"
                                         duration:1.0
                                         position:CSToastPositionCenter];
    }
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}


@end
