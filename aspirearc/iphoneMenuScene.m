//
//  iphoneMenuScene.m
//
//  Created by James Bossert on 8/15/11.
//  Copyright jrtb 2011. All rights reserved.
//


// Import the interfaces
#import "iphoneMenuScene.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"

@interface CCMenu (UnselectSelectedItem)
- (void) unselectSelectedItem;
@end

@implementation CCMenu (UnselectSelectedItem)

- (void) unselectSelectedItem
{
	if(_state == kCCMenuStateTrackingTouch)
	{
		[_selectedItem unselected];
		_state = kCCMenuStateWaiting;
		_selectedItem = nil;
	}
}

@end

#pragma mark -

@interface iphoneMenuScene (ScrollLayerCreation)

- (NSArray *) scrollLayerPages;
- (CustomScrollLayer *) scrollLayer;
- (void) updateFastPageChangeMenu;

@end

// HelloWorldLayer implementation
@implementation iphoneMenuScene

enum nodeTags
{
	kScrollLayer = 256,
	kAdviceLabel = 257,
	kFastPageChangeMenu = 258,
};

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	iphoneMenuScene *layer = [iphoneMenuScene node];
	
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
        
        touched = NO;
        
        pages = [[NSMutableArray alloc] init];
        items = [[NSMutableArray alloc] init];

        isTouchable = NO;

        iphoneAddY = 0;
        
        if (IS_IPHONE5)
            iphoneAddY = 44.0;

        CGSize size = [CCDirector sharedDirector].winSize;

        CCSprite *mainBack = [CCSprite spriteWithFile:@"main_menu_bg.pvr.gz"];
        mainBack.anchorPoint = ccp(0.5,1.0);
        mainBack.position = ccp(size.width*.5,size.height);
        [self addChild:mainBack z:0];

        CCSprite *sliderLine = [CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"];
        sliderLine.position = ccp(160.0,68.0+iphoneAddY*2);
        [self addChild:sliderLine z:0];

        CCSprite *aSmall1 = [CCSprite spriteWithFile:@"settings.pvr.gz"];
        aSmall1.opacity = 128;

        CCSprite *aSmall2 = [CCSprite spriteWithFile:@"settings.pvr.gz"];
        aSmall2.opacity = 255;

        CCMenuItemSprite *itemA = [CCMenuItemSprite itemWithNormalSprite:aSmall1
                                                          selectedSprite:aSmall2
                                                                  target:self
                                                                selector:@selector(settingsAction:)];
        
        CCMenu  *menuA = [CCMenu menuWithItems:itemA, nil];
        [menuA setPosition:ccp(22,22)];
        [self addChild:menuA z:70];

        /*
        float menuStartY = 300.5+iphoneAddY*2;
        float sepY = 38.0;
        
        CCMenuItemSprite *itemA = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                          selectedSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                                  target:self
                                                                selector:@selector(aAction:)];
        
        CCMenu  *menuA = [CCMenu menuWithItems:itemA, nil];
        [menuA setPosition:ccp(size.width*.5,menuStartY - sepY*0)];
        [self addChild:menuA z:2];

        CCLabelBMFont *labelA = [CCLabelBMFont labelWithString:@"About A.S.P.I.R.E." fntFile:@"main-menu-24.fnt"];
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
        
        CCLabelBMFont *labelB = [CCLabelBMFont labelWithString:@"About CALS" fntFile:@"main-menu-24.fnt"];
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
        
        CCLabelBMFont *labelC = [CCLabelBMFont labelWithString:@"ACT Practice Questions" fntFile:@"main-menu-24.fnt"];
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
        
        CCLabelBMFont *labelD = [CCLabelBMFont labelWithString:@"Schedules and Class Locations" fntFile:@"main-menu-24.fnt"];
        labelD.anchorPoint = ccp(0.5,0.6);
        labelD.position = menuD.position;
        [self addChild:labelD z:3];
        [items addObject:labelD];

        CCMenuItemSprite *itemE = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                          selectedSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                                  target:self
                                                                selector:@selector(eAction:)];
        
        CCMenu  *menuE = [CCMenu menuWithItems:itemE, nil];
        [menuE setPosition:ccp(size.width*.5,menuStartY - sepY*4)];
        [self addChild:menuE z:2];
        
        CCLabelBMFont *labelE = [CCLabelBMFont labelWithString:@"Social Media & Message Board" fntFile:@"main-menu-24.fnt"];
        labelE.anchorPoint = ccp(0.5,0.6);
        labelE.position = menuE.position;
        [self addChild:labelE z:3];
        [items addObject:labelE];

        CCMenuItemSprite *itemF = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                          selectedSprite:[CCSprite spriteWithFile:@"main_menu_cellbg.pvr.gz"]
                                                                  target:self
                                                                selector:@selector(fAction:)];
        
        itemF.opacity = 0;
        
        CCMenu  *menuF = [CCMenu menuWithItems:itemF, nil];
        [menuF setPosition:ccp(size.width*.5,menuStartY - sepY*5)];
        [self addChild:menuF z:2];
        
        CCLabelBMFont *labelF = [CCLabelBMFont labelWithString:@"Contact Your Teacher" fntFile:@"main-menu-24.fnt"];
        labelF.anchorPoint = ccp(0.5,0.6);
        labelF.position = menuF.position;
        [self addChild:labelF z:3];
        [items addObject:labelF];
         */
        
        // Do initial positioning & create scrollLayer.
		[self updateForScreenReshape];

	}
	return self;
}

