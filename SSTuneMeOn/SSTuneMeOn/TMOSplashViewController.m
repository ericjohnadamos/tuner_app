//
//  TMOSplashViewController.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 3/10/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMOSplashViewController.h"

static const CGFloat kAnimationDelay = 2.0f;
static const CGFloat kAnimationDuration = 0.35f;

@implementation TMOSplashViewController

#pragma mark - Synthesize properties

@synthesize delegate = m_delegate;
@synthesize datasource = m_datasource;

#pragma mark - Memory management

- (void) didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void) dealloc
{
  self.delegate = nil;
  self.datasource = nil;
  
  [super dealloc];
}

#pragma mark - Application lifecycle

- (void) viewDidLoad
{
  [super viewDidLoad];
- (void) didFinishSplashView
{
  if ([self.delegate respondsToSelector:
       @selector(splashViewControllerDidFinishDisplayViews:)])
  {
    [self.delegate splashViewControllerDidFinishDisplayViews: self];
  }
}

@end
