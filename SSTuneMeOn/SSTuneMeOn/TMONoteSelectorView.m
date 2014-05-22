//
//  TMONoteSelectorView.m
//  SSTuneMeOn
//
//  Created by Kevin Bernard R. San Gaspar on 5/3/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import "TMONoteSelectorView.h"
#import "TMONotesOrganizer.h"
#import "TMONoteGroup.h"
#import "TMONote.h"
#import "UIColor+HexString.h"
#import "TMOStandardTheme.h"
#import "TMOButtonGenerator.h"
#import "TMOLocalizedStrings.h"
#import "TMOUserSettings.h"

@interface TMONoteSelectorView ()
  <UIPickerViewDataSource,
   UIPickerViewDelegate>

@property (nonatomic, assign) TMOTheme* theme;
@property (nonatomic, retain) UIPickerView* pickerView;
@property (nonatomic, retain) NSArray* noteGroups;
@property (nonatomic, retain) TMONoteGroup* selectedGroup;
@property (nonatomic, retain) TMONote* selectedNote;
@property (nonatomic, retain) UIView* navBarView;
@property (nonatomic, retain) UIButton* doneButton;
@property (nonatomic, retain) UIButton* cancelButton;
@property (nonatomic, retain) UILabel* titleLabel;
@property (nonatomic, retain) UIView* iconContainer;
@property (nonatomic, retain) UIImageView* iconView;

@end

static const CGFloat kPickerNavbarHeight = 44.0f;
static const CGFloat kPickerWidth = 256.0f;
static const CGFloat kPickerHeight = 216.0f;
static const CGFloat kPickerOriginYOffset = 20.0f;
static const CGFloat kNavBarHeight = 44.0f;
static const CGFloat kNavButtonHeight = 44.0f;
static const CGFloat kNavButtonWidth = 44.0f;
static const CGFloat kStringIconWidth = 10.0f;
static const CGFloat kStringIconHeight = 21.0f;

@implementation TMONoteSelectorView
@synthesize theme = m_theme;
@synthesize pickerView = m_pickerView;
@synthesize noteGroups = m_noteGroups;
@synthesize selectedGroup = m_selectedGroup;
@synthesize selectedNote = m_selectedNote;
@synthesize navBarView = m_navBarView;
@synthesize doneButton = m_doneButton;
@synthesize cancelButton = m_cancelButton;
@synthesize titleLabel = m_titleLabel;
@synthesize iconContainer = m_iconContainer;
@synthesize iconView = m_iconView;
@synthesize delegate = m_delegate;

#pragma mark - Memory management

- (void) dealloc
{
  self.theme = nil;
  self.pickerView = nil;
  self.noteGroups = nil;
  self.selectedGroup = nil;
  self.selectedNote = nil;
  self.navBarView = nil;
  self.doneButton = nil;
  self.cancelButton = nil;
  self.titleLabel = nil;
  self.iconContainer = nil;
  self.iconView = nil;
  self.delegate = nil;
  [super dealloc];
}

#pragma mark - Initializers

- (id) init
{
  if (self = [super init])
  {
    [self initializeViews];
  }
  return self;
}

- (id) initWithFrame: (CGRect) frame
{
  if (self = [super initWithFrame: frame])
  {
    [self initializeViews];
  }
  return self;
}

#pragma mark - View getters

- (UIPickerView*) pickerView
{
  if (m_pickerView == nil)
  {
    CGRect frame = CGRectMake(0.0f,
                              kPickerNavbarHeight - kPickerOriginYOffset,
                              kPickerWidth,
                              kPickerHeight);
    m_pickerView = [[UIPickerView alloc] initWithFrame: frame];
    m_pickerView.dataSource = self;
    m_pickerView.delegate = self;
    [self.theme skinNotesPickerView: m_pickerView];
  }
  return m_pickerView;
}

- (UIView*) navBarView
{
  if (m_navBarView == nil)
  {
    CGSize viewSize = [[UIScreen mainScreen] bounds].size;
    m_navBarView = [[UIView alloc] init];
    m_navBarView.frame = CGRectMake(0.0f,
                                    0.0f,
                                    viewSize.width,
                                    kNavBarHeight);
    [self.theme skinNavigationBar: m_navBarView];
  }
  return m_navBarView;
}

- (UIButton*) cancelButton
{
  if (m_cancelButton == nil)
  {
    CGRect frame = CGRectMake(0.0f,
                              0.0f,
                              kNavButtonWidth,
                              kNavButtonHeight);
    
    UIButton* cancelButton = [TMOButtonGenerator cancelButtonWithFrame: frame];
    
    [cancelButton addTarget: self
                     action: @selector(didTapCancelButton:)
           forControlEvents: UIControlEventTouchUpInside];
    
    m_cancelButton = [cancelButton retain];
  }
  return m_cancelButton;
}

