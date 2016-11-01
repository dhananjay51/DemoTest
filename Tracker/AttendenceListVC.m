//
//  SnapEmpVC.m
//  Tracker
//
//  Created by Macbook Pro on 14/08/16.
//  Copyright © 2016 Aaravee. All rights reserved.
//

#import "AttendenceListVC.h"
#import "MBProgressHUD.h"
#import "DefindUrl.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "RosterCell.h"
#import "HomeVC.h"
#import "SWRevealViewController.h"
#import "AttendenceCell.h"
#import <CCBottomRefreshControl/UIScrollView+BottomRefreshControl.h>
#import <Toast/UIView+Toast.h>

@interface AttendenceListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *emplistarr;
    NSMutableArray *selectedImage;
    NSMutableDictionary * tempDict;
   
    UIRefreshControl *refreshControl;
    int pagenumber;
    BOOL indicatior;
}

@end

@implementation AttendenceListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    pagenumber=2;
    [Snaptable registerNib:[UINib nibWithNibName:@"AttendenceCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30.0f/255.0f green:160.0f/255.0f blue:67.0f/255.0f alpha:1.0f]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    refreshControl = [UIRefreshControl new];
    refreshControl.triggerVerticalOffset = 100.;
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    Snaptable.bottomRefreshControl = refreshControl;

    [self ConfirmlistWebservice];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)refresh {
    
    indicatior=YES;
    
    pagenumber=pagenumber+1;
    
    
    [self ConfirmlistWebservice];
    
    [self performSelector:@selector(updateTable) withObject:nil
               afterDelay:1];
    
    [refreshControl endRefreshing];
    
    // Do refresh stuff here
}
-(void)updateTable
{
    
    [Snaptable reloadData];
    
    
    [refreshControl endRefreshing];
    
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [emplistarr count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AttendenceCell   * cell = (AttendenceCell *)[Snaptable dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSArray *nib;
    
    if (cell == nil)
    {
        nib = [[NSBundle mainBundle]loadNibNamed:@"AttendenceCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *tempdict=[ emplistarr objectAtIndex:indexPath.row];
    NSString *companyname=[ tempdict valueForKey:@"COMPANY"];
    NSString *customername=[ tempdict valueForKey:@"CUSTOMERNAME"];
    NSString *taskname=[ tempdict valueForKey:@"TaskName"];
    NSString *datein=[ tempdict valueForKey:@"date_in"];
    NSString *dateout=[ tempdict valueForKey:@"date_out"];
    NSString *timein=[ tempdict valueForKey:@"time_in"];
    NSString *timeout=[ tempdict valueForKey:@"time_out"];
    cell.Compnayname.text= companyname;
    cell.Customername.text= customername;
    cell.TaskName.text= taskname;
    if(datein==nil||datein==(id)[NSNull null])
    {
        datein=@"";
    }
    
    if(dateout==nil||dateout==(id)[NSNull null])
    {
        dateout=@"";
    }

    if(timein==nil||timein==(id)[NSNull null])
    {
        timein=@"";
    }
    if(timeout==nil||timeout==(id)[NSNull null])
    {
        timeout=@"";
    }

    cell.Clockin.text=[NSString stringWithFormat:@"%@ %@ %@", @"clock in Time:", datein, timein];
     cell.Clockout.text=[NSString stringWithFormat:@"%@ %@ %@", @"clock out Time:", dateout, timeout];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm:ss"];
    NSDate *date1 = [df dateFromString:timeout];
    NSDate *date2 = [df dateFromString:timein];
    NSTimeInterval interval = [date2 timeIntervalSinceDate:date1];
    int hours = (int)interval / 3600;             // integer division to get the hours part
    int minutes = (interval - (hours*3600)) / 60;
    
    int seconds= (interval - (hours*3600) - (minutes*60)); //
    
   // interval minus hours part (in seconds) divided by 60 yields minutes
    NSString *timeDiff = [NSString stringWithFormat:@"%d:%02d:%02d", hours, minutes, seconds];
    cell. workedhour.text=[ NSString stringWithFormat:@"%@%@",@"Worked Hours:",timeDiff];
   
   
   return cell;

    
    
    }
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     HomeVC *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"addattendanceVC"];
     [self.navigationController pushViewController:vc animated:YES];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 187;
}
-(void)ConfirmlistWebservice
{
    if ([[AppDelegate getDelegate] connected])
    {
        if (indicatior==YES) {
            
        }
        else{
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }
        
        
        NSString *TokenId = [[NSUserDefaults standardUserDefaults]
                             
                             stringForKey:@"TokenId"];
         NSString *Url=@"http://www.eventsbyideation.com/v1/indextrackmzapp.php/attendancelist?";
        
        NSString*Compteleurl=[NSString stringWithFormat:@"%@pageNumber=%d&pageSize=%d",Url,0,pagenumber];
        
        
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
             //emplistarr=[ dictionary valueForKey:@"data"];
             
             NSArray *temparr=[ dictionary valueForKey:@"data"];
             if (temparr.count>0) {
                 
                 if (pagenumber==2) {
                     
                   emplistarr  =temparr;
                 }
                 
                 else
                 
                 {
                     
                    emplistarr= [emplistarr arrayByAddingObjectsFromArray:temparr];
                     
                 }
                 
                 Snaptable.delegate=self;
                 Snaptable.dataSource=self;
                 [Snaptable reloadData];
                 
                 [MBProgressHUD  hideHUDForView:self.view animated:YES];
                 

             }
              else{
                 [self.navigationController.view makeToast:@"No Record Found"
                                                  duration:1.0
                                                  position:CSToastPositionCenter];
                 [MBProgressHUD  hideHUDForView:self.view animated:YES];

                 
             }
            
             
             
         }];
        
        
             
    }
             
        
    
}

@end
