//
//  DetailViewController.m
//  Cats
//
//  Created by Olga on 10/24/17.
//  Copyright © 2017 Olga Nesterova. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    
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

@end
