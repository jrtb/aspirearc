//
//  QuestionsLayer.h
//  questions
//
//  Created by jrtb on 7/9/10.
//  Copyright jrtb 2010. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// Questions Layer
@interface iphoneQuestionScene : CCLayer
{
	CGSize size;
	
	CCMenuItemSprite *aButton;
	CCMenuItemSprite *bButton;
	CCMenuItemSprite *cButton;
	CCMenuItemSprite *dButton;
	
	NSString *question;
	NSString *answerA;
	NSString *answerB;
	NSString *answerC;
	NSString *answerD;
	NSString *explanation;
	NSString *category;
	NSString *correctAnswer;
		
	CCMenu *questionMenu;
	
	//CCLabel *aLabel;
	//CCLabel *bLabel;
	//CCLabel *cLabel;
	//CCLabel *dLabel;
	
	CCLabelTTF *explanationLabel;
	
	CCSprite *overlay;
	
	CCMenuItem *submitButton;
	CCMenu *submitMenu;
	
	CCMenuItem *nextButton;
	CCMenu *nextMenu;
	
	CCMenuItem *explanationButton;
	CCMenu *explanationMenu;

	CCMenuItem *backButton;
	CCMenu *backMenu;

	CCSprite *explanationBG;

	UIWebView *questionView;
	UITextView *aView;
	UITextView *bView;
	UITextView *cView;
	UITextView *dView;
	
}

// returns a Scene that contains the Questions as the only child
+(id) scene;

- (void) submitButtonPressed: (id)sender;
- (void) nextButtonPressed: (id)sender;

- (void) aButtonPressed: (id)sender;
- (void) bButtonPressed: (id)sender;
- (void) cButtonPressed: (id)sender;
- (void) dButtonPressed: (id)sender;

- (void) backButtonPressed: (id)sender;
- (void) explanationButtonPressed: (id)sender;

- (void) nextQuestion: (ccTime)sender;

- (float) getFontSizeForString :(NSString *)aString :(int)containerHeight :(int)containerWidth;

@end
