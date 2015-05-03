//
//  LoginController.m
//  ScoopsMane
//
//  Created by Jose Manuel Franco on 1/5/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import "LoginController.h"
#import "AzureHandler.h"
#import "CROUser.h"
#import "NewsTableViewController.h"

@interface LoginController (){
    NSString *userFBId;
    NSString *tokenFB;
    MSClient * client;
    CROUser *userLogged;
    NSMutableArray *booksPublished;
    NSMutableDictionary *dictionary;
}

@end

@implementation LoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    client=[[AzureHandler getInstance]client];
    self.fbButton.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(loginFB:)];
    [self.fbButton addGestureRecognizer:tap];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)isender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)loginFB:(id) sender{
    
    NSLog(@"Login FB");
    [self loginAppInViewController:self withCompletion:^(CROUser *user) {
        
        NSLog(@"Login en facebook correcto");
        
        //Sincronizamos vistas navigation con los datos de FB
        userLogged=user;
        UIImage *image=[UIImage imageWithData:[NSData dataWithContentsOfURL:userLogged.urlProfileImage ]];
        
        image=[self imageResize:image andResizeTo:CGSizeMake(40, 40)];
        UIImageView *imageView=[[UIImageView alloc]initWithImage:image];
        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
        imageView.clipsToBounds = YES;
        self.navigationItem.titleView=imageView;
        
        //Tenemos que ir a azure a que nos traiga todas las noticias que tiene creadas este usuario
        MSTable *newsTable=[client tableWithName:@"NEWS"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"state == %@",@"Published"];
        
        //Inicializo los objectos
        booksPublished=[[NSMutableArray alloc]init];
        dictionary=[[NSMutableDictionary alloc]init];
        
        [newsTable readWithPredicate:predicate completion:^(NSArray *items, NSInteger totalCount, NSError *error) {
            NSLog(@"Respuesta de Azure correcta %@",items);
            //Transformar el diccionario a modelo
            if(error) {
                NSLog(@"ERROR %@", error);
            } else {
                for(NSDictionary *item in items) {
                    CRONews *news=[[CRONews alloc]init];
                    news.author=[item objectForKey:@"author"];
                    news.title=[item objectForKey:@"title"];
                    news.text=[item objectForKey:@"texto"];
                    news.idAzure=[item objectForKey:@"id"];
                    news.modificationDate=[item objectForKey:@"modificationDate"];
                    news.state=[item objectForKey:@"state"];
                    [[AzureHandler getInstance]getImageFromAzureWithNote:news];
                    [self addNews:news];
                }
                
                [dictionary setObject:booksPublished forKey:@"Published"];
                
                NewsTableViewController *tableVC=[[NewsTableViewController alloc]initWithDictionaryOfNews:dictionary
                                                                                           withStyle:UITableViewStylePlain
                                                                                      withUserLogged:(userLogged)];
                [self.navigationController pushViewController:tableVC
                                                     animated:true];
                
                            }
            
        }];
        
        
        //ModeController *modeVC=[[ModeController alloc]initWithNibName:nil
                                                              // bundle:nil];
        //[self.navigationController pushViewController:modeVC animated:true];
    }];

    
}

-(void) addNews:(CRONews*)news{
    [booksPublished addObject:news];
}

-(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen]scale];
    /*You can remove the below comment if you dont want to scale the image in retina   device .Dont forget to comment UIGraphicsBeginImageContextWithOptions*/
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)loginAppInViewController:(UIViewController *)controller withCompletion:(completeBlock)block{
    
    [self loadUserAuthInfo];
    
    [client loginWithProvider:@"facebook"
                   controller:controller
                     animated:YES
                   completion:^(MSUser *user, NSError *error) {
                       
                       if (error) {
                           NSLog(@"Error en el login : %@", error);
                           block(nil);
                       } else {
                           CROUser *userApp=[[CROUser alloc]init];
                           userApp.azureToken=user.mobileServiceAuthenticationToken;
                           //[self saveAuthInfo];
                           [client invokeAPI:@"getuserinfoauthprovider" body:nil HTTPMethod:@"GET" parameters:nil headers:nil completion:^(id result, NSHTTPURLResponse *response, NSError *error) {
                               
                               //tenemos info extra del usuario
                               //tenemos info extra del usuario
                               NSLog(@"Prueba %@", result);
                               //tenemos info extra del usuario
                               userApp.urlProfileImage=[NSURL URLWithString:result[@"picture"][@"data"][@"url"]];
                               userApp.name=result[@"name"];
                               userApp.gender=result[@"gender"];

                               //self.profilePicture = [NSURL URLWithString:result[@"picture"][@"data"][@"url"]];
                               block(userApp);
                           }];
                           
                                                  }
                   }];
    
}

- (BOOL)loadUserAuthInfo{
    
    userFBId = @"858249040889793";
    tokenFB = @"16f70d507f483cd5c456c67fdb129dd4";
    
    if (userFBId) {
        client.currentUser = [[MSUser alloc]initWithUserId:userFBId];
        client.currentUser.mobileServiceAuthenticationToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"tokenFB"];
        
        
        
        return TRUE;
    }
    
    return FALSE;
}


@end
