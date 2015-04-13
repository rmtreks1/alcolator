//
//  ViewController.m
//  Alcolator
//
//  Created by Roshan Mahanama on 12/04/2015.
//  Copyright (c) 2015 RMTREKS. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>

/* Since using code and not storyboard, we don't need IBOutlet
@property (weak, nonatomic) IBOutlet UITextField *beerPercentTextField;
@property (weak, nonatomic) IBOutlet UISlider *beerCountSlider;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *beerCountLabel;
*/



@property (weak, nonatomic) UIButton *calculateButton;
@property (weak, nonatomic) UITapGestureRecognizer *hideKeyboardTapGestureRecognizer; // ah ha - suddenly it makes sense why we need this

 
 
@end

@implementation ViewController

- (void)loadView {
    // Allocate and initialize the all-encompassing view
    self.view = [[UIView alloc] init];
    
    // Allocate and initialize each of our views and the gesture recognizer
    UITextField *textField = [[UITextField alloc] init];
    UISlider *slider = [[UISlider alloc] init];
    UILabel *label = [[UILabel alloc] init];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    UILabel *beerCountLabel = [[UILabel alloc] init];
    UILabel *staticBeerPercentageLabel = [[UILabel alloc] init];
    
    // Add each view and the gesture recognizer as the view's subviews
    [self.view addSubview:textField];
    [self.view addSubview:slider];
    [self.view addSubview:label];
    [self.view addSubview:button];
    [self.view addGestureRecognizer:tap];
    [self.view addSubview:beerCountLabel];
    [self.view addSubview:staticBeerPercentageLabel];
    
    // Assign the views and gesture recognizer to our properties
    self.beerPercentTextField = textField;
    self.beerCountSlider = slider;
    self.resultLabel = label;
    self.calculateButton = button;
    self.hideKeyboardTapGestureRecognizer = tap;
    self.beerCountLabel = beerCountLabel;
    self.staticBeerPercentageLabel = staticBeerPercentageLabel;
}



- (void)viewDidLoad
{
    // setting title for the view
    self.title = NSLocalizedString(@"Wine", @"wine");
    
    
    
    // Calls the superclass's implementation
    [super viewDidLoad];
    
    // Set our primary view's background color to lightGrayColor
    self.view.backgroundColor = [UIColor whiteColor];

    
    // Tells the text field that `self`, this instance of `ViewController` should be treated as the text field's delegate
    self.beerPercentTextField.delegate = self;
    
    // Set the placeholder text
    self.beerPercentTextField.placeholder = NSLocalizedString(@"Alcohol % Per Beer", @"Beer percent placeholder text");
    
    // Tells `self.beerCountSlider` that when its value changes, it should call `[self -sliderValueDidChange:]`.
    // This is equivalent to connecting the IBAction in our previous checkpoint
    [self.beerCountSlider addTarget:self action:@selector(sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    
    // Set the minimum and maximum number of beers
    self.beerCountSlider.minimumValue = 1;
    self.beerCountSlider.maximumValue = 10;
    
    // Tells `self.calculateButton` that when a finger is lifted from the button while still inside its bounds, to call `[self -buttonPressed:]`
    [self.calculateButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // Set the title of the button
    [self.calculateButton setTitle:NSLocalizedString(@"Calculate!", @"Calculate command") forState:UIControlStateNormal];
    
    // Tells the tap gesture recognizer to call `[self -tapGestureDidFire:]` when it detects a tap.
    [self.hideKeyboardTapGestureRecognizer addTarget:self action:@selector(tapGestureDidFire:)];
    
    // Gets rid of the maximum number of lines on the label
    self.resultLabel.numberOfLines = 0;
    
    // open on the beerPercentTextField & set a numerical keyboard
    [self.beerPercentTextField becomeFirstResponder];
    self.beerPercentTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    // set the text for Beer Percentage Label
    self.staticBeerPercentageLabel.text = @"alcohol % per beer";
    
    // setting default font
    self.staticBeerPercentageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
    self.beerPercentTextField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];
    self.beerCountLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0f];
    self.resultLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0f];
    self.resultLabel.textAlignment = NSTextAlignmentCenter;
    self.calculateButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16.0f];

    
    // hide the calculate button & the label by default
    self.calculateButton.hidden = true;
    self.staticBeerPercentageLabel.hidden = true;
    
    
    // disabling the swipe left for previous screen as was intefering with the slider
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        
        
    // set the initial values for some lavels
    self.alternateAlcohol = NSLocalizedString(@"Wine", "wine");
        
        
        
    }

    
}




- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    // figuring out the size of the screen
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
//    CGFloat screenHeight = screenRect.size.height;
//    NSLog(@"the width is %f", screenWidth);
//    NSLog(@"the height is %f", screenHeight);
    
    
    // detecting the device orientation and then setting the navbar height
    // this is to compensate for the issue where the views are sometimes not appearing because the screen size is not accounted for
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat statusBarHeight;
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        statusBarHeight = 0.0f;
    } else if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)){
        statusBarHeight = 20.0f;
    }
    
    
    NSLog(@"nav bar height is %f", navBarHeight);
    
    // setting up more fixed variables
    CGFloat viewWidth = screenWidth;

    CGFloat padding = 20;
    CGFloat itemWidth = viewWidth - padding - padding;
    CGFloat itemHeight = 44;
    
    
    // laying out the views
    self.beerPercentTextField.frame = CGRectMake(padding, statusBarHeight + navBarHeight, 160, itemHeight);
    
    CGFloat rightOfbeerPercentTextField = CGRectGetMaxX(self.beerPercentTextField.frame);
    self.calculateButton.frame = CGRectMake(rightOfbeerPercentTextField + padding, statusBarHeight + navBarHeight, 100, itemHeight);
    
    CGFloat bottomOfTextField = CGRectGetMaxY(self.beerPercentTextField.frame);
    self.staticBeerPercentageLabel.frame = CGRectMake(padding, bottomOfTextField, itemWidth, itemHeight/2);
    
    CGFloat bottomOfBeerPercentageLabel = CGRectGetMaxY(self.staticBeerPercentageLabel.frame);
    self.beerCountSlider.frame = CGRectMake(padding, bottomOfBeerPercentageLabel + padding, itemWidth, itemHeight);
   
    CGFloat bottomOfSlider = CGRectGetMaxY(self.beerCountSlider.frame);
    // making the beer count label appear on the right of the slider just underneath
    self.beerCountLabel.frame = CGRectMake(padding, bottomOfSlider + padding/2, itemWidth, itemHeight);
    self.beerCountLabel.textAlignment = NSTextAlignmentRight;
    
    CGFloat bottomOfBeerCountLabel = CGRectGetMaxY(self.beerCountLabel.frame);
    self.resultLabel.frame = CGRectMake(padding, bottomOfBeerCountLabel + padding, itemWidth, itemHeight * 2);
    
    
    

}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)textFieldDidChange:(UITextField *)sender {
    NSString *enteredText = sender.text;
    float enteredNumber = [enteredText floatValue];
    
    if (enteredNumber == 0) {
        sender.text = nil;
        self.calculateButton.hidden = TRUE;

    } else {
        self.calculateButton.hidden = false;
    }
}


