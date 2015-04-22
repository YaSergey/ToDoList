//
//  ViewController.m
//  ToDoList
//
//  Created by Sergey Yasnetsky on 22.04.15.
//  Copyright (c) 2015 Sergey Yasnetsky. All rights reserved.
//

#import "ViewController.h"
#import "ToDoDetailViewController.h"


@interface ViewController ()

@property (strong, nonatomic) NSMutableArray * arrayEvents;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)addEvent:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self showNotification];
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNotification) name:@"NewEvent" object:nil];
    
//    [self reloadTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void) showNotification {
    
    [self.arrayEvents removeAllObjects];
    
    NSArray * array = [[UIApplication sharedApplication]scheduledLocalNotifications];
    
    self.arrayEvents = [[NSMutableArray alloc]initWithArray:array];
    
    [self reloadTableView];

}


- (void) reloadTableView {
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.arrayEvents.count;
    

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * identifaer = @"Cell";
    UITableViewCell  * cell = [tableView dequeueReusableCellWithIdentifier:identifaer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifaer];
    }
    
    UILocalNotification * notif = [self.arrayEvents objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [notif.userInfo objectForKey:@"event"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [notif.userInfo objectForKey:@"dateEvent"]];
    
    return cell;

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
    
        UILocalNotification * notif = [self.arrayEvents objectAtIndex:indexPath.row];
        [self.arrayEvents removeObjectAtIndex:indexPath.row];
        
        [[UIApplication sharedApplication] cancelLocalNotification:notif];
        
        [self reloadTableView];
    }
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILocalNotification * notif = [self.arrayEvents objectAtIndex:indexPath.row];
     
    
    ToDoDetailViewController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
    detail.isNewEwent = NO;
    detail.stringEwentItem = [notif.userInfo objectForKey:@"event"];
    detail.dateCurrentEwent = notif.fireDate;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewEvent" object:nil];
    
    [self.navigationController pushViewController:detail animated:YES];
}

- (IBAction)addEvent:(id)sender {
    ToDoDetailViewController * detail = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
      detail.isNewEwent = YES;
    
    [self.navigationController pushViewController:detail animated:YES];
}

@end
