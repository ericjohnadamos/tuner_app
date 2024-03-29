//
//  TMOMainViewController.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 3/10/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMOLocalizedStrings.h"

#import "TMOUserSettings.h"

#import "TMOMainViewController.h"
#import "TMOTutorialView.h"
#import "TMOButtonGenerator.h"
#import "TMOTheme.h"
#import "TMOStandardTheme.h"
#import "TMONoteSelectorView.h"
#import "TMOFrequencyListener.h"
#import "TMOTunerViewController.h"
#import "TMOSplashViewController.h"
#import "TMODancingAnimationView.h"
#import "TMOAnimationHelper.h"
#import "TMOTuneEventHandler.h"
#import "TMOPitchDetector.h"
#import "TMONoteHelper.h"
#import "TMOKVOService.h"

static const CGFloat kAnimationDuration = 0.35f;
static vDSP_Length const FFTViewControllerFFTWindowSize = 4096;

#pragma mark - Navbar Constants

static const CGFloat kNavBarHeight = 44.0f;
static const CGFloat kNavButtonHeight = 44.0f;
static const CGFloat kNavButtonWidth = 44.0f;
static const CGFloat kTunerViewHeight = 171.0f;;

@interface TMOMainViewController ()
  <TMOFrequencyListener,
   TMOTutorialViewDelegate,
   TMONoteSelectorViewDelegate,
   TMOSplashViewDelegate>

@property (nonatomic, strong) TMOTutorialView* tutorialView;

@property (nonatomic, assign) float currentFrequency;

@property (nonatomic, strong) UIView* navBarView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIButton* helpButton;
@property (nonatomic, strong) UIButton* notesButton;
@property (nonatomic, strong) TMONoteSelectorView* notesSelectorView;
@property (nonatomic, strong) TMOTunerViewController* tunerViewController;
@property (nonatomic, strong) TMOSplashViewController* splashController;
@property (nonatomic, strong) UIImageView* stageView;
@property (nonatomic, strong) TMODancingAnimationView* animationView;
@property (nonatomic, strong) TMOTuneEventHandler* eventHandler;
@property (nonatomic, strong) TMONoteHelper* noteHelper;
@property (nonatomic, strong) TMOKVOService* kvoService;

@end


@implementation TMOMainViewController

@synthesize currentFrequency;

@synthesize tutorialView = m_tutorialView;

@synthesize navBarView = m_navBarView;
@synthesize helpButton = m_helpButton;
@synthesize titleLabel = m_titleLabel;
@synthesize notesButton = m_notesButton;
@synthesize notesSelectorView = m_notesSelectorView;
@synthesize tunerViewController = m_tunerViewController;
@synthesize splashController = m_splashController;
@synthesize stageView = m_stageView;
@synthesize animationView = m_animationView;
@synthesize eventHandler = m_eventHandler;
@synthesize noteHelper = m_noteHelper;
@synthesize kvoService = m_kvoService;

#pragma mark - Application lifecycle

