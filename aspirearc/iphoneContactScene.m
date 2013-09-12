//
//  iphoneContactScene.m
//
//  Created by James Bossert on 8/15/11.
//  Copyright jrtb 2011. All rights reserved.
//


// Import the interfaces
#import "iphoneContactScene.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"

#import "Flurry.h"

// HelloWorldLayer implementation
@implementation iphoneContactScene

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	iphoneContactScene *layer = [iphoneContactScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
		
        printf("act category scene loading\n");
        
        isTouchable = NO;
        
        iphoneAddY = 0;
        
        if (IS_IPHONE5)
            iphoneAddY = 44.0;
        
        CGSize size = [CCDirector sharedDirector].winSize;
        
        CCSprite *mainBack = [CCSprite spriteWithFile:@"contact_menu_bg.pvr.gz"];
        mainBack.anchorPoint = ccp(0.5,1.0);
        mainBack.position = ccp(size.width*.5,size.height);
        [self addChild:mainBack z:2];
        
        CCSprite *bottom = [CCSprite spriteWithFile:@"bottom_bar.pvr.gz"];
        bottom.anchorPoint = ccp(0.5,0.5);
        bottom.position = ccp(size.width*.5,bottom.contentSize.height*.5);
        [self addChild:bottom z:2];
        
        labelBottom = [CCLabelBMFont labelWithString:@"ASPIRE - Contact Your Teacher" fntFile:@"bottom-menu-14.fnt"];
        labelBottom.anchorPoint = ccp(0.5,0.5);
        labelBottom.position = bottom.position;
        [self addChild:labelBottom z:3];
        
        CCSprite *aSmall = [CCSprite spriteWithFile:@"home_button.png"];
        aSmall.color = ccGRAY;
        
        CCMenuItemSprite *itemA = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"home_button.png"]
                                                          selectedSprite:aSmall
                                                                  target:self
                                                                selector:@selector(closeAction:)];
        
        CCMenu  *menuA = [CCMenu menuWithItems:itemA, nil];
        [menuA setPosition:ccp(size.width-40,size.height-20)];
        [self addChild:menuA z:70];
        
        //AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
                
	}
	return self;
}

- (void) closeAction: (id)sender
{
    
    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    //if (![appDelegate muted]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];
    //}
    
    [delegate setNumCorrect:0];
    [delegate setCurrentQuestionIndex:0];
    
    [delegate setScreenToggle:MENU];
    
    [delegate replaceTheScene];
}

-(void) onEnterTransitionDidFinish
{
	[super onEnterTransitionDidFinish];
    
    //CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    [self setTouchEnabled:YES];
    
    [self loadData];
    
}

