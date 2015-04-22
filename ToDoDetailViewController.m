//
//  ToDoDetailViewController.m
//  ToDoList
//
//  Created by Sergey Yasnetsky on 22.04.15.
//  Copyright (c) 2015 Sergey Yasnetsky. All rights reserved.
//

#import "ToDoDetailViewController.h"


@interface ToDoDetailViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textField;
- (IBAction)saveButton:(id)sender;
- (IBAction)datePickerAction:(UIDatePicker *)sender;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) NSDate * dateNewEvent;


@end

@implementation ToDoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.datePicker.minimumDate  = [NSDate date];
   
    
    if (self.isNewEwent) {
        [self.textField becomeFirstResponder];
    }
    else {
        self.textField.text = self.stringEwentItem;
        self.textField.userInteractionEnabled = NO;
        self.datePicker.userInteractionEnabled = NO;
    
        [self performSelector:@selector(setDateCurrentEwent) withObject:nil afterDelay:0.5];
    }
}

- (void) setDateCurrentEwent {
    
    [self.datePicker setDate:self.dateCurrentEwent animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) set_notification {
    
    NSDateFormatter * format = [[NSDateFormatter alloc]init];
        format.dateFormat = @"dd.MMM.yyyy HH:mm";
    
    NSString * stringDate =  [format stringFromDate:self.dateNewEvent];
    
    
    UILocalNotification * notif = [[UILocalNotification alloc]  init];
    
    notif.fireDate = self.dateNewEvent;
    notif.timeZone = [NSTimeZone defaultTimeZone];
    notif.alertBody = self.textField.text;
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.textField.text, @"event", stringDate, @"dateEvent", nil];
    notif.userInfo = dict;
    notif.soundName = UILocalNotificationDefaultSoundName;
    notif.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notif];
    
    NSLog(@"notif %@", notif);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewEvent" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)saveButton:(id)sender {
    
    if (!self.dateNewEvent) {
        UIAlertView * alert  = [[UIAlertView alloc] initWithTitle:@"АЛАРМ!" message:@"Выберите дату" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Ok", nil];
        [alert show];
        
    }
    else if ([self.textField.text length] == 0) {
        UIAlertView * alert  = [[UIAlertView alloc] initWithTitle:@"АЛАРМ!"message:@"Напечатай в текстовом поле" delegate:self cancelButtonTitle:@"Cansel" otherButtonTitles: @"Ok", nil];
            [alert show];
    }
    else {
        [self set_notification];
    }

}

- (IBAction)datePickerAction:(UIDatePicker *)sender {
    
    self.dateNewEvent = sender.date;
    
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [self.textField resignFirstResponder];
    
    return YES;
    
}


@end
