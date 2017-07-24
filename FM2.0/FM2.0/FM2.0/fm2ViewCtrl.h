//
//  ViewController.h
//  GLKCamera
//
//  Created by xuye on 4/13/16.
//  Copyright © 2016 appmagics. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void(^compareBlock)(int count);

@interface fm2ViewCtrl : UIViewController


@property (strong, nonatomic)void(^compareBlock)(int count, UIImage *image);;

@end

