//
//  OptionsLayer.m
//  questions
//
//  Created by jrtb on 7/9/10.
//  Copyright jrtb 2010. All rights reserved.
//

// Import the interfaces
#import "OptionsScene.h"

#import "SoundMenuItem.h"

#import "questionsAppDelegate.h"

#import "MenuScene.h"

#import "JRTBPref.h"

//#import <UIKit/UIKit.h>

// Options implementation
@implementation OptionsScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	OptionsScene *layer = [OptionsScene node];
	
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
	if( (self=[super init] )) {
		
		// ask director the the window size
		size = [[CCDirector sharedDirector] winSize];

		//optionsButtons = [[NSMutableArray alloc] init];	
		//categories = [[NSMutableArray alloc] init];	

		CCSprite *bg = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage: @"options.png"]];
		bg.position = CGPointMake(size.width/2, size.height/2);
		[self addChild:bg z:0];
		
	}
	return self;
}

- (float) getFontSizeForString :(NSString *)aString :(int)containerHeight :(int)containerWidth
{
	//  Measure the height of the string given the width.
	float fontSize = 20;
	CGSize maxSize = { containerWidth, 20000.0f };		// Start off with an actual width and a really large height.
	
	float actualHeight = containerHeight+20.0;
	
	while (actualHeight > containerHeight) {
		
		// Calculate the actual size of the text with the font, size and line break mode.
		CGSize actualSize = [aString sizeWithFont:[UIFont fontWithName:@"Arial" size:fontSize]
								constrainedToSize:maxSize
								lineBreakMode:UILineBreakModeWordWrap];
		
		actualHeight = actualSize.height;
		
		if (actualHeight > containerHeight) {
			
			fontSize = fontSize - 1.0;
			
		}
		
		printf("new font size: %f\n",fontSize);
		
	}
	
	return fontSize;
}	

