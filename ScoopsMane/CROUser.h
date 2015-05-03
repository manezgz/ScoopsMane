//
//  CROUser.h
//  ScoopsMane
//
//  Created by Jose Manuel Franco on 2/5/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CROUser : NSObject

@property(strong,nonatomic) NSString *azureToken;
@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSString *gender;
@property(strong,nonatomic) NSURL *urlProfileImage;

@end
