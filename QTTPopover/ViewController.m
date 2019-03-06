//
//  ViewController.m
//  QTTPopover
//
//  Created by 武恩泽 on 2019/3/4.
//  Copyright © 2019 武恩泽. All rights reserved.
//

#import "ViewController.h"
#import "QTTPopoverView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *downpop;

@property (weak, nonatomic) IBOutlet UIButton *uppop;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)tapUpPop:(id)sender {
    
    CGPoint startPoint = CGPointMake(self.view.frame.size.width - 60, 55);
    UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 160)];
    aView.backgroundColor = [UIColor whiteColor];
    QTTPopoverView *popview = [[QTTPopoverView alloc] initWithOption:nil showHandle:nil dismissHandle:nil];
    
    [popview showWith:aView atPoint:startPoint];
    
}

- (IBAction)tapDownPop:(id)sender {
    
}

@end
