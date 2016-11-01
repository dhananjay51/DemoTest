//
//  LogoutVC.h
//  Tracker
//
//  Created by Macbook Pro on 06/09/16.
//  Copyright © 2016 Aaravee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileVC : UIViewController
{
    IBOutlet  UIImageView *empimage;
    IBOutlet  UITextField *name;
    IBOutlet  UILabel *email;
    IBOutlet  UITextField *location;
     

    IBOutlet  UITextField *mobile;
  
   
    
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

-(IBAction)Louout:(id)sender;
-(IBAction)LinkClicked:(UIButton*)sender;
-(IBAction)updatebtn:(UIButton*)sender;
    

@end
