//
//  ViewController.m
//  FaceMagic
//
//  Created by 李晓帆 on 2017/3/8.
//  Copyright © 2017年 李晓帆. All rights reserved.
//

#import "ViewController.h"
#import "fm2ViewCtrl.h"

@interface ViewController ()
{
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *beginBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.0-50, self.view.frame.size.height/2.0-30, 100, 100)];
    [beginBtn addTarget:self action:@selector(startCamera:) forControlEvents:UIControlEventTouchUpInside];
    [beginBtn setImage:[UIImage imageNamed:@"begin"] forState:UIControlStateNormal];
    [self.view addSubview:beginBtn];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)startCamera:(UIButton *)btn {
    fm2ViewCtrl *camerCV = [[fm2ViewCtrl alloc]init];
    [self presentViewController:camerCV animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
