//
//  TouchableRegion.m
//  TCGCounter
//
//  Provides a lightweight CCNode which can respond to touches within a given rectangle.
//  Useful for invisible buttons, or buttons where the UI is not provided by a sprite. 
//  Can optionally to render an outline for development and testing purposes.
//
//  Created by Jay Roberts on 1/23/10.
//  Copyright 2010 Jay Roberts. All rights reserved.
//

#import "TouchableRegion.h"
#import "cocos2d.h"

@implementation TouchableRegion


+ (id) regionWithRect: (CGRect) rectangle target:(id) tar selector:(SEL) sel {
	return [[[self alloc] initWithRect: rectangle target: tar selector: sel] autorelease];
}

- (id)initWithRect:(CGRect) rectangle target:(id) tar selector:(SEL) sel {
	if ((self = [super init])) {
		rect = CGRectMake(rectangle.origin.x, rectangle.origin.y, rectangle.size.width, rectangle.size.height);
    showOutline = NO;
    isTouched = NO;

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
  CGPoint touchPoint = [touch locationInView:[touch view]];
  touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
  
  NSLog(@"ended: %@", NSStringFromCGPoint(touchPoint));

	if ( [self containsTouchLocation:touch] ) {
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