- (void) viewDidLoad
{
  [super viewDidLoad];
  
  if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
  {
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
  
  self.view.backgroundColor = [UIColor blackColor];
  
  /* Add the stage */
  [self.view addSubview: self.stageView];
  [self.view addSubview: self.animationView];
  [self.animationView startAnimating];
  
  [self addChildViewController: self.splashController];
  [self.view addSubview: self.splashController.view];
  
  /* Load tutorial web view */
  [self.tutorialView loadWebView];
  
  /* Add subviews */
  
  /* Add fake nav bar*/
  [self.navBarView addSubview: self.titleLabel];
  [self.navBarView addSubview: self.helpButton];
  [self.navBarView addSubview: self.notesButton];
  [self.view addSubview: self.navBarView];
  
  /* Add tuner view */
  [self addChildViewController: self.tunerViewController];
  [self.view addSubview: self.tunerViewController.view];
  [self.view addSubview: self.notesSelectorView];
  [self.view addSubview: self.tutorialView];
  
  self.tunerViewController.view.alpha = 0.0f;
  self.navBarView.alpha = 0.0f;
  
  __block __weak typeof (self) weakSelf = self;
  
  /* Handle successfull tune events */
  self.eventHandler.callback = ^(BOOL doesPerformCombo)
  {
    if (doesPerformCombo)
    {
    
      [weakSelf.animationView enqueueNextAnimation];
      [weakSelf.tunerViewController increaseProgress];
    }
    else
    {
      [weakSelf.tunerViewController decreaseProgress];
    }
  };
  
  self.medianPitchFollow = [[NSMutableArray alloc] initWithCapacity: 22];
  
  self.noteHelper = [[TMONoteHelper alloc] init];
  
  AVAudioSession* session = [AVAudioSession sharedInstance];
  NSError* error;
  
  [session setCategory: AVAudioSessionCategoryPlayAndRecord
                 error: &error];
  if (error)
  {
    NSLog(@"Error setting up audio session category: %@",
          error.localizedDescription);
  }
  
  [session setActive: YES
               error: &error];
  if (error)
  {
    NSLog(@"Error setting up audio session active: %@",
          error.localizedDescription);
  }
  
  self.audioPlotTime.plotType = EZPlotTypeBuffer;
  
  self.audioPlotFreq.shouldFill = YES;
  self.audioPlotFreq.plotType = EZPlotTypeBuffer;
  self.audioPlotFreq.shouldCenterYAxis = NO;
  
  self.microphone = [EZMicrophone microphoneWithDelegate: self];
  
  /* Create an instance of the EZAudioFFTRolling to keep a history of the
   * incoming audio data and calculate the FFT.
   */
  Float64 sampleRate = self.microphone.audioStreamBasicDescription.mSampleRate;
  self.fft
    = [EZAudioFFTRolling fftWithWindowSize: FFTViewControllerFFTWindowSize
                                sampleRate: sampleRate
                                  delegate: self];
  
  [self.microphone startFetchingAudio];
}

-(void)    microphone: (EZMicrophone*) microphone
     hasAudioReceived: (float **)      buffer
       withBufferSize: (UInt32)        bufferSize
 withNumberOfChannels: (UInt32)        numberOfChannels
{
  /* Calculate the FFT, will trigger EZAudioFFTDelegate */
  [self.fft computeFFTWithBuffer: buffer[0]
                  withBufferSize: bufferSize];
  
  __weak typeof (self) weakSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    [weakSelf.audioPlotTime updateBuffer:buffer[0]
                          withBufferSize:bufferSize];
  });
}

- (void)        fft: (EZAudioFFT*) fft
 updatedWithFFTData: (float*)      fftData
         bufferSize: (vDSP_Length) bufferSize
{
  float maxFrequency = [fft maxFrequency];
  
  NSString* noteName = [EZAudioUtilities
                        noteNameStringForFrequency: maxFrequency
                                     includeOctave: YES];
  
  NSLog(@"%@", [NSString stringWithFormat:
                @"Highest Note: %@,\nFrequency: %.2f",
                noteName, maxFrequency]);
  
  __weak typeof (self) weakSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^
  {
    [weakSelf.audioPlotFreq updateBuffer: fftData
                          withBufferSize: (UInt32)bufferSize];
    
    [self updateToFrequency: maxFrequency];
  });
}

#pragma mark - Lazy loaders

- (TMOTutorialView*) tutorialView
{
  if (m_tutorialView == nil)
  {
    CGRect frame = CGRectMake(0.0f, 20.0f,
                              CGRectGetWidth(self.view.bounds), 220.0f);
    TMOTutorialView* tutorialView
      = [[TMOTutorialView alloc] initWithFrame: frame];
    
    tutorialView.delegate = self;
    tutorialView.alpha = 0.0f;
    tutorialView.hidden = YES;

    m_tutorialView = tutorialView;
  }
  
  return m_tutorialView;
}

- (UIView*) navBarView
{
  if (m_navBarView == nil)
  {
    CGSize viewSize = self.view.frame.size;
    CGFloat statusBarHeight
      = [UIApplication sharedApplication].statusBarFrame.size.height;

    m_navBarView = [[UIView alloc] init];
    m_navBarView.frame = CGRectMake(0.0f,
                                    statusBarHeight,
                                    viewSize.width,
                                    kNavBarHeight);
    TMOTheme* theme = [TMOStandardTheme sharedInstance];
    [theme skinNavigationBar: m_navBarView];
  }
  return m_navBarView;
}

- (UILabel*) titleLabel
{
  if (m_titleLabel == nil)
  {
    CGSize viewSize = self.view.frame.size;
    m_titleLabel = [[UILabel alloc] init];
    m_titleLabel.frame = CGRectMake(kNavButtonWidth,
                                    0.0f,
                                    viewSize.width - (kNavButtonWidth * 2),
                                    kNavBarHeight);
    m_titleLabel.textAlignment = NSTextAlignmentCenter;

    /* Add theming */
    TMOTheme* theme = [TMOStandardTheme sharedInstance];
    [theme skinNavigationTitleLabel: m_titleLabel];
    
    m_titleLabel.text = [TMOLocalizedStrings stringForKey: kTMOAcousticGuitar];
  }
  return m_titleLabel;
}

