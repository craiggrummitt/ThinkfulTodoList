//
//  Todo.m
//  TodoList
//
//  Created by CraigGrummitt on 4/02/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//

#import "Todo.h"

@implementation Todo
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.text = [decoder decodeObjectForKey:@"text"];
    self.dueDate = [decoder decodeObjectForKey:@"dueDate"];
    
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.text forKey:@"text"];
    [encoder encodeObject:self.dueDate forKey:@"dueDate"];
}
@end
