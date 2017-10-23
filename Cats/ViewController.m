//
//  ViewController.m
//  Cats
//
//  Created by Olga on 10/23/17.
//  Copyright © 2017 Olga Nesterova. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *dataUrl = @"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&nojsoncallback=1&api_key=b066df57d7b11069504a3b0819a67999&tags=cat";
    NSURL *url = [NSURL URLWithString:dataUrl];

    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest
                                                completionHandler:^(NSData *_Nullable data,
                                                                    NSURLResponse *_Nullable response,
                                                                    NSError *_Nullable error) {
       

        if (error) {
            NSLog(@"Error getting data");
        } else {
            NSLog(@"RESPONSE: %@", response);
            NSLog(@"DATA: %@", data);
            
            NSError *jsonError = nil;
            NSDictionary *readDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            NSDictionary *secondDict = readDict.allValues[1];
            
            if (jsonError) {
                NSLog(@"jsonError: %@", jsonError.localizedDescription);
            } else {
                 NSLog(@"There are: %lu objects in readDict", (unsigned long)secondDict.count);
                
                NSArray *photosArray = [secondDict objectForKey:@"photo"];
                NSLog(@"photosArray contains %lu objects", photosArray.count);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        }
        
    }];
    
     [dataTask resume];
}





@end
