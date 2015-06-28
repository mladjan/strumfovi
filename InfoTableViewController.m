//
//  InfoTableViewController.m
//  
//
//  Created by Mladjan Antic on 6/28/15.
//
//

#import "InfoTableViewController.h"
#import "SettingsTableViewCell.h"

@interface InfoTableViewController ()

@end

@implementation InfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = footerView.frame;
    myLabel.font = [UIFont systemFontOfSize:15];
    myLabel.text = @"Version: 1.0";
    myLabel.textAlignment = NSTextAlignmentCenter;
    myLabel.textColor = [UIColor grayColor];
    [footerView addSubview:myLabel];
    
    self.tableView.tableFooterView = footerView;
}


- (IBAction)closeMe:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Table view data source




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SettingsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
   
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if(indexPath.row == 0){
        cell.label.text = @"Radar control";
        cell.rightSwitch.on = [defaults boolForKey:@"radar"];
    }else if(indexPath.row == 1){
        cell.label.text = @"Alcohol control";
        cell.rightSwitch.on = [defaults boolForKey:@"alcohol"];
    }else if(indexPath.row == 2){
        cell.label.text = @"Regular control";
        cell.rightSwitch.on = [defaults boolForKey:@"regular"];
    }
    cell.rightSwitch.tag = indexPath.row;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Notifications";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(18, 18, 320, 20);
    myLabel.font = [UIFont systemFontOfSize:15];
    myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
    myLabel.textColor = [UIColor grayColor];

    UIView *headerView = [[UIView alloc] init];
    [headerView addSubview:myLabel];
    
    return headerView;
}



- (IBAction)switchChanged:(UISwitch *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   
    if(sender.tag == 0){
        [defaults setBool:sender.isOn forKey:@"radar"];
    }else if(sender.tag == 1){
        [defaults setBool:sender.isOn forKey:@"alcohol"];
    }else if(sender.tag == 2){
        [defaults setBool:sender.isOn forKey:@"regular"];
    }
    
    [defaults synchronize];
}


@end
