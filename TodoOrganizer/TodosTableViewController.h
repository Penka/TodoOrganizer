//
//  TodosTableViewController.h
//  TodoOrganizer
//
//  Created by Apple on 11/3/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodosTableViewController : UITableViewController<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;


//mine
-(void) changeView; //for test purposes to change the view when clicking on add button in the navigation.


@end
