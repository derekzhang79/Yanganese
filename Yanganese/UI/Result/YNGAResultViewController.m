//
//  YNGAResultViewController.m
//  Yanganese
//
//  Created by Michael Yang on 1/13/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGAResultViewController.h"

#import "Quiz.h"
#import "Score.h"
#import <QuartzCore/QuartzCore.h>

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
    
	NSUInteger intScore = 0;
    for(NSNumber *catScore in _score.counts)
        intScore += [catScore integerValue];
    _scoreLabel.text = [NSString stringWithFormat:@"Score: %d", intScore];
    
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
    NSUInteger total = [[_score.totals objectAtIndex:[indexPath row]] integerValue];
    if(total <= 0)
        cell.detailTextLabel.textColor = [UIColor clearColor];
    else
    {
        float count = [[_score.counts objectAtIndex:[indexPath row]] floatValue];
        float percent = count / total * 100;
        cell.detailTextLabel.textColor = [UIColor whiteColor];
		NSString *label = [NSString stringWithFormat:@"%.2f%%", percent];
		cell.detailTextLabel.text = label;
    }
    
	return cell;
}

@end
