//
//  SnaplistCell.h
//  Tracker
//
//  Created by Macbook Pro on 14/08/16.
//  Copyright © 2016 Aaravee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@interface RosterCell : UITableViewCell
@property(nonatomic,strong) IBOutlet UILabel *companyname;
@property(nonatomic,strong) IBOutlet UILabel *centername;
@property(nonatomic,strong) IBOutlet UILabel *Customename;

@property(nonatomic,strong) IBOutlet UILabel *date;
@property(nonatomic,strong) IBOutlet UILabel *Time;
@property(nonatomic,strong) IBOutlet UILabel *Hour;
@property(nonatomic,strong) IBOutlet UILabel *location;
@property (nonatomic,retain)IBOutlet UIImageView *imgCheck;
@property(nonatomic,strong) IBOutlet  CustomButton *Confirbnt;
@property(nonatomic,strong) IBOutlet  CustomButton *Rejectbtn;
@property(nonatomic,strong) IBOutlet  CustomButton *Collingtbtn;
@property(nonatomic,strong) IBOutlet  CustomButton *Addtancedbtn;
@property(nonatomic,strong) IBOutlet  UIView *container;


@end
