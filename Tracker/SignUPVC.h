//
//  SignUPVC.h
//  Tracker
//
//  Created by vikas on 7/19/16.
//  Copyright © 2016 Aaravee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUPVC : UIViewController
{
    IBOutlet UIButton* empbtn;
    IBOutlet UIButton *adminbtn;
    IBOutlet UITextField *name;
    IBOutlet  UITextField *email;
    IBOutlet UITextField *mobileno;
    IBOutlet  UITextField *password;
    IBOutlet UITextField * regeisterkey;
    
}
-(IBAction)Addcheckmark:(UIButton*)sender;
-(IBAction)Backbtn:(UIButton*)sender;
@end
