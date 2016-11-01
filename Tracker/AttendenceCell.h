//
//  AttendenceCell.h
//  Tracker
//
//  Created by Macbook Pro on 14/09/16.
//  Copyright © 2016 Aaravee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendenceCell : UITableViewCell

@property(nonatomic,strong) IBOutlet UILabel *Compnayname;
@property(nonatomic,strong)IBOutlet UILabel *Customername;
@property(nonatomic,strong) IBOutlet  UILabel *TaskName;
@property(nonatomic,strong) IBOutlet  UILabel *Clockin;
@property(nonatomic,strong) IBOutlet  UILabel *Clockout;
@property(nonatomic,strong) IBOutlet  UILabel *workedhour;

@end
