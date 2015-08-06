//
//  TMOProgressDot.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos on 6/26/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMOProgressDot.h"
#import "TMOStandardTheme.h"

@interface TMOProgressDot()

@end

@implementation TMOProgressDot

#pragma mark - Synthesize properties

@synthesize fillColor = m_fillColor;
@synthesize strokeColor = m_strokeColor;

#pragma mark - Memory management

- (void) dealloc
{
  self.fillColor = nil;
}

#pragma mark - Lazy loaders

- (UIColor*) fillColor
{
  if (m_fillColor == nil)
  {
    m_fillColor = [UIColor clearColor];
  }
  
  return m_fillColor;
}

- (void) setFillColor: (UIColor*) fillColor
{
  m_fillColor = fillColor;
}

- (UIColor*) strokeColor
{
  if (m_strokeColor == nil)
  {
    m_strokeColor = [UIColor colorWithRed: 102 / 255.0f
                                    green: 102 / 255.0f
                                     blue: 102 / 255.0f
                                    alpha: 1.0f];
  }
  
  return m_strokeColor;
}

#pragma mark - Layout

- (void) drawRect: (CGRect) rect
{
  [super drawRect: rect];
  
  /*
   * Draw a circle
   */
  
  /* Get the context reference */
  CGContextRef contextRef = UIGraphicsGetCurrentContext();

  CGContextSetLineWidth(contextRef, 0.5f);
  
  CGContextSetStrokeColorWithColor(contextRef, self.strokeColor.CGColor);
  CGContextSetFillColorWithColor(contextRef, self.fillColor.CGColor);
  
  CGContextAddArc(contextRef,
                  rect.size.width * 0.5f,
                  rect.size.width * 0.5f,
                  (rect.size.width * 0.5f) - 0.50f,
                  0.0f,
                  2.0f * 3.1415926535898f,
                  1.0f);
  CGContextDrawPath(contextRef, kCGPathFillStroke);
}

- (void) setSelected: (BOOL) selected
            animated: (BOOL) animated
{
  /* Handle the updates here */
  
  if (selected)
  {
    self.fillColor = [UIColor greenColor];
  }
  else
  {
    self.fillColor = [UIColor clearColor];
  }
}

@end