- (UIButton*) doneButton
{
  if (m_doneButton == nil)
  {
    CGSize viewSize = [[UIScreen mainScreen] bounds].size;
    CGFloat notesXOffset = viewSize.width - kNavButtonWidth;
    
    CGRect frame = CGRectMake(notesXOffset,
                              0.0f,
                              kNavButtonWidth,
                              kNavButtonHeight);
    UIButton* doneButton
      = [TMOButtonGenerator doneButtonWithFrame: frame];

    [doneButton addTarget: self
                 action: @selector(didTapDoneButton:)
       forControlEvents: UIControlEventTouchUpInside];

    m_doneButton = [doneButton retain];
  }
  return m_doneButton;
}

- (UILabel*) titleLabel
{
  if (m_titleLabel == nil)
  {
    CGSize viewSize = [[UIScreen mainScreen] bounds].size;
    m_titleLabel = [UILabel new];
    m_titleLabel.frame = CGRectMake(kNavButtonWidth,
                                    0.0f,
                                    viewSize.width - (kNavButtonWidth * 2),
                                    kNavBarHeight);
    m_titleLabel.textAlignment = NSTextAlignmentCenter;
    /* Add theming */
    [self.theme skinNavigationTitleLabel: m_titleLabel];
    m_titleLabel.text
      = [TMOLocalizedStrings stringForKey: kTMONoteSelectorNavTitle];
  }
  return m_titleLabel;
}

- (UIView*) iconContainer
{
  if (m_iconContainer == nil)
  {
    CGSize viewSize = [[UIScreen mainScreen] bounds].size;
    m_iconContainer = [UIView new];
    m_iconContainer.frame = CGRectMake(kPickerWidth,
                                       kNavBarHeight - kPickerOriginYOffset,
                                       viewSize.width - kPickerWidth,
                                       kPickerHeight);
    m_iconContainer.backgroundColor = [UIColor blackColor];
  }
  return m_iconContainer;
}

- (UIImageView*) iconView
{
  if (m_iconView == nil)
  {
    /* Warning: Call to iconContainer lazyloader */
    CGSize containerSize = self.iconContainer.frame.size;
    m_iconView = [UIImageView new];
    m_iconView.frame
      = CGRectMake((containerSize.width - kStringIconWidth) / 2,
                   (containerSize.height - kStringIconHeight) / 2,
                   kStringIconWidth,
                   kStringIconHeight);
    m_iconView.image = [self.theme iconForSixStringsWithIndex: 0];
  }
  return m_iconView;
}

#pragma mark - Getters

- (TMOTheme*) theme
{
  if (m_theme == nil)
  {
    m_theme = [TMOStandardTheme sharedInstance];
  }
  return m_theme;
}

- (NSArray*) noteGroups
{
  if (m_noteGroups == nil)
  {
    m_noteGroups = [[TMONotesOrganizer sharedInstance] allGroups];
    [m_noteGroups retain];
  }
  return m_noteGroups;
}

- (TMONoteGroup*) selectedGroup
{
  if (m_selectedGroup == nil)
  {
    /* Warning: Call to noteGroups lazy loader */
    /* Retrive index from settings */
    NSInteger index = [TMOUserSettings sharedInstance].noteGroupIndex;
    m_selectedGroup = self.noteGroups[index];
    [m_selectedGroup retain];
  }
  return m_selectedGroup;
}

- (TMONote*) selectedNote
{
  if (m_selectedNote == nil)
  {
    /* Warning: Call to selectedGroup lazy loader */
    /* Retrive index from settings */
    NSInteger index = [TMOUserSettings sharedInstance].noteIndex;
    m_selectedNote = self.selectedGroup.notes[index];
    [m_selectedNote retain];
  }
  return m_selectedNote;
}

#pragma mark - Event Handlers

- (void) didTapDoneButton: (id) sender
{
  void (^block) (void) =
  ^{
    NSInteger groupIndex = [self.pickerView selectedRowInComponent: 0];
    NSInteger noteIndex = [self.pickerView selectedRowInComponent: 1];
    
    /* Save settings */
    TMOUserSettings* settings = [TMOUserSettings sharedInstance];
    settings.noteIndex = noteIndex;
    settings.noteGroupIndex = groupIndex;
    
    /* Notify delegate */
    if (self.delegate != nil)
    {
      [self.delegate noteSelectorView: self
                        didSelectNote: self.selectedNote
                        fromNoteGroup: self.selectedGroup];
    }
    
    [self dismiss];
  };
  
  /* Dispatch this so we are sure that the pickerView:didSelectRow 
     has already been called */
  dispatch_async(dispatch_get_main_queue(), block);
}

- (void) didTapCancelButton: (id) sender
{
  /* Reset previous values */
  [self dismiss];
  [self reloadFromSettings];
}

#pragma mark - Private methods

- (void) initializeViews
{
  /* Load data */
  [self reloadFromSettings];
  
  /* Add subviews */
  [self addSubview: self.pickerView];
  [self.iconContainer addSubview: self.iconView];
  [self addSubview: self.iconContainer];
  
  /* Add fake nav bar*/
  [self.navBarView addSubview: self.titleLabel];
  [self.navBarView addSubview: self.doneButton];
  [self.navBarView addSubview: self.cancelButton];
  [self addSubview: self.navBarView];
}

