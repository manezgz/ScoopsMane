//
//  NewsViewController.h
//  ScoopsMane
//
//  Created by Jose Manuel Franco on 1/5/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CRONews.h"
#import "CROUser.h"

#define NEWS_CHANGED @"newsChanged"
#define NEWS_KEY @"book"
#define INDEX_PATH_KEY @"indexPath"

@interface NewsViewController : UIViewController

-(instancetype) initNewNewsWithUser:(CROUser*)user;
-(instancetype) initWithNews:(CRONews*)news andUser:(CROUser*)user;

@property (strong,nonatomic) CRONews *news;
@property (weak, nonatomic) IBOutlet UILabel *stateValue;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *titleView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *modificationDateValue;
@property (weak, nonatomic) IBOutlet UITextField *ratingValueView;

@end