-(void) onEnterTransitionDidFinish
{
	[super onEnterTransitionDidFinish];

	printf("entering Options Scene\n");
	
	questionsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];

	backButton = [SoundMenuItem itemFromNormalImage:@"btn_menu.png" selectedImage:@"btn_menu_hl.png" target:self selector:@selector(backButtonPressed:)];
	backMenu = [CCMenu menuWithItems: backButton, nil];
	backMenu.position = ccp(160,30);
	[self addChild: backMenu z:11];
	
	/*
	CCLabel* titleLabel = [CCLabel labelWithString:@"Options" dimensions:CGSizeMake(size.width, 80) alignment:UITextAlignmentCenter fontName:@"Arial" fontSize:32];
	titleLabel.position = ccp(size.width/2, size.height-50);
	titleLabel.color = ccc3(61,101,157);
	[self addChild:titleLabel z:20];
	*/
	
	CCLabel* promptLabel = [CCLabel labelWithString:@"Choose questions from:" dimensions:CGSizeMake(size.width, 80) alignment:UITextAlignmentCenter fontName:@"Arial" fontSize:24];
	promptLabel.position = ccp(size.width/2, size.height-210);
	promptLabel.color = ccc3(0,0,0);
	[self addChild:promptLabel z:20];
	
	/*
	// figure out how many categories there are
	
	NSDictionary *question;
	printf("total questions: %i\n",[[delegate questions] count]);
	
	for (question in [delegate questions]) {
		
		NSString *aCategory = [[NSString alloc] initWithString:[question objectForKey:@"category"]];
		
		BOOL alreadyInThere = NO;
		
		for (int i=0; i < [categories count]; i++) {
			if ([[categories objectAtIndex:i] isEqualToString:aCategory]) {
				alreadyInThere = YES;
			}
		}
		
		if (!alreadyInThere) {
			[categories addObject:aCategory];
		}
		
	}

	for (int i=0; i < [categories count]; i++) {
		//NSLog([categories objectAtIndex:i]);
				
	}
	*/
	
	// Manually create a button for each category.
	allCategories = [SoundMenuItem itemFromNormalImage:@"button_unchecked.png" selectedImage:@"button_checked.png" target:self selector:@selector(allCategoriesPressed:)];
	category1 = [SoundMenuItem itemFromNormalImage:@"button_unchecked.png" selectedImage:@"button_checked.png" target:self selector:@selector(category1Pressed:)];
	category2 = [SoundMenuItem itemFromNormalImage:@"button_unchecked.png" selectedImage:@"button_checked.png" target:self selector:@selector(category2Pressed:)];
	//category3 = [SoundMenuItem itemFromNormalImage:@"button_unchecked.png" selectedImage:@"button_checked.png" target:self selector:@selector(category3Pressed:)];

	if ([[delegate currentCategory] isEqualToString:@"All categories"]) {
		[allCategories jrtbSelected];
	}
	if ([[delegate currentCategory] isEqualToString:@"ICND1"]) {
		[category1 jrtbSelected];
	}
	if ([[delegate currentCategory] isEqualToString:@"ICND2"]) {
		[category2 jrtbSelected];
	}
	//if ([[delegate currentCategory] isEqualToString:@"Category C"]) {
	//	[category3 jrtbSelected];
	//}
	
	optionsMenu = [CCMenu menuWithItems:allCategories, category1, category2, nil];
	[optionsMenu alignItemsVertically];
	optionsMenu.position = CGPointMake(30,190+20);
	[self addChild: optionsMenu z:4];
	
	CCLabel *aLabel = [CCLabel labelWithString:@"All categories" dimensions:CGSizeMake(size.width-60, 40) alignment:UITextAlignmentLeft fontName:@"Arial" fontSize:22];
	aLabel.position = ccp(size.width/2+21, 240);
	aLabel.color = ccc3(0,0,0);
	[self addChild:aLabel z:2];
	
	CCLabel *bLabel = [CCLabel labelWithString:@"ICND1" dimensions:CGSizeMake(size.width-60, 40) alignment:UITextAlignmentLeft fontName:@"Arial" fontSize:22];
	bLabel.position = ccp(size.width/2+21, 200);
	bLabel.color = ccc3(0,0,0);
	[self addChild:bLabel z:2];
	
	CCLabel *cLabel = [CCLabel labelWithString:@"ICND2" dimensions:CGSizeMake(size.width-60, 40) alignment:UITextAlignmentLeft fontName:@"Arial" fontSize:22];
	cLabel.position = ccp(size.width/2+21, 160);
	cLabel.color = ccc3(0,0,0);
	[self addChild:cLabel z:2];
	
	//CCLabel *dLabel = [CCLabel labelWithString:@"Category C" dimensions:CGSizeMake(size.width-60, 40) alignment:UITextAlignmentLeft fontName:@"Arial" fontSize:22];
	//dLabel.position = ccp(size.width/2+21, 120);
	//dLabel.color = ccc3(0,0,0);
	//[self addChild:dLabel z:2];
	
}

- (void) allCategoriesPressed: (id)sender
{
	[allCategories jrtbSelected];
	[category1 unselected];
	[category2 unselected];
	[category3 unselected];
	
	questionsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	JRTBPref *Pref = [JRTBPref alloc];		
	[Pref saveStringToPref:@"prefsCategory" :@"All categories"];
	[delegate setCurrentCategory:@"All categories"];
	[Pref release];
	
}

- (void) category1Pressed: (id)sender
{
	[allCategories unselected];
	[category1 jrtbSelected];
	[category2 unselected];
	[category3 unselected];
	
	questionsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	JRTBPref *Pref = [JRTBPref alloc];		
	[Pref saveStringToPref:@"prefsCategory" :@"ICND1"];
	[delegate setCurrentCategory:@"ICND1"];
	[Pref release];
	
}

- (void) category2Pressed: (id)sender
{
	[allCategories unselected];
	[category1 unselected];
	[category2 jrtbSelected];
	[category3 unselected];
	
	questionsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	JRTBPref *Pref = [JRTBPref alloc];		
	[Pref saveStringToPref:@"prefsCategory" :@"ICND2"];
	[delegate setCurrentCategory:@"ICND2"];
	[Pref release];
	
}

- (void) category3Pressed: (id)sender
{
	[allCategories unselected];
	[category1 unselected];
	[category2 unselected];
	[category3 jrtbSelected];
	
	questionsAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
	JRTBPref *Pref = [JRTBPref alloc];		
	[Pref saveStringToPref:@"prefsCategory" :@"Category C"];
	[delegate setCurrentCategory:@"Category C"];
	[Pref release];
	
}

- (void) backButtonPressed: (id)sender
{
	[[CCDirector sharedDirector] replaceScene:[MenuScene scene]];	
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
