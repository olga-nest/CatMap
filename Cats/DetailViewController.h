//
//  DetailViewController.h
//  Cats
//
//  Created by Olga on 10/24/17.
//  Copyright © 2017 Olga Nesterova. All rights reserved.
//

#import "ViewController.h"
#import "Photo.h"
#import <MapKit/MapKit.h>


@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *detailPhotoView;
@property (weak, nonatomic) IBOutlet MKMapView *detailMapView;
@property (weak, nonatomic) IBOutlet UITextView *detailTextView;

@property (nonatomic) Photo *photo;

@end
