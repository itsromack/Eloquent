//
//  WorkspaceViewHostController.h
//  MacSword2
//
//  Created by Manfred Bergmann on 06.11.08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <PSMTabBarControl/PSMTabBarControl.h>
#import <PSMTabBarControl/PSMTabStyle.h>
#import <WindowHostController.h>
#import <Indexer.h>
#import <ObjCSword/SwordModule.h>
#import <ProtocolHelper.h>

#define WORKSPACEVIEWHOST_NIBNAME   @"WorkspaceViewHost"

@class ContentDisplayingViewController;
@class SwordModule;
@class FileRepresentation;

@interface WorkspaceViewHostController : WindowHostController <NSCoding> {

    /** the view switcher */
    //IBOutlet NSSegmentedControl *tabControl;
    IBOutlet PSMTabBarControl *tabControl;
    IBOutlet NSTabView *tabView;
    
    IBOutlet NSViewController *initialViewController;
    IBOutlet NSView *defaultMainView;
    
    /** each tabItem should have this menu */
    IBOutlet NSMenu *tabItemMenu;

    /** one view controller for each tab */
    NSMutableArray *viewControllers;
    
    /** array of search text objects */
    NSMutableArray *searchTextObjs;
}

// methods
- (NSView *)contentView;
- (void)setContentView:(NSView *)aView;
- (NSString *)computeTabTitle;

// actions
- (IBAction)addTab:(id)sender;
- (IBAction)menuItemSelected:(id)sender;
- (IBAction)openModuleInstaller:(id)sender;

// NSCoding
- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;

@end