- (void) settingsAction: (id) sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];

    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    [delegate setScreenToggle:COUNTY];
    
    [delegate replaceTheScene];
    
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
    
    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    [delegate setScreenToggle:ABOUT];
    
    [delegate replaceTheScene];
    
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
    
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"ASPIREbooklet" ofType:@"pdf"]; assert(filePath != nil); // Path to last PDF file
    
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

    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Coming soon!" message:@"Currently waiting on ACT questions before ready to implement"
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
    [alert show];
    //[alert release];

    //AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    //[delegate setScreenToggle:INTRO];
    
    //[delegate replaceTheScene];
    
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

- (void) loadTeacher
{
    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    if ([[delegate selectedCounty] isEqualToString:@""]) {
        
        printf("county has not yet been selected\n");
        
        [delegate setAfterCounty:TEACHER];
        [delegate setLoadPDFInMenu:YES];
        
        [delegate setScreenToggle:COUNTY];
        [delegate replaceTheScene];
        
    } else {
        
        printf("county has already been selected\n");
        NSLog(@"Currently selected county: %@",[delegate selectedCounty]);
        
        NSString *pdfName = @"";
        
        if ([[delegate selectedCounty] isEqualToString:@"Alexander"] || 
            [[delegate selectedCounty] isEqualToString:@"Ashe"] ||
            [[delegate selectedCounty] isEqualToString:@"Burke"] ||
            [[delegate selectedCounty] isEqualToString:@"Camden"] ||
            [[delegate selectedCounty] isEqualToString:@"Catawba"] ||
            [[delegate selectedCounty] isEqualToString:@"Cherokee"] ||
            [[delegate selectedCounty] isEqualToString:@"Chowan"] ||
            [[delegate selectedCounty] isEqualToString:@"Davidson"] ||
            [[delegate selectedCounty] isEqualToString:@"Davie"] ||
            [[delegate selectedCounty] isEqualToString:@"Haywood"] ||
            [[delegate selectedCounty] isEqualToString:@"Hertford"] ||
            [[delegate selectedCounty] isEqualToString:@"Johnston"] ||
            [[delegate selectedCounty] isEqualToString:@"Lincoln"] ||
            [[delegate selectedCounty] isEqualToString:@"Madison"] ||
            [[delegate selectedCounty] isEqualToString:@"Mitchell"] ||
            [[delegate selectedCounty] isEqualToString:@"Montgomery"] ||
            [[delegate selectedCounty] isEqualToString:@"Northampton"] ||
            [[delegate selectedCounty] isEqualToString:@"Pasquotank"] ||
            [[delegate selectedCounty] isEqualToString:@"Person"] ||
            [[delegate selectedCounty] isEqualToString:@"Pitt"] ||
            [[delegate selectedCounty] isEqualToString:@"Robeson"] ||
            [[delegate selectedCounty] isEqualToString:@"Rowan"] ||
            [[delegate selectedCounty] isEqualToString:@"Rutherford"] ||
            [[delegate selectedCounty] isEqualToString:@"Sampson"] ||
            [[delegate selectedCounty] isEqualToString:@"Stanly"] ||
            [[delegate selectedCounty] isEqualToString:@"Union"] ||
            [[delegate selectedCounty] isEqualToString:@"Warren"] ||
            [[delegate selectedCounty] isEqualToString:@"Wayne"] ||
            [[delegate selectedCounty] isEqualToString:@"Wilson"]) {
            
            pdfName = [NSString stringWithFormat:@"%@ County",[delegate selectedCounty]];
            
        } else {
            
            /*
             - (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
             */
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"There isn't currently a teacher for your county"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            //[alert release];
        }
        
        if (![pdfName isEqualToString:@""]) {
            
            NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
            
            NSString *filePath = [[NSBundle mainBundle] pathForResource:pdfName ofType:@"pdf"]; assert(filePath != nil); // Path to last PDF file
            
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
        
    }
    
}

- (void) loadSchedule
{
    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    if ([[delegate selectedCounty] isEqualToString:@""]) {
        
        printf("county has not yet been selected\n");
        
        [delegate setAfterCounty:SCHEDULE];
        [delegate setLoadPDFInMenu:YES];
        
        [delegate setScreenToggle:COUNTY];
        [delegate replaceTheScene];
        
    } else {
        
        printf("county has already been selected\n");
        NSLog(@"Currently selected county: %@",[delegate selectedCounty]);
        
        NSString *pdfName = @"";
        if ([[delegate selectedCounty] isEqualToString:@"Ashe"]) {
            pdfName = @"Ashefall2013schedule";
        } else if ([[delegate selectedCounty] isEqualToString:@"Davie"]) {
            pdfName = @"DavieCountyASPIREfall2013";
        } else if ([[delegate selectedCounty] isEqualToString:@"Haywood"]) {
            pdfName = @"Haywood fall 2013 schedule";
        } else if ([[delegate selectedCounty] isEqualToString:@"Hertford"]) {
            pdfName = @"HertfordFall2013Schedule";
        } else if ([[delegate selectedCounty] isEqualToString:@"Lincoln"]) {
            pdfName = @"LincolnCharter2013fallschedule";
        } else if ([[delegate selectedCounty] isEqualToString:@"Madison"]) {
            pdfName = @"Madisonfall2013schedule";
        } else if ([[delegate selectedCounty] isEqualToString:@"Northhampton"]) {
            pdfName = @"Northampton fall 2013 schedule";
        } else if ([[delegate selectedCounty] isEqualToString:@"Pasquotank"]) {
            pdfName = @"Pasquotank Fall 2013 schedule";
        } else if ([[delegate selectedCounty] isEqualToString:@"Rowan"]) {
            pdfName = @"Rowan summer 2013 schedule";
        } else if ([[delegate selectedCounty] isEqualToString:@"Rutherford"]) {
            pdfName = @"Rutherford Fall 2013 Schedule";
        } else {
            
            /*
             - (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
             */
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"There isn't currently a schedule for your county"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
            [alert show];
            //[alert release];
        }
        
        if (![pdfName isEqualToString:@""]) {
            
            NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
            
            NSString *filePath = [[NSBundle mainBundle] pathForResource:pdfName ofType:@"pdf"]; assert(filePath != nil); // Path to last PDF file
            
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
        
    }

}

- (void) buttonPressedD: (ccTime)sender
{
    [self unschedule:@selector(buttonPressedD:)];
    
    CCMenuItemSprite *label = [items objectAtIndex:3];
    
    label.color = ccWHITE;
    
    [self loadSchedule];
    
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
    
    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    [delegate setScreenToggle:SOCIAL];
    
    [delegate replaceTheScene];
    
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
    
    [self loadTeacher];
    
}

-(void) onEnterTransitionDidFinish
{
	[super onEnterTransitionDidFinish];
    
    //CGSize screenSize = [CCDirector sharedDirector].winSize;

    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];

    if ([delegate loadPDFInMenu]) {
        
        [delegate setLoadPDFInMenu:NO];
        
        if ([delegate afterCounty] == SCHEDULE) {
            
            [self loadSchedule];
            
        } else {
            
            
        }
        
    } else {
    
        [self schedule:@selector(checkTouches:) interval:4.0];
        
        [self schedule:@selector(slideInFirstCard:) interval:0.2];
        
    }
    
}

- (void) slideInFirstCard: (ccTime) sender
{
    [self unschedule:@selector(slideInFirstCard:)];
    
    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];

    if ([delegate currentMenuItem] == 0) {
    
        printf("slide in first card\n");
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"short_whoosh.caf"];

        float duration = 0.2;
        
        id drop = [CCMoveBy actionWithDuration:duration position:ccp(-320,0)];
        id drop1 = [CCMoveBy actionWithDuration:.2 position:ccp(20,0)];
        id actionByBack = [drop1 reverse];
        id drop2 = [CCMoveBy actionWithDuration:.1 position:ccp(10,0)];
        id actionByBack2 = [drop2 reverse];
        
        CCAction *repC1 = [CCSequence actions:drop,drop1, actionByBack, drop2, actionByBack2, nil];
        
        CCLayer *pageOne = [pages objectAtIndex:[delegate currentMenuItem]];
        
        [pageOne runAction:repC1];
    }
    
    [self setTouchEnabled:YES];
    
}


