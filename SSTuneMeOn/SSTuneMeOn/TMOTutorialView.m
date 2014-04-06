//
//  TMOTutorialView.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 4/6/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMOTutorialView.h"
#import "TMOLocalizedStrings.h"


@interface TMOTutorialView () <UIWebViewDelegate>

@property (nonatomic, retain) UIWebView* tutorialWebView;

@end

@implementation TMOTutorialView

@synthesize tutorialWebView = m_tutorialWebView;

#pragma mark - Memory management

- (void) dealloc
{
  self.tutorialWebView = nil;
  
  [super dealloc];
}

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) frame
{
  self = [super initWithFrame: frame];
  
  if (self != nil)
  {
    [self addSubview: self.tutorialWebView];
    
    [self loadWebView];
  }
  
  return self;
}

#pragma mark - Lazy loaders

- (UIWebView*) tutorialWebView
{
  if (m_tutorialWebView == nil)
  {
    UIWebView* tutorialWebView = [[UIWebView alloc] initWithFrame: self.bounds];
    
    tutorialWebView.delegate = self;
    tutorialWebView.opaque = NO;
    tutorialWebView.backgroundColor = [UIColor clearColor];
    
    tutorialWebView.hidden = YES;
    tutorialWebView.userInteractionEnabled = YES;
    tutorialWebView.multipleTouchEnabled =  YES;
    tutorialWebView.scrollView.scrollEnabled = NO;
    
    NSArray* backgroundSubviews
      = [[[tutorialWebView subviews] objectAtIndex: 0] subviews];
    
    for (UIView* subview in backgroundSubviews)
    {
      if ([subview isKindOfClass: [UIImageView class]])
      {
        subview.hidden = YES;
      }
    }
    
    m_tutorialWebView = tutorialWebView;
  }
  
  return m_tutorialWebView;
}

#pragma mark - UIWebViewDelegate method

- (BOOL)           webView: (UIWebView*)              webView
shouldStartLoadWithRequest: (NSURLRequest*)           request
            navigationType: (UIWebViewNavigationType) navigationType
{
  return YES;
}

- (void) webViewDidStartLoad: (UIWebView*) webView
{
  /* TODO: Implement me */
}

- (void) webViewDidFinishLoad: (UIWebView*) webView
{
  self.tutorialWebView.hidden = NO;
}

- (void)     webView: (UIWebView*) webView
didFailLoadWithError: (NSError*)   error
{
  /* TODO: Implement me */
}

#pragma mark - Private method

- (void) loadWebView
{
  NSString* htmlString
    = [TMOLocalizedStrings stringForKey: kTMOTutorialWebViewText];
  
  [self.tutorialWebView loadHTMLString: htmlString
                               baseURL: nil];
}

@end
