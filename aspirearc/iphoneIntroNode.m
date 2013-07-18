//
//  iphoneIntroNode.m
//  Tongue
//
//  Created by Ricardo Quesada on 23/09/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "iphoneIntroNode.h"
//#import "MenuScene.h"
//#import "iphoneMenuScene.h"
#import "SimpleAudioEngine.h"
#import "AppDelegate.h"

//
// Small scene that plays the background music and makes a transition to the Menu scene
//
@implementation iphoneIntroNode

@synthesize touched;

+(id) scene {
	CCScene *s = [CCScene node];
	id node = [iphoneIntroNode node];
	[s addChild:node];
	return s;
}

-(id) init {
	if( ![super init])
		return nil;

    printf("intro scene loading\n");
    
	//printf("intro init\n");
		
	touched = NO;

    CGSize size = [[CCDirector sharedDirector] winSize];
    
    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];

    if (IS_IPHONE5) {
        printf("iphone5 detected\n");
        back = [CCSprite spriteWithFile:@"Default-568h@2x.png"];
    }
    else if ([delegate isRetina]) {
        back = [CCSprite spriteWithFile:@"Default@2x.png"];
    } else {
        back = [CCSprite spriteWithFile:@"Default.png"];
    }
    
    back.position = ccp(size.width*.5,size.height*.5);
    [self addChild:back z:0];
    
    //printf("screensize: %f, %f\n",screenSize.width,screenSize.height);
    
	return self;
}

-(void) onEnterTransitionDidFinish
{
	[super onEnterTransitionDidFinish];
	
    //AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    [self schedule: @selector(start2:) interval:0.0f];

    //[self setTouchEnabled:YES];

}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	if (!touched) {
		      
		touched = YES;
		
		//printf("touched\n");
		
		[self schedule: @selector(start2:) interval:0.0f];

	}
}

- (void) start2: (ccTime)sender
{
	[self unschedule: @selector(start2:)];
    
    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    [delegate setScreenToggle:MENU];
    
    [delegate replaceTheScene];

}

- (void)dealloc {
	
	NSLog(@"releasing iphoneIntroNode elements");
	
    [self unscheduleAllSelectors];

    [self removeAllChildrenWithCleanup:YES];
    
	[[CCDirector sharedDirector] purgeCachedData];
	
	[CCSpriteFrameCache purgeSharedSpriteFrameCache];
	[CCTextureCache purgeSharedTextureCache];
	
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
	[[CCTextureCache sharedTextureCache] removeAllTextures];
    
    //[super dealloc];
}

@end
