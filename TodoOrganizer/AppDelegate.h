//
//  AppDelegate.h
//  TodoOrganizer
//
//  Created by Apple on 11/3/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


//mine
//-(void) addTodo; //it's place is not here but it will work for test purposes.

@end
