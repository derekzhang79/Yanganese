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
#import "YNGAAlertView.h"
#import "Quiz.h"
#import "Question.h"
#import "Score.h"
#import "CategoryScore.h"

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
            else
                button.alpha = answerHidden ? 0.0 : 1.0;
        }
        if(answerHidden) {
            self.answerLabel.text = [question answerText];
            
            self.answerLabel.transform = translateDown;
            self.answerLabel.alpha = 1.0;
            lastButton.transform = translations[lastButtonTag - 1];
        }
        else {
            self.answerLabel.text = @"";
            
            self.answerLabel.transform = translateOriginal;
            self.answerLabel.alpha = 0.0;
            lastButton.transform = translateOriginal;
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
    NSEntityDescription *catScoreEntity = [NSEntityDescription entityForName:@"CategoryScore" inManagedObjectContext:context];
    
    // Load global scores    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *noQuiz = [NSPredicate predicateWithFormat:@"quiz == nil"];
    [request setEntity:entity];
    [request setPredicate:noQuiz];
    [request setFetchLimit:1];
    
    NSError *fetchError;
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&fetchError];
    
    Score *globalScore = [fetchedObjects lastObject];
    BOOL newGlobal = NO;

    if(globalScore == nil)
    {
        newGlobal = YES;
        globalScore = [[Score alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    }
    
    // Load quiz score
    Score *quizScore = self.quiz.score;
    BOOL newScore = NO;
    
    if(quizScore == nil)
    {
        newScore = YES;
        quizScore = [[Score alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
        self.quiz.score = quizScore;
    }
    
    // Update counts
    for(int i = 0; i < kCategoryCount; i++)
    {
        NSInteger count = correctCount[i];
        NSInteger total = questionTotal[i];
        
        CategoryScore *quizCatScore;
        if(newScore)
        {
            quizCatScore = [[CategoryScore alloc] initWithEntity:catScoreEntity insertIntoManagedObjectContext:context];
            [quizScore addCategoryScoresObject:quizCatScore];
        }
        else
            quizCatScore = [quizScore.categoryScores objectAtIndex:i];
        
        quizCatScore.count = [NSNumber numberWithInteger:count];
        quizCatScore.total = [NSNumber numberWithInteger:total];
        
        CategoryScore *globalCatScore;
        if(newGlobal)
        {
            globalCatScore = [[CategoryScore alloc] initWithEntity:catScoreEntity insertIntoManagedObjectContext:context];
            globalCatScore.count = [NSNumber numberWithInteger:count];
            globalCatScore.total = [NSNumber numberWithInteger:count];
            
            [globalScore addCategoryScoresObject:globalCatScore];
        }
        else
        {
            globalCatScore = [globalScore.categoryScores objectAtIndex:i];
            
            globalCatScore.count = [NSNumber numberWithInteger:(count + [globalCatScore.count integerValue])];
            globalCatScore.total = [NSNumber numberWithInteger:(total + [globalCatScore.total integerValue])];
            
        }
    }

    quizScore.timeSecond = [NSNumber numberWithInt:timeSec];
    quizScore.timeMinute = [NSNumber numberWithInt:timeMin];
    
    // Save changes
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
	YNGAAlertView *alertView = [[YNGAAlertView alloc] initWithFrame:CGRectMake(30, 120, 260, 200)];
    alertView.messageLabel.text = @"Quit the current round?\nYour information will be lost.";
    alertView.delegate = self;
    
    [self.view addSubview:alertView];
    [alertView show];
}

- (void)updateTime:(NSTimer *)timer
{
	timeSec++;
	timeMin += timeSec / 60;
	timeSec = timeSec % 60;
    
	[self changeTimeToCurrent];
}

#pragma mark - Alert view delegate

- (void)alertView:(YNGAAlertView *)alertView didDismissWithButtonIndex:(ButtonIndex)buttonIndex
{
    if(buttonIndex == kOKButtonIndex)
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [_timer invalidate];
        
        void(^fade)(void) = ^ {
            for(UIView *view in self.view.subviews)
                view.alpha = 0.0f;
        };
        
        void(^home)(BOOL) = ^(BOOL completion) {
            [self.navigationController popToRootViewControllerAnimated:NO];
        };
        
        [UIView animateWithDuration:kTransitionTime animations:fade completion:home];
    }
}

@end
