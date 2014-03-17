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
}

@end
