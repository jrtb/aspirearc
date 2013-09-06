//
//  QuestionsLayer.m
//  questions
//
//  Created by jrtb on 7/9/10.
//  Copyright jrtb 2010. All rights reserved.
//

// Import the interfaces
#import "iphoneQuestionScene.h"

#import "AppDelegate.h"

#import "CCUIViewWrapper.h"

#import "iphoneMenuScene.h"

#import "iphoneACTResultsScene.h"

// Questions implementation
@implementation iphoneQuestionScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	iphoneQuestionScene *layer = [iphoneQuestionScene node];
	
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
		
		CCSprite *bg = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage: @"white.png"]];
		bg.position = CGPointMake(size.width/2, size.height/2);
        bg.scale = 2.0;
		[self addChild:bg z:0];
		
		overlay = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage: @"white.png"]];
		overlay.position = CGPointMake(size.width/2, size.height/2);
        overlay.scale = 2.0;
		[self addChild:overlay z:10];
		
		[overlay runAction:[CCFadeTo actionWithDuration:0.4f opacity:0]];
		
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
    
    [delegate setNumCorrect:0];
    [delegate setCurrentQuestionIndex:0];
    
    [delegate setScreenToggle:MENU];
    
    [delegate replaceTheScene];
}

- (CGSize) getSizeForString :(NSString *)aString :(int)containerHeight :(int)containerWidth :(float)fontSize
{
	//  Measure the height of the string given the width.
	CGSize maxSize = { containerWidth, 20000.0f };		// Start off with an actual width and a really large height.
	
	// Calculate the actual size of the text with the font, size and line break mode.
	CGSize actualSize = [aString sizeWithFont:[UIFont fontWithName:@"Helvetica" size:fontSize]
							constrainedToSize:maxSize
								lineBreakMode:UILineBreakModeWordWrap];
	
	return actualSize;
}	

- (float) getFontSizeForString :(NSString *)aString :(int)containerHeight :(int)containerWidth
{
	//  Measure the height of the string given the width.
	float fontSize = 20;
	CGSize maxSize = { containerWidth, 20000.0f };		// Start off with an actual width and a really large height.
	
	float actualHeight = containerHeight+20.0;
	
	while (actualHeight > containerHeight) {
		
		// Calculate the actual size of the text with the font, size and line break mode.
		CGSize actualSize = [aString sizeWithFont:[UIFont fontWithName:@"Helvetica" size:fontSize]
								constrainedToSize:maxSize
									lineBreakMode:UILineBreakModeWordWrap];
		
		actualHeight = actualSize.height;
		
		if (actualHeight > containerHeight) {
			
			fontSize = fontSize - 1.0;
			
		}
		
		//printf("new font size: %f\n",fontSize);
		
	}
	
	return fontSize;
}	

