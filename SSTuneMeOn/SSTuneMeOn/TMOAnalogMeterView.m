//
//  TMOAnalogMeterView.m
//  SSTuneMeOn
//
//  Created by Kevin Bernard R. San Gaspar on 5/4/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMOAnalogMeterView.h"
#import <CoreGraphics/CoreGraphics.h>
#import "UIColor+HexString.h"
@interface TMOAnalogMeterView ()

@property (nonatomic, retain) UIImageView* meterBGView;
@property (nonatomic, retain) UIView* pinView;
@property (nonatomic, retain) CALayer* containerLayer;
@property (nonatomic, assign) CGFloat target;
@property (nonatomic, assign) CGFloat current;
@property (nonatomic, retain) NSTimer* timer;
@end

static const CGFloat kViewWidth = 320.0f;
static const CGFloat kViewHeight = 171.0f;
static const CGFloat kPinWidth = 2.0f;
static const CGFloat kPinHeight = 50.0f;

static const CGFloat kMeterRadius = 146.0f;
static const CGFloat kCenterPointX = 160.0f;
static const CGFloat kCenterPointY= 0.0f;

static const CGFloat kBaseSpeed =  0.005f;
static const CGFloat kUpdateRate = 1 / 60.0f;
static const CGFloat kStartingAngle = 60.0f;
static const CGFloat kBaseShadowRadius = 4.0f;
static const CGFloat kShadowRadiusConstant = 16.0f;
static const CGFloat kOpacityConstant = 0.8f;

static const CGFloat kTuneBad = 0.5f;
static const CGFloat kTuneModerate = 0.05f;

@implementation TMOAnalogMeterView
@synthesize meterBGView = m_meterBGView;
@synthesize pinView = m_pinView;;
@synthesize containerLayer = m_containerLayer;
@synthesize timer = m_timer;
#pragma nark - Memory management

- (void) dealloc
{
  self.meterBGView = nil;
  self.pinView = nil;
  self.containerLayer = nil;
  [super dealloc];
}

#pragma mark - Initializations

- (id) initWithFrame: (CGRect) frame
{
  if (self = [super initWithFrame:frame])
  {
    [self initializeView];
  }
  return self;
}

#pragma mark - View getters

- (UIImageView*) meterBGView
{
  if (m_meterBGView == nil)
  {
    m_meterBGView = [UIImageView new];
    m_meterBGView.image = [UIImage imageNamed: @"tune_indicator"];
    m_meterBGView.frame = CGRectMake(0.0f, 0.0f, kViewWidth, kViewHeight);
  }
  return m_meterBGView;
}

- (UIView*) pinView
{
  if (m_pinView == nil)
  {
    m_pinView = [UIView new];
    m_pinView.frame = CGRectMake((kViewWidth - kPinWidth) / 2,
                                   kViewHeight - kPinHeight,
                                   kPinWidth,
                                   kPinHeight);
    UIImage* maskLayer = [UIImage imageNamed: @"tuner_pin_mask"];
    CALayer* pinViewMask = [CALayer layer];
    
    pinViewMask.contents = (id) maskLayer.CGImage;
    pinViewMask.frame = m_pinView.bounds;
    m_pinView.layer.mask = pinViewMask;
    
    m_pinView.backgroundColor = [UIColor greenColor];
  }
  return m_pinView;
}

- (CALayer*) containerLayer
{
  if (m_containerLayer == nil)
  {
    m_containerLayer = [CALayer layer];
    m_containerLayer.shadowColor = [UIColor greenColor].CGColor;
    m_containerLayer.shadowRadius = 4.0f;
    m_containerLayer.shadowOffset = CGSizeMake(0.f, 0.f);
    m_containerLayer.shadowOpacity = 1.f;
  }
  return m_containerLayer;
}
#pragma mark - Private methods

- (void) initializeView
{
  [self addSubview: self.meterBGView];
  
  [self.containerLayer addSublayer: self.pinView.layer];
  [self.layer addSublayer: self.containerLayer];
}
@end
