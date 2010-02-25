//
//  TouchableRegion.h
//  TCGCounter
//
//  Provides a lightweight CCNode which can respond to touches within a given rectangle.
//  Useful for invisible buttons, or buttons where the UI is not provided by a sprite. 
//  Can optionally to render an outline for development and testing purposes.
//
//  Created by Jay Roberts on 1/23/10.
//  Copyright 2010 Jay Roberts. All rights reserved.
//

#import "cocos2d.h"

@interface TouchableRegion : CCNode <CCTargetedTouchDelegate> {
	CGRect rect;
  BOOL showOutline;
  NSInvocation *invocation;
  BOOL isTouched;
}

@property(nonatomic) CGRect rect;
@property(nonatomic) BOOL showOutline;

+ (id)regionWithRect: (CGRect) rectangle target:(id) tar selector:(SEL) sel;
- (id)initWithRect: (CGRect) rectangle target:(id) tar selector:(SEL) sel;

@end