//
//  TMONoteSelectorView.h
//  SSTuneMeOn
//
//  Created by Kevin Bernard R. San Gaspar on 5/3/14.
//  Copyright (c) 2014 Eric John Adamos. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TMONoteSelectorView;
@class TMONote;
@class TMONoteGroup;

@protocol TMONoteSelectorViewDelegate <NSObject>

- (void) noteSelectorViewDidDismiss: (TMONoteSelectorView*) noteSelectorView;
- (void) noteSelectorView: (TMONoteSelectorView*) noteSelector
            didSelectNote: (TMONote*)             note
            fromNoteGroup: (TMONoteGroup*)        noteGroup;
@end

@interface TMONoteSelectorView : UIView

@property (nonatomic, retain) id<TMONoteSelectorViewDelegate> delegate;

@end