- (void) checkTouches: (ccTime) sender
{
    [self unschedule:@selector(checkTouches:)];
    [self schedule:@selector(checkTouches:) interval:4.0];

    CustomScrollLayer *scrollLayer = (CustomScrollLayer *)[self getChildByTag:kScrollLayer];
    
    int nextScreen = [scrollLayer currentScreen] + 1;
    if (nextScreen >= [scrollLayer totalScreens])
        nextScreen = 0;
    
    [scrollLayer selectPage: nextScreen];

}

// Removes old "0 1 2" menu and creates new for actual pages count.
- (void) updateFastPageChangeMenu
{
	// Remove fast page change menu if it exists.
	[self removeChildByTag:kFastPageChangeMenu cleanup:YES];
	
	// Get total current pages count.
	int pagesCount = [[self scrollLayerPages]count];
	CustomScrollLayer *scroller = (CustomScrollLayer *)[self getChildByTag:kScrollLayer];
	if (scroller)
	{
		pagesCount = [[scroller pages] count];
	}
	
	// Create & add fast-page-change menu.
	CCMenu *fastPageChangeMenu = [CCMenu menuWithItems: nil];
	for (int i = 0; i < pagesCount ; ++i)
	{
		NSString *numberString = [NSString stringWithFormat:@"%d", i+1];
		CCLabelTTF *labelWithNumber = [CCLabelTTF labelWithString:numberString fontName:@"Marker Felt" fontSize:22];
		CCMenuItemLabel *item = [CCMenuItemLabel itemWithLabel:labelWithNumber target:self selector:@selector(fastMenuItemPressed:)];
		[fastPageChangeMenu addChild: item z: 0 tag: i];
	}
	[fastPageChangeMenu alignItemsHorizontally];
	[self addChild: fastPageChangeMenu z: 0 tag: kFastPageChangeMenu];
	
	// Position fast page change menu without calling updateForScreenReshape.
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	fastPageChangeMenu.position = ccp( 0.5f * screenSize.width, 15.0f);
}

