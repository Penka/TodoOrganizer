//
//  DetailViewController.m
//  TodoOrganizer
//
//  Created by Apple on 11/5/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import "DetailViewController.h"
#import "AddStepViewController.h"


@interface DetailViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *placeLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *deadlineLabel;

-(void) updateInterface;
-(void) addStepButtonClick;


@end

@implementation DetailViewController

@synthesize stepsTableView = _stepsTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.todo.isDone) {
        self.view.backgroundColor = [UIColor orangeColor];
    } else{
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
	// Do any additional setup after loading the iew.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.stepsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 270, 320, 400)];
    self.stepsTableView.dataSource = self;
    self.stepsTableView.delegate = self;

    [self.stepsTableView registerClass: [UITableViewCell class] forCellReuseIdentifier:@"StepCell"];
  
    UIButton *addStepButton = [[UIButton alloc] initWithFrame:CGRectMake(60, 250, 120, 20)];
    [addStepButton setTitle:@"Add step" forState:UIControlStateNormal];

    [addStepButton addTarget:self action:@selector(addStepButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    addStepButton.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:addStepButton];
    
    self.stepsViewController = [[StepsViewController alloc] init];
    
    self.stepsViewController.todo = self.todo;
    
    self.stepsViewController.view.backgroundColor = [UIColor magentaColor];
    
    //[self addChildViewController:self.stepsViewController];
    
//    [self.stepsViewController.tableView setBounds:CGRectMake(0, 300, 100, 400)];
//    
    [self.view addSubview:self.stepsTableView];

    
    
    
    [self updateInterface];
    [self.stepsTableView reloadData];
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
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
     [self.stepsTableView reloadData];
 }
 }


-(void) addStepButtonClick
{
    
    AddStepViewController *addStepViewController = [[AddStepViewController alloc] init];
    addStepViewController.todo = self.todo;
    addStepViewController.managedObjectContext = self.managedObjectContext;
    
    [self.navigationController pushViewController:addStepViewController animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger stepsCount = self.todo.steps.count;
    return stepsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StepCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    //cell.textLabel.text = @"table inside uivc";
    NSArray *allSteps = [self.todo.steps allObjects];
    
    Step *step = [allSteps objectAtIndex:indexPath.row];
    cell.textLabel.text = step.text;
    
    return cell;
}


-(void) updateInterface
{
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, 200, 50)];
    self.titleLabel.backgroundColor = [UIColor blueColor];
    self.titleLabel.text = self.todo.title;
    [self.view addSubview:self.titleLabel];
    
    self.descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 150, 200, 50)];
    self.descriptionLabel.backgroundColor = [UIColor blueColor];
    self.descriptionLabel.text = self.todo.todoDescription;
    [self.view addSubview:self.descriptionLabel];
    
    self.placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 200, 200, 50)];
    self.placeLabel.backgroundColor = [UIColor blueColor];
    self.placeLabel.text = self.todo.place;
    [self.view addSubview:self.placeLabel];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
