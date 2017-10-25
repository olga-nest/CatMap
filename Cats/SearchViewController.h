//
//  SearchViewController.h
//  Cats
//
//  Created by Olga on 10/24/17.
//  Copyright © 2017 Olga Nesterova. All rights reserved.
//

#import "ViewController.h"

@protocol SearchTagDelegate <NSObject>

- (void)insertNewTag: (NSString *) usersTag;

@end


@interface SearchViewController : UIViewController

@property (nonatomic, weak) id <SearchTagDelegate> delegate;

@end
