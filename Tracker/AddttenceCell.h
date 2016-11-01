//
//  AddttenceCell.h
//  Tracker
//
//  Created by Macbook Pro on 25/09/16.
//  Copyright © 2016 Aaravee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@interface AddttenceCell : UITableViewCell
@property(nonatomic,strong) IBOutlet UILabel *companyName;
@property(nonatomic,strong) IBOutlet UILabel *customerName;
@property(nonatomic,strong) IBOutlet UILabel *CenterName;

@property(nonatomic,strong) IBOutlet UILabel *date;
@property(nonatomic,strong) IBOutlet UILabel *Time;
@property(nonatomic,strong) IBOutlet UILabel *Hour;
@property(nonatomic,strong) IBOutlet UILabel *location;
@property(nonatomic,strong) IBOutlet  CustomButton *Clockin;
@property(nonatomic,strong) IBOutlet  CustomButton *Clouckoout;
@property(nonatomic,strong) IBOutlet  CustomButton *Collingtbtn;

@end