// Positions children of CustomScrollLayerTestLayer.
// ScrollLayer is updated via deleting old and creating new one.
// (Cause it's created with pages - normal CCLayer, which contentSize = winSize)
- (void) updateForScreenReshape
{
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	
	CCNode *fastPageChangeMenu = [self getChildByTag:kFastPageChangeMenu];
	//CCNode *adviceLabel = [self getChildByTag:kAdviceLabel];
	
	fastPageChangeMenu.position = ccp( 0.5f * screenSize.width, 15.0f);
	//adviceLabel.anchorPoint = ccp(0.5f, 1.0f);
	//adviceLabel.position = ccp(0.5f * screenSize.width, screenSize.height);
	
	// ReCreate Scroll Layer for each Screen Reshape (slow, but easy).
	CustomScrollLayer *scrollLayer = (CustomScrollLayer *)[self getChildByTag:kScrollLayer];
	if (scrollLayer)
	{
		[self removeChild:scrollLayer cleanup:YES];
	}
	
    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];

	scrollLayer = [self scrollLayer];
	[self addChild: scrollLayer z: 0 tag: kScrollLayer];
	[scrollLayer selectPage: [delegate currentMenuItem]];
	scrollLayer.delegate = self;
    
}

#pragma mark ScrollLayer Creation