-(void) onEnterTransitionDidFinish
{
	[super onEnterTransitionDidFinish];
	
    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
	
	NSDictionary *currentQuestion = [delegate getNextQuestion];
	question = [[NSString alloc] initWithString:[currentQuestion objectForKey:@"question"]];
	answerA = [[NSString alloc] initWithString:[currentQuestion objectForKey:@"answerA"]];
	answerB = [[NSString alloc] initWithString:[currentQuestion objectForKey:@"answerB"]];
	answerC = [[NSString alloc] initWithString:[currentQuestion objectForKey:@"answerC"]];
	answerD = [[NSString alloc] initWithString:[currentQuestion objectForKey:@"answerD"]];
	explanation = [[NSString alloc] initWithString:[currentQuestion objectForKey:@"explanation"]];
	category = [[NSString alloc] initWithString:[currentQuestion objectForKey:@"category"]];
	correctAnswer = [[NSString alloc] initWithString:[currentQuestion objectForKey:@"correctAnswer"]];
	
	CCLabelTTF* titleLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Question %i",[delegate currentQuestionIndex]] fontName:@"HelveticaNeue-Light" fontSize:16 dimensions:CGSizeMake(size.width, 40) hAlignment:UITextAlignmentCenter];
	titleLabel.position = ccp(size.width/2, size.height-25);
	titleLabel.color = ccc3(28,126,251);
	[self addChild:titleLabel z:20];
	
    float bot = 198;
    if (IS_IPHONE5)
        bot = 278;
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
	questionView = [[UIWebView alloc] initWithFrame:CGRectMake(6.0, 28.0, 320-12.0, bot)];
	//questionView.scrollEnabled = YES;
	questionView.userInteractionEnabled = YES;
    questionView.backgroundColor = [UIColor clearColor];
    questionView.opaque = NO;
	//questionView.text = question;
	//questionView.editable = NO;
	//questionView.font = [UIFont fontWithName:@"Arial" size:20.0f];
    [questionView loadHTMLString:question baseURL:baseURL];
    
	CCUIViewWrapper *viewWrapper = [CCUIViewWrapper wrapperForUIView:questionView];
	[self addChild:viewWrapper];
    	
	/*
	 CGSize            winSize;
	 CCSprite          *pic;
	 CCScrollView      *sclView;
	 winSize = [[CCDirector sharedDirector] winSize];
	 
	 pic     = [CCSprite spriteWithFile:@"pic.jpg"];
	 sclView = [CCScrollView scrollViewWithViewSize:CGSizeMake(50, 50)];
	 pic.position          = ccp(0.0f, 0.0f);
	 sclView.position      = ccp(0.0f, 0.0f);
	 sclView.contentOffset = ccp(0.0f, 0.0f);
	 sclView.contentSize   = CGSizeMake(50, 50);
	 sclView.direction     = CCScrollViewDirectionVertical;	
	 sclView.clipToBounds = YES;
	 
	 [sclView addChild:pic];
	 [self addChild:sclView z:22];
	 */
	
	/*
	 CCLabel* questionLabel = [CCLabel labelWithString:question dimensions:CGSizeMake(size.width-30, 400) alignment:UITextAlignmentLeft fontName:@"Arial" fontSize:40];
	 //CCLabel* questionLabel = [CCLabel labelWithString:question fontName:@"Arial" fontSize:40];
	 questionLabel.position = ccp(0.0f, 0.0f);
	 questionLabel.anchorPoint   = ccp(0.0f, 1.0f);
	 //questionLabel.position = ccp(size.width/2, size.height/2+90);
	 questionLabel.color = ccc3(0,0,0);
	 //[self addChild:questionLabel z:2];
	 
	 CGSize questionSize = [self getSizeForString :question :400 :290 :40];
	 
	 printf("question height: %f, question width: %f\n",questionSize.height, questionSize.width);
	 
	 float lh = 180;
	 if (questionSize.height < 180) {
	 lh = questionSize.height;
	 }
	 float mh = 180;
	 if (questionSize.height > 180) {
	 mh = questionSize.height;
	 }
	 
	 CCScrollView *sclViewQuestion;
	 sclViewQuestion = [CCScrollView scrollViewWithViewSize:CGSizeMake(290,lh)];
	 sclViewQuestion.position      = ccp(15,30);
	 sclViewQuestion.contentOffset = ccp(0.0f, 0.0f);
	 sclViewQuestion.contentSize   = CGSizeMake(290, lh);
	 sclViewQuestion.direction     = CCScrollViewDirectionVertical;
	 sclViewQuestion.bounces       = YES;
	 sclViewQuestion.clipToBounds  =  NO;
	 
	 [sclViewQuestion addChild:questionLabel];
	 [self addChild:sclViewQuestion z:22];
	 */
	   
    aButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"button_unchecked.png"]
                                      selectedSprite:[CCSprite spriteWithFile:@"button_checked.png"]
                                              target:self
                                            selector:@selector(aButtonPressed:)];

    bButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"button_unchecked.png"]
                                      selectedSprite:[CCSprite spriteWithFile:@"button_checked.png"]
                                              target:self
                                            selector:@selector(bButtonPressed:)];

    cButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"button_unchecked.png"]
                                      selectedSprite:[CCSprite spriteWithFile:@"button_checked.png"]
                                              target:self
                                            selector:@selector(cButtonPressed:)];

    dButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"button_unchecked.png"]
                                      selectedSprite:[CCSprite spriteWithFile:@"button_checked.png"]
                                              target:self
                                            selector:@selector(dButtonPressed:)];
	
	if (!answerC || [answerC isEqualToString:@""]) {
		cButton.opacity = 0;
		[cButton setIsEnabled:NO];
	}
	if (!answerD || [answerD isEqualToString:@""]) {
		dButton.opacity = 0;
		[dButton setIsEnabled:NO];
	}
	
    float top2 = (158.0/480)*size.height;
    float diff2 = 15.0;
    if (IS_IPHONE5)
        top2 = top2 - 30;
    //if ([delegate isRetina])
    //    diff2 = 30.0;

	questionMenu = [CCMenu menuWithItems:aButton, bButton, cButton, dButton, nil];
	[questionMenu alignItemsVerticallyWithPadding:diff2];
	//[aButton jrtbSelected];
	questionMenu.position = ccp(30,top2);
	[self addChild: questionMenu z:3];
	
    /*
	explanationLabel = [CCLabelTTF labelWithString:explanation fontName:@"Helvetica" fontSize:[self getFontSizeForString:explanation :300 :290] dimensions:CGSizeMake(size.width-30, 300) hAlignment:UITextAlignmentLeft ];
	explanationLabel.position = ccp(size.width/2, size.height/2+40);
	explanationLabel.color = ccc3(0,0,0);
	explanationLabel.opacity = 0;
	[self addChild:explanationLabel z:11];
	*/
    
    explanationView = [[UIWebView alloc] initWithFrame:CGRectMake(6.0, 28.0, 320-12.0, bot)];
	//questionView.scrollEnabled = YES;
	explanationView.userInteractionEnabled = YES;
    explanationView.backgroundColor = [UIColor clearColor];
    explanationView.opaque = NO;
	//questionView.text = question;
	//questionView.editable = NO;
	//questionView.font = [UIFont fontWithName:@"Arial" size:20.0f];
    [explanationView loadHTMLString:explanation baseURL:baseURL];

	explanationViewWrapper = [CCUIViewWrapper wrapperForUIView:explanationView];
    explanationViewWrapper.opacity = 0;
	[self addChild:explanationViewWrapper z:11];

	//aLabel = [CCLabel labelWithString:answerA dimensions:CGSizeMake(size.width-60, 40) alignment:UITextAlignmentLeft fontName:@"Arial" fontSize:[self getFontSizeForString:answerA :40 :240]];
	//aLabel.position = ccp(size.width/2+21, size.height/2-50);
	//aLabel.color = ccc3(0,0,0);
	//[self addChild:aLabel z:2];
	
    float top = (227.0/480)*size.height;
    float diff = 50.0;
    //if ([delegate isRetina])
    //    diff = 100.0;
    if (IS_IPHONE5)
        top = top + 44;

	aView = [[UITextView alloc] initWithFrame:CGRectMake(41.0, top, size.width-40, diff)];
	aView.scrollEnabled = YES;
	aView.userInteractionEnabled = YES;
	aView.editable = NO;
	aView.text = answerA;
	aView.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    aView.backgroundColor = [UIColor clearColor];
	
    CCUIViewWrapper *aViewWrapper = [CCUIViewWrapper wrapperForUIView:aView];
	[self addChild:aViewWrapper z:2];

	//bLabel = [CCLabel labelWithString:answerB dimensions:CGSizeMake(size.width-60, 40) alignment:UITextAlignmentLeft fontName:@"Arial" fontSize:[self getFontSizeForString:answerB :40 :240]];
	//bLabel.position = ccp(size.width/2+21, size.height/2-50-40);
	//bLabel.color = ccc3(0,0,0);
	//[self addChild:bLabel z:2];
	
	bView = [[UITextView alloc] initWithFrame:CGRectMake(41.0, top+50, size.width-40, diff)];
	bView.scrollEnabled = YES;
	bView.userInteractionEnabled = YES;
	bView.editable = NO;
	bView.text = answerB;
	bView.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    bView.backgroundColor = [UIColor clearColor];
	
    CCUIViewWrapper *bViewWrapper = [CCUIViewWrapper wrapperForUIView:bView];
	[self addChild:bViewWrapper z:2];

	//cLabel = [CCLabel labelWithString:answerC dimensions:CGSizeMake(size.width-60, 40) alignment:UITextAlignmentLeft fontName:@"Arial" fontSize:[self getFontSizeForString:answerC :40 :240]];
	//cLabel.position = ccp(size.width/2+21, size.height/2-50-80);
	//cLabel.color = ccc3(0,0,0);
	//[self addChild:cLabel z:2];
	
	cView = [[UITextView alloc] initWithFrame:CGRectMake(41.0, top+100, size.width-40, diff)];
	cView.scrollEnabled = YES;
	cView.userInteractionEnabled = YES;
	cView.editable = NO;
	cView.text = answerC;
	cView.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    cView.backgroundColor = [UIColor clearColor];
	
    CCUIViewWrapper *cViewWrapper = [CCUIViewWrapper wrapperForUIView:cView];
	[self addChild:cViewWrapper z:2];

	//dLabel = [CCLabel labelWithString:answerD dimensions:CGSizeMake(size.width-60, 40) alignment:UITextAlignmentLeft fontName:@"Arial" fontSize:[self getFontSizeForString:answerD :40 :240]];
	//dLabel.position = ccp(size.width/2+21, size.height/2-50-120);
	//dLabel.color = ccc3(0,0,0);
	//[self addChild:dLabel z:2];
	
	dView = [[UITextView alloc] initWithFrame:CGRectMake(41.0, top+150, size.width-40, diff)];
	dView.scrollEnabled = YES;
	dView.userInteractionEnabled = YES;
	dView.editable = NO;
	dView.text = answerD;
	dView.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    dView.backgroundColor = [UIColor clearColor];
    
    CCUIViewWrapper *dViewWrapper = [CCUIViewWrapper wrapperForUIView:dView];
	[self addChild:dViewWrapper z:2];
	
    CCSprite *submitButtonH = [CCSprite spriteWithFile:@"btn_submit.png"];
    submitButtonH.color = ccGRAY;

    submitButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"btn_submit.png"]
                                      selectedSprite:submitButtonH
                                              target:self
                                            selector:@selector(submitButtonPressed:)];

	submitMenu = [CCMenu menuWithItems: submitButton, nil];
	submitMenu.position = ccp(size.width/2,30);
	[self addChild: submitMenu z:3];

    CCSprite *nextButtonH = [CCSprite spriteWithFile:@"btn_next.png"];
    nextButtonH.color = ccGRAY;

    nextButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"btn_next.png"]
                                           selectedSprite:nextButtonH
                                                   target:self
                                                 selector:@selector(nextButtonPressed:)];

	nextMenu = [CCMenu menuWithItems: nextButton, nil];
	nextMenu.position = ccp(100,30);
	nextButton.opacity = 0;
    nextMenu.enabled = NO;
	[self addChild: nextMenu z:11];
	
    CCSprite *explanationButtonH = [CCSprite spriteWithFile:@"btn_explain.png"];
    explanationButtonH.color = ccGRAY;

    explanationButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"btn_explain.png"]
                                         selectedSprite:explanationButtonH
                                                 target:self
                                               selector:@selector(explanationButtonPressed:)];

	explanationMenu = [CCMenu menuWithItems: explanationButton, nil];
	explanationMenu.position = ccp(220,30);
	explanationButton.opacity = 0;
    explanationMenu.enabled = NO;
	[self addChild: explanationMenu z:11];

    CCSprite *backButtonH = [CCSprite spriteWithFile:@"btn_next.png"];
    backButtonH.color = ccGRAY;

    backButton = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithFile:@"btn_next.png"]
                                                selectedSprite:backButtonH
                                                        target:self
                                                      selector:@selector(backButtonPressed:)];

	backMenu = [CCMenu menuWithItems: backButton, nil];
	backMenu.position = ccp(220,30);
	backButton.opacity = 0;
    backMenu.enabled = NO;
	[self addChild: backMenu z:11];
	
	explanationBG = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage: @"white.png"]];
	explanationBG.position = CGPointMake(size.width/2, size.height/2);
	explanationBG.opacity = 0;
    explanationBG.scale = 2.0;
	[self addChild:explanationBG z:10];
	
}

