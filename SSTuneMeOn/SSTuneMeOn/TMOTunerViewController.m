//
//  TMOTunerViewController.m
//  SSTuneMeOn
//
//  Created by Kevin Bernard R. San Gaspar on 5/8/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMOTunerViewController.h"
#import "TMOAnalogMeterView.h"
#import "TMONote.h"
#import "TMONoteGroup.h"
#import "TMOStandardTheme.h"
#import "TMOLocalizedStrings.h"
#import "TMOUserSettings.h"
#import "TMOProgressView.h"
#import "TMOProgressDot.h"
#import "TMOProgressControl.h"

@interface TMOTunerViewController ()

@property (nonatomic, assign) TMOTheme* theme;
@property (nonatomic, retain) TMONote* note;
@property (nonatomic, retain) TMONoteGroup* noteGroup;
@property (nonatomic, retain) TMOAnalogMeterView* analogMeterView;
@property (nonatomic, retain) UIImageView* noteIconView;
@property (nonatomic, retain) UIImageView* stringIconView;
@property (nonatomic, retain) UILabel* frequencyLabel;
@property (nonatomic, assign) BOOL isTuned;
@property (nonatomic, assign) CGFloat currentFrequency;
@property (nonatomic, assign) CGFloat currentVariance;
@property (nonatomic, retain) NSTimer* timer;

@property (nonatomic, retain) TMOProgressControl* progressControl;

@end

static const CGFloat kViewWidth = 320.0f;
static const CGFloat kViewHeight = 171.0f;
static const CGFloat kStringIconWidth = 10.0f;
static const CGFloat kStringIconHeight = 21.0f;
static const CGFloat kStringIconTopMargin = 21.0f;
static const CGFloat kNoteIconWidth = 70.0f;
static const CGFloat kNoteIconHeight = 79.0f;
static const CGFloat kFrequencyLabelHeight = 20.0f;
static const CGFloat kFrequencyLabelUpdateInterval = 0.5f;

@implementation TMOTunerViewController

@synthesize theme = m_theme;
@synthesize note = m_note;
@synthesize noteGroup = m_noteGroup;
@synthesize analogMeterView = m_analogMeterView;
@synthesize noteIconView = m_noteIconView;
@synthesize stringIconView = m_stringIconView;;
@synthesize frequencyLabel = m_frequencyLabel;
@synthesize isTuned = m_isTuned;
@synthesize currentFrequency = m_currentFrequency;
@synthesize timer = m_timer;

@synthesize progressControl = m_progressControl;

#pragma mark - Memory management

- (void) dealloc
{
  self.theme = nil;
  self.note = nil;;
  self.noteGroup = nil;
  self.analogMeterView = nil;
  self.noteIconView = nil;
  self.stringIconView = nil;
  self.frequencyLabel = nil;
  self.timer = nil;
  
  self.progressControl = nil;
  
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
  
  /* Add subviews */
  [self.view addSubview: self.analogMeterView];
  [self.view addSubview: self.noteIconView];
  [self.view addSubview: self.stringIconView];
  [self.view addSubview: self.frequencyLabel];
  [self.view addSubview: self.progressControl];
  
  /* Set progress control frame */
  CGSize progressControlSize = self.progressControl.frame.size;
  CGFloat progressControlWidth = self.progressControl.frame.size.width;
  
  CGFloat progressControlY = 90.0f;
  CGFloat progressControlX
    = (self.view.frame.size.width - progressControlWidth) * 0.5f;
  
  self.progressControl.frame = CGRectMake(progressControlX,
                                          progressControlY,
                                          progressControlSize.width,
                                          progressControlSize.height);
  
  /* Update UI based on values */
  [self updateNoteIcon];
  [self updateStringIcon];

  [self.analogMeterView start];
  [self startUpdateFrequencyLabel];
}

- (void) didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - View Getters

- (TMOProgressControl*) progressControl
{
  if (m_progressControl == nil)
  {
    m_progressControl = [[TMOProgressControl alloc] init];
    
    m_progressControl.numberOfPages = 4;
    m_progressControl.currentPage = -1;
    
    [m_progressControl addTarget: self
                          action: @selector(pageControlClicked:)
                forControlEvents: UIControlEventValueChanged];
    
    m_progressControl.defersCurrentPageDisplay = YES;
    m_progressControl.type = DDPageControlTypeOnFullOffEmpty;
    
    m_progressControl.onColor = [UIColor greenColor];
    m_progressControl.offColor = [UIColor colorWithWhite: 0.7f
                                                   alpha: 1.0f];
    m_progressControl.indicatorDiameter = 10.0f;
    m_progressControl.indicatorSpace = 10.0f;
  }
  
  return m_progressControl;
}

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

- (UIImageView*) noteIconView
{
  if (m_noteIconView == nil)
  {
    m_noteIconView = [UIImageView new];
    m_noteIconView.frame = CGRectMake((kViewWidth - kNoteIconWidth) / 2.0f,
                                      0.0f,
                                      kNoteIconWidth,
                                      kNoteIconHeight);
  }
  return m_noteIconView;
}

- (UIImageView*) stringIconView
{
  if (m_stringIconView == nil)
  {
    CGFloat xOrigin = ((kViewWidth - kNoteIconWidth) / 2.0f) + kNoteIconWidth;
    m_stringIconView = [UIImageView new];
    m_stringIconView.frame = CGRectMake(xOrigin,
                                        kStringIconTopMargin,
                                        kStringIconWidth,
                                        kStringIconHeight);
  }
  return m_stringIconView;
}

