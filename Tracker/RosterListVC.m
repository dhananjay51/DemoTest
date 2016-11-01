//
//  SnaplistVC.m
//  Tracker
//
//  Created by Macbook Pro on 14/08/16.
//  Copyright © 2016 Aaravee. All rights reserved.
//

#import "RosterListVC.h"

#import "SWRevealViewController.h"
#import "MapVC.h"
#import "MBProgressHUD.h"
#import "DefindUrl.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "RosterCell.h"
#import "AttendenceListVC.h"
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>
#import <Toast/UIView+Toast.h>
#import "MapVC.h"


@interface RosterListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *emplistarr;
    NSMutableArray *selectedImage;
    NSMutableDictionary * tempDict;
    NSString * status;
    NSString *rosterid;
    BOOL StatusHide;
    UIRefreshControl *refreshControl;
    int pagenumber;
    BOOL indicatior;
    NSString *Checkingstring;
    
}


@end

@implementation RosterListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    emptable.allowsMultipleSelection=YES;
     self.navigationItem.title=@"Published";
    
    selectedImage=[[NSMutableArray alloc]init];
    tempDict=[[NSMutableDictionary alloc]init];
     pagenumber=2;

    [self Snaplist];
   ;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
   [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30.0f/255.0f green:160.0f/255.0f blue:67.0f/255.0f alpha:1.0f]];
    

    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
   
    
    // Set the gesture
    ///[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [emptable registerNib:[UINib nibWithNibName:@"RosterCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    // Do any additional setup after loading the view.
    
    refreshControl = [UIRefreshControl new];
    refreshControl.triggerVerticalOffset = 100.;
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    emptable.bottomRefreshControl = refreshControl;

}

- (void)refresh {
    
    indicatior=YES;
    
    
     pagenumber=pagenumber+1;
    
    if ([Checkingstring  isEqualToString:@"Roster"]) {
        
    }
  
    else if ([Checkingstring isEqualToString:@"Confirm"])
    {
        [self ConfirmlistWebservice:YES];
    }
    else{
        [self ConfirmlistWebservice:NO];
        
    }
   
    
    
    [self performSelector:@selector(updateTable) withObject:nil
               afterDelay:1];
    
    [refreshControl endRefreshing];
    
    // Do refresh stuff here
}
-(void)updateTable
{
    
    [emptable reloadData];
    
    
    [refreshControl endRefreshing];
    
}

-(void)confirm{
    
    
     [self ConfirmReject:@"Confirmed"];

}

-(void)Reject{
    
     [self ConfirmReject:@"Rejected"];

}

-(IBAction)segmentedControlValueDidChange:(UISegmentedControl *)segment
{
    switch (segment.selectedSegmentIndex) {
        case 0:{
            
        
            [self Snaplist];
            self.navigationItem.title=@"Published";
            indicatior=NO;
             pagenumber=2;
            
            Checkingstring=@"Roster";
            break;
        }
        case 1:{
            [ self ConfirmlistWebservice:YES];
            pagenumber=2;
              Checkingstring=@"Confirm";
            indicatior=NO;

            self.navigationItem.title=@"ACCEPTED";
            break;
        }
            
        case 2:{
            [ self ConfirmlistWebservice:NO];
            Checkingstring=@"Reject";
            indicatior=NO;

            self.navigationItem.title=@"REJECTED";
            pagenumber=2;
           break;
        }
            // Tres
            
         default:
            break;
    }
}


