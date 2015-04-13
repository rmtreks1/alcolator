//
//  ViewController.h
//  Alcolator
//
//  Created by Roshan Mahanama on 12/04/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) UITextField *beerPercentTextField;
@property (weak, nonatomic) UISlider *beerCountSlider;
@property (weak, nonatomic) UILabel *resultLabel;
@property (weak, nonatomic) UILabel *beerCountLabel;
@property (weak, nonatomic) UILabel *staticBeerPercentageLabel;

- (void)buttonPressed:(UIButton *)sender;

- (void)sliderValueDidChange:(UISlider *)sender;


@end

