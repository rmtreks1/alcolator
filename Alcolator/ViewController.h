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

// defining some labels
@property (strong, nonatomic) NSString *alternateAlcohol;
@property (strong, nonatomic) NSString *alternateAlcoholTextSingular;
@property (strong, nonatomic) NSString *alternateAlcoholTextPlural;


// opening up some more variables
@property (assign) CGFloat ouncesInOneStandard;
@property (assign) CGFloat alcoholPercentageOfOneStandard;




- (void)buttonPressed:(UIButton *)sender;

- (void)sliderValueDidChange:(UISlider *)sender;


@end