-(void)ConfirmReject:(NSString*)Status{
    
    if ([[AppDelegate getDelegate] connected])
    {

    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [tempDict setObject:rosterid forKey:@"roster_id"];
    [tempDict setValue:Status forKey:@"status"];
    NSString *TokenId = [[NSUserDefaults standardUserDefaults]
                         stringForKey:@"TokenId"];
        NSURL *strURL;
       
        if ([Status isEqualToString:@"Confirmed"]) {
            strURL = [NSURL URLWithString:@"http://www.eventsbyideation.com/v1/indextrackmzapp.php/acceptresectroster"];
        }
        else{
            strURL = [NSURL URLWithString:@"http://www.eventsbyideation.com/v1/indextrackmzapp.php/acceptresectroster"];
        }
    
      
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:strURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:TokenId forHTTPHeaderField:@"Auth"];
    
    NSError *error;
    NSData *json = [NSJSONSerialization dataWithJSONObject:tempDict options:0 error:&error];
    
    [request setHTTPBody:json];
    
    
    
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
     {
         NSLog(@"%@", connectionError);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [emplistarr count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RosterCell   * cell = (RosterCell *)[emptable dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSArray *nib;
    
    if (cell == nil)
    {
        nib = [[NSBundle mainBundle]loadNibNamed:@"SnaplistCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
    }
     cell.backgroundColor = [UIColor clearColor];
     cell.contentView.backgroundColor = [UIColor clearColor];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
     NSDictionary *tempdict=[ emplistarr objectAtIndex:indexPath.row];
     NSString *companyname=[ tempdict valueForKey:@"COMPANY"];
    NSString *customer=[ tempdict valueForKey:@"CUSTOMERNAME"];
   
    
    NSString * centername=[ tempdict valueForKey:@"TaskName"];
    
    NSString * date=[ tempdict valueForKey:@"date"];
    NSString * dateto=[ tempdict valueForKey:@"date_to"];
    NSString *timefrom=[tempdict valueForKey:@"time_from"];
    NSString *timeto =[tempdict valueForKey:@"time_to" ];
    NSString * hour=[ tempdict valueForKey:@"total_hours"];
    NSString * address=[ tempdict valueForKey:@"address"];
    
    cell.companyname.text=companyname;
    cell.centername.text=centername;
    cell.Customename.text= customer;
    cell.date.text= [ NSString stringWithFormat:@"%@""-%@", date, dateto];
    cell.Time.text=[ NSString stringWithFormat:@"%@""-%@", timefrom, timeto];
    
    cell.Hour.text=hour;
    cell.location.text=address;

    
    
    
    cell.Rejectbtn.buttonIndexPath=indexPath;
    cell.Confirbnt.buttonIndexPath=indexPath;
    cell.Collingtbtn.buttonIndexPath=indexPath;
    
    
    
    [cell.Rejectbtn addTarget:self action:@selector(Rejectbtn:event:) forControlEvents:UIControlEventTouchUpInside];
     [cell.Confirbnt addTarget:self action:@selector(Confirbnt:event:) forControlEvents:UIControlEventTouchUpInside];
      [cell.Collingtbtn addTarget:self action:@selector(map:event:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    cell.Rejectbtn.layer.cornerRadius = 5;
    cell.Rejectbtn.layer.masksToBounds=YES;
    cell.Confirbnt.layer.cornerRadius = 5;
    cell.Confirbnt.layer.masksToBounds=YES;

    
    
    if (StatusHide==YES) {
        cell.Rejectbtn.hidden=YES;
        cell.Confirbnt.hidden=YES;
    }
    
    else{
        cell.Rejectbtn.hidden=NO;
        cell.Confirbnt.hidden=NO;
    }
    
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *tempdict =[emplistarr  objectAtIndex:indexPath.row];
    
    
    NSString * rosterid=[ tempdict valueForKey:@"roster_id"];
    
    
    
       RosterCell *cell = (RosterCell *)[emptable cellForRowAtIndexPath:indexPath];
    
            [cell setSelected:YES];
    
       tempDict=[[NSMutableDictionary alloc]init];

    
    
    
    
     // [selectedImage addObject:rosterid];
        
        
    
    
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  248;
}


-(IBAction)map:(id)sender event:(id)event
{
    CustomButton *btn = (CustomButton *)sender;
    NSIndexPath *indexPath = btn.buttonIndexPath;
    NSDictionary *tempdict =[emplistarr  objectAtIndex:indexPath.row];
    
    MapVC *vc=[ self.storyboard instantiateViewControllerWithIdentifier:@"MapVC"];
   // vc.tempdict= tempdict;
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
-(IBAction)Confirbnt:(id)sender event:(id)event
{
    

    CustomButton *btn = (CustomButton *)sender;
       NSIndexPath *indexPath = btn.buttonIndexPath;
      NSDictionary *tempdict =[emplistarr  objectAtIndex:indexPath.row];
    
    
      rosterid=[ tempdict valueForKey:@"roster_id"];
    [self confirm];
    
    
}
-(IBAction)Rejectbtn:(id)sender event:(id)event
{          CustomButton *btn = (CustomButton *)sender;
     NSIndexPath *indexPath = btn.buttonIndexPath;
    NSDictionary *tempdict =[emplistarr  objectAtIndex:indexPath.row];
    
    
      rosterid=[ tempdict valueForKey:@"roster_id"];
    
      [self Reject];

    
    
  }

-(IBAction)Sharelist:(UIBarButtonItem*)sender{

    
    
    
    NSString *Registerkey = [[NSUserDefaults standardUserDefaults]
                             stringForKey:@"registerkey"];
    
    
    NSString *textToShare =[NSString stringWithFormat:@"%@ %@",@"This Is Registerkey For Emp",Registerkey];
    
     NSURL *myWebsite = [NSURL URLWithString:@"http://www.codingexplorer.com/"];
    
    
    NSArray *objectsToShare = @[textToShare, myWebsite];
    
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

-(void)Snaplist
{
    
    if ([[AppDelegate getDelegate] connected])
    {
        StatusHide=NO;
        if (indicatior==YES) {
            
        }
        else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }
        
         NSString *TokenId = [[NSUserDefaults standardUserDefaults]
                             
                             stringForKey:@"TokenId"];
        
         //NSURL *strURL =[NSURL URLWithString:BaseURl RosterListUrl];
        
        NSString*Compteleurl=[NSString stringWithFormat:@"%@pageNumber=%d&pageSize=%d",BaseURl RosterListUrl,0,pagenumber];
        
        
        NSString * strURL = [ Compteleurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        
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
             
             emplistarr=[ dictionary valueForKey:@"data"];
             NSString *mess=[ dictionary valueForKey:@"message"];
             int code=[[ dictionary valueForKey:@"code"]intValue];
             
            
             
             
             
             if (code==0)
             
             {     NSArray *temparr=[ dictionary valueForKey:@"data"];
                 if (temparr.count>0) {
                     
                     if (pagenumber==2) {
                         
                         emplistarr  =[temparr mutableCopy];
                     }
                     
                     else
                     
                     {
                         
                         emplistarr= [[emplistarr arrayByAddingObjectsFromArray:temparr]mutableCopy];
                         
                     }
                     
                 
                 emptable.hidden=NO;
                 emptable.dataSource=self;
                 emptable.delegate=self;
                 [emptable reloadData];
                 
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 
             }
             
             }
             else{
                 
                 [emplistarr removeAllObjects];
                  emptable.hidden=YES;
                 
                 
                 UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Alert!!" message:mess delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 
                 [msg show];
                 
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
             }
                 
             
         }];
        
    }
    else{
         [SVProgressHUD showErrorWithStatus:@"No Internet connection"];
    }
    
    
}

-(void)ConfirmlistWebservice:(BOOL)Status
{
  

    if ([[AppDelegate getDelegate] connected])
    {
        
         StatusHide=YES;
        if (indicatior==YES) {
            
        }
        else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }
        
        
        
        NSString *TokenId = [[NSUserDefaults standardUserDefaults]
                             
                             stringForKey:@"TokenId"];
        NSURL *url;
        
        if (Status ==YES) {
            
            NSString*Compteleurl=
            [NSString stringWithFormat:@"%@pageNumber=%d&pageSize=%d",@"http://www.eventsbyideation.com/v1/indextrackmzapp.php/rosterconfirmed?",0,pagenumber];
            
            
             NSString * strURL = [Compteleurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            
             url=[NSURL URLWithString:strURL];
            

            
            
         ///strURL=[NSURL URLWithString:@"http://www.eventsbyideation.com/v1/indextrackmzapp.php/rosterconfirmed"];
        }
        
        else{
            /// strURL=[NSURL URLWithString:@"http://www.eventsbyideation.com/v1/indextrackmzapp.php/rosterrejected"];
            
            NSString*Compteleurl=[NSString stringWithFormat:@"%@pageNumber=%d&pageSize=%d",@"http://www.eventsbyideation.com/v1/indextrackmzapp.php/rosterrejected?",0,pagenumber];
            
            
             NSString * strURL = [ Compteleurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            
             url=[NSURL URLWithString:strURL];

            
        }
       
       
        
        
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
             emplistarr=[ dictionary valueForKey:@"data"];
             NSString *mess=[ dictionary valueForKey:@"message"];
             int code=[[ dictionary valueForKey:@"code"]intValue];
             
             
             
             if (code==0)
             {
                 
                 
                 NSArray *temparr=[ dictionary valueForKey:@"data"];
                 if (temparr.count>0) {
                     
                     if (pagenumber==2) {
                         
                         emplistarr  =[temparr mutableCopy];
                     }
                     
                     else
                     
                     {
                         
                         emplistarr= [[emplistarr arrayByAddingObjectsFromArray:temparr]mutableCopy];
                         
                     }
                     
                 emptable.hidden=NO;
                 emptable.dataSource=self;
                 emptable.delegate=self;
                 [emptable reloadData];
                 
                 
             }
                 
             }
             
             else{
                 
                 UIAlertView *msg = [[UIAlertView alloc]initWithTitle:@"Alert!!" message:mess delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 
                 [msg show];
                 [emplistarr removeAllObjects];
                 //[emplistarr removeAllObjects];
                  emptable.hidden=YES;
                 
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 
                 
             }
             
         }];
         
    }
         
    else{
        [SVProgressHUD showErrorWithStatus:@"No Internet connection"];
    }
    
    
}

@end
