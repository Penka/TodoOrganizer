//
//  Todo.h
//  TodoOrganizer
//
//  Created by Apple on 11/14/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Step;

@interface Todo : NSManagedObject

@property (nonatomic, retain) NSDate * deadline;
@property (nonatomic, retain) NSNumber * isDone;
@property (nonatomic, retain) NSString * place;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * todoDescription;
@property (nonatomic, retain) NSSet *steps;
@end

@interface Todo (CoreDataGeneratedAccessors)

- (void)addStepsObject:(Step *)value;
- (void)removeStepsObject:(Step *)value;
- (void)addSteps:(NSSet *)values;
- (void)removeSteps:(NSSet *)values;

@end
