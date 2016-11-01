//
//  SnapEmpVC.h
//  Tracker
//
//  Created by Macbook Pro on 14/08/16.
//  Copyright © 2016 Aaravee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendenceListVC : UIViewController
{
    IBOutlet UITableView * Snaptable;
}
@property(nonatomic,strong) NSString *reject;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@end
