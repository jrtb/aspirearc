//
//  iphoneAboutMenuScene.m
//
//  Created by James Bossert on 8/15/11.
//  Copyright jrtb 2011. All rights reserved.
//


// Import the interfaces
#import "iphoneAboutMenuScene.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"

// HelloWorldLayer implementation
@implementation iphoneAboutMenuScene

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	iphoneAboutMenuScene *layer = [iphoneAboutMenuScene node];
	
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
		
        printf("menu scene loading\n");
        
        showingSpinner = NO;

        items = [[NSMutableArray alloc] init];
        
        wrapperOpen = NO;

        isTouchable = NO;
        
        iphoneAddY = 0;
        
        if (IS_IPHONE5)
            iphoneAddY = 44.0;
        
        CGSize size = [CCDirector sharedDirector].winSize;
        
        CCSprite *mainBack = [CCSprite spriteWithFile:@"about_menu_bg.pvr.gz"];
        mainBack.anchorPoint = ccp(0.5,1.0);
        mainBack.position = ccp(size.width*.5,size.height);
        [self addChild:mainBack z:0];
        
        CCSprite *bottom = [CCSprite spriteWithFile:@"bottom_bar.pvr.gz"];
        bottom.anchorPoint = ccp(0.5,0.5);
        bottom.position = ccp(size.width*.5,bottom.contentSize.height*.5);
        [self addChild:bottom z:2];
        
        labelBottom = [CCLabelBMFont labelWithString:@"About ASPIRE" fntFile:@"bottom-menu-14.fnt"];
        labelBottom.anchorPoint = ccp(0.5,0.5);
        labelBottom.position = bottom.position;
        [self addChild:labelBottom z:3];

        float menuStartY = 240.5+iphoneAddY*2;
        float sepY = 38.5;
        
        CCMenuItemSprite *itemA = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                          selectedSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                                  target:self
                                                                selector:@selector(aAction:)];
        
        CCMenu  *menuA = [CCMenu menuWithItems:itemA, nil];
        [menuA setPosition:ccp(size.width*.5,menuStartY - sepY*0)];
        [self addChild:menuA z:2];
        
        CCLabelBMFont *labelA = [CCLabelBMFont labelWithString:@"ASPIRE Overview" fntFile:@"main-menu-24.fnt"];
        labelA.anchorPoint = ccp(0.5,0.6);
        labelA.position = menuA.position;
        [self addChild:labelA z:3];
        [items addObject:labelA];
        
        CCMenuItemSprite *itemB = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                          selectedSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                                  target:self
                                                                selector:@selector(bAction:)];
        
        CCMenu  *menuB = [CCMenu menuWithItems:itemB, nil];
        [menuB setPosition:ccp(size.width*.5,menuStartY - sepY*1)];
        [self addChild:menuB z:2];
        
        CCLabelBMFont *labelB = [CCLabelBMFont labelWithString:@"ASPIRE Brochure" fntFile:@"main-menu-24.fnt"];
        labelB.anchorPoint = ccp(0.5,0.6);
        labelB.position = menuB.position;
        [self addChild:labelB z:3];
        [items addObject:labelB];
        
        CCMenuItemSprite *itemC = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                          selectedSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                                  target:self
                                                                selector:@selector(cAction:)];
        
        CCMenu  *menuC = [CCMenu menuWithItems:itemC, nil];
        [menuC setPosition:ccp(size.width*.5,menuStartY - sepY*2)];
        [self addChild:menuC z:2];
        
        CCLabelBMFont *labelC = [CCLabelBMFont labelWithString:@"ASPIRE Application" fntFile:@"main-menu-24.fnt"];
        labelC.anchorPoint = ccp(0.5,0.6);
        labelC.position = menuC.position;
        [self addChild:labelC z:3];
        [items addObject:labelC];
        
        CCMenuItemSprite *itemD = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                          selectedSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                                  target:self
                                                                selector:@selector(dAction:)];
        
        CCMenu  *menuD = [CCMenu menuWithItems:itemD, nil];
        [menuD setPosition:ccp(size.width*.5,menuStartY - sepY*3)];
        [self addChild:menuD z:2];
        
        CCLabelBMFont *labelD = [CCLabelBMFont labelWithString:@"Student Packet" fntFile:@"main-menu-24.fnt"];
        labelD.anchorPoint = ccp(0.5,0.6);
        labelD.position = menuD.position;
        [self addChild:labelD z:3];
        [items addObject:labelD];
        
        CCMenuItemSprite *itemE = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                          selectedSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                                  target:self
                                                                selector:@selector(eAction:)];
        itemE.opacity = 0;
        CCMenu  *menuE = [CCMenu menuWithItems:itemE, nil];
        [menuE setPosition:ccp(size.width*.5,menuStartY - sepY*4)];
        [self addChild:menuE z:2];
        
        CCLabelBMFont *labelE = [CCLabelBMFont labelWithString:@"Website" fntFile:@"main-menu-24.fnt"];
        labelE.anchorPoint = ccp(0.5,0.6);
        labelE.position = menuE.position;
        [self addChild:labelE z:3];
        [items addObject:labelE];
                
        CCSprite *a1Small = [CCSprite spriteWithFile:@"home_button.png"];
        a1Small.color = ccGRAY;
        
        CCMenuItemSprite *itemA1 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"home_button.png"]
                                                          selectedSprite:a1Small
                                                                  target:self
                                                                selector:@selector(closeAction:)];
        
        CCMenu  *menuA1 = [CCMenu menuWithItems:itemA1, nil];
        [menuA1 setPosition:ccp(size.width-40,size.height-20)];
        [self addChild:menuA1 z:70];

	}
	return self;
}

