//
//  ViewController.m
//  Count Phrase
//
//  Created by Titano on 4/23/16.
//  Copyright © 2016 Hoat Ha Van. All rights reserved.
//

#import "ViewController.h"
#import "StatisticWordsViewController.h"
#import "ReportViewController.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *ibContentTextView;
@property (strong, nonatomic) NSArray *wordsArray;
@property (strong, nonatomic) NSArray *wordsSortedArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self processWords];
}

-(void)processWords {
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"noidung" ofType:@"txt"];
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    self.ibContentTextView.text = string;
    NSString *phrase = [string lowercaseString];
    NSString *cleanedString;
    NSCharacterSet *charactersToRemove = [[NSCharacterSet letterCharacterSet] invertedSet];
    cleanedString = [[phrase componentsSeparatedByCharactersInSet:charactersToRemove] componentsJoinedByString:@" "];
    
    NSCountedSet *countedSet = [NSCountedSet new];
    
    [cleanedString enumerateSubstringsInRange:NSMakeRange(0, [cleanedString length])
                                      options:NSStringEnumerationByWords | NSStringEnumerationLocalized
                                   usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
                                       
                                       [countedSet addObject:substring];
                                   }];
    
    NSMutableArray *dictArray = [NSMutableArray array];
    [countedSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [dictArray addObject:@{@"word": obj,
                               @"count": @([countedSet countForObject:obj])}];
    }];
    self.wordsArray = [NSArray arrayWithArray:dictArray];
    dispatch_group_leave(group);
    
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSArray *sorted = [dictArray sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"count" ascending:NO]]];
        //NSLog(@"Objects sorted by count: %@",sorted);
        self.wordsSortedArray = [NSArray arrayWithArray:sorted];
        NSInteger count = 0;
        for (NSDictionary *dict in self.wordsSortedArray) {
            NSString *word = [dict valueForKey:@"word"];
            if (word.length > 1) {
                count++;
            }
        }
        self.title = [NSString stringWithFormat:@"%ld words", count];
    });
}
- (IBAction)statisticWords:(id)sender {
    StatisticWordsViewController *statisticController = [self.storyboard instantiateViewControllerWithIdentifier:@"StatisticWordsViewController"];
    statisticController.results = self.wordsArray;
    [self.navigationController pushViewController:statisticController animated:YES];
}

- (IBAction)showSortedWords:(id)sender {
    ReportViewController *reportController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReportViewController"];
    reportController.results = self.wordsSortedArray;
    [self.navigationController pushViewController:reportController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