- (UIButton*) helpButton
{
  if (m_helpButton == nil)
  {
    CGRect frame = CGRectMake(0.0f,
                              0.0f,
                              kNavButtonWidth,
                              kNavButtonHeight);
    UIButton* helpButton = [TMOButtonGenerator helpButtonWithFrame: frame];
    
    [helpButton addTarget: self
                   action: @selector(didTapHelpButton)
         forControlEvents: UIControlEventTouchUpInside];
    
    m_helpButton = helpButton;
  }
  return m_helpButton;
}

- (UIButton*) notesButton
{
  if (m_notesButton == nil)
  {
    CGSize viewSize = self.view.frame.size;
    CGFloat notesXOffset = viewSize.width - kNavButtonWidth;
    CGRect frame = CGRectMake(notesXOffset,
                              0.0f,
                              kNavButtonWidth,
                              kNavButtonHeight);
    UIButton* notesButton
      = [TMOButtonGenerator selectionButtonWithFrame: frame];

    [notesButton addTarget: self
                    action: @selector(didTapNotesButton)
          forControlEvents: UIControlEventTouchUpInside];
    
    m_notesButton = notesButton;
  }
  
  return m_notesButton;
}

- (TMONoteSelectorView*) notesSelectorView
{
  if (m_notesSelectorView == nil)
  {
    CGSize viewSize = self.view.frame.size;
    CGFloat statusBarHeight
      = [UIApplication sharedApplication].statusBarFrame.size.height;
    m_notesSelectorView = [[TMONoteSelectorView alloc] init];
    m_notesSelectorView.frame = CGRectMake(0.0f,
                                           statusBarHeight,
                                           viewSize.width,
                                           viewSize.height);
    m_notesSelectorView.delegate = self;
    m_notesSelectorView.hidden = YES;
  }
  return m_notesSelectorView;
}

- (TMOTunerViewController*) tunerViewController
{
  if (m_tunerViewController == nil)
  {
    CGSize viewSize = self.view.frame.size;
    CGFloat statusBarHeight
      = [UIApplication sharedApplication].statusBarFrame.size.height;
    CGRect frame = CGRectMake(0.0f,
                              kNavBarHeight + statusBarHeight,
                              viewSize.width,
                              kTunerViewHeight);
    m_tunerViewController
      = [[TMOTunerViewController alloc] initWithFrame: frame];
  }
  return m_tunerViewController;
}

