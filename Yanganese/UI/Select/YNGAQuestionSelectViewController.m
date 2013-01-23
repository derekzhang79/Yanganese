//
//  YNGAQuestionSelectViewController.m
//  Yanganese
//
//  Created by Michael Yang on 1/23/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGAQuestionSelectViewController.h"

#import "YNGAQuestionCell.h"
#import "Question.h"

#define kRowHeight 120.0f

@implementation YNGAQuestionSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = kRowHeight;
    self.searchDisplayController.searchResultsTableView.rowHeight = kRowHeight;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ListCellIdentifier = @"Question Cell";
    
    YNGAQuestionCell *cell = (YNGAQuestionCell *)[tableView dequeueReusableCellWithIdentifier:ListCellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"YNGAQuestionCell" owner:self options:nil];
		cell = _protoCell;
		self.protoCell = nil;
    }
	
    // Set cell properties
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selectHighlight.png"]];
    
    Question *question;
    if (tableView == self.searchDisplayController.searchResultsTableView)
        question = [self.filteredData objectAtIndex:[indexPath row]];
    else
        question = [self.data objectAtIndex:[indexPath row]];
    
    cell.textLabel.text = question.text;
    
    for(UILabel *label in cell.optionLabels)
    {
        NSString *value = [question valueForKey:[NSString stringWithFormat:@"%c", ('w' + label.tag - 1)]];
        label.text = value;
    }
    
    int index = [question.categoryID intValue];
    
    if(index > 0)
        cell.iconView.image = [self.categoryImages objectAtIndex:index - 1];
    
    return cell;
}

@end
