//
//  DetailViewController.m
//  Cats
//
//  Created by Olga on 10/24/17.
//  Copyright © 2017 Olga Nesterova. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

//@property (nonatomic) LocationManager *locationManager;

@end

@implementation DetailViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    [self getPhotoLocationData];
    
    }

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.photo) {
        self.detailTextView.text = [self.photo photoTitle];
        self.detailPhotoView.image = [self.photo image];
    }
}

- (void)setPhoto:(Photo *)photo {
    if (_photo != photo) {
        _photo = photo;
        
        // Update the view.
        [self configureView];
    }
}


-(void)getPhotoLocationData
    {
        NSString *urlString = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.geo.getLocation&api_key=b066df57d7b11069504a3b0819a67999&photo_id=%@&format=json&nojsoncallback=1&", self.photo.photoId];
        
        NSURL *photoURL = [NSURL URLWithString:urlString];
        
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:photoURL];
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *_Nullable data,
                                                                                                     NSURLResponse *_Nullable response,
                                                                                                     NSError *_Nullable error) {
            
            if (error) {
                NSLog(@"Error getting data: %@", error.localizedDescription);
            } else {
                NSLog(@"RESPONSE: %@", response);
                NSLog(@"DATA: %@", data);
                
                NSError *jsonError = nil;
                
                //get all values from top-level Dictionary
                NSDictionary *readDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                NSDictionary *secondDict = readDict.allValues[0];
                
                if (jsonError) {
                    NSLog(@"jsonError: %@", jsonError.localizedDescription);
                } else {
                    
                    //Dictionarie with all photo location Data
                    NSDictionary *locationDataDictionary = secondDict.allValues[1];
                    
                    double lat = [[locationDataDictionary objectForKey:@"latitude"]doubleValue];
                    double lon = [[locationDataDictionary objectForKey:@"longitude"]doubleValue];
                    NSLog(@"Creating coordinates: lat: %f, lon: %f", lat, lon);
                    
                    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(lat, lon);
                    self.photo.coordinate = coordinates;
                    MKCoordinateSpan span = MKCoordinateSpanMake(.5f, .5f);
                    self.detailMapView.region = MKCoordinateRegionMake(self.photo.coordinate, span);
                    
                    MKPointAnnotation *photoAnnotation = [[MKPointAnnotation alloc]init];
                    photoAnnotation.coordinate = coordinates;
                    NSLog(@"Photo title: %@", self.photo.photoTitle);
                    NSString *title = self.photo.photoTitle;
                    [photoAnnotation setTitle:title];
                    NSLog(@"Adding title to annotation: %@", photoAnnotation.title);
                    
                    
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        [self.detailMapView addAnnotation:photoAnnotation];
                    }];
                    
                }
            }
            
        }];
        
        [dataTask resume];
}

@end
