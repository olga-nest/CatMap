//
//  SearchViewController.m
//  Cats
//
//  Created by Olga on 10/24/17.
//  Copyright © 2017 Olga Nesterova. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (nonatomic) NSString *method;
@property (nonatomic) NSString *api_key;
@property (nonatomic) NSString *tags;
@property (nonatomic) NSString *has_geo;
@property (nonatomic) NSString *extras;
@property (nonatomic) NSString *format;
@property (nonatomic) NSString *nojsoncallback;

@property (nonatomic) NSURL *urlCreatedFromSearch;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDefaultValuesForURL];
    
   }

- (IBAction)saveSearchInput:(UIButton *)sender {
    NSString *tag = self.searchTextField.text;
    
    NSLog(@"Saving tag: %@", tag);
    self.tags = tag;
    [self constructURL];
    [self.delegate getSearchURL:self.urlCreatedFromSearch];
    
}

-(NSURL *)constructURL {
    
    NSDictionary *queriesDict = @{@"method" : self.method,
                                  @"api_key" : self.api_key,
                                  @"tags" : self.tags,
                                  @"has_geo" : self.has_geo,
                                  @"extras" : self.extras,
                                  @"format" : self.format,
                                  @"nojsoncallback" : self.nojsoncallback};
    
    NSMutableArray *queries = [NSMutableArray new];
    for (NSString *key in queriesDict) {
        [queries addObject:[NSURLQueryItem queryItemWithName:key value:queriesDict[key]]];
    }
    
    NSURLComponents *components = [NSURLComponents new];
    components.scheme = @"https";
    components.host = @"api.flickr.com";
    components.path = @"/services/rest/";
    components.queryItems = queries;
    
    self.urlCreatedFromSearch = components.URL;
    NSLog(@"URL created: %@", self.urlCreatedFromSearch);
    
    return self.urlCreatedFromSearch;
}

-(void)getDefaultValuesForURL {
    self.method = @"flickr.photos.search";
    self.api_key = @"b066df57d7b11069504a3b0819a67999";
    self.tags = @"cat";
    self.has_geo = @"1";
    self.extras = @"url_m";
    self.format = @"json";
    self.nojsoncallback = @"1";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
    if ([segue.identifier isEqualToString:@"searchToCollection"]){
    ViewController *viewController = (ViewController *) [segue destinationViewController];
        self.delegate = viewController; }
    else {
        NSLog(@"Bummer...");
    }
}


@end
