//
//  Todo.h
//  TodoList
//
//  Created by CraigGrummitt on 4/02/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Todo : NSObject<NSCoding>
@property (strong,nonatomic) NSString *text;
@property (strong,nonatomic) NSDate *dueDate;
@end