// Returns array of CCLayers - pages for ScrollLayer.
- (NSArray *) scrollLayerPages
{
        
    CCLayer *page01 = [CCLayer node];
    
    float extra = 0;
    
    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
    
    if ([delegate currentMenuItem] == 0)
        extra = 320;
    
    CCSprite *small01 = [CCSprite spriteWithFile:@"slider_01.pvr.gz"];
    small01.color = ccc3(255,255,255);
    
    CCMenuItemSprite *item01 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"slider_01.pvr.gz"]
                                                       selectedSprite:small01
                                                               target:self
                                                             selector:@selector(aAction:)];
    
    [items addObject:item01];
    
    CCMenu  *menu01 = [CCMenu menuWithItems:item01, nil];
    [menu01 setPosition:ccp(160.0+extra,196.0+iphoneAddY*2)];
    [page01 addChild:menu01 z:2];
    
    [pages addObject:page01];

    CCLayer *page02 = [CCLayer node];
    
    CCSprite *small02 = [CCSprite spriteWithFile:@"slider_02.pvr.gz"];
    small02.color = ccc3(255,255,255);
    
    CCMenuItemSprite *item02 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"slider_02.pvr.gz"]
                                                       selectedSprite:small02
                                                               target:self
                                                             selector:@selector(bAction:)];
    
    [items addObject:item02];
    
    CCMenu  *menu02 = [CCMenu menuWithItems:item02, nil];
    [menu02 setPosition:ccp(160.0,196.0+iphoneAddY*2)];
    [page02 addChild:menu02 z:2];
    
    [pages addObject:page02];

    CCLayer *page03 = [CCLayer node];
    
    CCSprite *small03 = [CCSprite spriteWithFile:@"slider_03.pvr.gz"];
    small03.color = ccc3(255,255,255);
    
    CCMenuItemSprite *item03 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"slider_03.pvr.gz"]
                                                       selectedSprite:small03
                                                               target:self
                                                             selector:@selector(cAction:)];
    
    [items addObject:item03];
    
    CCMenu  *menu03 = [CCMenu menuWithItems:item03, nil];
    [menu03 setPosition:ccp(160.0,196.0+iphoneAddY*2)];
    [page03 addChild:menu03 z:2];
    
    [pages addObject:page03];

    CCLayer *page04 = [CCLayer node];
    
    CCSprite *small04 = [CCSprite spriteWithFile:@"slider_04.pvr.gz"];
    small04.color = ccc3(255,255,255);
    
    CCMenuItemSprite *item04 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"slider_04.pvr.gz"]
                                                       selectedSprite:small04
                                                               target:self
                                                             selector:@selector(dAction:)];
    
    [items addObject:item04];
    
    CCMenu  *menu04 = [CCMenu menuWithItems:item04, nil];
    [menu04 setPosition:ccp(160.0,196.0+iphoneAddY*2)];
    [page04 addChild:menu04 z:2];
    
    [pages addObject:page04];

    CCLayer *page05 = [CCLayer node];
    
    CCSprite *small05 = [CCSprite spriteWithFile:@"slider_05.pvr.gz"];
    small05.color = ccc3(255,255,255);
    
    CCMenuItemSprite *item05 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"slider_05.pvr.gz"]
                                                       selectedSprite:small05
                                                               target:self
                                                             selector:@selector(eAction:)];
    
    [items addObject:item05];
    
    CCMenu  *menu05 = [CCMenu menuWithItems:item05, nil];
    [menu05 setPosition:ccp(160.0,196.0+iphoneAddY*2)];
    [page05 addChild:menu05 z:2];
    
    [pages addObject:page05];

    CCLayer *page06 = [CCLayer node];
    
    CCSprite *small06 = [CCSprite spriteWithFile:@"slider_06.pvr.gz"];
    small06.color = ccc3(255,255,255);
    
    CCMenuItemSprite *item06 = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"slider_06.pvr.gz"]
                                                       selectedSprite:small06
                                                               target:self
                                                             selector:@selector(fAction:)];
    
    [items addObject:item06];
    
    CCMenu  *menu06 = [CCMenu menuWithItems:item06, nil];
    [menu06 setPosition:ccp(160.0,196.0+iphoneAddY*2)];
    [page06 addChild:menu06 z:2];
    
    [pages addObject:page06];

	return [NSArray arrayWithObjects: [pages objectAtIndex:0],
            [pages objectAtIndex:1],
            [pages objectAtIndex:2],
            [pages objectAtIndex:3],
            [pages objectAtIndex:4],
            [pages objectAtIndex:5],
            nil];
}

