//
//  AzureHandler.h
//  ScoopsMane
//
//  Created by Jose Manuel Franco on 27/4/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CRONews.h"
#import "WindowsAzureMobileServices/WindowsAzureMobileServices.h"

@interface AzureHandler : NSObject

@property (strong,nonatomic) MSClient *client;
@property (strong,nonatomic) MSTable *newsTable;
@property (strong,nonatomic) MSTable *ratingTable;

+(AzureHandler *) getInstance;

-(void)uploadNewsToAzureWithNews:(CRONews*)news block:(void (^)(CRONews* news))completionBlock;

-(void)insertRatingWithNews:(CRONews*)news block:(void (^)(CRONews* news))completionBlock;


-(void)updateNewsToAzureWithNews:(CRONews*)news block:(void (^)(CRONews* news))completionBlock;

-(void) getImageFromAzureWithNote:(CRONews*)news;

@end