- (void) nextButtonPressed: (id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];

	CCSprite *bg = [CCSprite spriteWithTexture:[[CCTextureCache sharedTextureCache] addImage: @"white.png"]];
	bg.position = CGPointMake(size.width/2, size.height/2);
	bg.opacity = 0;
    bg.scale = 2.0;
	[self addChild:bg z:30];
	
	[bg runAction:[CCFadeTo actionWithDuration:0.4f opacity:255]];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	questionView.alpha = 0;
	aView.alpha = 0;
	bView.alpha = 0;
	cView.alpha = 0;
	dView.alpha = 0;
	[UIView commitAnimations];
	
	[self schedule:@selector(nextQuestion:) interval:0.4];
}

- (void) explanationButtonPressed: (id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];

	[explanationBG runAction:[CCFadeTo actionWithDuration:0.4f opacity:255]];
	[explanationViewWrapper runAction:[CCFadeTo actionWithDuration:0.4f opacity:255]];
	
	//backButton.opacity = 255;
	//[backMenu setIsTouchEnabled:YES];
	nextMenu.position = ccp(160,30);
	
	[questionView removeFromSuperview];
	[aView removeFromSuperview];
	[bView removeFromSuperview];
	[cView removeFromSuperview];
	[dView removeFromSuperview];
	
	submitButton.opacity = 0;
	submitMenu.enabled = NO;
	explanationButton.opacity = 0;
    explanationMenu.enabled = NO;
	
}