- (UILabel*) frequencyLabel
{
  if (m_frequencyLabel == nil)
  {
    m_frequencyLabel = [UILabel new];
    m_frequencyLabel.frame = CGRectMake((kViewWidth - kNoteIconWidth) / 2.0f,
                                        kNoteIconHeight,
                                        kNoteIconWidth,
                                        kFrequencyLabelHeight);
    [self.theme skinFrequencyLabel: m_frequencyLabel];
  }
  return m_frequencyLabel;
}

#pragma mark - Getters

- (TMONote*) note
{
  if (m_note == nil)
  {
    m_note = [[TMOUserSettings sharedInstance] selectedNote];
    [m_note retain];
  }
  return m_note;
}

- (TMONoteGroup*) noteGroup
{
  if (m_noteGroup == nil)
  {
    m_noteGroup = [[TMOUserSettings sharedInstance] selectedGroup];
    [m_noteGroup retain];
  }
  return m_noteGroup;
}

- (TMOTheme*) theme
{
  if (m_theme == nil)
  {
    m_theme = [TMOStandardTheme sharedInstance];
  }
  return m_theme;
}

#pragma mark - Private methods

- (void) updateNoteIcon
{
  if (self.isTuned)
  {
    self.noteIconView.image
      = [self.theme highlightedNoteIconForNoteWithName: self.note.name];
  }
  else
  {
    self.noteIconView.image
      = [self.theme noteIconForNoteWithName: self.note.name];
  }
}

- (void) updateStringIcon
{
  NSInteger imageIndex = 0;
  
  if (self.noteGroup.notes.count == 6)
  {
    imageIndex = [self.noteGroup.notes indexOfObject: self.note];
    
    if (imageIndex != NSNotFound)
    {
      self.stringIconView.image
        = [self.theme iconForSixStringsWithIndex: imageIndex];
    }
  }
  else if (self.noteGroup.notes.count == 4)
  {
    imageIndex  = [self.noteGroup.notes indexOfObject: self.note];
    
    if (imageIndex != NSNotFound)
    {
      self.stringIconView.image
        = [self.theme iconFourStringsWithIndex: imageIndex];
    }
  }
}

- (void) updateFrequencyLabel
{
  @autoreleasepool
  {
    NSString* hertzString = [TMOLocalizedStrings stringForKey: kTMOHertz];
    NSString* freqText
      = [NSString stringWithFormat: @"%0.0f %@",
                                    self.currentFrequency,
                                    hertzString];
    
    dispatch_async(dispatch_get_main_queue(), ^
    {
      self.frequencyLabel.attributedText
        = [self.theme attributedStringForFrequencyLabelWithString: freqText];
      
      self.frequencyLabel.textColor
        = [self.analogMeterView colorFromPercentDelta: self.currentVariance];
    });
  }
}

- (CGFloat) varianceForFrequency: (CGFloat) frequency
             withTargetFrequency: (CGFloat) target
{
  CGFloat variance = 0;
  
  if (frequency != target && target != 0)
  {
    variance = (frequency - target) / target;
  }
  
  return variance;
}

- (void) startUpdateFrequencyLabel
{
  NSTimer* timer
    = [NSTimer timerWithTimeInterval: kFrequencyLabelUpdateInterval
                              target: self
                            selector: @selector(updateFrequencyLabel)
                            userInfo: nil
                             repeats: YES];
  
	[[NSRunLoop mainRunLoop] addTimer: timer
                            forMode: NSDefaultRunLoopMode];
  
  self.timer = timer;
}

#pragma mark - TMOFrequencyListener method

- (void) frequencyChangedWithValue: (float) newFrequency
{
  self.currentFrequency = newFrequency;
  
  CGFloat newVariance = [self varianceForFrequency: self.currentFrequency
                               withTargetFrequency: self.note.frequency];
  [self.analogMeterView updateToVariance: newVariance];
  self.currentVariance = newVariance;
  
  BOOL newIsTuned = (ABS(newVariance) <= kTuneVrianceThreshold);
  
  if (!self.isTuned && newIsTuned != self.isTuned)
  {
    dispatch_async(dispatch_get_main_queue(), ^(void)
    {
     [self updateNoteIcon];
    });
  }
}

#pragma mark -
#pragma mark DDPageControl triggered actions

- (void) pageControlClicked: (id) sender
{
  /* Nothing to do */
}

#pragma mark - Public methods

- (void) updateWithNote: (TMONote*)      note
              noteGroup: (TMONoteGroup*) noteGroup
{
  self.note = note;
  self.noteGroup = noteGroup;

  dispatch_async(dispatch_get_main_queue(), ^(void)
  {
    self.isTuned = NO;
    [self updateNoteIcon];
    [self updateStringIcon];
  });
}

- (void) increaseProgress
{
  if (self.progressControl.currentPage < self.progressControl.numberOfPages)
	{
		self.progressControl.currentPage = ++self.progressControl.currentPage;
		
    [self.progressControl updateCurrentPageDisplay];
	}
}

- (void) decreaseProgress
{
  if (self.progressControl.currentPage >= 0)
	{
		self.progressControl.currentPage = --self.progressControl.currentPage;
		
    [self.progressControl updateCurrentPageDisplay];
	}
}

@end
