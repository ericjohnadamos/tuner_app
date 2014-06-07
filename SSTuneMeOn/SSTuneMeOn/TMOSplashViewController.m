//
//  TMOSplashViewController.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 3/10/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMOSplashViewController.h"
#import <CoreGraphics/CoreGraphics.h>

@interface TMOSplashViewController ()

@property (nonatomic, retain) CALayer* dancerLayer;
@property (nonatomic, retain) UIView* containerView;
@property (nonatomic, retain) UIImageView* stageView;
@property (nonatomic, retain) UIImageView* logoView;
@property (nonatomic, retain) UIView* backgroundView;
@property (nonatomic, retain) NSArray* animationImages;

@end


@implementation TMOSplashViewController

#pragma mark - Synthesize properties

@synthesize delegate = m_delegate;
@synthesize dancerLayer = m_dancerLayer;
@synthesize containerView = m_containerView;
@synthesize stageView = m_stageView;
@synthesize logoView = m_logoView;
@synthesize backgroundView = m_backgroundView;
@synthesize animationImages = m_animationImages;

#pragma mark - Memory management

- (void) didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void) dealloc
{
  self.delegate = nil;
  self.dancerLayer = nil;
  self.containerView = nil;
  self.stageView = nil;
  self.logoView = nil;
  self.backgroundView = nil;
  self.animationImages = nil;
  
  [super dealloc];
}

#pragma mark - Application lifecycle

- (void) viewDidLoad
{
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor blackColor];
  
  [self.view addSubview: self.backgroundView];
  [self.view addSubview: self.logoView];
  [self.view addSubview: self.stageView];
  [self.view addSubview: self.containerView];
  [self.containerView.layer addSublayer: self.dancerLayer];
  [self startAnimation];
}

#pragma mark - Getters

- (UIView*) containerView
{
  if (m_containerView == nil)
  {
    CGSize viewSize = self.view.frame.size;
    CGFloat width = 320.0f;
    CGFloat height = 333.0f;
    
    m_containerView = [UIView new];
    m_containerView.frame = CGRectMake(0.0f,
                                       viewSize.height - height,
                                       width,
                                       height);
  }
  return m_containerView;
}

- (CALayer*) dancerLayer
{
  if (m_dancerLayer == nil)
  {
    CGFloat width = 320.0f;
    CGFloat height = 333.0f;
    
    m_dancerLayer = [CALayer layer];
    m_dancerLayer.frame = CGRectMake(0.0f, 0.0f, width, height);
    m_dancerLayer.contents = (id) ((UIImage*) self.animationImages[0]).CGImage;
  }
  return m_dancerLayer;
}

- (UIImageView*) stageView
{
  if (m_stageView == nil)
  {
    CGSize viewSize = self.view.frame.size;
    
    m_stageView = [UIImageView new];
    m_stageView.image = [UIImage imageNamed: @"stage"];
    m_stageView.frame = CGRectMake(0.0f,
                                   viewSize.height - 40.0f,
                                   viewSize.width,
                                   40.0f);
  }
  return m_stageView;
}

- (UIImageView*) logoView
{
  if (m_logoView == nil)
  {
    CGSize viewSize = self.view.frame.size;

    m_logoView = [UIImageView new];
    m_logoView.image = [UIImage imageNamed: @"logo"];
    m_logoView.frame = CGRectMake(0.0f,
                                  44.0f,
                                  viewSize.width,
                                  243.0f);
  }
  return m_logoView;
}

- (UIView*) backgroundView
{
  if (m_backgroundView == nil)
  {
    CGSize viewSize = self.view.frame.size;
    
    m_backgroundView = [UIView new];
    m_backgroundView.frame = CGRectMake(0.0f,
                                        0.0f,
                                        viewSize.width,
                                        viewSize.height);
    m_backgroundView.opaque = YES;
  }
  return m_backgroundView;
}

