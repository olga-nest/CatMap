//
//  ViewController.m
//  Cats
//
//  Created by Olga on 10/23/17.
//  Copyright © 2017 Olga Nesterova. All rights reserved.
//

#import "ViewController.h"
#import "PhotoCollectionViewCell.h"


@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (strong, nonatomic) UICollectionViewFlowLayout *defaultLayout;
@property (nonatomic, strong) NSMutableArray *allPhotos;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic) NSURL *url;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoCollectionView.delegate = self;
    self.photoCollectionView.dataSource = self;
    
    [self setupDefaultLayout];
    
    self.photoCollectionView.collectionViewLayout = self.defaultLayout;
       
    [self getCatPictures];
    
}


-(NSURL *)constructURL {
    
    NSDictionary *queriesDict = @{@"method" : @"flickr.photos.search",
                              @"api_key" : @"b066df57d7b11069504a3b0819a67999",
                              @"tags" : @"cat",
                              @"has_geo" : @"1",
                              @"extras" : @"url_m",
                              @"format" : @"json",
                              @"nojsoncallback" : @"1"};
    
    NSMutableArray *queries = [NSMutableArray new];
    for (NSString *key in queriesDict) {
        [queries addObject:[NSURLQueryItem queryItemWithName:key value:queriesDict[key]]];
    }
    
    NSURLComponents *components = [NSURLComponents new];
    components.scheme = @"https";
    components.host = @"api.flickr.com";
    components.path = @"/services/rest/";
    components.queryItems = queries;
    
    NSURL *url = components.URL;
    NSLog(@"URL created: %@", url);
    
    return url;
}

-(void)getCatPictures {
    [self.activityIndicator startAnimating];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[self constructURL]];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest
                                                completionHandler:^(NSData *_Nullable data,
                                                                    NSURLResponse *_Nullable response,
                                                                    NSError *_Nullable error) {
                                                    
                                                    if (error) {
                                                        NSLog(@"Error getting data: %@", error.localizedDescription);
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
                                                                
                                                                //get photo id
                                                                //reuse objectID
                                                                
                                                                //get photo location
//                                                                double lon = [[object objectForKey:@"longitude"]integerValue];
//                                                                double lat = [[object objectForKey:@"latitude"]integerValue];
//
//                                                                CLLocationCoordinate2D photoLocation = CLLocationCoordinate2DMake(lat, lon);
//
                                                                //instantiate Photo
                                                                Photo *photo = [[Photo alloc]initWithImage:url andTitle:objectTitle andId:objectID];
//                                                                photo.coordinate = photoLocation;
                                                                
                                                                //add to array
                                                                [self.allPhotos addObject:photo];
                                                                NSLog(@"There are %lu objects in allPhotos array", self.allPhotos.count);
                                                            }
                                                        }
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            //Reload data after data source is updated
                                                            [self.photoCollectionView reloadData];
                                                            [self.activityIndicator stopAnimating];
                                                        });
                                                    }
                                                }];
    [dataTask resume];
    NSLog(@"Resuming dataTask");
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    NSLog(@"Will show %lu items", self.allPhotos.count);
    return self.allPhotos.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Creating PhotoCollectionViewCell cells");
    
    PhotoCollectionViewCell *cell = [self.photoCollectionView dequeueReusableCellWithReuseIdentifier:@"CellId" forIndexPath:indexPath];
    
    Photo *photo = [self.allPhotos objectAtIndex:indexPath.row];
    cell.photoImageView.image = photo.image;
    cell.photoLabelView.text = photo.photoTitle;
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailViewSegue"]) {
        
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        
        Photo *photo = self.allPhotos[indexPath.item];
        DetailViewController *detailViewController = (DetailViewController *) [segue destinationViewController];;
        [detailViewController setPhoto:photo];

    } else {
        NSLog(@"Oops, something went wrong... Bummer");
    }
}

-(void)setupDefaultLayout {
    NSLog(@"Setting default layout");
    self.defaultLayout = [[UICollectionViewFlowLayout alloc] init];
    
    self.defaultLayout.itemSize = CGSizeMake(150, 150); // Set size of cell
    self.defaultLayout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);  // "Border around each section"
    self.defaultLayout.minimumInteritemSpacing = 15;  // Minimum horizontal spacing between cells
    self.defaultLayout.minimumLineSpacing = 10;
}



@end
