//
//  StatisticWordsViewController.m
//  Count Phrase
//
//  Created by Titano on 4/24/16.
//  Copyright © 2016 Hoat Ha Van. All rights reserved.
//

#import "StatisticWordsViewController.h"

@interface StatisticWordsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *ibTextView;
@end

@implementation StatisticWordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"Statistic Words";
    
    NSString *strings = @"";
    for (NSDictionary *dict in self.results) {
        NSString *word = [dict valueForKey:@"word"];
        if (word.length > 1) {
            NSString *count = [dict valueForKey:@"count"];
            NSString *tempString = [NSString stringWithFormat:@"%@ : [%@]\n", word, count];
            strings = [strings stringByAppendingString:tempString];
        }
    }
    self.ibTextView.text = strings;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