- (void) closeAction: (id)sender
{
    
    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    //if (![appDelegate muted]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];
    //}
    
    if (wrapperOpen) {
        
        [self removeChild:webViewWrapper];
        webViewWrapper = nil;
        
        wrapperOpen = NO;
        
        labelBottom.string = @"About ASPIRE";
        
    } else {
        
        [delegate setScreenToggle:MENU];
        
        [delegate replaceTheScene];
        
    }
}

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];
    
    [readerViewController dismissModalViewControllerAnimated:NO];
	[readerViewController.view removeFromSuperview];
}

- (void) aAction: (id)sender
{
    //AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    //if (![appDelegate muted]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];
    //}
    
    CCMenuItemSprite *aMenuItem = [items objectAtIndex:0];
    
    aMenuItem.color = ccc3(170, 170, 170);
    
    [self schedule:@selector(buttonPressedA:) interval:0.1];
    
}

- (void) buttonPressedA: (ccTime)sender
{
    [self unschedule:@selector(buttonPressedA:)];
    
    CCMenuItemSprite *aMenuItem = [items objectAtIndex:0];
    
    aMenuItem.color = ccc3(255, 255, 255);
    
    //AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Overview of the ASPIRE program fall 2013" ofType:@"pdf"]; assert(filePath != nil); // Path to last PDF file
    
	ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    
	if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
	{
		readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        
		readerViewController.delegate = self; // Set the ReaderViewController delegate to self
        
		//[self.navigationController pushViewController:readerViewController animated:YES];
        
		readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [[CCDirector sharedDirector] presentViewController:readerViewController animated:YES completion:nil];
        
    }
    
    //[delegate setScreenToggle:INTRO];
    
    //[delegate replaceTheScene];
    
}

- (void) bAction: (id)sender
{
    //AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    //if (![appDelegate muted]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];
    //}
    
    CCMenuItemSprite *label = [items objectAtIndex:1];
    
    label.color = ccc3(170, 170, 170);
    
    [self schedule:@selector(buttonPressedB:) interval:0.1];
    
}

- (void) buttonPressedB: (ccTime)sender
{
    [self unschedule:@selector(buttonPressedB:)];
    
    CCMenuItemSprite *label = [items objectAtIndex:1];
    
    label.color = ccWHITE;
    
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"brochure_students1" ofType:@"pdf"]; assert(filePath != nil); // Path to last PDF file
    
	ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    
	if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
	{
		readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        
		readerViewController.delegate = self; // Set the ReaderViewController delegate to self
        
		//[self.navigationController pushViewController:readerViewController animated:YES];
        
		readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [[CCDirector sharedDirector] presentViewController:readerViewController animated:YES completion:nil];
        
    }
    
}

- (void) cAction: (id)sender
{
    //AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    //if (![appDelegate muted]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];
    //}
    
    CCMenuItemSprite *label = [items objectAtIndex:2];
    
    label.color = ccc3(170, 170, 170);
    
    [self schedule:@selector(buttonPressedC:) interval:0.1];
    
}

- (void) buttonPressedC: (ccTime)sender
{
    [self unschedule:@selector(buttonPressedC:)];
    
    CCMenuItemSprite *label = [items objectAtIndex:2];
    
    label.color = ccWHITE;
    
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ASPIRE Student Application" ofType:@"pdf"]; assert(filePath != nil); // Path to last PDF file
    
	ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    
	if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
	{
		readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        
		readerViewController.delegate = self; // Set the ReaderViewController delegate to self
        
		//[self.navigationController pushViewController:readerViewController animated:YES];
        
		readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [[CCDirector sharedDirector] presentViewController:readerViewController animated:YES completion:nil];
        
    }
    
}

