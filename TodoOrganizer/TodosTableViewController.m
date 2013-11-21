//
//  TodosTableViewController.m
//  TodoOrganizer
//
//  Created by Apple on 11/3/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import "TodosTableViewController.h"
#import "DetailsViewController.h"
#import "AddTodoViewController.h"
#import "Todo.h"
#import "TodoTableViewCell.h"

@interface TodosTableViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end

@implementation TodosTableViewController


#pragma mark - Fetched Results Controller setup

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Todo" inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"deadline" ascending:YES];
    NSSortDescriptor *sortByDone = [[NSSortDescriptor alloc]
                              initWithKey:@"isDone" ascending:YES];
    
    NSArray *sortDescriptors = @[sortByDone, sort];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setFetchBatchSize:20];
    
    [NSFetchedResultsController deleteCacheWithName:@"Root"];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

#pragma mark - Load methods

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.fetchedResultsController = nil;
    
    [self.tableView registerClass: [TodoTableViewCell class] forCellReuseIdentifier:@"TodoCellIdentifier"];
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    
    [self setRightNavigationButton];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id  sectionInfo =
        [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"My Todos";
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Todo *todo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if((!todo.isDone.boolValue) && ([todo.deadline compare:[NSDate date]]==NSOrderedDescending)){
        [self scheduleNotification:todo];
    }
    
    static NSString *cellIdentifier = @"Cell";
    
    TodoTableViewCell *cell = (TodoTableViewCell *)[table dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {        
        cell = [[TodoTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier containingTableView:table currentTodo:todo];
    }
    
    else{
        [cell loadUIElements];
    }
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Detemine if it's in editing mode
    if (self.editing)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath] ];
        
        [self.tableView beginUpdates];
   
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        [self.tableView reloadData];
        
        [self.tableView endUpdates];
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Todo *selectedTodo = (Todo *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
    [self showTodoDetails:selectedTodo];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
    }
}

#pragma mark - Navigation controllers

-(void) showTodoDetails :(Todo *)selectedTodo {
    DetailsViewController *detailsViewController = [[DetailsViewController alloc] init];
    detailsViewController.todo = selectedTodo;
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

-(void) navigateToAddView
{
    AddTodoViewController *addTodoViewController = [[AddTodoViewController alloc] init];
    addTodoViewController.managedObjectContext = self.managedObjectContext;
    [self.navigationController pushViewController:addTodoViewController animated:YES];
}

#pragma mark - Navigation buttons

-(void) setRightNavigationButton {
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(navigateToAddView)];
    self.navigationItem.rightBarButtonItem = addButtonItem;
}


#pragma mark - Notifications

- (void) scheduleNotification:(Todo *)todo
{
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    
    //Setting the notification 30 minutes before the deadline.
    NSDate *fireDate = [todo.deadline dateByAddingTimeInterval:-(60*30)];
    localNotification.fireDate = fireDate;
    localNotification.alertBody = todo.title;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end