- (void) reloadFromSettings
{
  /* Retrieve data from index and select rows for picker view */
  self.selectedNote = nil;
  self.selectedGroup = nil;
  [self.pickerView reloadAllComponents];
  
  TMOUserSettings* settings = [TMOUserSettings sharedInstance];
  NSInteger noteGroupIndex = settings.noteGroupIndex;
  NSInteger noteIndex = settings.noteIndex;
  
  [self.pickerView selectRow: noteGroupIndex
                 inComponent: 0
                    animated: NO];
  
  [self.pickerView selectRow: noteIndex
                 inComponent: 1
                    animated: NO];
  
  [self applySelection];
}

- (void) applySelection
{
  NSInteger numberOfComponents
    = [self numberOfComponentsInPickerView: self.pickerView];
  
  for (NSInteger comp = 0; comp < numberOfComponents; comp++)
  {
    NSInteger selectedRow = [self.pickerView selectedRowInComponent: comp];
    UILabel* pickerLabel
      = (id) [self.pickerView  viewForRow: selectedRow
                             forComponent: comp];
    
    [self.theme skinSelectedNotesPickerLabel: pickerLabel];
  }
  
  UIImage* newIconImage = [self imageForSelectedGroupAndNote];
  
  if (newIconImage)
  {
    self.iconView.image = newIconImage;
  }
}

- (UIImage*) imageForSelectedGroupAndNote
{
  UIImage* image = nil;
  
  if (self.selectedGroup.notes.count == 6)
  {
    NSInteger imageIndex
      = [self.selectedGroup.notes indexOfObject: self.selectedNote];
    
    if (imageIndex != NSNotFound)
    {
      image = [self.theme iconForSixStringsWithIndex: imageIndex];
    }
  }
  else if (self.selectedGroup.notes.count == 4)
  {
    NSInteger imageIndex
      = [self.selectedGroup.notes indexOfObject: self.selectedNote];
    
    if (imageIndex != NSNotFound)
    {
      image = [self.theme iconFourStringsWithIndex: imageIndex];
    }
  }
  return image;
}

- (void) dismiss
{
  void (^animation) (void) =
  ^{
    self.alpha = 0.0f;
  };

  void (^completion) (BOOL) = ^(BOOL completed)
  {
    self.hidden = YES;
    
    if (self.delegate != nil)
    {
      [self.delegate noteSelectorViewDidDismiss: self];
    }
  };

  [UIView animateWithDuration: 0.35f
                   animations: animation
                   completion: completion];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger) numberOfComponentsInPickerView: (UIPickerView*) pickerView
{
  return  2;
}

- (NSInteger) pickerView: (UIPickerView*) pickerView
 numberOfRowsInComponent: (NSInteger)     component
{
  NSInteger num = 0;
  
  switch (component)
  {
    case 0:
    {
      num = self.noteGroups.count;
    }
      break;
      
    case 1:
    {
      num = self.selectedGroup.notes.count;
    }
      break;
  }
  return num;
}

- (CGFloat) pickerView: (UIPickerView*) pickerView
     widthForComponent: (NSInteger)     component
{
  return component == 0 ? kPickerWidth * 0.75f : kPickerWidth * 0.25f;
}

- (CGFloat) pickerView: (UIPickerView*) pickerView
 rowHeightForComponent: (NSInteger)     component
{
  return 54.0f;
}

- (void) pickerView: (UIPickerView*) pickerView
       didSelectRow: (NSInteger)     row
        inComponent: (NSInteger)     component
{
  switch (component)
  {
    case 0:
    {
      self.selectedGroup = self.noteGroups[row];
      [self.pickerView reloadComponent: 1];
      
      /* Set new selected note after reloading */
      NSInteger selectedNoteIndex = [pickerView selectedRowInComponent: 1];
      self.selectedNote = self.selectedGroup.notes[selectedNoteIndex];
    }
      break;
      
    case 1:
    {
      self.selectedNote = self.selectedGroup.notes[row];
      [self.pickerView reloadComponent: 0];
    }
      break;
  }
  [self applySelection];
}

- (UIView*) pickerView: (UIPickerView*) pickerView
            viewForRow: (NSInteger)     row
          forComponent: (NSInteger)     component
           reusingView: (UIView*)       view
{
  UILabel* pickerLabel = (id) view;
  
  if (pickerLabel == nil)
  {
    pickerLabel= [[UILabel alloc] init];
    pickerLabel.frame
      = CGRectMake(0.0f, 0.0f,
                   [pickerView rowSizeForComponent:component].width,
                   [pickerView rowSizeForComponent:component].height);
  }
  
  [self.theme skinNotesPickerLabel: pickerLabel];
  
  /* Set text */
  NSString* title = nil;
  switch (component)
  {
    case 0:
    {
      title = ((TMONoteGroup*) self.noteGroups[row]).groupName;
    }
      break;
      
    case 1:
    {
      title = ((TMONote*) self.selectedGroup.notes[row]).name;
    }
      break;
  }
  pickerLabel.text = title;
  return pickerLabel;
}

@end
