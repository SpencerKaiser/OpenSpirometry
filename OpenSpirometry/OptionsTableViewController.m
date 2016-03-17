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
    
//    [self setOptionType:self.type];
//    [self setTableData];
}

- (void)setOptionType:(NSString*)type {
    self.type = type;
    [self setTableData];
    [self.tableView reloadData];
}

- (void)setTableData {
    if ([self.type isEqual: @"Mouthpiece"]) {
        self.options = [NSArray arrayWithObjects:
                        @"Mouthpiece A (Blue)",
                        @"Mouthpiece B (Red)",
                        @"Mouthpiece C (Green)",
                        @"Mouthpiece D (Yellow)",
                        @"Mouthpiece E (Black)",
                        @"DigiDoc Whistle",
                        nil];
    } else if ([self.type isEqual: @"Downstream"]) {
        self.options = [NSArray arrayWithObjects:
                        @"Downstream A (Blue)",
                        @"Downstream B (Red)",
                        @"Downstream C (Green)",
                        @"Downstream D (Yellow)",
                        @"Downstream E (Black)",
                        nil];
    } else if ([self.type isEqual: @"PWG"]) {
        self.options = [NSArray arrayWithObjects:
                        @"ATS24.1",
                        @"ATS24.2",
                        @"ATS24.3",
                        @"ATS24.4",
                        @"ATS24.5",
                        @"ATS24.6",
                        @"ATS24.7",
                        @"ATS24.8",
                        @"ATS24.9",
                        @"ATS24.10",
                        @"ATS24.12",
                        @"ATS24.12",
                        @"ATS24.13",
                        @"ATS24.14",
                        @"ATS24.15",
                        @"ATS24.16",
                        @"ATS24.17",
                        @"ATS24.18",
                        @"ATS24.19",
                        @"ATS24.20",
                        @"ATS24.21",
                        @"ATS24.22",
                        @"ATS24.23",
                        @"ATS24.24",
                        @"ATS24*.1",
                        @"ATS24*.2",
                        @"ATS24*.3",
                        @"ATS24*.4",
                        @"ATS24*.5",
                        @"ATS24*.6",
                        @"ATS24*.7",
                        @"ATS24*.8",
                        @"ATS24*.9",
                        @"ATS24*.10",
                        @"ATS24*.12",
                        @"ATS24*.12",
                        @"ATS24*.13",
                        @"ATS24*.14",
                        @"ATS24*.15",
                        @"ATS24*.16",
                        @"ATS24*.17",
                        @"ATS24*.18",
                        @"ATS24*.19",
                        @"ATS24*.20",
                        @"ATS24*.21",
                        @"ATS24*.22",
                        @"ATS24*.23",
                        @"ATS24*.24",
                        @"ATS26.1",
                        @"ATS26.2",
                        @"ATS26.3",
                        @"ATS26.4",
                        @"ATS26.5",
                        @"ATS26.6",
                        @"ATS26.7",
                        @"ATS26.8",
                        @"ATS26.9",
                        @"ATS26.10",
                        @"ATS26.12",
                        @"ATS26.12",
                        @"ATS26.13",
                        @"ATS26.14",
                        @"ATS26.15",
                        @"ATS26.16",
                        @"ATS26.17",
                        @"ATS26.18",
                        @"ATS26.19",
                        @"ATS26.20",
                        @"ATS26.21",
                        @"ATS26.22",
                        @"ATS26.23",
                        @"ATS26.24",
                        @"ATS26.25",
                        @"ATS26.26",
                        @"ProfA0100",
                        @"ProfA0150",
                        @"ProfA0200",
                        @"ProfA0300",
                        @"ProfA0450",
                        @"ProfA0600",
                        @"ProfA0720",
                        @"ProfA0870",
                        @"ProfA1020",
                        @"ProfA1170",
                        @"ProfB0720",
                        @"ProfB072025",
                        @"ProfB072050",
                        @"ProfB072075",
                        @"ISO2678.1",
                        @"ISO2678.2",
                        @"ISO2678.3",
                        @"ISO2678.4",
                        @"ISO2678.5",
                        @"ISO2678.6",
                        @"ISO2678.7",
                        @"ISO2678.8",
                        @"ISO2678.9",
                        @"ISO2678.10",
                        @"ISO2678.11",
                        @"ISO2678.12",
                        @"ISO2678.13",
                        nil];
    } else {
        [NSException raise:@"Invalid Popover Type" format:@"An invalid popover type was used... [OptionsTableViewController.m]"];
    }
    
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
