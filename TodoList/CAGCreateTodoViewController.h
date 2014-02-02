//
//  CAGCreateTodoViewController.h
//  TodoList
//
//  Created by CraigGrummitt on 30/01/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CAGCreateTodoViewControllerDelegate
- (void)createTodo:(NSString *)todo withDueDate:(NSDate *)dueDate;
- (void)didCancelCreatingNewTodo;
@end
@interface CAGCreateTodoViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) id<CAGCreateTodoViewControllerDelegate>delegate;
@end
