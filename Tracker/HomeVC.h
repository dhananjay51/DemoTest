//
//  addattendanceVC.h
//  Tracker
//
//  Created by Macbook Pro on 17/08/16.
//  Copyright © 2016 Aaravee. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol sampleDelegate <NSObject>

- (void)secondControllerFinishedWithItems:(NSDictionary*)newData;

@end
@interface HomeVC : UIViewController
{
    IBOutlet  UITableView *addttdeancetable;
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic, strong) id <sampleDelegate> sampleDelegateObject;

@end
