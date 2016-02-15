//
//  OptionsTableViewController.m
//  OpenSpirometry
//
//  Created by Spencer Kaiser on 2/12/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

#import "OptionsTableViewController.h"

@interface OptionsTableViewController ()
@property (strong, nonatomic) NSString* selected;
@property (strong, nonatomic) NSArray* options;
@end

@implementation OptionsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"Created OptionsTableViewController");
    
    [self setOptionType:self.type];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setOptionType:(NSString*)type {
    self.type = type;
    
    if ([self.type isEqual: @"Mouthpiece"]) {
        self.options = [NSArray arrayWithObjects:
                        @"Mouthpiece A (Blue)",
                        @"Mouthpiece B (Red)",
                        @"Mouthpiece C (Green)",
                        @"Mouthpiece D (Yellow)",
                        @"Mouthpiece E (Black)",
                        nil];
    } else if ([self.type isEqual: @"Downstream"]) {
        self.options = [NSArray arrayWithObjects:
                        @"Downstream A (Blue)",
                        @"Downstream B (Red)",
                        @"Downstream C (Green)",
                        @"Downstream D (Yellow)",
                        @"Downstream E (Black)",
                        nil];
    } else {
        [NSException raise:@"Invalid Popover Type" format:@"An invalid popover type was used..."];
    }
        
        
    
    [self.tableView reloadData];
}

- (void)selectionMade {
    if([self.delegate respondsToSelector:@selector(optionSelected:)])
    {
        [self.delegate optionSelected:self.selected];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpiroOptionCell" forIndexPath:indexPath];
    cell.textLabel.text = self.options[indexPath.row];
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selected = self.options[indexPath.row];
    [self selectionMade];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)dealloc{
    NSLog(@"Did dealloc Options Popover");
}

@end
