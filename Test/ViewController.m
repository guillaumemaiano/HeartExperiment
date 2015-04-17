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
    //CALayer* heartLayer;

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
    backgroundLayer.frame = CGRectInset(self.view.layer.frame, 20, 20);
    backgroundLayer.backgroundColor = [[UIColor colorWithRed:1.1 green:1 blue:0 alpha:1.0]CGColor];
    backgroundLayer.contents = (__bridge id) backgroundImg.CGImage;
    backgroundLayer.contentsScale = [[UIScreen mainScreen] scale];
    [self.view.layer addSublayer:backgroundLayer ];
    
    CALayer* heartLayer =[CALayer layer];
    heartLayer.contentsGravity = kCAGravityResizeAspect;
    heartLayer.shadowOffset = CGSizeMake(0, 3);
    heartLayer.shadowRadius = 5.0;
    heartLayer.shadowColor = [UIColor blackColor].CGColor;
    heartLayer.shadowOpacity = 0.8;
    heartLayer.frame = CGRectInset(self.view.layer.frame, 80, 200);
    heartLayer.contents = (__bridge id) heartImage.CGImage;
    heartLayer.contentsScale = [[UIScreen mainScreen] scale];
    heartLayer.masksToBounds = YES;
    // prevent default animation
    // (in our case, we could just use the base, given animation,
    // but if you want to compelxify the animation, it might be better to have full control)
    NSMutableDictionary *newActions = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSNull null], @"onOrderIn",
                                       [NSNull null], @"onOrderOut",
                                       [NSNull null], @"sublayers",
                                       [NSNull null], @"contents",
                                       [NSNull null], @"bounds",
                                       nil];
    heartLayer.actions = newActions;
    [heartLayer setName:@"heartLayer"];
    [self.view.layer addSublayer:heartLayer];
    
    CALayer* heartShapeLayer =[CALayer layer];
    heartShapeLayer.contentsGravity = kCAGravityResizeAspect;

    heartShapeLayer.frame = heartLayer.frame;
    heartShapeLayer.contents = (__bridge id)(heartShapeImage.CGImage);
    heartShapeLayer.contentsScale = [[UIScreen mainScreen] scale];
    [self.view.layer addSublayer:heartShapeLayer];
   
    CGRect endBounds = CGRectMake(0, 0, 0, 0);
    shapeLayerBounds = heartShapeLayer.bounds;
    
    // we'll first animate the heart to empty to show how it works
    animation = [ CABasicAnimation animationWithKeyPath:@"bounds" ];
    [animation setFromValue: [NSValue valueWithCGRect: heartLayer.frame]];
    [animation setToValue:[NSValue valueWithCGRect: CGRectMake(0, 0, 0, 0)]];
    [animation setDuration:2.0];
    [animation setRepeatCount:0];
    
    // Finally, add the animation to the layer
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [heartLayer setBounds:endBounds];
    }];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    //[heartLayer removeFromSuperlayer];
    [heartLayer addAnimation:animation forKey: nil ]; // passing in a key allows retrieving it (for example to stop=remove it)
    [CATransaction commit];
    // heartShapeLayer.contents = (id) heartShapeImage.CIImage; // <- outdated code

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
    CALayer * heartLayer = [self findLayerByName:@"heartLayer" inLayer:self.view.layer];
    [animation setFromValue:[NSValue valueWithCGRect:heartLayer.bounds]];
    [animation setToValue:[NSValue valueWithCGRect:endBounds]];
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        [heartLayer setBounds:endBounds];
    }];
    [heartLayer addAnimation:animation forKey: nil ]; // passing in a key allows retrieving it (for example to stop=remove it)
    [CATransaction commit];
}

static inline double radians (double degrees) {
    return degrees * M_PI/180;
}

UIImage* rotate(UIImage* src, UIImageOrientation orientation)
{
    UIGraphicsBeginImageContext(src.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, radians(90));
    } else if (orientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, radians(-90));
    } else if (orientation == UIImageOrientationDown) {
        // NOTHING
    } else if (orientation == UIImageOrientationUp) {
        CGContextRotateCTM (context, radians(90));
    }
    
    [src drawAtPoint:CGPointMake(0, 0)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CALayer *)findLayerByName:(NSString*) layerTagName inLayer:(CALayer*) layer{
    
    for (CALayer *sublayer in [layer sublayers]) {
        
        if ([[sublayer name] isEqualToString:layerTagName]) {
            return sublayer;
        }
    }
    
    return nil;
}

@end
