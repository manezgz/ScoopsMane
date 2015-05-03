//
//  NewsViewController.m
//  ScoopsMane
//
//  Created by Jose Manuel Franco on 1/5/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import "NewsViewController.h"
#import "AzureHandler.h"

@interface NewsViewController (){
    AzureHandler *azureHandler;
    CROUser *userLogged;
    BOOL inserting;
}

@end

@implementation NewsViewController

-(instancetype) initNewNewsWithUser:(CROUser *)user{
    inserting=YES;
    CRONews *news=[[CRONews alloc]init];
    news.image=[UIImage imageNamed:@"noImage"];

    return [self initWithNews:news andUser:user];
}

-(instancetype) initWithNews:(CRONews *)news andUser:(CROUser *)user{
    if(self==[super initWithNibName:nil
                             bundle:nil]){
        
        _news=news;
        userLogged=user;
        azureHandler=[AzureHandler getInstance];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self syncViewVithModel];
    // Añadimos un gesture recognizer a la foto
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)postNewsModificationEvent{
    //Creamos y enviamos la notificación.
    NSNotification *notification=[NSNotification notificationWithName:(NEWS_CHANGED)
                                                               object:(self)
                                                             userInfo:(@{NEWS_KEY:self.news})];
    [[NSNotificationCenter defaultCenter]postNotification:(notification)];
}

- (IBAction)rateNews:(id)sender {
    if([self.ratingValueView.text isEqualToString:@""]){
        
    }else{
    //Pillamos el rating
        self.news.rating=self.ratingValueView.text;
    [[AzureHandler getInstance]insertRatingWithNews:self.news block:^(CRONews *news) {
        NSLog(@"Noticia actulizada correctamente en Azure");
        //news.image=self.news.image;
        //syncronizamos
        //[self postNewsModificationEvent];
        [self.navigationController popViewControllerAnimated:true];
    }];
    }

}

-(void) syncModelWithView{
    self.news.image=self.imageView.image;
    self.news.title=self.titleView.text;
    self.news.text=self.textView.text;
    self.news.author=userLogged.name;
    NSDate *date = [[NSDate alloc]init];
    self.news.modificationDate=date;
}

-(void) syncViewVithModel{
    self.imageView.image=self.news.image;
    self.titleView.text=self.news.title;
    self.textView.text=self.news.text;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
    self.modificationDateValue.text= [formatter stringFromDate:self.news.modificationDate];
    self.stateValue.text=self.news.state;
}





@end