- (TMOSplashViewController*) splashController
{
  if (m_splashController == nil)
  {
    m_splashController = [TMOSplashViewController new];
    m_splashController.delegate = self;
  }
  return m_splashController;
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

- (TMODancingAnimationView*) animationView
{
  if (m_animationView == nil)
  {
    CGSize viewSize = self.view.frame.size;
    CGFloat height = 243.0f;
    
    CGFloat statusBarHeight
      = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    CGRect frame
      = CGRectMake(0.0f,
                   viewSize.height - height
                      - kNavBarHeight - statusBarHeight - 20.0f,
                   viewSize.width,
                   height);
    
    m_animationView = [[TMODancingAnimationView alloc] initWithFrame: frame];
  }
  return m_animationView;
}

- (TMOTuneEventHandler*) eventHandler
{
  if (m_eventHandler == nil)
  {
    m_eventHandler = [TMOTuneEventHandler new];
  }
  return m_eventHandler;
}

#pragma mark - Event handlers

- (void) didTapHelpButton
{
  self.tutorialView.alpha = 0.0f;
  self.tutorialView.hidden = NO;
  
  [UIView animateWithDuration: kAnimationDuration
                   animations: ^(void)
   {
     self.tutorialView.alpha = 1.0f;
   }];
}

- (void) didTapNotesButton
{
  if (self.notesSelectorView.hidden)
  {
    [self stopListener];
    self.notesButton.enabled = NO;
  }

  self.notesSelectorView.alpha = 0.0f;
  self.notesSelectorView.hidden = NO;
  
  [UIView animateWithDuration: kAnimationDuration
                   animations: ^(void)
   {
     self.notesSelectorView.alpha = 1.0f;
   }];
}

#pragma mark - Control listeners

- (void) startListener
{
  [self.microphone startFetchingAudio];
}

- (void) stopListener
{
  [self.microphone stopFetchingAudio];
}

#pragma mark - TMOFrequencyListener

- (void) frequencyChangedWithValue: (float) newFrequency
{
  @autoreleasepool
  {
    /* This method gets called by the rendering function. Update the UI with
     * the character type and store it in our string.
     */
    double value = newFrequency;
    
    NSNumber* nsnum = [NSNumber numberWithDouble: value];
    
    [self.medianPitchFollow insertObject: nsnum
                                 atIndex: 0];
    
    if (self.medianPitchFollow.count > 22)
    {
      [self.medianPitchFollow removeObjectAtIndex:
       self.medianPitchFollow.count - 1];
    }
    
    double median = 0;
    
    if (self.medianPitchFollow.count >= 2)
    {
      NSSortDescriptor* highestToLowest
        = [NSSortDescriptor sortDescriptorWithKey: @"self"
                                        ascending: NO];
      
      NSMutableArray* tempSort = [NSMutableArray arrayWithArray:
                                  self.medianPitchFollow];
      
      [tempSort sortUsingDescriptors: [NSArray arrayWithObject: highestToLowest]];
      
      if (tempSort.count % 2 == 0)
      {
        double first = 0, second = 0;
        
        first = [[tempSort objectAtIndex: tempSort.count /2 - 1] doubleValue];
        second = [[tempSort objectAtIndex:tempSort.count / 2] doubleValue];
        median = (first+second) / 2;
        value = median;
      }
      else
      {
        median = [[tempSort objectAtIndex: tempSort.count / 2] doubleValue];
        value = median;
      }
      
      [tempSort removeAllObjects];
      tempSort = nil;
    }
    self.currentFrequency = value;

    dispatch_async(dispatch_get_main_queue(), ^(void)
    {
      [self.tunerViewController frequencyChangedWithValue: value];
      [self.eventHandler frequencyChangedWithValue: value];
    });
  }
}

#pragma mark - TMOTutorialViewDelegate methods

- (void) tutorialView: (TMOTutorialView*) tutorialView
         didSetHidden: (BOOL)             isHidden
{
  /* If the tutorial view is set to hidden, then begin the frequency listener.
   * Otherwise, disable it.
   */
  SEL listenerAction = @selector(startListener);
  if (!isHidden)
  {
    listenerAction = @selector(stopListener);
  }
  
  [self performSelectorOnMainThread: @selector(startListener)
                         withObject: nil
                      waitUntilDone: YES];
}

- (void) tutorialView: (TMOTutorialView*) tutorialView
     didTapOkayButton: (UIButton*)        okayButton
{
  /* Override the okay button event handler inside the tutorial view */
  [UIView animateWithDuration: kAnimationDuration
                   animations: ^(void)
   {
     self.tutorialView.alpha = 0.0f;
   }
                   completion: ^(BOOL isFinished)
   {
     self.tutorialView.alpha = 1.0f;
     self.tutorialView.hidden = YES;
   }];
}

#pragma mark - TMONoteSelectorViewDelegate methods

- (void) noteSelectorView: (TMONoteSelectorView*) noteSelector
            didSelectNote: (TMONote*)             note
            fromNoteGroup: (TMONoteGroup*)        noteGroup
{
  [self.tunerViewController updateWithNote: note
                                 noteGroup: noteGroup];
}

- (void) noteSelectorViewDidDismiss: (TMONoteSelectorView*) noteSelectorView
{
  self.notesButton.enabled = YES;
  [self startListener];
}

#pragma mark - TMOSplashViewDelegate

- (void) splashViewControllerDidFinishAnimation:
          (TMOSplashViewController*) controller
{
  TMOUserSettings* userSettings = [TMOUserSettings sharedInstance];
  
  BOOL isFirstTime = [userSettings isFirstTime];
  
  [UIView animateWithDuration: 0.35f
                   animations:
    ^{
        /* Manage tutorial view */
        if (isFirstTime)
        {
          userSettings.firstTime = NO;
          
          self.tutorialView.alpha = 1.0f;
          self.tutorialView.hidden = NO;
        }
        
        self.splashController.view.alpha = 0.0f;
        self.tunerViewController.view.alpha = 1.0f;
        self.navBarView.alpha = 1.0f;
     }
                   completion: ^(BOOL finished)
    {
     
       [self.splashController.view removeFromSuperview];
       [self.splashController removeFromParentViewController];
     }];
}

- (void) updateToFrequency: (double) frequency
{
  [self.eventHandler frequencyChangedWithValue: frequency];
  [self.tunerViewController frequencyChangedWithValue: frequency];
}

@end
