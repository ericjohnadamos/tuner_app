//
//  TMOProgressControl.m
//  SSTuneMeOn
//
//  Created by Eric John Adamos on 8/9/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMOProgressControl.h"

#define kDotDiameter 4.0f
#define kDotSpace 12.0f

@implementation TMOProgressControl

#pragma mark - Synthesize properties

@synthesize numberOfPages = m_numberOfPages;
@synthesize currentPage = m_currentPage;
@synthesize hidesForSinglePage = m_hidesForSinglePage;
@synthesize defersCurrentPageDisplay = m_defersCurrentPageDisplay;

@synthesize type = m_type;
@synthesize onColor = m_onColor;
@synthesize offColor = m_offColor;
@synthesize indicatorDiameter = m_indicatorDiameter;
@synthesize indicatorSpace = m_indicatorSpace;


#pragma mark - Memory deallocation

- (void) dealloc
{
  self.onColor = nil;
  self.offColor = nil;
	
	[super dealloc];
}

#pragma mark - Initalizers

- (id) initWithType: (DDPageControlType) theType
{
	self = [self initWithFrame: CGRectZero];
  
  if (self != nil)
  {
    [self setType: theType];
  }
  
	return self;
}

- (id) init
{
	self = [self initWithFrame: CGRectZero];
  
	return self;
}

- (id) initWithFrame: (CGRect) frame
{
  self = [super initWithFrame: CGRectZero];
  
	if (self != nil)
	{
		self.backgroundColor = [UIColor clearColor] ;
	}
  
	return self ;
}

#pragma mark - Draw rect

- (void) drawRect: (CGRect) rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	CGContextSetAllowsAntialiasing(context, TRUE);
	
	CGFloat diameter
    = (self.indicatorDiameter > 0) ? self.indicatorDiameter : kDotDiameter;
	CGFloat space = (self.indicatorSpace > 0) ? self.indicatorSpace : kDotSpace;
	
	CGRect currentBounds = self.bounds;
	CGFloat dotsWidth
    = self.numberOfPages * diameter + MAX(0, self.numberOfPages - 1) * space;
	CGFloat x = CGRectGetMidX(currentBounds) - dotsWidth / 2;
	CGFloat y = CGRectGetMidY(currentBounds) - diameter / 2;
	
	UIColor* drawOnColor
    = self.onColor ? self.onColor : [UIColor colorWithWhite: 1.0f
                                                      alpha: 1.0f];
	UIColor* drawOffColor
    = self.offColor ? self.offColor : [UIColor colorWithWhite: 0.7f
                                                        alpha: 0.5f];
	
	for (int i = 0; i < self.numberOfPages; i++)
	{
		CGRect dotRect = CGRectMake(x, y, diameter, diameter);
		
		if (i <= self.currentPage)
		{
			if (   self.type == DDPageControlTypeOnFullOffFull
          || self.type == DDPageControlTypeOnFullOffEmpty)
			{
				CGContextSetFillColorWithColor(context, drawOnColor.CGColor);
				CGContextFillEllipseInRect(context, CGRectInset(dotRect, -0.5f, -0.5f));
			}
			else
			{
				CGContextSetStrokeColorWithColor(context, drawOnColor.CGColor);
				CGContextStrokeEllipseInRect(context, dotRect);
			}
		}
		else
		{
			if (   self.type == DDPageControlTypeOnEmptyOffEmpty
          || self.type == DDPageControlTypeOnFullOffEmpty)
			{
				CGContextSetStrokeColorWithColor(context, drawOffColor.CGColor);
				CGContextStrokeEllipseInRect(context, dotRect);
			}
			else
			{
				CGContextSetFillColorWithColor(context, drawOffColor.CGColor);
				CGContextFillEllipseInRect(context, CGRectInset(dotRect, -0.5f, -0.5f));
			}
		}
    
		x += diameter + space ;
	}

	CGContextRestoreGState(context);
}

#pragma mark -
#pragma mark Accessors

- (void) setCurrentPage: (NSInteger) pageNumber
{
	if (m_currentPage == pageNumber)
  {
    return;
  }

	m_currentPage = MIN(MAX(-1, pageNumber), self.numberOfPages - 1);
	
	if (!self.defersCurrentPageDisplay)
  {
    [self setNeedsDisplay];
  }
}

