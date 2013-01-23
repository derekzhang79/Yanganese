//
//  YNGAQuizSelectViewController.m
//  Yanganese
//
//  Created by Michael Yang on 1/23/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGAQuizSelectViewController.h"

#import "YNGAQuizCell.h"
#import "YNGARatingView.h"
#import "Quiz.h"

#define kRowHeight 75.0f

@implementation YNGAQuizSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.rowHeight = kRowHeight;
    self.searchDisplayController.searchResultsTableView.rowHeight = kRowHeight;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ListCellIdentifier = @"Quiz Cell";
    
    YNGAQuizCell *cell = (YNGAQuizCell *)[tableView dequeueReusableCellWithIdentifier:ListCellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"YNGAQuizCell" owner:self options:nil];
		cell = _protoCell;
		self.protoCell = nil;
    }
	
    // Set cell properties
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.nameLabel.highlightedTextColor = [UIColor grayColor];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selectHighlight.png"]];
    
    Quiz *quiz;
    if (tableView == self.searchDisplayController.searchResultsTableView)
        quiz = [self.filteredData objectAtIndex:[indexPath row]];
    else
        quiz = [self.data objectAtIndex:[indexPath row]];
    
    cell.nameLabel.text = quiz.title;
    
    int index = [quiz.categoryID intValue];
    
    if(index > 0)
        cell.iconView.image = [self.categoryImages objectAtIndex:index - 1];
    cell.authorLabel.text = quiz.author;
    cell.ratingView.rating = [quiz.rating floatValue];
    
    return cell;
}

@end
