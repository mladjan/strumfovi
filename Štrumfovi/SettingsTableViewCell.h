//
//  SettingsTableViewCell.h
//  Štrumfovi
//
//  Created by Mladjan Antic on 6/28/15.
//  Copyright (c) 2015 BLGRDCreative. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UISwitch *rightSwitch;

@end
