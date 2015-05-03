//
//  LoginController.h
//  ScoopsMane
//
//  Created by Jose Manuel Franco on 1/5/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CROUser.h"

typedef void (^completeBlock)(CROUser* user);

@interface LoginController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *fbButton;

@end
