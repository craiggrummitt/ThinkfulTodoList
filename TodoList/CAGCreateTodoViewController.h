//
//  CAGCreateTodoViewController.h
//  TodoList
//
//  Created by CraigGrummitt on 30/01/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Todo;


@protocol CAGCreateTodoViewControllerDelegate
- (void)createTodo:(NSString *)todo withDueDate:(NSDate *)dueDate;
- (void)updateTodo: (NSString *)todo withDueDate:(NSDate *)dueDate atRow:(NSUInteger)row;
- (void)didCancelCreatingNewTodo;
@end
@interface CAGCreateTodoViewController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) id<CAGCreateTodoViewControllerDelegate>delegate;
@property (strong, nonatomic) Todo *todo;
@property (assign, nonatomic) NSUInteger row;
- (instancetype)initWithTodo:(Todo *)todo atRow:(NSUInteger)row;
@end
