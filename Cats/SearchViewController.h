//
//  SearchViewController.h
//  Cats
//
//  Created by Olga on 10/24/17.
//  Copyright © 2017 Olga Nesterova. All rights reserved.
//

#import "ViewController.h"

@protocol SearchTagDelegate <NSObject>

- (void)getSearchURL: (NSURL *) url;

@end


@interface SearchViewController : UIViewController 

@property (nonatomic, weak) id <SearchTagDelegate> delegate;
- (NSURL *)constructURL;

@end