- (void) backButtonPressed: (id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];

	[explanationBG runAction:[CCFadeTo actionWithDuration:0.4f opacity:0]];
	[explanationViewWrapper runAction:[CCFadeTo actionWithDuration:0.4f opacity:0]];
	
	backButton.opacity = 0;
    backMenu.enabled = NO;
    if (![explanation isEqualToString:@""]) {
        explanationButton.opacity = 255;
        explanationMenu.enabled = YES;
    }
	
}


- (void) submitButtonPressed: (id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];

	submitButton.opacity = 0;
    submitMenu.enabled = NO;
	nextButton.opacity = 255;
    nextMenu.enabled = YES;
    if (![explanation isEqualToString:@""]) {
        explanationButton.opacity = 255;
        explanationMenu.enabled = YES;
    }
	
	[aButton runAction:[CCFadeTo actionWithDuration:0.0f opacity:128]];
	[bButton runAction:[CCFadeTo actionWithDuration:0.0f opacity:128]];
	
	if (answerC && ![answerC isEqualToString:@""]) {
		[cButton runAction:[CCFadeTo actionWithDuration:0.0f opacity:128]];
	}
	if (answerD && ![answerD isEqualToString:@""]) {
		[dButton runAction:[CCFadeTo actionWithDuration:0.0f opacity:128]];
	}
	
    questionMenu.enabled = NO;
	
    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];

    if (([correctAnswer isEqualToString:@"A"] && aButton.isSelected) ||
        ([correctAnswer isEqualToString:@"B"] && bButton.isSelected) ||
        ([correctAnswer isEqualToString:@"C"] && cButton.isSelected) ||
        ([correctAnswer isEqualToString:@"D"] && dButton.isSelected)) {
        
        printf("correct\n");
        [delegate setNumCorrect:[delegate numCorrect]+1];
        
        printf("num correct: %i\n",[delegate numCorrect]);
        
    }

	if ([correctAnswer isEqualToString:@"A"]) {
		//	aLabel.color = ccc3(61,157,66);
		[aView setTextColor:[UIColor colorWithRed:61/255.0 green:157/255.0 blue:66/255.0 alpha:1]];
	} else {
		//	aLabel.color = ccc3(157,61,61);
		[aView setTextColor:[UIColor colorWithRed:157/255.0 green:61/255.0 blue:61/255.0 alpha:1]];
	}		
	if ([correctAnswer isEqualToString:@"B"]) {
		//bLabel.color = ccc3(61,157,66);
		[bView setTextColor:[UIColor colorWithRed:61/255.0 green:157/255.0 blue:66/255.0 alpha:1]];
    } else {
		//bLabel.color = ccc3(157,61,61);
		[bView setTextColor:[UIColor colorWithRed:157/255.0 green:61/255.0 blue:61/255.0 alpha:1]];
	}
	if ([correctAnswer isEqualToString:@"C"]) {
		//cLabel.color = ccc3(61,157,66);
		[cView setTextColor:[UIColor colorWithRed:61/255.0 green:157/255.0 blue:66/255.0 alpha:1]];
    } else {
		//cLabel.color = ccc3(157,61,61);
		[cView setTextColor:[UIColor colorWithRed:157/255.0 green:61/255.0 blue:61/255.0 alpha:1]];
	}
	if ([correctAnswer isEqualToString:@"D"]) {
		//dLabel.color = ccc3(61,157,66);
		[dView setTextColor:[UIColor colorWithRed:61/255.0 green:157/255.0 blue:66/255.0 alpha:1]];
    } else {
		//dLabel.color = ccc3(157,61,61);
		[dView setTextColor:[UIColor colorWithRed:157/255.0 green:61/255.0 blue:61/255.0 alpha:1]];
	}
	
}

