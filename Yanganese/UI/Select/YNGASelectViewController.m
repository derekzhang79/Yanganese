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

@end

@implementation YNGASelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.rowHeight = kRowHeight;
    self.tableView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
	
	[super viewWillAppear:animated];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = _quizzes.count;
    
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
    
    Quiz *quiz = [_quizzes objectAtIndex:[indexPath row]];
    cell.nameLabel.text = quiz.title;
    cell.iconView.image = [categoryImages objectAtIndex:[quiz.categoryID intValue]];
    cell.authorLabel.text = quiz.author;
    cell.ratingView.rating = [quiz.rating floatValue];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