- (NSArray*) animationImages
{
  if (m_animationImages == nil)
  {
    m_animationImages
      = [[NSArray alloc]
          initWithArray:
            @[[UIImage imageNamed: @"intro_001.png"],
              [UIImage imageNamed: @"intro_002.png"],
              [UIImage imageNamed: @"intro_003.png"],
              [UIImage imageNamed: @"intro_004.png"],
              [UIImage imageNamed: @"intro_005.png"],
              [UIImage imageNamed: @"intro_006.png"],
              [UIImage imageNamed: @"intro_007.png"],
              [UIImage imageNamed: @"intro_008.png"],
              [UIImage imageNamed: @"intro_009.png"],
              [UIImage imageNamed: @"intro_010.png"],
              [UIImage imageNamed: @"intro_011.png"],
              [UIImage imageNamed: @"intro_012.png"],
              [UIImage imageNamed: @"intro_013.png"],
              [UIImage imageNamed: @"intro_014.png"],
              [UIImage imageNamed: @"intro_015.png"],
              [UIImage imageNamed: @"intro_016.png"],
              [UIImage imageNamed: @"intro_017.png"],
              [UIImage imageNamed: @"intro_018.png"],
              [UIImage imageNamed: @"intro_019.png"],
              [UIImage imageNamed: @"intro_020.png"],
              [UIImage imageNamed: @"intro_021.png"],
              [UIImage imageNamed: @"intro_022.png"],
              [UIImage imageNamed: @"intro_023.png"],
              [UIImage imageNamed: @"intro_024.png"],
              [UIImage imageNamed: @"intro_025.png"],
              [UIImage imageNamed: @"intro_026.png"],
              [UIImage imageNamed: @"intro_027.png"],
              [UIImage imageNamed: @"intro_028.png"],
              [UIImage imageNamed: @"intro_029.png"],
              [UIImage imageNamed: @"intro_030.png"],
              [UIImage imageNamed: @"intro_031.png"],
              [UIImage imageNamed: @"intro_032.png"],
              [UIImage imageNamed: @"intro_033.png"],
              [UIImage imageNamed: @"intro_034.png"],
              [UIImage imageNamed: @"intro_035.png"],
              [UIImage imageNamed: @"intro_036.png"],
              [UIImage imageNamed: @"intro_037.png"],
              [UIImage imageNamed: @"intro_038.png"],
              [UIImage imageNamed: @"intro_039.png"],
              [UIImage imageNamed: @"intro_040.png"],
              [UIImage imageNamed: @"intro_041.png"],
              [UIImage imageNamed: @"intro_042.png"],
              [UIImage imageNamed: @"intro_043.png"],
              [UIImage imageNamed: @"intro_044.png"],
              [UIImage imageNamed: @"intro_045.png"],
              [UIImage imageNamed: @"intro_046.png"],
              [UIImage imageNamed: @"intro_047.png"],
              [UIImage imageNamed: @"intro_048.png"],
              [UIImage imageNamed: @"intro_049.png"],
              [UIImage imageNamed: @"intro_050.png"],
              [UIImage imageNamed: @"intro_051.png"],
              [UIImage imageNamed: @"intro_052.png"],
              [UIImage imageNamed: @"intro_053.png"],
              [UIImage imageNamed: @"intro_054.png"],
              [UIImage imageNamed: @"intro_055.png"],
              [UIImage imageNamed: @"intro_056.png"],
              [UIImage imageNamed: @"intro_057.png"],
              [UIImage imageNamed: @"intro_058.png"],
              [UIImage imageNamed: @"intro_059.png"]]];
  }
  return m_animationImages;
}

#pragma mark - Private methods

- (void) startAnimation
{
  CAKeyframeAnimation* animationSequence
    = [CAKeyframeAnimation animationWithKeyPath: @"contents"];
  animationSequence.calculationMode = kCAAnimationLinear;
  animationSequence.autoreverses = NO;
  animationSequence.duration = 2.00;
  animationSequence.repeatCount = 0;
  animationSequence.fillMode = kCAFillModeBoth;
  animationSequence.removedOnCompletion = NO;
  
  NSMutableArray* animationSequenceArray = [[NSMutableArray alloc] init];
  [animationSequenceArray autorelease];
  
  for (UIImage* image in self.animationImages)
  {
    [animationSequenceArray addObject:(id)image.CGImage];
  }
  
  animationSequence.values = animationSequenceArray;
  animationSequence.delegate = self;
  
  [self.dancerLayer addAnimation: animationSequence
                          forKey: @"contents"];
}

- (void) animationDidStop: (CAAnimation*) anim
                 finished: (BOOL)flag
{
  if ([self.delegate respondsToSelector:
       @selector(splashViewControllerDidFinishAnimation:)])
  {
    [self.delegate splashViewControllerDidFinishAnimation: self];
  }
}

@end
