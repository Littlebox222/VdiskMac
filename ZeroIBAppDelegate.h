//
//  ZeroIBAppDelegate.h
//  ZeroIB
//
//  Created by liam on 10-10-22.
//  Copyright 2010 Beyondcow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VdiskSDK-OSX/VdiskSDK.h>
#import <AppKit/AppKit.h>
#import <Quartz/Quartz.h>

#import "TableHeaderView.h"
#import "TableFooterView.h"
#import "FileListTableView.h"

#import "TableCellView.h"
#import "ShareWindow.h"


@interface ZeroIBAppDelegate : NSObject <NSApplicationDelegate, NSToolbarDelegate, VdiskSessionDelegate, VdiskRestClientDelegate, NSTableViewDataSource, NSTableViewDelegate, NSWindowDelegate, TableHeaderViewDelegate, NSUserNotificationCenterDelegate, QLPreviewPanelDataSource, QLPreviewPanelDelegate, QLPreviewItem, NSDraggingSource, NSDraggingDestination, NSPasteboardItemDataProvider, FileListTableViewDelegate> {
    
    NSWindow *_window;
    NSButton *_buttonSignIn;
    NSButton *_buttonFileList;
    NSWindowController *_controller;
    NSToolbar *_toolBar;
    NSScrollView *_scrollView;
    NSView *_windowContentView;
    FileListTableView *_tableView;
    VdiskRestClient *_vdiskRestClient;
    NSMutableArray *_metadataArray;
    NSString *_vDiskUserRootPath;
    NSString *_selectedFilePath;
    QLPreviewPanel *_previewPanel;
    VdiskMetadata *_selectedMetadata;
    TableFooterView *_tableFooterView;
    
    NSURL *_fileURLToUpload;
    
    NSWindowController *_shareWindowController;
    ShareWindow *_shareWindow;
}


@property (nonatomic, retain) NSWindow *window;
@property (nonatomic, retain) NSButton *buttonSignIn;
@property (nonatomic, retain) NSButton *buttonFileList;
@property (nonatomic, retain) NSWindowController *controller;
@property (nonatomic, retain) NSToolbar *toolBar;

@property (nonatomic, retain) NSScrollView *scrollView;
@property (nonatomic, retain) FileListTableView *tableView;
@property (nonatomic, retain) NSView *windowContentView;

@property (nonatomic, retain) NSMutableArray *metadataArray;
@property (nonatomic, retain) NSString *vDiskUserRootPath;
@property (nonatomic, retain) NSString *selectedFilePath;

@property (nonatomic, retain) QLPreviewPanel *previewPanel;
@property (nonatomic, retain) VdiskMetadata *selectedMetadata;

@property (nonatomic, retain) TableFooterView *tableFooterView;

@property (nonatomic, retain) NSWindowController *shareWindowController;
@property (nonatomic, retain) ShareWindow *shareWindow;

- (void)togglePreviewPanel:(id)previewPanel;

@end
