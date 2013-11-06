//
//  TodosTableViewController.m
//  TodoOrganizer
//
//  Created by Apple on 11/3/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import "TodosTableViewController.h"
#import "DetailViewController.h"
#import "AddTodoViewController.h"
#import "Todo.h"


@interface TodosTableViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

-(void) handleSwipeFrom:(UIGestureRecognizer *) sender;
-(void) completeTodo:(Todo *) todo;

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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    //[self addTodo];
    
    self.fetchedResultsController = nil;
    
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier:@"TodoCell"];
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem* addButton = [[UIBarButtonItem alloc] init];
    
    addButton.action = @selector(changeView);
    addButton.target = self;
    addButton.title = @"Add";

    self.navigationItem.leftBarButtonItem = addButton;
    
    
    //from here starts the code for gesturing - swiping for completing todo
    UISwipeGestureRecognizer* gestureR;
    gestureR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    gestureR.direction = UISwipeGestureRecognizerDirectionRight;
    [self.tableView addGestureRecognizer:gestureR];
        
    //end

}


-(void) changeView
{
    // Create the next view controller.
    AddTodoViewController *addTodoViewController = [[AddTodoViewController alloc] init];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:addTodoViewController animated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id  sectionInfo =
        [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"TodoCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Todo *todo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = todo.title;
    
    if(todo.isDone){
        cell.backgroundColor = [UIColor orangeColor];
    }
    return cell;
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

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object.
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error;
        if (![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        [self.tableView reloadData];
        
        //here refresh the list of todos so that the deleted todo will not show.
    }
    
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailsViewController = [[DetailViewController alloc] init];

    detailsViewController.managedObjectContext = self.managedObjectContext;
    
    Todo *selectedTodo = (Todo *)[[self fetchedResultsController] objectAtIndexPath:indexPath];

    detailsViewController.todo = selectedTodo;
    
    [self.navigationController pushViewController:detailsViewController animated:YES];
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



@end