- (void) nextQuestion: (ccTime) sender
{
	[self unschedule:@selector(nextQuestion:)];
	
    AppController *delegate  = (AppController*) [[UIApplication sharedApplication] delegate];
	
	if ([delegate doneWithAssessment]) {
		[delegate setCurrentQuestionIndex:0];
		[delegate setDoneWithAssessment:NO];
		[[CCDirector sharedDirector] replaceScene:[iphoneACTResultsScene scene]];
	} else {		
		[[CCDirector sharedDirector] replaceScene:[iphoneQuestionScene scene]];
	}
	
}

- (void) aButtonPressed: (id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];

	[aButton selected];
	[bButton unselected];
	[cButton unselected];
	[dButton unselected];
}

- (void) bButtonPressed: (id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];

	[aButton unselected];
	[bButton selected];
	[cButton unselected];
	[dButton unselected];
}

- (void) cButtonPressed: (id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];

	[aButton unselected];
	[bButton unselected];
	[cButton selected];
	[dButton unselected];
}

- (void) dButtonPressed: (id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"click2.caf"];

	[aButton unselected];
	[bButton unselected];
	[cButton unselected];
	[dButton selected];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    printf("questionScene dealloc running\n");
    
    [self unscheduleAllSelectors];
    
    [self removeAllChildrenWithCleanup:YES];
    
	[[CCDirector sharedDirector] purgeCachedData];
	
	[CCSpriteFrameCache purgeSharedSpriteFrameCache];
	[CCTextureCache purgeSharedTextureCache];
	
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
	[[CCTextureCache sharedTextureCache] removeAllTextures];

	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	//[super dealloc];
}
@end
