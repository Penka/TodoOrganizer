//
//  DetailViewController.m
//  TodoOrganizer
//
//  Created by Apple on 11/5/13.
//  Copyright (c) 2013 Some. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *placeLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *deadlineLabel;

-(void) updateInterface;

@end

@implementation DetailViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem* completeTodoButton = [[UIBarButtonItem alloc] init];
    
    completeTodoButton.action = @selector(completeTodo);
    completeTodoButton.target = self;
    completeTodoButton.title = @"Complete";
    
    self.navigationItem.leftBarButtonItem = completeTodoButton;
    
    [self updateInterface];
}

-(void) updateInterface{
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 100, 200, 50)];
    self.titleLabel.backgroundColor = [UIColor blueColor];
    self.titleLabel.text = self.todo.title;; //self.titleLabel.text = self.todo.title;
    [self.view addSubview:self.titleLabel];
    
    self.descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 150, 200, 50)];
    self.descriptionLabel.backgroundColor = [UIColor blueColor];
    self.descriptionLabel.text = self.todo.todoDescription;;
    [self.view addSubview:self.descriptionLabel];
    
    self.placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 200, 200, 50)];
    self.placeLabel.backgroundColor = [UIColor blueColor];
    self.placeLabel.text = self.todo.place;;
    [self.view addSubview:self.placeLabel];
    
}

-(void) completeTodo{
    [self.todo setValue:[NSNumber numberWithBool:YES] forKey:@"isDone"];
    
    self.navigationController.view.backgroundColor = [UIColor greenColor];
    
    NSError *error;
    [self.managedObjectContext save:&error];
    NSLog(error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
