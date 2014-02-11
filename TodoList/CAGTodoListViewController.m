//
//  CAGTodoListViewController.m
//  TodoList
//
//  Created by CraigGrummitt on 29/01/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//

#import "CAGTodoListViewController.h"
#import "Todo.h"

@interface CAGTodoListViewController ()
@property (strong, nonatomic) NSMutableArray *todos;
@end

@implementation CAGTodoListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"To-Do List";
       // self.navigationItem.title = [NSString stringWithFormat:@"To-Do List %f", CGRectGetWidth(self.view.frame)];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didTapAddButton)];
        /********   get todos from file using custom model with NSCoding */
        self.todos = [NSKeyedUnarchiver unarchiveObjectWithFile:self.resourcePath];
        /********      get todos from persisent data using custom model with NSCoding
        NSData *todoData =[[NSUserDefaults standardUserDefaults] objectForKey:@"todos"];
        self.todos = [NSKeyedUnarchiver unarchiveObjectWithData:todoData];*/
        /********      get todos from persisent data using NSDictionary
        //        self.todos = [[NSUserDefaults standardUserDefaults] objectForKey:@"todos"];*/
        if (!self.todos) {
            self.todos = [[NSMutableArray alloc] init];
        }
        //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    return self;
}
- (NSString *)resourcePath {
    return [NSBundle.mainBundle.resourcePath  stringByAppendingPathComponent:@"todos"];
}
- (void) didTapAddButton
{
    CAGCreateTodoViewController *createVC = [[CAGCreateTodoViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:createVC];
    createVC.delegate = self;
    [self.navigationController presentViewController:navController animated:YES completion:nil];
  
/*    CAGCreateTodoViewController *createVC = [[CAGCreateTodoViewController alloc] init];
    createVC.delegate = self;
    [self.navigationController presentViewController:createVC animated:YES completion:nil];*/

    
   /* UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New To-Do" message:@"Enter a to-do item" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Done", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];*/
}
//user selects a row, edits a todo
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Todo *todo = self.todos[indexPath.row];
    CAGCreateTodoViewController *createVC = [[CAGCreateTodoViewController alloc] initWithTodo:todo atRow:indexPath.row];
    //UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:createVC];
    createVC.delegate = self;
    [self.navigationController pushViewController:createVC animated:YES];
    
}
//user hits 'Done' button in 'editTodo' popup
- (void)updateTodo: (NSString *)todo withDueDate:(NSDate *)dueDate atRow:(NSUInteger)row;
{
    /* EDIT USING CUSTOM MODEL */
    Todo *item = [[Todo alloc] init];
    item.text = todo;
    item.dueDate = dueDate;
    [self.todos replaceObjectAtIndex:row withObject:item];
    //sort data
    NSSortDescriptor *todoSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dueDate" ascending:YES];
    [self.todos sortUsingDescriptors:@[todoSortDescriptor]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *todoData = [NSKeyedArchiver archivedDataWithRootObject:self.todos];
    [userDefaults setObject:todoData forKey:@"todos"];
    [userDefaults synchronize];
    
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
   
}
//user hits 'Done' button in 'createTodo' popup
- (void)createTodo:(NSString *)todo withDueDate:(NSDate *)dueDate
{
    /* CREATE USING CUSTOM MODEL */
    Todo *item = [[Todo alloc] init];
    item.text = todo;
    item.dueDate = dueDate;
    [self.todos addObject:item];
    //sort data
    NSSortDescriptor *todoSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dueDate" ascending:YES];
    [self.todos sortUsingDescriptors:@[todoSortDescriptor]];
    
    /********  PERSISTENT DATA USING Custom Model and saving to file */
    [NSKeyedArchiver archiveRootObject:self.todos toFile:self.resourcePath];
    /********  PERSISTENT DATA USING Custom Model and NSUserDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *todoData = [NSKeyedArchiver archivedDataWithRootObject:self.todos];
    [userDefaults setObject:todoData forKey:@"todos"];
    [userDefaults synchronize];*/
    
    
    /******** CREATE USING NSDICTIONARY
    NSDictionary *todoItem = @{@"text": todo, @"dueDate": dueDate};
    [self.todos addObject:todoItem];
    
    //add to persisent data
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.todos forKey:@"todos"];
    [userDefaults synchronize];
            */
    //reload tableView
    [self.tableView reloadData];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
//user hits 'Cancel' button in 'createTodo' popup
- (void)didCancelCreatingNewTodo
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
            //    NSString *input =[[alertView textFieldAtIndex:0] text];
            //      NSString *input =[alertView textFieldAtIndex:0].text;
            //    [self.todos addObject:input];
    //add to array
    [self.todos addObject:[alertView textFieldAtIndex:0].text];
    /***** add to persistent data in file */
    [NSKeyedArchiver archiveRootObject:self.todos toFile:[self resourcePath]];
    /*****  add to persisent data in NSUserDefaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.todos forKey:@"todos"];
    [userDefaults synchronize];*/
    
    //reload tableView
    [self.tableView reloadData];
    //NSLog(@"%@",input);
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.todos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
       // cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    //get the two properties of the row(todoItem) and put them into the two textFields
    Todo *todoItem = self.todos[indexPath.row];
    cell.textLabel.text = todoItem.text;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Due %@", [dateFormatter stringFromDate:todoItem.dueDate]];
    
    
    //previous code - when we only had one property per row(todoItem)
    //cell.textLabel.text = self.todos[indexPath.row][@"text"];
    return cell;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.todos removeObjectAtIndex:indexPath.row];
        /*****persistent data - remove from file */
        [NSKeyedArchiver archiveRootObject:self.todos toFile:self.resourcePath];
        /*****persistent data - remove from NSUserDefaults
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSData *todoData = [NSKeyedArchiver archivedDataWithRootObject:self.todos];
        [userDefaults setObject:todoData forKey:@"todos"];
        [userDefaults synchronize];*/
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
   // else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    //}
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
