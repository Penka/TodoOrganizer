//
//  Step.h
//  TodoOrganizer
//
//  Created by Apple on 11/14/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Todo;

@interface Step : NSManagedObject

@property (nonatomic, retain) NSNumber * isDone;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) Todo *todo;

@end