- (void)sliderValueDidChange:(UISlider *)sender {
    NSLog(@"Slider value changed to %f", sender.value);
    [self.beerPercentTextField resignFirstResponder]; // what does resignFirstResponder do?
    
    
    // calculating alcohol in the beers
    int numberOfBeers = self.beerCountSlider.value;
    int ouncesInOnBeerGlass = 12;
    
    float alcoholPercentageOfBeer = [self.beerPercentTextField.text floatValue] / 100 ;
    float ouncesOfAlcoholPerBeer = ouncesInOnBeerGlass * alcoholPercentageOfBeer;
    float ouncesOfAlcoholTotal = ouncesOfAlcoholPerBeer * numberOfBeers;
    
    
    // calculating the equivalent amount of wine
    float ouncesInOneStandard = 5;
    float alcoholPercentageOfOneStandard = 0.13;
    
    float ouncesOfAlcoholPerOneStandard = ouncesInOneStandard * alcoholPercentageOfOneStandard;
    float numberOfStandardsForEquivalentAlcoholAmount = ouncesOfAlcoholTotal / ouncesOfAlcoholPerOneStandard;
    
    // use Singular or Plural
    NSString *beerText;
    
    if (numberOfBeers == 1) {
        beerText = NSLocalizedString(@"beer", @"singular beer");
    } else {
        beerText = NSLocalizedString(@"beers", @"plural of beer");
    }
    
    
    NSString *wineText;
    
    if (numberOfStandardsForEquivalentAlcoholAmount == 1) {
        wineText = NSLocalizedString(@"glass", @"single glass");
    } else {
        wineText = NSLocalizedString(@"glasses", @"plural of glass");
    }
    
    
    // generate the text and display it on the label
    NSString *resultText = [NSString stringWithFormat:NSLocalizedString(@"%d %@ contains as much alcohol as %.1f %@ of %@.", nil), numberOfBeers, beerText, numberOfStandardsForEquivalentAlcoholAmount, wineText, self.alternateAlcohol];
    self.resultLabel.text = resultText;
    
    // generate text & display number of beers
    NSString *beerCountText = [NSString stringWithFormat:NSLocalizedString(@"%d %@", nil), numberOfBeers, beerText];
    self.beerCountLabel.text = beerCountText;

    
    // set the title label
    NSString *titleWithCount = [NSString stringWithFormat:NSLocalizedString(@"%@ (%.1f %@)", nil), self.alternateAlcohol,numberOfStandardsForEquivalentAlcoholAmount, wineText];
    self.title = titleWithCount;

    
}


 - (void)buttonPressed:(UIButton *)sender {

     [self.beerPercentTextField resignFirstResponder]; // when do I use . and when do I use []

    
    // calculating alcohol in the beers
    int numberOfBeers = self.beerCountSlider.value;
    int ouncesInOnBeerGlass = 12;
    
    float alcoholPercentageOfBeer = [self.beerPercentTextField.text floatValue] / 100 ;
    float ouncesOfAlcoholPerBeer = ouncesInOnBeerGlass * alcoholPercentageOfBeer;
    float ouncesOfAlcoholTotal = ouncesOfAlcoholPerBeer * numberOfBeers;
    
    
    // calculating the equivalent amount of wine
    float ouncesInOneWineGlass = 5;
    float alcoholPercentageOfWine = 0.13;
    
    float ouncesOfAlcoholPerWineGlass = ouncesInOneWineGlass * alcoholPercentageOfWine;
    float numberOfWineGlassesForEquivalentAlcoholAmount = ouncesOfAlcoholTotal / ouncesOfAlcoholPerWineGlass;
    
    // use Singular or Plural
    NSString *beerText;
    
    if (numberOfBeers == 1) {
        beerText = NSLocalizedString(@"beer", @"singular beer");
    } else {
        beerText = NSLocalizedString(@"beers", @"plural of beer");
    }
    
    
    NSString *wineText;
    
    if (numberOfWineGlassesForEquivalentAlcoholAmount == 1) {
        wineText = NSLocalizedString(@"glass", @"single glass");
    } else {
        wineText = NSLocalizedString(@"glasses", @"plural of glass");
    }
    
    
    // generate the text and display it on the label
    NSString *resultText = [NSString stringWithFormat:NSLocalizedString(@"%d %@ contains as much alcohol as %.1f %@ of wine.", nil), numberOfBeers, beerText, numberOfWineGlassesForEquivalentAlcoholAmount, wineText];
    self.resultLabel.text = resultText;
    
    // generate text & display number of beers
    NSString *beerCountText = [NSString stringWithFormat:NSLocalizedString(@"%d %@", nil), numberOfBeers, beerText];
    self.beerCountLabel.text = beerCountText;
     
     
     


}


- (void)tapGestureDidFire:(UITapGestureRecognizer *)sender {
    [self.beerPercentTextField resignFirstResponder];
}



-(void)textFieldDidBeginEditing:(UITextField *)beerPercentTextField{
    // Set the text color on input to Blue
    self.beerPercentTextField.backgroundColor = [UIColor whiteColor];
    self.beerPercentTextField.textColor = [UIColor blueColor];
    self.beerPercentTextField.keyboardAppearance = UIKeyboardAppearanceDark;
   // self.calculateButton.hidden = true; // hide the calculate button during edit
}


-(void)textFieldDidEndEditing:(UITextField *)beerPercentTextField{
    // change the color of the beerPercentTextField back to black to take emphasis away
    self.beerPercentTextField.backgroundColor = self.view.backgroundColor;
    self.beerPercentTextField.textColor = [UIColor blackColor];
    NSLog(@"%lu",(unsigned long)self.beerPercentTextField.text.length); // error!!! beerPercentTextField is storing text not float
    if (self.beerPercentTextField.text.length != 0) {
        self.calculateButton.hidden = false; // hide the calculate button during edit
        self.staticBeerPercentageLabel.hidden = false;
        self.resultLabel.hidden=false;
    } else {
        self.calculateButton.hidden = true;
        self.staticBeerPercentageLabel.hidden = true;
        self.resultLabel.hidden=true;
    }
    
}



@end
