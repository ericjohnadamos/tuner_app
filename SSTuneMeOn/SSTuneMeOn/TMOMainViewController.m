//
//  TMOMainViewController.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 3/10/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "RIOInterface.h"
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

static const CGFloat kAnimationDuration = 0.35f;

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

@property (nonatomic, retain) TMOTutorialView* tutorialView;

@property (nonatomic, assign) float currentFrequency;

@property (nonatomic, retain) UIView* navBarView;
@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) UIButton* helpButton;
@property (nonatomic, retain) UIButton* notesButton;
@property (nonatomic, retain) TMONoteSelectorView* notesSelectorView;
@property (nonatomic, retain) TMOTunerViewController* tunerViewController;
@property (nonatomic, retain) TMOSplashViewController* splashController;
@property (nonatomic, retain) UIImageView* stageView;

@end


@implementation TMOMainViewController

@synthesize rioRef = m_rioRef;
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

#pragma mark - Memory management

- (void) didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  
  /* TODO: Implement purge views */
}

- (void) dealloc
{
  self.tutorialView = nil;
  
  self.navBarView = nil;
  self.titleLabel = nil;
  self.helpButton = nil;
  self.notesButton = nil;
  self.notesSelectorView = nil;
  self.tunerViewController = nil;
  self.splashController = nil;
  
  [super dealloc];
}

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
  
  /* Manage tutorial view */
  TMOUserSettings* userSettings = [TMOUserSettings sharedInstance];
  if ([userSettings isFirstTime])
  {
    userSettings.firstTime = NO;
  
    self.tutorialView.alpha = 1.0f;
    self.tutorialView.hidden = NO;
  }
}

#pragma mark - Lazy loaders

- (RIOInterface*) rioRef
{
  if (m_rioRef == nil)
  {
    RIOInterface* rioRef = [RIOInterface sharedInstance];
    
    m_rioRef = rioRef;
  }
  
  return m_rioRef;
}

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
    
    m_helpButton = [helpButton retain];
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
    
    m_notesButton = [notesButton retain];
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
  [self.rioRef startListening: self];
}

- (void) stopListener
{
  [self.rioRef stopListening];
}

#pragma mark - TMOFrequencyListener

- (void) frequencyChangedWithValue: (float) newFrequency
{
  /* This method gets called by the rendering function. Update the UI with
   * the character type and store it in our string.
   */

  @autoreleasepool
  {
    self.currentFrequency = newFrequency;

    [self.tunerViewController frequencyChangedWithValue: newFrequency];
  }
}

#pragma mark - TMOTutorialViewDelegate methods

- (void) tutorialView: (TMOTutorialView*) tutorialView
         didSetHidden: (BOOL)             isHidden
{
  /* If the tutorial view is set to hidden, then begin the frequency listener.
   * Otherwise, disable it.
   */
  if (isHidden)
  {
    [self startListener];
  }
  else
  {
    [self stopListener];
  }
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
  [self.tunerViewController updateWithNote: note noteGroup: noteGroup];
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
  [self startListener];
  
  [UIView animateWithDuration: 0.35f
                   animations:
    ^{
        self.splashController.view.alpha = 0.0f;
        self.tunerViewController.view.alpha = 1.0f;
        self.navBarView.alpha = 1.0f;
     }
                   completion: ^(BOOL finished)
    {
     
       [self.splashController.view removeFromSuperview];
       [self.splashController removeFromParentViewController];
       self.splashController = nil;
     }];
}

@end
