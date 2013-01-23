//
//  YNGASelectViewController.m
//  Yanganese
//
//  Created by Michael Yang on 1/13/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGASelectViewController.h"

#import "YNGAQuizCell.h"
#import "YNGARatingView.h"
#import "YNGATableNotificationView.h"
#import "Quiz.h"

#define kRowHeight 75

@interface YNGASelectViewController ()

- (void)animateBack;

@end

@implementation YNGASelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.rowHeight = kRowHeight;
    self.tableView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    self.tableView.alpha = 0.0;
    
    self.searchDisplayController.searchResultsTableView.rowHeight = kRowHeight;
    self.searchDisplayController.searchResultsTableView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // Allow editing
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    // Load and add notification view
    [[NSBundle mainBundle] loadNibNamed:@"YNGATableNotificationView" owner:self options:nil];

    _notificationView.frame  = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y + 100, _notificationView.frame.size.width, _notificationView.frame.size.height);
    _notificationView.hidden = YES;

    [self.tableView addSubview:_notificationView];

    // Initialize categories and corresponding images
    NSArray *categories = @[@"astro", @"bio", @"chem", @"earth", @"gen", @"math", @"phys"];
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:categories.count];
    for(NSString *category in categories)
    {
        UIImage *categoryImage = [UIImage imageNamed:[category stringByAppendingPathExtension:@"png"]];
        if(categoryImage != nil)
            [temp addObject:categoryImage];
        
    }
    categoryImages = [[NSArray alloc] initWithArray:temp];
    
    // Initialize filtered search array
    self.filteredData = [NSMutableArray arrayWithCapacity:self.data.count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
	[UIView animateWithDuration:kTransitionTime animations:^{
        self.tableView.alpha = 1.0;
    }];
    
	[super viewWillAppear:animated];
}

#pragma mark -

- (void)animateBack
{
	[self.navigationController setNavigationBarHidden:YES animated:YES];
    
    void(^fadeTable)(void) = ^(void) {
        self.tableView.alpha = 0.0;
    };
    
    void(^popController)(BOOL) = ^(BOOL completed) {
        [self.navigationController popViewControllerAnimated:NO];
    };

    [UIView animateWithDuration:kTransitionTime animations:fadeTable completion:popController];
}

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    [_filteredData removeAllObjects];
    
    NSPredicate *matchTitle = [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@", searchText];
    self.filteredData = [NSMutableArray arrayWithArray:[_data filteredArrayUsingPredicate:matchTitle]];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.searchDisplayController.searchResultsTableView)
        return _filteredData.count;
    
    NSInteger count = _data.count;
    
    if(count == 0)
    {
        _notificationView.textView.text = _emptyMessage;
        _notificationView.imageView.image = [UIImage imageNamed:@"zero.png"];
        _notificationView.hidden = NO;
    }

    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ListCellIdentifier = @"List Cell";
    
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
        quiz = [_filteredData objectAtIndex:[indexPath row]];
    else
        quiz = [_data objectAtIndex:[indexPath row]];
    
    cell.nameLabel.text = quiz.title;
    
    int index = [quiz.categoryID intValue];

    if(index > 0)
        cell.iconView.image = [categoryImages objectAtIndex:index - 1];
    cell.authorLabel.text = quiz.author;
    cell.ratingView.rating = [quiz.rating floatValue];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Search display delegate

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:
    [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];

    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];

    return YES;
}

@end
