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

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   }

- (IBAction)saveSearchInput:(UIButton *)sender {
    NSString *tag = self.searchTextField.text;
    
    NSLog(@"Saving tag: %@", tag);
    
//    [self.delegate insertNewTag:tag];
    [self dismissViewControllerAnimated:true completion:nil];
    
    
}




@end
