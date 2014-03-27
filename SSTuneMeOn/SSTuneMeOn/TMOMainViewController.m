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

@end


@implementation TMOMainViewController

@synthesize currentFrequency;

@synthesize helpButton = m_helpButton;
@synthesize notesButton = m_notesButton;

#pragma mark - Memory management

- (void) didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void) dealloc
{
  self.helpButton = nil;
  self.notesButton = nil;
  
  [super dealloc];
}

#pragma mark - Application lifecycle

- (void) viewDidLoad
{
  [super viewDidLoad];
  
  [self stopListener];
  [self startListener];
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
    
    
    [notesButton setImage: [UIImage imageNamed: @"notes"]
                 forState: UIControlStateNormal];
    
    [notesButton addTarget: self
                    action: @selector(didTapNotesButton)
          forControlEvents: UIControlEventTouchUpInside];
    
    m_notesButton = [notesButton retain];
  }
  
  return m_notesButton;
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
  
  NSLog(@"current frequency: %f", self.currentFrequency);
}

- (void) updateFrequencyLabel
{
  /* TODO: Implement me */
}

@end
