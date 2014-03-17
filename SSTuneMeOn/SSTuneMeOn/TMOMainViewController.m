//
//  TMOMainViewController.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 3/10/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMOMainViewController.h"

#import "RIOInterface.h"


@interface TMOMainViewController ()

@property (nonatomic, assign) float currentFrequency;

@end


@implementation TMOMainViewController

@synthesize currentFrequency;

#pragma mark - Memory management

- (void) didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (void) dealloc
{
  [super dealloc];
}

#pragma mark - Application lifecycle

- (void) viewDidLoad
{
  [super viewDidLoad];
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
