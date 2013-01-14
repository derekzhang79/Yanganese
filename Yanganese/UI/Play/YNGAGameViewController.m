//
//  YNGAGameViewController.m
//  Yanganese
//
//  Created by Michael Yang on 1/13/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import "YNGAGameViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "YNGAAppDelegate.h"
#import "YNGAGameResultViewController.h"
#import "Quiz.h"
#import "Question.h"
#import "Score.h"

#define kXTrans1 83
#define kXTrans2 -82
#define kYTrans1 58
#define kYTrans2 -7

@interface YNGAGameViewController ()

- (void)updateTextView;
- (void)toggleAnswer;
- (void)resetColor;
- (void)exit;
- (void)endRound;
- (void)changeTimeToCurrent;
- (void)changeScoreToCurrent;

@end

@implementation YNGAGameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set title and style
	self.title = @"Quiz";
	_questionView.layer.cornerRadius = kCornerRadius;
	_questionView.font = [UIFont fontWithName:@"Helvetica" size:16];
	
    // Initialize instance variables and labels
	categories = @[@"Astro", @"Bio", @"Chem", @"Earth", @"Gen", @"Math", @"Phys"];
	score = 0;
	timeMin = 0;
	timeSec = 0;
	answerHidden = YES;
	[self changeTimeToCurrent];
	[self changeScoreToCurrent];

    // Initialize transitions
	int x[2] = {kXTrans1, kXTrans2};
	int y[2] = {kYTrans1, kYTrans2};
	for(int i = 0; i < _buttons.count; i++)
		translations[i] = CGAffineTransformMakeTranslation(x[i % 2], y[i / 2]);
    
	// Create and add quit button
	UIBarButtonItem *quit = [[UIBarButtonItem alloc] initWithTitle:@"Quit" style:UIBarButtonItemStyleBordered target:self action:@selector(exit)];
	[self.navigationItem setLeftBarButtonItem:quit];
    
	// Begin timer and start quiz
	self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    questionNumber = 0;
	[self updateTextView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"endGame"])
    {
        YNGAGameResultViewController *resultController = segue.destinationViewController;
        resultController.score = self.quiz.score;
    }
}

#pragma mark -

- (void)updateTextView
{
    question = [self.quiz.questions objectAtIndex:questionNumber];
    
	// Set question details
	self.title = [[NSString alloc] initWithFormat:@"Question %d", (questionNumber + 1)];
	
	// set question type in navigation bar
	self.numberLabel.text = [categories objectAtIndex:[question.categoryID integerValue]];

    _questionView.text = [question fullText];
}

- (IBAction)answer:(id)sender
{
	NSUInteger categoryIndex = [question.categoryID integerValue];

    UIButton *button = (UIButton *)sender;
    lastButtonTag = button.tag;

	NSString *buttonTitle = [sender titleForState:UIControlStateNormal];
    
	if ([buttonTitle isEqualToString:[question.answer uppercaseString]])
    {
		[button setBackgroundImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateDisabled];
		
        score++;
		correctCount[categoryIndex]++;
	}
    else
        [button setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateDisabled];

	[self changeScoreToCurrent];
	
	[self toggleAnswer];

    button.enabled = NO;
	questionTotal[categoryIndex]++;
    questionNumber++;

	[self performSelector:@selector(resetColor) withObject:nil afterDelay:1.5];
}

- (void)toggleAnswer
{
	[UIView animateWithDuration:kTransitionTime animations:^ {
        
        UIButton *lastButton;
        for(UIButton *button in _buttons)
        {
            if(button.tag == lastButtonTag)
                lastButton = button;

            button.alpha = answerHidden ? 0.0 : 1.0;
        }
        if(answerHidden) {
            self.answerLabel.text = [question answerText];
            
            self.answerLabel.transform = translateDown;
            self.answerLabel.alpha = 1.0;
            //lastButton.transform = translations[lastButtonTag - 1];
        }
        else {
            self.answerLabel.text = @"";
            
            self.answerLabel.transform = translateOriginal;
            self.answerLabel.alpha = 0.0;
            //lastButton.transform = translateOriginal;
        }
	}];
	
	answerHidden = !answerHidden;
}

- (void)resetColor
{
    [self toggleAnswer];
    
	for(UIButton *button in _buttons)
        if(button.tag == lastButtonTag)
            button.enabled = YES;
	
	if(questionNumber < self.quiz.questions.count)
		[self updateTextView];
	else
		[self endRound];
	
}

- (void)endRound
{
    YNGAAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Score" inManagedObjectContext:context];

    NSMutableArray *counts = [[NSMutableArray alloc] initWithCapacity:kCategoryCount];
    NSMutableArray *totals = [[NSMutableArray alloc] initWithCapacity:kCategoryCount];
    
    for(int i = 0; i < kCategoryCount; i++)
    {
        [counts addObject:[NSNumber numberWithInt:correctCount[i]]];
        [totals addObject:[NSNumber numberWithInt:questionTotal[i]]];
    }

    Score *quizScore = self.quiz.score;
    
    if(quizScore == nil)
    {
        quizScore = [[Score alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        self.quiz.score = quizScore;
    }
    
    quizScore.counts = counts;
    quizScore.totals = totals;
    
    NSError *contextError;
    [context save:&contextError];
    
    [self performSegueWithIdentifier:@"endGame" sender:self];
}

- (void)changeScoreToCurrent
{
	NSString *newScore = [NSString stringWithFormat:@"Score: %d", score];
	_scoreLabel.text = newScore;
}

- (void)changeTimeToCurrent
{
	NSString *newTime = timeSec < 10 ? [NSString stringWithFormat:@"Time: %d:0%d", timeMin, timeSec] : [NSString stringWithFormat:@"Time: %d:%d", timeMin, timeSec];
	_timeLabel.text = newTime;
}

- (void)exit
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Exiting" message:@"Are you sure you want to quit the current round?\nYour information will be lost."
												   delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
	[alert show];
}

- (void)updateTime:(NSTimer *)timer
{
	timeSec++;
	timeMin += timeSec / 60;
	timeSec = timeSec % 60;
    
	[self changeTimeToCurrent];
}

@end
