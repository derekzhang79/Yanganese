//
//  YNGAReviewQuestionViewController.m
//  Yanganese
//
//  Created by Michael Yang on 1/14/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGAReviewQuestionViewController.h"

#import "YNGAScrollView.h"
#import "Quiz.h"
#import "Question.h"

@interface YNGAReviewQuestionViewController ()

- (void)refreshTitle;
- (void)loadScrollViewWithPage:(int)page;

@end

@implementation YNGAReviewQuestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	answerHidden = YES;
	
    categories = @[@"Astro", @"Bio", @"Chem", @"Earth", @"Gen", @"Math", @"Phys"];
    
	[self loadScrollViewWithPage:_questionScroll.page];

	[self refreshTitle];
}

#pragma mark -

- (IBAction)show
{
	[_toggleButton setTitle:(answerHidden ? @"Hide" : @"Show") forState:UIControlStateNormal];
	
	[UIView animateWithDuration:kTransitionTime animations:^ {
        if(answerHidden) {
            Question *question = [self.quiz.questions objectAtIndex:_questionScroll.page];
            self.answerLabel.text = [question answerText];
            self.answerLabel.transform = translateDown;
            self.answerLabel.alpha = 1.0;
        }
        else
        {
            self.answerLabel.text = @"";
            self.answerLabel.transform = translateOriginal;
            self.answerLabel.alpha = 0.0;
        }
	}];
	
	answerHidden = !answerHidden;
}

- (void)refreshTitle
{
	NSString *titleString = [[NSString alloc] initWithFormat:@"Question %d", _questionScroll.page + 1];
	self.title = titleString;
	
    Question *question = [self.quiz.questions objectAtIndex:_questionScroll.page];
    
	self.numberLabel.text = [categories objectAtIndex:([question.categoryID intValue] - 1)];
}

- (void)loadScrollViewWithPage:(int)page {
	NSUInteger prevPage, nextPage;
    Question *prev, *curr, *next;
    
    if(page != 0)
		prevPage = page - 1;
	else
		prevPage = [self.quiz.questions count] - 1;
    prev = [self.quiz.questions objectAtIndex:prevPage];
	_questionScroll.prev.text = [prev fullText];
    
	if(page != [self.quiz.questions count] - 1)
		nextPage = page + 1;
	else
		nextPage = 0;
    next = [self.quiz.questions objectAtIndex:nextPage];
    _questionScroll.next.text = [next fullText];
    
	_questionScroll.page = page;
	curr = [self.quiz.questions objectAtIndex:page];
    _questionScroll.curr.text = [curr fullText];
}

#pragma mark - Scroll view delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
	if(_questionScroll.contentOffset.x > _questionScroll.frame.size.width)
		[self loadScrollViewWithPage:(_questionScroll.page >= ([self.quiz.questions count] - 1) ? 0 : (_questionScroll.page + 1))];
	else if(_questionScroll.contentOffset.x < _questionScroll.frame.size.width)
		[self loadScrollViewWithPage:(_questionScroll.page <= 0 ? ([self.quiz.questions count] - 1) : (_questionScroll.page - 1))];
    
	[_questionScroll scrollToMiddle];
	
	[self refreshTitle];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if(!answerHidden)
		[self show];
}

@end
