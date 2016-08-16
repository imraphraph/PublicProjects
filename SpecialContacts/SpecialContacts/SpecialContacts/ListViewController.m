//
//  ViewController.m
//  SpecialContacts
//
//  Created by Raphael Lim on 15/08/2016.
//  Copyright © 2016 Raphael Lim. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *contacts;
@property NSMutableArray *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *userInputTextField;
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //delegate allows tableView to ask the ViewController to react.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //initialize contacts, build empty NSMutable Array
    self.contacts = [[NSMutableArray alloc]initWithObjects:@"James Bond", @"Queen Elizabeth", nil];
    self.phoneNumber = [[NSMutableArray alloc]initWithObjects:@"007", @"22222", nil];
    
    
}

//mandatory to use UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier: @"cell"];
    //display object at its index path in NSMutableArray
    cell.textLabel.text = [self.contacts objectAtIndex:indexPath.row];
    //display the subtitle (detailTextLabel= subtitle)
    cell.detailTextLabel.text = [self.phoneNumber objectAtIndex:indexPath.row];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector (functionAfterSwipeLeft:)];
    swipeLeft.numberOfTouchesRequired = 1;
    swipeLeft.direction=UISwipeGestureRecognizerDirectionLeft;
    [cell addGestureRecognizer:swipeLeft];
      [self.tableView setEditing:NO animated:NO];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector (functionAfterSwipeRight:)];
    swipeRight.numberOfTouchesRequired = 1;
    swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
    [cell addGestureRecognizer:swipeRight];
      [self.tableView setEditing:NO animated:NO];
    
    //returns cell
    return cell;

}

//this disables the delete swipe from running concurrently with our left right swipe
- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Detemine if it's in editing mode
    if (self.tableView.editing)
    {
        return UITableViewCellEditingStyleDelete;
    }
    
    return UITableViewCellEditingStyleNone;
}

-(void) functionAfterSwipeLeft: (id)sender {
    UITableViewCell *cell = [sender view];
    [self.tableView setEditing:NO animated:NO];
    [cell.textLabel setTextColor: [UIColor yellowColor]];
    
}

-(void) functionAfterSwipeRight: (id)sender {
    UITableViewCell *cell = [sender view];
    [self.tableView setEditing:NO animated:NO];
    [cell.textLabel setTextColor:[UIColor redColor]];
    
}

//mandatory to use UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //counting number of objects in the array
    return self.contacts.count;
}

//add contacts button function
- (IBAction)addContacts:(UIBarButtonItem *)sender {
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Name"
                                                                              message: @"Phone Number"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [controller addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"name";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    [controller addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"phone number";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        //IF WANA ENABLE PASSWORD
        textField.secureTextEntry = NO;
    }];
    [controller addAction:[UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = controller.textFields;
        UITextField *nameField = textfields[0];
        UITextField *phoneNumber = textfields[1];
        //add userInput into contacts array
        [self.contacts addObject: nameField.text];
        [self.phoneNumber addObject: phoneNumber.text];
            //refreshes tableView
        [self.tableView reloadData];
//        [self.view endEditing:YES];
    }]];
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (IBAction)edit:(UIBarButtonItem *)sender {
    //if table view is active, then set editing to NO which toggles edit back to inactive, else active
    if ([self.tableView isEditing]){
        [self.tableView setEditing:NO animated:YES];
    } else {
        [self.tableView setEditing:YES animated:YES];
    }
}



//if editing style active use this function
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        //editing style active this removes object at index
        [self.contacts removeObjectAtIndex:indexPath.row];
        [self.phoneNumber removeObjectAtIndex:indexPath.row];
        [self.tableView setEditing: NO animated: YES];
        //refreshes tableView
        [self.tableView reloadData];
    
    }
    

}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSString *stringToMove = self.contacts[sourceIndexPath.row];
    [self.contacts removeObjectAtIndex:sourceIndexPath.row];
    [self.contacts insertObject:stringToMove atIndex:destinationIndexPath.row];
    
}
                                     
@end
