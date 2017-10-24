//
//  Photo.m
//  Cats
//
//  Created by Olga on 10/23/17.
//  Copyright © 2017 Olga Nesterova. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (instancetype)initWithImage: (NSURL *) url andTitle: (NSString *)title andId: (NSString *) photoId
{
    self = [super init];
    if (self) {
        _image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        _photoTitle = title;
        _photoId = photoId;
    }
    return self;
}

@end
