//
//  Step.h
//  TodoOrganizer
//
//  Created by Apple on 11/6/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Todo;

@interface Step : NSManagedObject

@property (nonatomic, strong) NSString *text;
@property (nonatomic) Boolean isDone;
@property (nonatomic, strong) NSString *stepDescription;
@property (nonatomic, strong) Todo *todo;

@end
