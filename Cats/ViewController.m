//
//  ViewController.m
//  Cats
//
//  Created by Olga on 10/23/17.
//  Copyright © 2017 Olga Nesterova. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

//@property (nonatomic, strong) NSArray *readPhotosArray;
@property (nonatomic, strong) NSMutableArray *allPhotos;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *allPhotos = [NSMutableArray new];
    [self getCatPictures];
    
    
}

-(void)getCatPictures {
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
                                                            
                                                            //Array of dictionaries
                                                            NSArray *readPhotosArray = [secondDict objectForKey:@"photo"];
                                                            NSLog(@"photosArray contains %lu objects", readPhotosArray.count);
                                                            
                                                            if (!self.allPhotos) {
                                                                self.allPhotos = [NSMutableArray new];
                                                            }
                                                            
                                                            for (NSDictionary *object in readPhotosArray) {
                                                                
                                                                //create url from pieces
                                                                
                                                                NSString *farmID = [object objectForKey:@"farm"];
                                                                NSString *serverID = [object objectForKey:@"server"];
                                                                NSString *objectID = [object objectForKey:@"id"];
                                                                NSString *secret = [object objectForKey:@"secret"];
                                                                
                                                                NSString *stringUrl = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg", farmID, serverID, objectID, secret];
                                                                
                                                                NSURL *url = [NSURL URLWithString:stringUrl];
                                                            //    NSLog(@"URL created: %@", url);
                                                                
                                                                //get title
                                                                NSString *objectTitle = [object objectForKey:@"title"];
                                                                //instantiate Photo
                                                                Photo *photo = [[Photo alloc]initWithPhotoURL:url andTitle:objectTitle];
                                                                //add to array
                                                                [self.allPhotos addObject:photo];
                                                                NSLog(@"There are %lu objects in allPhotos array", self.allPhotos.count);
                                                               
                                                            }
                                                        }
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                        });
                                                    }
                                                }];
    [dataTask resume];
}


@end
