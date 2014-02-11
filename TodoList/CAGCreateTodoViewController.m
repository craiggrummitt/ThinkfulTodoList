//
//  CAGCreateTodoViewController.m
//  TodoList
//
//  Created by CraigGrummitt on 30/01/2014.
//  Copyright (c) 2014 CraigGrummitt. All rights reserved.
//

#import "CAGCreateTodoViewController.h"
#import "Todo.h"

@interface CAGCreateTodoViewController ()
@property (strong, nonatomic) UILabel *todoLabel;
@property (strong, nonatomic) UITextField *todoInput;
@property (strong, nonatomic) UILabel *dueDateLabel;
@property (strong, nonatomic) UITextField *dueDateInput;
@property (strong, nonatomic) NSDate *dueDate;
@property (strong, nonatomic) UIButton *shareButton;
@property (nonatomic) CGFloat appWidth;
@property (nonatomic) CGFloat appHeight;
@end

@implementation CAGCreateTodoViewController

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
	self.navigationItem.title = @"New To-Do";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(didTapDoneButton)];
    if (!self.todo) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonSystemItemCancel target:self action:@selector(didTapCancelButton)];
    }
    
    //******* CG ADDED BEGIN ***/
    //UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    //if (UIDeviceOrientationIsPortrait(deviceOrientation)) {
    //} else {
     //   self.appHeight =CGRectGetWidth(self.view.frame);
      //  self.appWidth=CGRectGetHeight(self.view.frame);
    //}
    //******* CG ADDED END ***/
    [self renderView];
}
- (void)renderView
{
    NSLog (@"Rotating! %f",CGRectGetWidth(self.view.frame));
    self.appWidth =CGRectGetWidth(self.view.frame);
    self.appHeight=CGRectGetHeight(self.view.frame);
    [self renderTodoText];
    [self renderDueDate];
    [self renderShareButton];
}
- (void)resizeView
{
    self.appWidth =CGRectGetWidth(self.view.frame);
    self.appHeight=CGRectGetHeight(self.view.frame);
    [self resizeTodoInput];
    [self resizeDueDateInput];
    [self resizeShareButton];
}
- (void) resizeTodoInput {
    self.todoInput.frame = CGRectMake(CGRectGetMinX(self.todoLabel.frame),
                                      CGRectGetMaxY(self.todoLabel.frame) + 5,
                                      self.appWidth - (40),
                                      40);
}
- (void) resizeDueDateInput {
    CGRect dueDateFrame = self.todoInput.frame;
    dueDateFrame.origin.y = CGRectGetMaxY(self.dueDateLabel.frame) + 5;
    self.dueDateInput.frame = dueDateFrame;
}
- (void)resizeShareButton {
    CGFloat top =CGRectGetMaxY(self.dueDateInput.frame);
    self.shareButton.frame = CGRectMake(
                                        (self.appWidth-CGRectGetWidth(self.shareButton.frame))/2,
                                        top + (self.appHeight-top-CGRectGetHeight(self.shareButton.frame))/2,
                                        CGRectGetWidth(self.shareButton.frame),
                                        CGRectGetHeight(self.shareButton.frame)
                                        );
}
- (void)didTapDoneButton {
    if (self.todoInput.text.length==0 || !self.dueDate) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Invalid todo!" message:@"Check your todo - it's invalid!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Done", nil];
        [alertView show];
    } else {
        if (self.todo) {
            [self.delegate updateTodo:self.todoInput.text withDueDate:self.dueDate atRow:self.row];
        } else {
            [self.delegate createTodo:self.todoInput.text withDueDate:self.dueDate];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

}
- (void)didTapCancelButton {
    [self.delegate didCancelCreatingNewTodo];
}
- (void)renderTodoText {
    self.todoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, 0, 0)];
    self.todoLabel.text = @"To-do:";
    self.todoLabel.font = [UIFont boldSystemFontOfSize:UIFont.systemFontSize];
    [self.todoLabel sizeToFit];
    [self.view addSubview:self.todoLabel];
    
    
    self.todoInput = [[UITextField alloc] init];
    if (self.todo) {
        self.todoInput.text = self.todo.text;
    }
    self.todoInput.borderStyle = UITextBorderStyleRoundedRect;
    self.todoInput.placeholder = @"Enter a to-do here.";
    self.todoInput.clearButtonMode = UITextFieldViewModeUnlessEditing;
    self.todoInput.delegate = self;
    [self resizeTodoInput];
    [self.view addSubview:self.todoInput];
}
- (void)renderDueDate {
    CGRect dueDateLabelFrame = CGRectMake(CGRectGetMinX(self.todoInput.frame), CGRectGetMaxY(self.todoInput.frame) + 30, 0, 0);
    self.dueDateLabel = [[UILabel alloc] initWithFrame:dueDateLabelFrame];
    self.dueDateLabel.text = @"Due date:";
    self.dueDateLabel.font = [UIFont boldSystemFontOfSize:UIFont.systemFontSize];
    [self.dueDateLabel sizeToFit];
    [self.view addSubview:self.dueDateLabel];
    
    self.dueDateInput = [[UITextField alloc] init];
    self.dueDateInput.borderStyle = UITextBorderStyleRoundedRect;
    self.dueDateInput.placeholder = @"Due date";
    self.dueDateInput.clearButtonMode = UITextFieldViewModeUnlessEditing;
    self.dueDateInput.delegate = self;
    
    [self resizeDueDateInput];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(didChangeDate:) forControlEvents:UIControlEventValueChanged];
    self.dueDateInput.inputView = datePicker;
    
    [self.view addSubview:self.dueDateInput];
    
    
    if (self.todo) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        self.dueDate = self.todo.dueDate;
        self.dueDateInput.text = [dateFormatter stringFromDate:self.dueDate];
        datePicker.date = self.dueDate;
    }
}
- (void) renderShareButton {
    self.shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.shareButton setTitle:@"Share" forState:UIControlStateNormal];
    [self.shareButton sizeToFit];
    [self resizeShareButton];
    //UIButton *shareButton = [[UIButton alloc] initWithFrame:shareFrame];
    [self.shareButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.shareButton];
}
-(void)btnClick:(id)sender
{
    NSString *shareString = [NSString stringWithFormat:@"Todo: %@ Due Date=%@", self.todoInput.text, self.dueDateInput.text];
    // UIImage *shareImage = [UIImage imageNamed:@"captech-logo.jpg"];
    //NSURL *shareUrl = [NSURL URLWithString:@"http://www.captechconsulting.com"];
    
//    NSArray *activityItems = [NSArray arrayWithObjects:shareString, shareImage, shareUrl, nil];
    NSArray *activityItems = [NSArray arrayWithObjects:shareString, nil, nil, nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    activityViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}
- (void)didChangeDate:(UIDatePicker *)picker {
    self.dueDate  = [picker date];
    
    NSDateFormatter  *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    
    self.dueDateInput.text = [dateFormatter stringFromDate:self.dueDate];
}
- (id)initWithTodo:(Todo *)todo atRow:(NSUInteger)row {
    if (self = [super init]) {
        self.todo = todo;
        self.row =row;
    }
    return self;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self resizeView];
}
@end
