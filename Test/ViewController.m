//
//  ViewController.m
//  Test
//
//  Created by guillaume MAIANO on 16/04/15.
//  Copyright (c) 2015 guillaume MAIANO. All rights reserved.
//

#import "ViewController.h"
@import QuartzCore;

@interface ViewController ()

@end

@implementation ViewController

    CABasicAnimation * animation;
    int heartQuint;
    CGRect shapeLayerBounds;
    CALayer* heartLayer;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    
    
}

- (void) viewDidAppear:(BOOL)animated
{
    UIImage* backgroundImg = [UIImage imageNamed:@"background"];//rotate([UIImage imageNamed:@"background"],UIImageOrientationUp);
    UIImage* heartImage = [UIImage imageNamed:@"Coeur"];
    UIImage* heartShapeImage = [UIImage imageNamed:@"Coeurshape"];
    
    CALayer* backgroundLayer = [CALayer layer];
    backgroundLayer.contentsGravity = kCAGravityResizeAspect;
    backgroundLayer.opacity = 1;
    backgroundLayer.opaque = YES;
    backgroundLayer.hidden = NO;
    backgroundLayer.cornerRadius = 20.0;
    backgroundLayer.frame = CGRectInset(self.view.layer.frame, 60, 20);
    backgroundLayer.backgroundColor = [[UIColor colorWithRed:1.1 green:1 blue:0 alpha:1.0]CGColor];
    backgroundLayer.contents = (__bridge id) backgroundImg.CGImage;
    backgroundLayer.contentsScale = [[UIScreen mainScreen] scale];
    [self.view.layer addSublayer:backgroundLayer ];
    
    heartLayer =[CALayer layer];
    heartLayer.contentsGravity = kCAGravityResizeAspect;
    heartLayer.shadowOffset = CGSizeMake(0, 3);
    heartLayer.shadowRadius = 5.0;
    heartLayer.shadowColor = [UIColor blackColor].CGColor;
    heartLayer.shadowOpacity = 0.8;
    heartLayer.frame = CGRectInset(self.view.layer.frame, 80, 200);
    heartLayer.contents = (__bridge id) heartImage.CGImage;
    heartLayer.contentsScale = [[UIScreen mainScreen] scale];
    heartLayer.masksToBounds = YES;
    [heartLayer setName:@"heartLayer"];
    [self.view.layer addSublayer:heartLayer];
    
    CALayer* heartShapeLayer =[CALayer layer];
    heartShapeLayer.contentsGravity = kCAGravityResizeAspect;

    heartShapeLayer.frame = heartLayer.frame;
    heartShapeLayer.contents = (__bridge id)(heartShapeImage.CGImage);
    heartShapeLayer.contentsScale = [[UIScreen mainScreen] scale];
    [self.view.layer addSublayer:heartShapeLayer];
   
    shapeLayerBounds = heartShapeLayer.bounds;
   

    // everytime we tap, let's fill the heart 20%
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(fillHeart20:)];
    [self.view addGestureRecognizer:singleFingerTap];

    heartQuint = 0;



}


//The event handling method
- (void)fillHeart20:(UITapGestureRecognizer *)recognizer {
    heartQuint++;
    heartQuint%=5;
    float height = shapeLayerBounds.size.height * heartQuint/5.0;
    CGRect endBounds = CGRectMake(shapeLayerBounds.origin.x, shapeLayerBounds.origin.y, shapeLayerBounds.size.width, height);
        [heartLayer setBounds:endBounds];
 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
