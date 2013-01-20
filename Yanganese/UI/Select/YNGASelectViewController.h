//
//  YNGASelectViewController.h
//  Yanganese
//
//  Created by Michael Yang on 1/13/13.
//  Copyright (c) 2013 Michael Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YNGAQuizCell;
@class YNGATableNotificationView;

@interface YNGASelectViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>
{
    NSArray *categoryImages;
}

@property (weak, nonatomic) IBOutlet YNGAQuizCell *protoCell;
@property (strong, nonatomic) IBOutlet YNGATableNotificationView *notificationView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, retain) NSMutableArray *quizzes;
@property (nonatomic, retain) NSMutableArray *filteredQuizzes;
@property (nonatomic, retain) NSString *emptyMessage;

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope;

@end
