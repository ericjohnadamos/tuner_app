//
//  TMOSplashViewController.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 3/10/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMOSplashViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import "TMOAnimationHelper.h"

@interface TMOSplashViewController ()

@property (nonatomic, strong) CALayer* dancerLayer;
@property (nonatomic, strong) UIView* containerView;
@property (nonatomic, strong) UIImageView* stageView;
@property (nonatomic, strong) UIImageView* logoView;
@property (nonatomic, strong) UIView* backgroundView;

@end


@implementation TMOSplashViewController

#pragma mark - Synthesize properties

@synthesize delegate = m_delegate;
@synthesize dancerLayer = m_dancerLayer;
@synthesize containerView = m_containerView;
@synthesize stageView = m_stageView;
@synthesize logoView = m_logoView;
@synthesize backgroundView = m_backgroundView;

#pragma mark - Memory management

- (void) didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void) dealloc
{
  self.delegate = nil; 
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

#pragma mark - Private methods

- (void) startAnimation
{
  CAKeyframeAnimation* animationSequence
    = [[TMOAnimationHelper sharedHelper]
        animationForKey: kAnimationKeySplash];
  
  animationSequence.delegate = self;
  
  /* Overwrite duration too make it slower to have a dramatic effect */
  animationSequence.duration = 3.0f;
  
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
