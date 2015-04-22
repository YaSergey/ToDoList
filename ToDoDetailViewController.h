//
//  ToDoDetailViewController.h
//  ToDoList
//
//  Created by Sergey Yasnetsky on 22.04.15.
//  Copyright (c) 2015 Sergey Yasnetsky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToDoDetailViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, assign) BOOL isNewEwent;
@property (nonatomic, strong) NSString * stringEwentItem;
@property (nonatomic, strong) NSDate * dateCurrentEwent;

- (void) reloadTableView;

@end
