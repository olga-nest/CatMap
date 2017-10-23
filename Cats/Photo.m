//
//  Photo.m
//  Cats
//
//  Created by Olga on 10/23/17.
//  Copyright © 2017 Olga Nesterova. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (instancetype)initWithPhotoURL: (NSURL *) url andTitle: (NSString *)title
{
    self = [super init];
    if (self) {
        _photoURL = url;
        _photoTitle = title;
    }
    return self;
}

@end
