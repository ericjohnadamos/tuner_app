//
//  TMOTunerViewController.m
//  SSTuneMeOn
//
//  Created by Kevin Bernard R. San Gaspar on 5/8/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMOTunerViewController.h"
#import "TMOAnalogMeterView.h"

@interface TMOTunerViewController ()

@property (nonatomic, retain) TMOAnalogMeterView* analogMeterView;

@end

static const CGFloat kViewWidth = 320.0f;
static const CGFloat kViewHeight = 171.0f;

@implementation TMOTunerViewController
@synthesize analogMeterView = m_analogMeterView;

#pragma mark - Memory management

- (void) dealloc
{
  self.analogMeterView = nil;
  [super dealloc];
}

#pragma mark - Initializations

- (id) initWithFrame: (CGRect) frame
{
  if (self = [super init])
  {
    self.view.frame = CGRectMake(frame.origin.x,
                                 frame.origin.y,
                                 kViewWidth,
                                 kViewHeight);
  }
  return self;
}

#pragma mark - View Controller Lifecycle

- (void) viewDidLoad
{
  [super viewDidLoad];
  [self.view addSubview: self.analogMeterView];
}

- (void) didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - View Getters

- (TMOAnalogMeterView*) analogMeterView
{
  if (m_analogMeterView == nil)
  {
    CGSize viewSize = self.view.frame.size;
    CGRect frame = CGRectMake(0.0f, 0.0f, viewSize.width, viewSize.height);
    m_analogMeterView = [[TMOAnalogMeterView alloc] initWithFrame: frame];
  }
  return m_analogMeterView;
}

@end
