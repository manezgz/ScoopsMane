//
//  AzureHandler.m
//  ScoopsMane
//
//  Created by Jose Manuel Franco on 27/4/15.
//  Copyright (c) 2015 Jose Manuel Franco. All rights reserved.
//

#import "AzureHandler.h"


@interface AzureHandler ()<NSURLConnectionDelegate> {
    NSMutableData * _receivedData;
}

@end

@implementation AzureHandler

static  AzureHandler *inst = nil;

+(AzureHandler *) getInstance{
    
    @synchronized(self){
        if (!inst) {
            inst = [[self alloc] init];
        }
    }
    return inst;
}

-(id)init{
    _client= _client= [MSClient clientWithApplicationURLString:@"https://scoopsmanekeppcoding.azure-mobile.net/"
                                                applicationKey:@"xrQyUTQkxcsoWLOmxjVtKFLDAaonGk29"];

    // crear instacia de MSTable para persistir en tabla
    _newsTable = [self.client tableWithName:@"NEWS"];
    _ratingTable = [self.client tableWithName:@"RATINGS"];
    
    return self;
}




-(void)uploadNewsToAzureWithNews:(CRONews*)news
                           block:(void (^)(CRONews* newsSync))completionBlock{

    
        
        //Crear diccionario from CRONews
        NSDictionary *newsDict = @{@"nombre":news.author,
                                 @"author":news.author,
                                 @"containerName":@"scoopmane",
                                 @"title":news.title,
                                 @"modificationDate":news.modificationDate,
                                 @"texto":news.text};
        
        //Subimos a azure
        [self.newsTable insert: newsDict
                    completion:^(NSDictionary *item, NSError *error) {
            
                        if (!error) {
                            NSLog(@"El resultado de la insercion es : %@", item);
                            [self syncNews:news WithDictionary:item];
                            // ahora subimos la imagen al container
                            [self postBlobWithNews:news
                                             block:^(NSError *err) {
                                                    NSLog(@"ultimo comletion block");
                                                     completionBlock(news);
                                             }
                             ];
                        } else {
                            NSLog(@"Error --> %@", error);
                        }
                    }
         ];

}

-(void)insertRatingWithNews:(CRONews*)news block:(void (^)(CRONews* news))completionBlock{
    //Crear diccionario from CRONews
    NSDictionary *newsDict = @{@"newsid":news.idAzure,
                               @"rating":news.rating};
    
    //Subimos a azure
    [self.ratingTable insert:newsDict
                completion:^(NSDictionary *item, NSError *error) {
                    
                    if (!error) {
                        NSLog(@"El resultado de la insercion es : %@", item);
                        completionBlock(nil);
                    } else {
                        NSLog(@"Error --> %@", error);
                    }
                }
     ];
}


-(void)updateNewsToAzureWithNews:(CRONews*)news block:(void (^)(CRONews* news))completionBlock{
    //Crear diccionario from CRONews
    NSDictionary *newsDict = @{@"id":news.idAzure,
                               @"nombre":news.author,
                               @"author":news.author,
                               @"containerName":@"scoopmane",
                               @"title":news.title,
                               @"modificationDate":news.modificationDate,
                               @"texto":news.text,
                               @"state":news.state};
    
    //Subimos a azure
    [self.newsTable update:newsDict
                completion:^(NSDictionary *item, NSError *error) {
                    
                    if (!error) {
                        NSLog(@"El resultado de la insercion es : %@", item);
                        [self syncNews:news WithDictionary:item];
                        //Tenemos que actualizar la imagen si es que ha cambiado
                         completionBlock(news);
                    } else {
                        NSLog(@"Error --> %@", error);
                    }
                }
     ];
}

-(void) syncNews:(CRONews*)news
  WithDictionary:(NSDictionary*)dict{
    news.idAzure=[dict objectForKey:@"id"];
    news.state=[dict objectForKey:@"state"];
    news.rating=[dict objectForKey:@"rating"];
    news.blobContainer=[dict objectForKey:@"containerName"];
    news.modificationDate=[dict objectForKey:@"modificationDate"];
}

- (void) getSasUrlForNewBlob:(NSString *)blobName forContainer:(NSString *)containerName block:(void (^)(NSString* sasUrl))completionBlock{
    NSDictionary *item = @{  };
    NSDictionary *params = @{ @"containerName" : containerName, @"blobName" : blobName };
    MSTable *blobTable = [self.client tableWithName:@"BlobBlobs"];
    
    [blobTable insert:item parameters:params completion:^(NSDictionary *item, NSError *error) {
        NSLog(@"Item: %@", item);
        completionBlock([item objectForKey:@"sasUrl"]);
    }];
}


#pragma mark - Blobs

- (void)postBlobWithNews:(CRONews *)news block:(void (^)(NSError *err))completionBlock{
    [self getSasUrlForNewBlob:news.idAzure
                 forContainer:news.blobContainer
                        block:^(NSString *sasUrl) {
                            NSData *imageData=UIImageJPEGRepresentation(news.image, 0.9);
                            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:sasUrl]];
                            [request setHTTPMethod:@"PUT"];
                            [request addValue:@"image/jpeg" forHTTPHeaderField:@"Content-Type"];
                            [request setHTTPBody:imageData];
                            [[NSURLConnection alloc] initWithRequest:request delegate:self];
                            _receivedData = [[NSMutableData alloc] init];
                            [_receivedData setLength:0];
                            completionBlock(nil);
                        }
     ];
}

-(void) getImageFromAzureWithNote:(CRONews*)news{
    NSString *path=@"https://keepcodingbymane.blob.core.windows.net/scoopmane/";
    path=[path stringByAppendingString:news.idAzure];
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    news.image=img;
    
}

#pragma NSUrlConnectionDelegate Methods

-(void)connection:(NSConnection*)conn didReceiveResponse:
(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if ([httpResponse statusCode] >= 400) {
        NSLog(@"Status Code: %li", (long)[httpResponse statusCode]);
        NSLog(@"Remote url returned error %ld %@",(long)[httpResponse statusCode],[NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]);
    }
    else {
        NSLog(@"Safe Response Code: %li", (long)[httpResponse statusCode]);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:
(NSData *)data
{
    [_receivedData appendData:data];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:
(NSError *)error
{
    //We should do something more with the error handling here
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:
           NSURLErrorFailingURLStringErrorKey]);
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSLog(@"Terminado...");
    
}


@end