- (void) dAction: (id)sender
{
    //AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    //if (![appDelegate muted]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];
    //}
    
    CCMenuItemSprite *label = [items objectAtIndex:3];
    
    label.color = ccc3(170, 170, 170);
    
    [self schedule:@selector(buttonPressedD:) interval:0.1];
    
}

- (void) buttonPressedD: (ccTime)sender
{
    [self unschedule:@selector(buttonPressedD:)];
    
    CCMenuItemSprite *label = [items objectAtIndex:3];
    
    label.color = ccWHITE;
    
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"student packet2013" ofType:@"pdf"]; assert(filePath != nil); // Path to last PDF file
    
	ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    
	if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
	{
		readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        
		readerViewController.delegate = self; // Set the ReaderViewController delegate to self
        
		//[self.navigationController pushViewController:readerViewController animated:YES];
        
		readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        [[CCDirector sharedDirector] presentViewController:readerViewController animated:YES completion:nil];
        
    }
    
}

- (void) eAction: (id)sender
{
    //AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    //if (![appDelegate muted]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];
    //}
    
    CCMenuItemSprite *label = [items objectAtIndex:4];
    
    label.color = ccc3(170, 170, 170);
    
    [self schedule:@selector(buttonPressedE:) interval:0.1];
    
}

- (void) buttonPressedE: (ccTime)sender
{
    [self unschedule:@selector(buttonPressedE:)];
    
    CCMenuItemSprite *label = [items objectAtIndex:4];
    
    label.color = ccWHITE;
    
    //AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    labelBottom.string = @"ASPIRE - Web";
    
    wrapperOpen = YES;
    
    CGSize size = [CCDirector sharedDirector].winSize;
    
    CGRect frame = CGRectMake(0, 64, size.width, size.height-64-24);
    webView = [[UIWebView alloc] initWithFrame:frame];
    webView.delegate = self;
    webView.scalesPageToFit = YES;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://harvest.cals.ncsu.edu/aspire/"]]];
    
    // put a wrappar around the slider
	webViewWrapper = [CCUIViewWrapper wrapperForUIView:webView];
	[self addChild:webViewWrapper];
    
    if (showingSpinner) {
        showingSpinner = NO;
        [spinner stopAnimating];
        [spinner removeFromSuperview];
        //[spinner release];
        //spinner = nil;
    }
    showingSpinner = YES;
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.color = [UIColor grayColor];
    spinner.hidesWhenStopped = YES;
    [spinner startAnimating];
    spinner.frame = CGRectMake(160-60, 240-60, 120, 120);
    
    [[[CCDirector sharedDirector] view] addSubview:spinner];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (showingSpinner) {
        showingSpinner = NO;
        [spinner stopAnimating];
        [spinner removeFromSuperview];
        //[spinner release];
        //spinner = nil;
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (showingSpinner) {
        showingSpinner = NO;
        [spinner stopAnimating];
        [spinner removeFromSuperview];
        //[spinner release];
        //spinner = nil;
    }
}

- (void) fAction: (id)sender
{
    //AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    //if (![appDelegate muted]) {
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];
    //}
    
    CCMenuItemSprite *label = [items objectAtIndex:5];
    
    label.color = ccc3(170, 170, 170);
    
    [self schedule:@selector(buttonPressedF:) interval:0.1];
    
}

- (void) buttonPressedF: (ccTime)sender
{
    [self unschedule:@selector(buttonPressedF:)];
    
    CCMenuItemSprite *label = [items objectAtIndex:5];
    
    label.color = ccWHITE;
    
    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    [delegate setScreenToggle:COUNTY];
    
    [delegate replaceTheScene];
    
}

-(void) onEnterTransitionDidFinish
{
	[super onEnterTransitionDidFinish];
    
    //CGSize screenSize = [CCDirector sharedDirector].winSize;
    
    [self setTouchEnabled:YES];
    
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
    
    /*
     for (int i=0; i < [items count]; i++) {
     id aPiece = [items objectAtIndex:i];
     [aPiece stopAllActions];
     [aPiece removeAllChildrenWithCleanup:YES];
     [self removeChild:aPiece cleanup:YES];
     }
     [items removeAllObjects];
     [items release];
     items = nil;
     */
    
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"menu_background.pvr.gz"];
    
	[[CCDirector sharedDirector] purgeCachedData];
	
	[CCSpriteFrameCache purgeSharedSpriteFrameCache];
	[CCTextureCache purgeSharedTextureCache];
	
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
	[[CCTextureCache sharedTextureCache] removeAllTextures];
    
	// don't forget to call "super dealloc"
	//[super dealloc];
}
@end
