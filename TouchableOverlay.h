//
//  TouchableOverlay.h
//  TCGCounter
//
//  Provides a lightweight CCNode which can respond to touches within a given rectangle.
//  Accepts a CCSprite parameter which is shown when the overlay is pressed. Useful in certain UI situations.
//  Fades out the overlay sprite if the button press is cancelled, otherwise the sprite stays visible. Matches the
//  behavior of the standard info button in Apple utility applications.
//  Can optionally to render an outline for development and testing purposes.
//
//  Created by Jay Roberts on 1/23/10.
//  Copyright 2010 Jay Roberts. All rights reserved.
//

#import "cocos2d.h"

@interface TouchableOverlay : CCNode <CCTargetedTouchDelegate> {
	CGRect rect;
  BOOL showOutline;
  NSInvocation *invocation;
  BOOL isTouched;
  CCSprite *sprite;
}

@property(nonatomic) CGRect rect;
@property(nonatomic) BOOL showOutline;

+ (id)overlayWithRect: (CGRect) rectangle target:(id) tar selector:(SEL) sel sprite:(CCSprite *) sprt;
- (id)initWithRect: (CGRect) rectangle target:(id) tar selector:(SEL) sel sprite:(CCSprite *) sprt;

@end