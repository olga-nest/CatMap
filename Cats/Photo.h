//
//  Photo.h
//  Cats
//
//  Created by Olga on 10/23/17.
//  Copyright © 2017 Olga Nesterova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Photo : NSObject

@property (nonatomic) NSString *photoTitle;
@property (nonatomic) NSURL *photoURL;
@property (nonatomic) UIImage *image;
@property (nonatomic) NSString *photoId;

- (instancetype)initWithImage: (NSURL *) url andTitle: (NSString *)title andId: (NSString *) photoId;

@end
