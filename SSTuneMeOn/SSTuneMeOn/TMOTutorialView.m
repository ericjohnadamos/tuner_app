//
//  TMOTutorialView.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos <ericjohnadamos@gmail.com> on 4/6/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "TMOTutorialView.h"
#import "TMOLocalizedStrings.h"


static const CGFloat kAnimationDuration = 0.35f;


@interface TMOTutorialView () <UIWebViewDelegate>

@property (nonatomic, retain) UIWebView* tutorialWebView;
@property (nonatomic, retain) UIButton* okayButton;

@end

@implementation TMOTutorialView

@synthesize tutorialWebView = m_tutorialWebView;
@synthesize okayButton = m_okayButton;

#pragma mark - Memory management

- (void) dealloc
{
  self.delegate = nil;
  self.tutorialWebView = nil;
  self.okayButton = nil;
  
  [super dealloc];
}

#pragma mark - Initializer

- (id) initWithFrame: (CGRect) frame
{
  self = [super initWithFrame: frame];
  
  if (self != nil)
  {
    self.backgroundColor = [UIColor blackColor];
    
    [self setupComponents];
    
    [self addSubview: self.tutorialWebView];
    [self addSubview: self.okayButton];
  }
  
  return self;
}

#pragma mark - Lazy loaders

- (UIWebView*) tutorialWebView
{
  if (m_tutorialWebView == nil)
  {
    UIWebView* tutorialWebView = [[UIWebView alloc] initWithFrame: CGRectZero];
    
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

- (UIButton*) okayButton
{
  if (m_okayButton == nil)
  {
    UIButton* okayButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    
    NSString* text = [TMOLocalizedStrings stringForKey:
                      kTMOTutorialOkayButtonText];
    
    [okayButton setTitle: text
                forState: UIControlStateNormal];
    
    [okayButton setTitleColor: [UIColor whiteColor]
                     forState: UIControlStateNormal];
    
    okayButton.layer.borderWidth = 1.0f;
    okayButton.layer.borderColor = [UIColor whiteColor].CGColor;
    okayButton.layer.cornerRadius = 5.0f;
    
    [okayButton addTarget: self
                   action: @selector(didTapOkayButton)
         forControlEvents: UIControlEventTouchUpInside];
    
    m_okayButton = [okayButton retain];
  }
  
  return m_okayButton;
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

- (void) setupComponents
{
  CGRect viewBounds = self.bounds;
  CGPoint viewPoint = self.center;
  CGFloat buttonWidth = 100.0f;
  CGFloat buttonHeight = 30.0f;
  
  self.tutorialWebView.frame
    = CGRectMake(0.0f,
                 0.0f,
                 viewBounds.size.width,
                 viewBounds.size.height - buttonHeight);
  
  CGFloat webViewMaxY = CGRectGetMaxY(self.tutorialWebView.frame);
  
  CGRect okayButtonFrame = CGRectMake(viewPoint.x - (buttonWidth * 0.5f),
                                      webViewMaxY,
                                      buttonWidth,
                                      buttonHeight);
  self.okayButton.frame = okayButtonFrame;
}

- (void) didTapOkayButton
{
  if (   self.delegate != nil
      && [self.delegate respondsToSelector:
          @selector(tutorialView:didTapOkayButton:)])
  {
    [self.delegate tutorialView: self
               didTapOkayButton: self.okayButton];
  }
  else
  {
    [UIView animateWithDuration: kAnimationDuration
                     animations: ^(void)
     {
       self.alpha = 0.0f;
     }
                     completion: ^(BOOL isFinished)
     {
       self.alpha = 1.0f;
       self.hidden = YES;
     }];
  }
}

@end
