//
//  AppDelegate.m
//  ScoopsMane
//
//  Created by Jose Manuel Franco on 26/4/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import "WindowsAzureMobileServices/WindowsAzureMobileServices.h"
#import "AppDelegate.h"
#import "AzureHandler.h"
#import "LoginController.h"
#import "NewsViewController.h"

@interface AppDelegate ()<NSURLConnectionDelegate> {
    NSMutableData * _receivedData;
    NSMutableArray *model;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    MSClient *client=[MSClient clientWithApplicationURL:[NSURL URLWithString:@"https://scoopsmanekeppcoding.azure-mobile.net/"]
//                                         applicationKey:@"xrQyUTQkxcsoWLOmxjVtKFLDAaonGk29"];
//    
//    NSLog(@"MSCLIENT  info %@",client.description);
//    
//    MSTable *table=[client tableWithName:@"NEWS"];
//    
//    NSDictionary *noticia=@{@"title":@"Noticia test"};
//    
//    [table insert:noticia completion:^(NSDictionary *item, NSError *error) {
//        if(error){
//            NSLog(@"Error %@",error);
//        }else{
//            NSLog(@"Insercion realizada con exito %@",item.description);
//        }
//    }];
    
    CRONews *news=[[CRONews alloc]init];
    news.author=@"Mane";
    news.title=@"Titulo";
    news.text=@"Texto";
   
    //NewsViewController *controller=[[NewsViewController alloc]initNewNews];
    
    LoginController *loginVC=[[LoginController alloc]initWithNibName:nil
                                                              bundle:nil];
    
    //CREAMOS NAVIGATION CONTROLLER
    UINavigationController *navVC=[[UINavigationController alloc]initWithRootViewController:loginVC];
    
    
    self.window.rootViewController = navVC;
    //AzureHandler *azureHandler=[AzureHandler getInstance];
    
    //[azureHandler uploadNewsToAzureWithNews:news
    //                                  block:^(CRONews *news) {
    //    NSLog(@"FINALIZO EN APPDELEGATE");
    //}];
    
    [self.window makeKeyAndVisible];
    return YES;
}

//- (void) getSasUrlForNewBlob:(NSString *)blobName forContainer:(NSString *)containerName withCompletion:(CompletionWithSasBlock) completion {
//    NSDictionary *item = @{  };
//    NSDictionary *params = @{ @"containerName" : containerName, @"blobName" : blobName };
//    MSTable *blobTable = [self.client tableWithName:@"BlobBlobs"];
//    
//    [blobTable insert:item parameters:params completion:^(NSDictionary *item, NSError *error) {
//        NSLog(@"Item: %@", item);
//        
//        completion([item objectForKey:@"sasUrl"]);
//    }];
//}
//
//
//#pragma mark - Blobs
//
//- (void)postBlobWithUrl:(NSString *)sasUrl {
//    [self getSasUrlForNewBlob:@"image.jpg"
//                    forContainer:@"scoopmane"
//                  withCompletion:^(NSString *sasUrl) {
//                      NSData *imageData=UIImageJPEGRepresentation([UIImage imageNamed:@"1601118_10154107430985232_5173404889896842031_n.jpg"], 0.9);
//                      
//                      NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:sasUrl]];
//                      [request setHTTPMethod:@"PUT"];
//                      [request addValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
//                      [request setHTTPBody:imageData];
//                      NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//                      _receivedData = [[NSMutableData alloc] init];
//                      [_receivedData setLength:0];
//
//                  }];
//    
//   }
//
//#pragma NSUrlConnectionDelegate Methods
//
//-(void)connection:(NSConnection*)conn didReceiveResponse:
//(NSURLResponse *)response
//{
//    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//    if ([httpResponse statusCode] >= 400) {
//        NSLog(@"Status Code: %li", (long)[httpResponse statusCode]);
//        NSLog(@"Remote url returned error %ld %@",(long)[httpResponse statusCode],[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
//    }
//    else {
//        NSLog(@"Safe Response Code: %li", (long)[httpResponse statusCode]);
//    }
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:
//(NSData *)data
//{
//    [_receivedData appendData:data];
//    
//}
//
//- (void)connection:(NSURLConnection *)connection didFailWithError:
//(NSError *)error
//{
//    //We should do something more with the error handling here
//    NSLog(@"Connection failed! Error - %@ %@",
//          [error localizedDescription],
//          [[error userInfo] objectForKey:
//           NSURLErrorFailingURLStringErrorKey]);
//    
//}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    
//    NSLog(@"Terminado...");
//    
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
