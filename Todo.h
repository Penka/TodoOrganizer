//
//  Todo.h
//  TodoOrganizer
//
//  Created by Apple on 11/3/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface Todo : NSManagedObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDate *deadline;
@property (nonatomic) Boolean isDone;
@property (nonatomic, strong) NSString *place;
@property (nonatomic, strong) NSString *todoDescription;

@end
