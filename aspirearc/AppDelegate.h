//
//  AppDelegate.h
//  aspirearc
//
//  Created by jrtb on 7/16/13.
//  Copyright ncsu 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

#define IPAD 0
#define IPHONE 1

#define INTRO 151
#define MENU 152
#define COUNTY 153
#define SOCIAL 154
#define ABOUT 155

#define TEACHER 200
#define SCHEDULE 201

#define CATEGORY 203
#define QUESTIONS 202

#define CONTACT 204

// Added only for iOS 6 support
@interface MyNavigationController : UINavigationController <CCDirectorDelegate>
@end

@interface AppController : NSObject <UIApplicationDelegate>
{
    int                 screenToggle;
    int                 nextScreen;
    
	int					deviceMode;
    int                 deviceLevel;
    
    BOOL                isRetina;
    
    BOOL                muted;
    
    NSString            *selectedCounty;
    
    int                 currentMenuItem;
    
    int                 afterCounty;
    BOOL                loadPDFInMenu;

	UIWindow *window_;
	MyNavigationController *navController_;

	CCDirectorIOS	*__unsafe_unretained director_;							// weak ref
    
    NSMutableArray      *questions;
	int                 currentQuestionIndex;
	BOOL                doneWithAssessment;
	NSString            *currentCategory;
	int                 numQuestions;
    int                 numCorrect;

}

@property BOOL loadPDFInMenu;
@property int currentMenuItem;

@property int afterCounty;

@property int screenToggle;
@property int nextScreen;

@property int deviceMode;
@property int deviceLevel;

@property BOOL isRetina;

@property BOOL muted;

@property (nonatomic, copy) NSString *selectedCounty;

@property (nonatomic, strong) UIWindow *window;
@property (readonly) MyNavigationController *navController;
@property (unsafe_unretained, readonly) CCDirectorIOS *director;

@property (nonatomic, retain) NSMutableArray *questions;
@property int currentQuestionIndex;
@property BOOL doneWithAssessment;
@property (nonatomic, retain) NSString *currentCategory;
@property int numQuestions;
@property int numCorrect;

-(void) replaceTheScene;

- (NSDictionary *) getNextQuestion;
- (void) resetQuestions;

@end
