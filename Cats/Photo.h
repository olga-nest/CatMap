//
//  Photo.h
//  Cats
//
//  Created by Olga on 10/23/17.
//  Copyright © 2017 Olga Nesterova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface Photo : NSObject <MKAnnotation>

@property (nonatomic) NSString *photoTitle;
@property (nonatomic) NSURL *photoURL;
@property (nonatomic) UIImage *image;
@property (nonatomic) NSString *photoId;
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (instancetype)initWithImage: (NSURL *) url andTitle: (NSString *)title andId: (NSString *) photoId;

@end
