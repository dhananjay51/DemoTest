//
//  LogoutVC.m
//  Tracker
//
//  Created by Macbook Pro on 06/09/16.
//  Copyright © 2016 Aaravee. All rights reserved.
//

#import "ProfileVC.h"
#import "SWRevealViewController.h"
#import "MBProgressHUD.h"
#import "DefindUrl.h"
#import "AppDelegate.h"
#import "SVProgressHUD.h"
#import "LOGINVC.h"
#import <Toast/UIView+Toast.h>
@interface ProfileVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@end

@implementation ProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"Setting";
    
   

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    

  ;
    
    
    
    empimage.layer.cornerRadius = empimage.frame.size.height/2;
    empimage.clipsToBounds = YES;
    
    
    
    
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:30.0f/255.0f green:160.0f/255.0f blue:67.0f/255.0f alpha:1.0f]];
    
    
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    [self getprofile];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)LinkClicked:(UIButton *)sender{
   
    
    
    
}

-(IBAction)Louout:(id)sender{
    
}
-(void)LogOut{
    
    
    [self.navigationController popViewControllerAnimated:YES];
   }


-(IBAction)AddImage:(UIButton*)sender{
    
    
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Camera",
                            @"Gallery",
                            nil];
    popup.tag = 1;
    [popup showInView:self.view];
    
}

- (IBAction)takePhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    
    [self presentViewController:picker animated:YES completion:NULL];
}


- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    empimage.image = chosenImage;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self takePhoto:nil];
                    break;
                case 1:
                    [self selectPhoto:nil];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

-(IBAction)updatebtn:(UIButton *)sender{
    
    if (empimage.image==nil) {
        [self.navigationController.view makeToast:@"Please Select image"
                                         duration:1.0
                                         position:CSToastPositionCenter];
    }
    else{
        [self Updateprofile];
    }
}

-(void)Updateprofile{
// the boundary string : a random string, that will not repeat in post data, to separate post data fields.
NSString *BoundaryConstant = [NSString stringWithString:@"----------V2ymHFg03ehbqgZCaKO6jy"];

// string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
NSString* FileParamConstant = @"file";

// the server url to which the image (or the media) is uploaded. Use your server url here
NSURL* requestURL = [NSURL URLWithString:@"http://www.eventsbyideation.com/v1/indextrackmzapp.php/userprofileupdate"];

// create request
NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];



// post body
NSMutableData *body = [NSMutableData data];

[MBProgressHUD showHUDAddedTo:self.view animated:YES];
if ([AppDelegate getDelegate].connected==YES) {
    
    
    
    NSData *imageData = UIImageJPEGRepresentation(empimage.image, 1.0);
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    NSString *TokenId = [[NSUserDefaults standardUserDefaults]
                         
                         stringForKey:@"TokenId"];
    [request setValue:TokenId forHTTPHeaderField: @"Auth"];
    
    
    NSString *boundary = @"unique-consistent-string";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"profile_pic"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"Some Caption"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add image data
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpg\r\n", @"profile_pic"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    [request setURL:requestURL];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%d", [body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSLog(@"%@", error);
        if(data.length > 0)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",dict);
            
             NSString * image=[ dict valueForKey:@"profile_pic"];
            NSString * imageurl=[ NSString stringWithFormat:@"%@%@",@"http://www.eventsbyideation.com/v1/user_image/",image];
            
            NSURL* url = [NSURL URLWithString:imageurl];
            NSURLRequest* request = [NSURLRequest requestWithURL:url];
            
            
            [NSURLConnection sendAsynchronousRequest:request
                                               queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse * response,
                                                       NSData * data,
                                                       NSError * error) {
                                       if (!error){
                                           empimage.image = [UIImage imageWithData:data];
                                       }
                                   }];
            

            
            
        }
        
        else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    
}
 else{
    [self.navigationController.view makeToast:@"No Internet Connection"
                                     duration:1.0
                                     position:CSToastPositionCenter];
}
 
    [MBProgressHUD hideHUDForView:self.view animated:YES];

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
                 int mobileno=[[ userpriledict valueForKey:@"mobile"] intValue];
                 NSString * image=[ userpriledict valueForKey:@"profile_pic"];
                 NSString * imageurl=[ NSString stringWithFormat:@"%@%@",@"http://www.eventsbyideation.com/v1/",image];
                 
                 name.text= username;
                 email.text=useremail;
                 mobile.text=[NSString stringWithFormat:@"%d", mobileno];
                 
                 
                 NSURL* url = [NSURL URLWithString:imageurl];
                 NSURLRequest* request = [NSURLRequest requestWithURL:url];
                 
                 
                 [NSURLConnection sendAsynchronousRequest:request
                                                    queue:[NSOperationQueue mainQueue]
                                        completionHandler:^(NSURLResponse * response,
                                                            NSData * data,
                                                            NSError * error) {
                                            if (!error){
                                                empimage.image = [UIImage imageWithData:data];
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