- (NSInteger) currentPage
{
  return m_currentPage;
}

- (void) setNumberOfPages: (NSInteger) numOfPages
{
	m_numberOfPages = MAX(0, numOfPages);
	self.currentPage = MIN(MAX(0, self.currentPage), m_numberOfPages - 1);
	
	/* Correct the bounds accordingly */
	self.bounds = self.bounds;
	
	[self setNeedsDisplay];
  [self setHidden: (self.hidesForSinglePage && (m_numberOfPages < 2))];
}

- (NSInteger) numberOfPages
{
  return m_numberOfPages;
}

- (void) setHidesForSinglePage: (BOOL) hide
{
	m_hidesForSinglePage = hide;
	
	if (m_hidesForSinglePage && (self.numberOfPages < 2))
  {
    [self setHidden: YES];
  }
}

- (BOOL) hidesForSinglePage
{
  return m_hidesForSinglePage;
}

- (void) setDefersCurrentPageDisplay: (BOOL) defers
{
  m_defersCurrentPageDisplay = defers;
}

- (BOOL) defersCurrentPageDisplay
{
  return m_defersCurrentPageDisplay;
}

- (void) setType: (DDPageControlType) aType
{
  m_type = aType;
	
	[self setNeedsDisplay];
}

- (DDPageControlType) type
{
  return m_type;
}

- (void) setOnColor: (UIColor*) aColor
{
	[aColor retain];
  
  m_onColor = nil;
  m_onColor = aColor;
	
	[self setNeedsDisplay];
}

- (UIColor*) onColor
{
  return m_onColor;
}

- (void) setOffColor: (UIColor*) aColor
{
	[aColor retain];
  
  m_offColor = nil;
  m_offColor = aColor;
	
	[self setNeedsDisplay];
}

- (UIColor*) offColor
{
  return m_offColor;
}

- (void) setIndicatorDiameter: (CGFloat) aDiameter
{
	m_indicatorDiameter = aDiameter;
	
	self.bounds = self.bounds;
	
	[self setNeedsDisplay];
}

- (CGFloat) indicatorDiameter
{
  return m_indicatorDiameter;
}

- (void) setIndicatorSpace: (CGFloat) aSpace
{
	m_indicatorSpace = aSpace;
	
	self.bounds = self.bounds;
	
	[self setNeedsDisplay];
}

- (CGFloat) indicatorSpace
{
  return m_indicatorSpace;
}

- (void) setFrame: (CGRect) aFrame
{
	aFrame.size = [self sizeForNumberOfPages: self.numberOfPages];
  
	super.frame = aFrame;
}

- (void) setBounds: (CGRect) aBounds
{
	aBounds.size = [self sizeForNumberOfPages: self.numberOfPages];
  
	super.bounds = aBounds;
}

#pragma mark - UIPageControl methods

- (void) updateCurrentPageDisplay
{
	if (!self.defersCurrentPageDisplay)
  {
    return;
  }
  
  [self setNeedsDisplay];
}

- (CGSize) sizeForNumberOfPages: (NSInteger) pageCount
{
	CGFloat diameter
    = (self.indicatorDiameter > 0) ? self.indicatorDiameter : kDotDiameter;
	CGFloat space = (self.indicatorSpace > 0) ? self.indicatorSpace : kDotSpace;
	
	return CGSizeMake(pageCount * diameter + (pageCount - 1) * space + 44.0f,
                    MAX(44.0f, diameter + 4.0f)) ;
}

#pragma mark - Touches handlers

- (void) touchesEnded: (NSSet*)   touches
            withEvent: (UIEvent*) event
{
	UITouch* theTouch = [touches anyObject];
	CGPoint touchLocation = [theTouch locationInView: self];
	
	if (touchLocation.x < (self.bounds.size.width / 2))
  {
    self.currentPage = MAX(self.currentPage - 1, 0);
  }
	else
  {
    self.currentPage = MIN(self.currentPage + 1, self.numberOfPages - 1);
  }
  
	[self sendActionsForControlEvents: UIControlEventValueChanged];
}

@end