- (void) loadData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"countyinfo" ofType:@"plist"];
	
    NSMutableArray *data = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
	NSDictionary *datum;
	
    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];

    BOOL gotOne = NO;
    
    for (datum in data) {

        NSLog(@"county a: %@",[datum objectForKey:@"county"]);
        NSLog(@"county b: %@",[delegate selectedCounty]);

        if ([[datum objectForKey:@"county"] isEqualToString:[delegate selectedCounty]]) {
            
            gotOne = YES;
            
            NSLog(@"county: %@",[datum objectForKey:@"county"]);
            NSLog(@"name1: %@",[datum objectForKey:@"name1"]);
            NSLog(@"email1: %@",[datum objectForKey:@"email1"]);
    
            UITextView *aView = [[UITextView alloc] initWithFrame:CGRectMake(6.0, 130.0, 320-12.0, 200)];
            aView.scrollEnabled = NO;
            aView.userInteractionEnabled = YES;
            aView.backgroundColor = [UIColor clearColor];
            aView.opaque = NO;
            aView.text = [NSString stringWithFormat:@"%@ County\n\n",[datum objectForKey:@"county"]];

            if ([datum objectForKey:@"name1"] && ![[datum objectForKey:@"name1"] isEqualToString:@""]
                && [datum objectForKey:@"name2"] && ![[datum objectForKey:@"name2"] isEqualToString:@""]
                && [datum objectForKey:@"name3"] && ![[datum objectForKey:@"name3"] isEqualToString:@""]) {
                aView.text = [aView.text stringByAppendingString:[NSString stringWithFormat:@"%@, %@, %@\n",[datum objectForKey:@"name1"],[datum objectForKey:@"name2"],[datum objectForKey:@"name3"]]];
            }

            if ([datum objectForKey:@"name1"] && ![[datum objectForKey:@"name1"] isEqualToString:@""]
                && [datum objectForKey:@"name2"] && ![[datum objectForKey:@"name2"] isEqualToString:@""]
                && (![datum objectForKey:@"name3"] || [[datum objectForKey:@"name3"] isEqualToString:@""])) {
                aView.text = [aView.text stringByAppendingString:[NSString stringWithFormat:@"%@, %@\n",[datum objectForKey:@"name1"],[datum objectForKey:@"name2"]]];
            }

            if ([datum objectForKey:@"name1"] && ![[datum objectForKey:@"name1"] isEqualToString:@""]
                && (![datum objectForKey:@"name2"] || [[datum objectForKey:@"name2"] isEqualToString:@""])
                && (![datum objectForKey:@"name3"] || [[datum objectForKey:@"name3"] isEqualToString:@""])) {
                aView.text = [aView.text stringByAppendingString:[NSString stringWithFormat:@"%@\n",[datum objectForKey:@"name1"]]];
            }

            if ([datum objectForKey:@"email1"] && ![[datum objectForKey:@"email1"] isEqualToString:@""]
                && [datum objectForKey:@"email2"] && ![[datum objectForKey:@"email2"] isEqualToString:@""]
                && [datum objectForKey:@"email3"] && ![[datum objectForKey:@"email3"] isEqualToString:@""]) {
                aView.text = [aView.text stringByAppendingString:[NSString stringWithFormat:@"%@, %@, %@\n",[datum objectForKey:@"email1"],[datum objectForKey:@"email2"],[datum objectForKey:@"email3"]]];
            }
            
            if ([datum objectForKey:@"email1"] && ![[datum objectForKey:@"email1"] isEqualToString:@""]
                && [datum objectForKey:@"email2"] && ![[datum objectForKey:@"email2"] isEqualToString:@""]
                && (![datum objectForKey:@"email3"] || [[datum objectForKey:@"email3"] isEqualToString:@""])) {
                aView.text = [aView.text stringByAppendingString:[NSString stringWithFormat:@"%@, %@\n",[datum objectForKey:@"email1"],[datum objectForKey:@"email2"]]];
            }
            
            if ([datum objectForKey:@"email1"] && ![[datum objectForKey:@"email1"] isEqualToString:@""]
                && (![datum objectForKey:@"email2"] || [[datum objectForKey:@"email2"] isEqualToString:@""])
                && (![datum objectForKey:@"email3"] || [[datum objectForKey:@"email3"] isEqualToString:@""])) {
                aView.text = [aView.text stringByAppendingString:[NSString stringWithFormat:@"%@\n",[datum objectForKey:@"email1"]]];
            }

            if ([datum objectForKey:@"phone1"] && ![[datum objectForKey:@"phone1"] isEqualToString:@""]
                && [datum objectForKey:@"phone2"] && ![[datum objectForKey:@"phone2"] isEqualToString:@""]) {
                aView.text = [aView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@, %@\n",[datum objectForKey:@"phone1"],[datum objectForKey:@"phone2"]]];
            }

            if ([datum objectForKey:@"phone1"] && ![[datum objectForKey:@"phone1"] isEqualToString:@""]
                && (![datum objectForKey:@"phone2"] || [[datum objectForKey:@"phone2"] isEqualToString:@""])) {
                aView.text = [aView.text stringByAppendingString:[NSString stringWithFormat:@"\n%@\n",[datum objectForKey:@"phone1"]]];
            }

            aView.editable = NO;
            aView.dataDetectorTypes = UIDataDetectorTypeAll;
            aView.font = [UIFont fontWithName:@"Helvetica" size:20.0f];
            //[explanationView loadHTMLString:explanation baseURL:baseURL];
            
            CCUIViewWrapper *aViewWrapper = [CCUIViewWrapper wrapperForUIView:aView];
            [self addChild:aViewWrapper z:11];
            
        }

    }
    
    if (!gotOne) {
        
        UITextView *aView = [[UITextView alloc] initWithFrame:CGRectMake(6.0, 130.0, 320-12.0, 200)];
        aView.scrollEnabled = NO;
        aView.userInteractionEnabled = YES;
        aView.backgroundColor = [UIColor clearColor];
        aView.opaque = NO;
        aView.text = [NSString stringWithFormat:@"%@ County does not currently have any contact information.",[delegate selectedCounty]];

        aView.editable = NO;
        aView.dataDetectorTypes = UIDataDetectorTypeAll;
        aView.font = [UIFont fontWithName:@"Helvetica" size:20.0f];
        //[explanationView loadHTMLString:explanation baseURL:baseURL];
        
        CCUIViewWrapper *aViewWrapper = [CCUIViewWrapper wrapperForUIView:aView];
        [self addChild:aViewWrapper z:11];

    }
    
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
    printf("menu deallocing\n");
    
    if (soundID != -6000) {
        [[SimpleAudioEngine sharedEngine] stopEffect:soundID];
        soundID = -6000;
    }
    
    [self unscheduleAllSelectors];
    
    [self removeAllChildrenWithCleanup:YES];
    
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"contact_menu_bg.pvr.gz"];
    
	[[CCDirector sharedDirector] purgeCachedData];
	
	[CCSpriteFrameCache purgeSharedSpriteFrameCache];
	[CCTextureCache purgeSharedTextureCache];
	
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
	[[CCTextureCache sharedTextureCache] removeAllTextures];
    
	// don't forget to call "super dealloc"
	//[super dealloc];
}
@end
