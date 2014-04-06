//
//  TMOMainViewController.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 3/10/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMOMainViewController.h"

#import "RIOInterface.h"


CGFloat kXOffset = 20.0f;
CGFloat kYOffset = 30.0f;
CGFloat kButtonDimension = 30.0f;

@interface TMOMainViewController ()

@property (nonatomic, assign) float currentFrequency;

@property (nonatomic, retain) UIButton* helpButton;
@property (nonatomic, retain) UIButton* notesButton;

@property (nonatomic, retain) UILabel* frequencyLabel;
@property (nonatomic, retain) UILabel* hertzLabel;

@end


@implementation TMOMainViewController

@synthesize currentFrequency;

@synthesize helpButton = m_helpButton;
@synthesize notesButton = m_notesButton;

@synthesize frequencyLabel = m_frequencyLabel;
@synthesize hertzLabel = m_hertzLabel;

#pragma mark - Memory management

- (void) didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  
  /* TODO: Implement purge views */
}

- (void) dealloc
{
  self.helpButton = nil;
  self.notesButton = nil;
  
  self.frequencyLabel = nil;
  self.hertzLabel = nil;
  
  [super dealloc];
}

#pragma mark - Application lifecycle

- (void) viewDidLoad
{
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor blackColor];
  
  /* Begin calculations of frequency and hertz frames */
  CGFloat width = 150.0f;
  CGFloat height = 44.0f;
  
  CGFloat xPointForFrequency = CGRectGetMidX(self.view.bounds) - (width * 0.5f);
  CGFloat yPointForFrequency = 200.0f;
  
  self.frequencyLabel.frame
    = CGRectMake(xPointForFrequency, yPointForFrequency, width, height);
  
  CGFloat xPointForHertz = CGRectGetMaxX(self.frequencyLabel.frame);
  CGFloat yPointForHertz = 200.0f;
  
  self.hertzLabel.frame
    = CGRectMake(xPointForHertz, yPointForHertz, width, height);
  
  /* Add as subviews */
  [self.view addSubview: self.helpButton];
  [self.view addSubview: self.notesButton];
  [self.view addSubview: self.frequencyLabel];
  [self.view addSubview: self.hertzLabel];
}

#pragma mark - Lazy loaders

- (UIButton*) helpButton
{
  if (m_helpButton == nil)
  {
    UIButton* helpButton = [UIButton buttonWithType: UIButtonTypeCustom];
    
    helpButton.frame
      = CGRectMake(kXOffset, kYOffset, kButtonDimension, kButtonDimension);
    
    [helpButton setImage: [UIImage imageNamed: @"help"]
                forState: UIControlStateNormal];
    
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
    UIButton* notesButton = [UIButton buttonWithType: UIButtonTypeCustom];
    
    CGFloat notesXOffset
      = (self.view.bounds.size.width - kButtonDimension) - kXOffset;
    notesButton.frame
      = CGRectMake(notesXOffset, kYOffset, kButtonDimension, kButtonDimension);
    
    [notesButton setImage: [UIImage imageNamed: @"notes"]
                 forState: UIControlStateNormal];
    
    [notesButton addTarget: self
                    action: @selector(didTapNotesButton)
          forControlEvents: UIControlEventTouchUpInside];
    
    m_notesButton = [notesButton retain];
  }
  
  return m_notesButton;
}

- (UILabel*) frequencyLabel
{
  if (m_frequencyLabel == nil)
  {
    UILabel* frequencyLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    
    frequencyLabel.font = [UIFont boldSystemFontOfSize: 24.0f];
    frequencyLabel.textColor = [UIColor orangeColor];
    frequencyLabel.textAlignment = NSTextAlignmentRight;
    
    m_frequencyLabel = frequencyLabel;
  }
  
  return m_frequencyLabel;
}

- (UILabel*) hertzLabel
{
  if (m_hertzLabel == nil)
  {
    UILabel* hertzLabel = [[UILabel alloc] initWithFrame: CGRectZero];
    
    hertzLabel.font = [UIFont systemFontOfSize: 20.0f];
    hertzLabel.textColor = [UIColor orangeColor];
    hertzLabel.textAlignment = NSTextAlignmentLeft;
    hertzLabel.text = @"Hz";
    
    m_hertzLabel = hertzLabel;
  }
  
  return m_hertzLabel;
}

#pragma mark - Event handlers

- (void) didTapHelpButton
{
  /* TODO: Implement me */
}

- (void) didTapNotesButton
{
  /* TODO: Implement me */
}

#pragma mark - Control listeners

- (void) startListener
{
  [[RIOInterface sharedInstance] startListening: self];
}

- (void) stopListener
{
  [[RIOInterface sharedInstance] stopListening];
}

#pragma mark - Key Management

- (void) frequencyChangedWithValue: (float) newFrequency
{
  /* This method gets called by the rendering function. Update the UI with
   * the character type and store it in our string.
   */
	self.currentFrequency = newFrequency;
  
  [self performSelectorInBackground: @selector(updateFrequencyLabel)
                         withObject: nil];
}

- (void) updateFrequencyLabel
{
  self.frequencyLabel.text
    = [NSString stringWithFormat: @"%.f", self.currentFrequency];
}

@end
