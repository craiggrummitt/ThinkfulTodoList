//
//  CAGTodoListViewController.m
//  TodoList
//
//  Created by CraigGrummitt on 29/01/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//

#import "CAGTodoListViewController.h"

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
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didTapAddButton)];
        //get todos from persisent data
        self.todos = [[NSUserDefaults standardUserDefaults] objectForKey:@"todos"];
        if (!self.todos) {
            self.todos = [[NSMutableArray alloc] init];
        }
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    }
    return self;
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
//user hits 'Done' button in 'createTodo' popup
- (void)createTodo:(NSString *)todo withDueDate:(NSDate *)dueDate
{
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
    //add to persisent data
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.todos forKey:@"todos"];
    [userDefaults synchronize];
    
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = self.todos[indexPath.row];
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
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:self.todos forKey:@"todos"];
        [userDefaults synchronize];
        
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
