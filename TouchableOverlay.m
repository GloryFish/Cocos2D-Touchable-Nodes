//
//  TouchableOverlay.m
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

#import "TouchableOverlay.h"
#import "cocos2d.h"

@implementation TouchableOverlay


+ (id) overlayWithRect: (CGRect) rectangle target:(id) tar selector:(SEL) sel sprite:(CCSprite *) sprt {
	return [[[self alloc] initWithRect: rectangle target: tar selector: sel sprite: sprt] autorelease];
}

- (id)initWithRect:(CGRect) rectangle target:(id) tar selector:(SEL) sel sprite:(CCSprite *) sprt {
	if ((self = [super init])) {
		rect = CGRectMake(rectangle.origin.x, rectangle.origin.y, rectangle.size.width, rectangle.size.height);
    showOutline = NO;
    isTouched = NO;
    sprite = sprt;
    sprite.opacity = 0;
    
		NSMethodSignature * sig = nil;
		
		if( tar && sel ) {
			sig = [[tar class] instanceMethodSignatureForSelector: sel];
			
			invocation = nil;
			invocation = [NSInvocation invocationWithMethodSignature: sig];
      [invocation setTarget: tar];
      [invocation setSelector: sel];
      [invocation retain];
    }
  }
  
	return self;
}

@synthesize rect;
@synthesize showOutline;

- (void)onEnter {
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
	[super onEnter];
}

- (void)onExit {
	[[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
	[super onExit];
}	

- (BOOL)containsTouchLocation:(UITouch *)touch {
	return CGRectContainsPoint(rect, [self convertTouchToNodeSpaceAR:touch]);
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	if ( [self containsTouchLocation:touch] ) {
  	isTouched = YES;
    sprite.opacity = 255;

    CGPoint touchPoint = [touch locationInView:[touch view]];
    touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    NSLog(@"began: %@", NSStringFromCGPoint(touchPoint));
    return kEventHandled;
  } else {
    return kEventIgnored;
  }
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
	if ( [self containsTouchLocation:touch] ) {
    CGPoint touchPoint = [touch locationInView:[touch view]];
    touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    NSLog(@"moved: %@", NSStringFromCGPoint(touchPoint));	
  }
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
  isTouched = NO;
  
	id fadeAction = [CCFadeOut actionWithDuration:0.5f];
	[sprite runAction: fadeAction];
  
  CGPoint touchPoint = [touch locationInView:[touch view]];
  touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
  
  NSLog(@"ended: %@", NSStringFromCGPoint(touchPoint));
  
	if ( [self containsTouchLocation:touch] ) {
    sprite.visible = YES; // Keep the button pressed if we are going to fire the action
    [invocation invoke];
  }
}

- (void) draw {
	if (showOutline) {
  	if (isTouched) {
      glColor4ub(255, 255, 0, 255);
    } else {
      glColor4ub(255, 0, 0, 255);
    }
    glLineWidth(1);
    
    CGPoint vertices2[] = { ccp(rect.origin.x, rect.origin.y), 
      ccp(rect.origin.x, rect.origin.y + rect.size.height), 
      ccp(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height),
      ccp(rect.origin.x + rect.size.width, rect.origin.y) 
    };
    
    ccDrawPoly( vertices2, 4, YES);
    
    glColor4ub(255,255,255,255);
  }
}

-(void) dealloc {
	[invocation release];
	[super dealloc];
}

@end