// Creates new Scroll Layer with pages returned from scrollLayerPages.
- (CustomScrollLayer *) scrollLayer
{
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	
	// Create the scroller and pass-in the pages (set widthOffset to 0 for fullscreen pages).
	CustomScrollLayer *scroller = [CustomScrollLayer nodeWithLayers: [self scrollLayerPages] widthOffset: 0 pageSpriteFrameName:@"dot.png"];
	scroller.pagesIndicatorPosition = ccp(screenSize.width * 0.5f, 17.0f+iphoneAddY*2);
	
    // New feature: margin offset - to slowdown scrollLayer when scrolling out of it contents.
    // Comment this line or change marginOffset to screenSize.width to disable this effect.
    scroller.marginOffset = 0.5f * screenSize.width;
    
	return scroller;
}

#pragma mark Callbacks

// "Add Page" Button Callback - adds new page & updates fast page change menu.
- (void) addPagePressed: (CCNode *) sender
{
	NSLog(@"CustomScrollLayerTestLayer#addPagePressed: called!");
	
	// Add page with label with number.
	CGSize screenSize = [CCDirector sharedDirector].winSize;
	
	CustomScrollLayer *scroller = (CustomScrollLayer *)[self getChildByTag:kScrollLayer];
	
	int x = [scroller.pages count] + 1;
	CCLayer *pageX = [CCLayer node];
	CCLabelTTF *label = [CCLabelTTF labelWithString: [NSString stringWithFormat:@"Page %d", x]
										   fontName: @"GROBOLD"
										   fontSize:44];
	label.position =  ccp( screenSize.width /2 , screenSize.height/2 );
	[pageX addChild:label];
	
	[scroller addPage: pageX];
	
	//Update fast page change menu.
	//[self updateFastPageChangeMenu];
}

// "Remove page" menu callback - removes pages through running new action with delay.
- (void) removePagePressed: (CCNode *) sender
{
	// Run action with page removal on cocos2d thread.
	[self runAction:[CCSequence actions:
					 [CCDelayTime actionWithDuration:0.2f],
					 [CCCallFunc actionWithTarget:self selector:@selector(removePage)],
					 nil]
	 ];
}

- (void) removePage
{
	// Actually remove page.
	CustomScrollLayer *scroller = (CustomScrollLayer *)[self getChildByTag:kScrollLayer];
	[scroller removePageWithNumber: [scroller.pages count] - 1];
	
	// Update fast page change menu.
	//[self updateFastPageChangeMenu];
}

// "0 1 2" menu callback - used for fast page change.
- (void) fastMenuItemPressed: (CCNode *) sender
{
	CustomScrollLayer *scroller = (CustomScrollLayer *)[self getChildByTag:kScrollLayer];
	
	[scroller moveToPage: sender.tag];
}

#pragma mark Scroll Layer Callbacks

// Unselects all selected menu items in node - used in scroll layer callbacks to
// cancel menu items when scrolling started.
-(void)unselectAllMenusInNode:(CCNode *)node
{
	for (CCNode *child in node.children)
	{
		if ([child isKindOfClass:[CCMenu class]])
		{
			// Child here is CCMenu subclass - unselect.
			[(CCMenu *)child unselectSelectedItem];
		}
		else
		{
			// Child here is some other CCNode subclass.
			[self unselectAllMenusInNode: child];
		}
	}
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    printf("touch\n");
    touched = YES;
}

- (void) scrollLayerScrollingStarted:(CustomScrollLayer *) sender
{
	NSLog(@"CustomScrollLayerTestLayer#scrollLayerScrollingStarted: %@", sender);
	
    //if (touched)
        [[SimpleAudioEngine sharedEngine] playEffect:@"short_whoosh.caf"];
    
    [self unschedule:@selector(checkTouches:)];
    [self schedule:@selector(checkTouches:) interval:8.0];

	// No buttons can be touched after scroll started.
	[self unselectAllMenusInNode: self];
}

- (void) scrollLayer: (CustomScrollLayer *) sender scrolledToPageNumber: (int) page
{
	NSLog(@"CustomScrollLayerTestLayer#scrollLayer:scrolledToPageNumber: %@ %d", sender, page);
    
    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];

    [delegate setCurrentMenuItem:page];
    
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
