//
//  ViewController.h
//  Tracker
//
//  Created by vikas on 7/19/16.
//  Copyright © 2016 Aaravee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LOGINVC : UIViewController
{
    IBOutlet UIButton* empbtn;
    IBOutlet UIButton *adminbtn;
    IBOutlet UITextField *email;
    IBOutlet UITextField  *password;
    
}
-(IBAction)Addcheckmark:(UIButton*)sender;
@end

