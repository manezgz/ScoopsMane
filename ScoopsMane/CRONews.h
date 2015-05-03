//
//  CRONews.h
//  ScoopsMane
//
//  Created by Jose Manuel Franco on 27/4/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface CRONews : NSObject

@property (strong,nonatomic) NSString *idAzure;
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *text;
@property (strong,nonatomic) NSString *author;
@property (strong,nonatomic) NSString *blobContainer;
@property (strong,nonatomic) NSDate *modificationDate;
@property (strong,nonatomic) NSString *publishedDate;
@property (strong,nonatomic) NSString *state;
@property (strong,nonatomic) NSString *rating;
@property (strong,nonatomic) UIImage *image;

@end
