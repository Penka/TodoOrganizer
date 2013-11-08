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
#import "TodoCell.h"

@interface TodosTableViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

-(void) handleSwipeFrom:(UIGestureRecognizer *) sender;
-(void) completeTodo:(Todo *) todo;
-(void) changeViewToAddVC;

@end

@implementation TodosTableViewController


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
                              initWithKey:@"title" ascending:NO];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
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

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //[self addTodo];
    
    self.fetchedResultsController = nil;
    
    [self.tableView registerClass: [TodoCell class] forCellReuseIdentifier:@"TodoCellIdentifier"];
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
	}
    
    [self setRightNavigationButton];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    [self setGesturerForCompletingTodo];
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
//    
//    static NSString *cellIdentifier = @"TodoCell";
//    
//    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    static NSString *TodoCellIdentifier = @"TodoCellIdentifier";
    
    TodoCell *cell = (TodoCell *)[self.tableView dequeueReusableCellWithIdentifier:TodoCellIdentifier];

    if (cell == nil) {
        cell = [[TodoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TodoCellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    Todo *todo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    //cell.textLabel.text = todo.title;
    cell.todo = todo;
    
    if(todo.isDone){
        cell.backgroundColor = [UIColor orangeColor];
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
        
        //[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.tableView reloadData];
        
        [self.tableView endUpdates];
    }
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}

#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Todo *selectedTodo = (Todo *)[[self fetchedResultsController] objectAtIndexPath:indexPath];
    [self showTodoDetails:selectedTodo];
}

#pragma mark - My methods

-(void) showTodoDetails :(Todo *)selectedTodo
{
    DetailsViewController *detailsViewController = [[DetailsViewController alloc] init];
    detailsViewController.todo = selectedTodo;
    [self.navigationController pushViewController:detailsViewController animated:YES];
}

-(void) setGesturerForCompletingTodo
{
    UISwipeGestureRecognizer* gestureR;
    gestureR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    gestureR.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:gestureR];
}

-(void) setRightNavigationButton
{
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] init];
    
    addButton.action = @selector(changeViewToAddVC);
    addButton.target = self;
    addButton.title = @"Add";
    
    self.navigationItem.rightBarButtonItem = addButton;
}

-(void) changeViewToAddVC
{
    AddTodoViewController *addTodoViewController = [[AddTodoViewController alloc] init];
    [self.navigationController pushViewController:addTodoViewController animated:YES];
    
}

-(void) addTodo
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    for (int i = 1; i <= 30; i++) {
        NSManagedObject *newTodo = [NSEntityDescription
                                    insertNewObjectForEntityForName:@"Todo"
                                    inManagedObjectContext:context];
        NSString *title = [NSString stringWithFormat:@"My Title %d", i];
        NSString *description = [NSString stringWithFormat:@"Description %d", i];
        NSString *place = [NSString stringWithFormat:@"Place %d", i];
        
        [newTodo setValue:title forKey:@"title"];
        [newTodo setValue:description forKey:@"todoDescription"];
        [newTodo setValue:place forKey:@"place"];
        
        for (int j = 1; j<= 10; j++) {
            NSManagedObject *newStep = [NSEntityDescription
                                        insertNewObjectForEntityForName:@"Step"
                                        inManagedObjectContext:context];
            NSString *text = [NSString stringWithFormat:@"Text %d %d", i, j];
            
            [newStep setValue:text forKey:@"text"];
            [newStep setValue:newTodo forKey:@"todo"];
            
            NSError *error;
            if (![context save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }
        
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
        }
        
        [[self navigationController] popViewControllerAnimated:YES];
    }
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
			
        case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
	}
}

-(void) handleSwipeFrom : (UIGestureRecognizer *) gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint swipeLocation = [gestureRecognizer locationInView:self.tableView];
        NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
        //UITableViewCell* swipedCell = [self.tableView cellForRowAtIndexPath:swipedIndexPath];
        
        Todo *todo = [self.fetchedResultsController objectAtIndexPath:swipedIndexPath];
        
        [self completeTodo:todo];
    }
}

-(void) completeTodo:(Todo *) todo
{
    [todo setValue:[NSNumber numberWithBool:YES] forKey:@"isDone"];
    
    NSError *error;
    if(![self.managedObjectContext save:&error]){
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

@end
