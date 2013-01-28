//
//  YNGAResultViewController.m
//  Yanganese
//
//  Created by Michael Yang on 1/13/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGAResultViewController.h"

#import <QuartzCore/QuartzCore.h>

#import "Quiz.h"
#import "Score.h"
#import "CategoryScore.h"

@interface YNGAResultViewController ()

- (void)animateBack;

@end

@implementation YNGAResultViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Set style
	_scoreLabel.layer.cornerRadius = kCornerRadius;
	_timeLabel.layer.cornerRadius = kCornerRadius / 2;
	_resultTable.layer.cornerRadius = kCornerRadius;
	
	categoryList = @[@"Astro", @"Bio", @"Chem", @"Earth", @"Gen", @"Math", @"Phys"];
    
    [self calcScore];
    
	NSUInteger minutes, seconds;
    minutes = [_score.timeMinute intValue];
    seconds = [_score.timeSecond intValue];
    _timeLabel.text = seconds < 10 ? [NSString stringWithFormat:@"Time: %d:0%d", minutes, seconds] : [NSString stringWithFormat:@"Time: %d:%d", minutes, seconds];
}

#pragma mark -

- (void)animateBack
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    void(^fade)(void) = ^ {
        for(UIView *view in self.view.subviews)
            view.alpha = 0.0;
    };
    
    void(^home)(BOOL) = ^(BOOL completion) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    };
    
    [UIView animateWithDuration:kTransitionTime animations:fade completion:home];
}

- (void)calcScore
{
    NSUInteger intScore = 0;
    for(CategoryScore *catScore in _score.categoryScores)
        intScore += [catScore.count integerValue];
    _scoreLabel.text = [NSString stringWithFormat:@"Score: %d", intScore];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [categoryList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ResultCellIdentifier = @"Result Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ResultCellIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ResultCellIdentifier];
	
	// Initialize cell properties
	cell.textLabel.text = [categoryList objectAtIndex:[indexPath row]];
	cell.textLabel.textColor = [UIColor whiteColor];
	cell.contentView.backgroundColor = [UIColor blackColor];
	cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:16];
	
    // Show percentage if value exists
    if(_score.categoryScores.count == 0)
    {
        cell.detailTextLabel.textColor = [UIColor clearColor];
        return cell;
    }
        
    CategoryScore *catScore = [_score.categoryScores objectAtIndex:[indexPath row]];
    NSUInteger total = [catScore.total integerValue];
    if(total <= 0)
        cell.detailTextLabel.textColor = [UIColor clearColor];
    else
    {
        float count = [catScore.count floatValue];
        float percent = count / total * 100;
        cell.detailTextLabel.textColor = [UIColor whiteColor];
		NSString *label = [NSString stringWithFormat:@"%.2f%%", percent];
		cell.detailTextLabel.text = label;
    }
    
	return cell;
}

@end
