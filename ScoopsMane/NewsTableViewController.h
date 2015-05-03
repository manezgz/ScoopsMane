//
//  NewsTableViewController.h
//  ScoopsMane
//
//  Created by Jose Manuel Franco on 2/5/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRONews.h"
#import "CROUser.h"
#define BOOK_SELECTED_CHANGED @"bookSelectedChanged"

@class NewsTableViewController;

@protocol NewsTableViewControllerDelegate <NSObject>

- (void)newsTableViewController:(NewsTableViewController *)tableVC
                    didSelectANews:(CRONews *)news
                       atIndexPath:(NSIndexPath *)indexPath;

@end

@interface NewsTableViewController : UITableViewController<NewsTableViewControllerDelegate>

@property(strong,nonatomic) NSMutableDictionary *dictionaryOfNews;
@property (weak, nonatomic) id<NewsTableViewControllerDelegate> delegate;

-(id)initWithDictionaryOfNews:(NSDictionary*)dictionary
               withStyle:(UITableViewStyle) aStyle
          withUserLogged:(CROUser*)user;

@end
