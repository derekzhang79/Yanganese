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
#import "Quiz.h"

#define kRowHeight 75

@interface YNGASelectViewController ()

@end

@implementation YNGASelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.rowHeight = kRowHeight;
    
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
    return _quizzes.count;
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
}

@end
