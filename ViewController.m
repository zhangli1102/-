//
//  ViewController.m
//  加入购物车动画
//
//  Created by Zhangli on 16/7/14.
//  Copyright © 2016年 Zhangli. All rights reserved.
//

#import "ViewController.h"

#define SCREEN_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define SCreen_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) CALayer *layer;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *shopBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.count = 0;
    [self createItems];
}

- (void)createItems{
    UIColor *customColor = [UIColor colorWithRed:237/255.0 green:20/255.0 blue:91/255.0 alpha:1.0f];
    //立即抢购按钮
    self.shopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shopBtn.frame = CGRectMake(50, SCreen_HEIGHT * 0.5, 100, 40);
    [self.shopBtn setTitle:@"立即抢购" forState:UIControlStateNormal];
    [self.shopBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.shopBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.shopBtn setBackgroundImage:[UIImage imageNamed:@"ButtonRedLarge.png"] forState:UIControlStateNormal];
    [self.shopBtn addTarget:self action:@selector(startAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.shopBtn];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.imageView.image = [UIImage imageNamed:@"TabCartSelected@2x.png"];
    self.imageView.center = CGPointMake(220, SCreen_HEIGHT * 0.53);
    [self.view addSubview:self.imageView];
    
    self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(228, SCreen_HEIGHT * 0.5, 20, 20)];
    self.countLabel.textColor = customColor;
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.font = [UIFont boldSystemFontOfSize:12];
    self.countLabel.backgroundColor = [UIColor whiteColor];
    self.countLabel.layer.cornerRadius = CGRectGetHeight(self.countLabel.bounds)/2;
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.layer.borderWidth = 1.0f;
    self.countLabel.layer.borderColor = customColor.CGColor;
    [self.view addSubview:self.countLabel];
    
    if (self.count == 0) {
        self.countLabel.hidden = YES;
    }
    
    self.path = [UIBezierPath bezierPath];
    [self.path moveToPoint:CGPointMake(50, 150)];
    [self.path addQuadCurveToPoint:CGPointMake(228, SCreen_HEIGHT * 0.5 + 5) controlPoint:CGPointMake(150, 20)];
}

- (void)startAnimation{
    if (!self.layer) {
        self.shopBtn.enabled = NO;
        self.layer = [CALayer layer];
        self.layer.contents = (__bridge id)[UIImage imageNamed:@"test01.jpg"].CGImage;
        self.layer.contentsGravity = kCAGravityResizeAspectFill;
        self.layer.bounds = CGRectMake(50, 50, 50, 50);
        [self.layer setCornerRadius:CGRectGetHeight([self.layer bounds]) / 2];
        self.layer.masksToBounds = YES;
        self.layer.position = CGPointMake(50, 150);
        [self.view.layer addSublayer:self.layer];
    }
    [self groupAnimation];
}

- (void)groupAnimation{
    //关键帧动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.path = self.path.CGPath;
    animation.rotationMode = kCAAnimationRotateAuto;
    //先放大
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnimation.duration = 0.5f;
    expandAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    expandAnimation.toValue = [NSNumber numberWithFloat:2.0f];
    expandAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    //后放小
    CABasicAnimation *narrowAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    narrowAnimation.beginTime = 0.5;
    narrowAnimation.fromValue = [NSNumber numberWithFloat:2.0f];
    narrowAnimation.duration = 1.5f;
    narrowAnimation.toValue = [NSNumber numberWithFloat:0.5f];
    narrowAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    //动画组
    CAAnimationGroup *groups = [CAAnimationGroup animation];
    groups.animations = @[animation, expandAnimation, narrowAnimation];
    groups.duration = 2.0f;
    groups.removedOnCompletion = NO;
    groups.fillMode = kCAFillModeForwards;
    groups.delegate = self;
    [self.layer addAnimation:groups forKey:@"group"];
}

//加入购物车后，购物车抖动
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    if (anim == [self.layer animationForKey:@"group"]) {
        self.shopBtn.enabled = YES;
        [self.layer removeFromSuperlayer];
        self.layer = nil;
        self.count++;
        if (self.count) {
            self.countLabel.hidden = NO;
        }
        
        //countLabel数字变化动画
        CATransition *animation = [CATransition animation];
        animation.duration = 0.25f;
        self.countLabel.text = [NSString stringWithFormat:@"%ld",(long)self.count];
        [self.countLabel.layer addAnimation:animation forKey:nil];
        
        CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
        shakeAnimation.duration = 0.25f;
        shakeAnimation.fromValue = [NSNumber numberWithFloat:-5.0f];
        shakeAnimation.toValue = [NSNumber numberWithFloat:5.0f];
        shakeAnimation.autoreverses = YES;
        [self.imageView.layer addAnimation:shakeAnimation forKey:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
