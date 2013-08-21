//
//  ZeroIBAppDelegate.m
//  ZeroIB
//
//  Created by liam on 10-10-22.
//  Copyright 2010 Beyondcow. All rights reserved.
//

#import "ZeroIBAppDelegate.h"
#import "ZeroIBMainMenu.h"

#define kVdiskSDKDemoAppKey         @"去微盘开发者中心申请"
#define kVdiskSDKDemoAppSecret      @"去微盘开发者中心申请"


#define kToolbarID                  @"ToolBarID"
#define kButtonFileListID           @"ButtonFileListID"
#define kButtonSignInID             @"ButtonSignInID"


@implementation ZeroIBAppDelegate

@synthesize window = _window;
@synthesize buttonSignIn = _buttonSignIn;
@synthesize buttonFileList = _buttonFileList;
@synthesize controller = _controller;
@synthesize toolBar = _toolBar;
@synthesize scrollView = _scrollView;
@synthesize windowContentView = _windowContentView;
@synthesize tableView = _tableView;
@synthesize metadataArray = _metadataArray;
@synthesize vDiskUserRootPath = _vDiskUserRootPath;
@synthesize selectedFilePath = _selectedFilePath;
@synthesize selectedMetadata = _selectedMetadata;
@synthesize tableFooterView = _tableFooterView;
@synthesize previewPanel = _previewPanel;
@synthesize shareWindowController = _shareWindowController;
@synthesize shareWindow = _shareWindow;

#pragma mark - Application Delegate

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification {
	
	NSSize screenSize=[[NSScreen mainScreen] visibleFrame].size;
	float windowWidth=300;
	float windowHeight=512;
	
	_window=[[NSWindow alloc] initWithContentRect:NSMakeRect((screenSize.width-windowWidth)/2, (screenSize.height-windowHeight)/2, windowWidth, windowHeight)
									   styleMask:NSTitledWindowMask | NSResizableWindowMask | NSClosableWindowMask | NSTexturedBackgroundWindowMask | NSMiniaturizableWindowMask
										 backing:NSBackingStoreBuffered 
										   defer:YES];
	_window.delegate = self;
    
	//[ZeroIBMainMenu populateMainMenu];
	
    // ToolBar Button
	self.buttonSignIn = [[[NSButton alloc] init] autorelease];
	[_buttonSignIn setFrame:NSMakeRect(20, 30, 80, 25)];
	[_buttonSignIn setBezelStyle:NSTexturedRoundedBezelStyle];
	[_buttonSignIn setTitle:@"登录"];
	[_buttonSignIn setTarget:self];
	[_buttonSignIn setAction:@selector(linkToVdisk:)];
    
    self.buttonFileList = [[[NSButton alloc] init] autorelease];
	[_buttonFileList setFrame:NSMakeRect(120, 30, 80, 25)];
	[_buttonFileList setBezelStyle:NSTexturedRoundedBezelStyle];
	[_buttonFileList setTitle:@"未登录"];
	[_buttonFileList setTarget:self];
    
    // Window ContentView
    self.windowContentView = [[[NSView alloc] initWithFrame:_window.frame] autorelease];
    CALayer *viewLayer = [CALayer layer];
    [viewLayer setBackgroundColor:CGColorCreateGenericRGB(0.0, 0.0, 0.0, 0.4)];
    [_windowContentView setWantsLayer:YES];
    [_windowContentView setLayer:viewLayer];
    
    
    // ScrollView with Tableview
    NSRect scrollFrame = NSMakeRect( 0, 0, 300, _windowContentView.frame.size.height);
    self.scrollView = [[[NSScrollView alloc] initWithFrame:scrollFrame] autorelease];
    
    [_scrollView setBorderType:NSNoBorder];
    [_scrollView setHasVerticalScroller:YES];
    [_scrollView setHasHorizontalScroller:NO];
    [_scrollView setAutohidesScrollers:NO];
    
    NSRect clipViewBounds = [[_scrollView contentView] bounds];
    self.tableView = [[[FileListTableView alloc] initWithFrame:clipViewBounds] autorelease];
    
    NSTableColumn *firstColumn = [[[NSTableColumn alloc] initWithIdentifier:@"firstColumn"] autorelease];
    [[firstColumn headerCell] setStringValue:@"First Column"];
    firstColumn.width = _tableView.frame.size.width;
    [_tableView addTableColumn:firstColumn];
    [_tableView setDoubleAction:@selector(tableViewRowDoubleClicked)];
    
    TableHeaderView *headerView = [[[TableHeaderView alloc] initWithFrame:NSMakeRect(0, 0, 300, 20)] autorelease];
    headerView.delegate = self;
    [_tableView setHeaderView:headerView];
    
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setCustomDelegate:self];
    [_scrollView setDocumentView:_tableView];
    
    [_windowContentView addSubview:_scrollView];
	_window.contentView = _windowContentView;
	_controller = [[NSWindowController alloc] initWithWindow:_window];
    
    // Table footer
    self.tableFooterView = [[TableFooterView alloc] initWithFrame:NSMakeRect(0, 0, 300, 30)];
    [_window.contentView addSubview:_tableFooterView];
    [_tableFooterView setAlphaValue:0.0f];
    [_tableFooterView setHidden:YES];
    
    // Set up Toolbar
    [self setupToolbar];
    
    
    // metadata array
    self.metadataArray = [[[NSMutableArray alloc] init] autorelease];
    
    
    // create folder
    self.vDiskUserRootPath = [NSString stringWithFormat:@"%@/my_vdisk", NSHomeDirectory()];
    NSFileManager *fileManager= [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:_vDiskUserRootPath]) {
        
        if(![fileManager createDirectoryAtPath:_vDiskUserRootPath withIntermediateDirectories:YES attributes:nil error:NULL]) {
            
            NSLog(@"Error: Create folder failed %@", _vDiskUserRootPath);
        }
    }
    
    [[NSUserNotificationCenter defaultUserNotificationCenter] setDelegate:self];
    
    [_window registerForDraggedTypes:[NSArray arrayWithObjects:NSTIFFPboardType,NSFilenamesPboardType,nil]];
    _fileURLToUpload = nil;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
	[_controller showWindow:self];
    
    VdiskSession *session = [[[VdiskSession alloc] initWithAppKey:kVdiskSDKDemoAppKey appSecret:kVdiskSDKDemoAppSecret appRoot:@"basic"] autorelease];
    
    session.delegate = self;
    [session setRedirectURI:@"http://vauth.appsina.com/link_macosx_vdisk/"];
    [VdiskSession setSharedSession:session];
    
    if ([session isLinked] && ![session isExpired]) {
        
        _vdiskRestClient = [[VdiskRestClient alloc] initWithSession:[VdiskSession sharedSession]];
        [_vdiskRestClient setDelegate:self];
        [_vdiskRestClient loadMetadata:@"/"];
        
        _buttonFileList.title = session.userID;
        _buttonSignIn.title = @"注销";
        
    }else {
        
        _buttonFileList.title = @"未登录";
        _buttonSignIn.title = @"登录";
    }
}

- (BOOL) applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
    
    [_controller showWindow:self];
	return YES;
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication {
	return NO;
}

- (void) applicationWillTerminate:(NSNotification *)notification {
    
	[_window release];
	_window=nil;

	[_controller release];
	_controller=nil;
    
    [_buttonFileList release];
    [_buttonSignIn release];
    
    [_toolBar release];
    [_scrollView release];
    [_windowContentView release];
    [_tableView release];
    
    [_metadataArray release];
    [_vDiskUserRootPath release];
    [_selectedFilePath release];
    [_selectedMetadata release];
    [_tableFooterView release];
}

- (void)linkToVdisk:(id)sender {
    
    if ([[VdiskSession sharedSession] isLinked]) {
        
        [[VdiskSession sharedSession] unlink];
    }else {
        [[VdiskSession sharedSession] link];
    }
    
}

- (void) setupToolbar {
    
    self.toolBar = [[[NSToolbar alloc] initWithIdentifier:kToolbarID] autorelease];
    
    [_toolBar setAllowsUserCustomization: YES];
    [_toolBar setAutosavesConfiguration: YES];
    [_toolBar setDisplayMode: NSToolbarDisplayModeIconOnly];
    [_toolBar setDelegate: self];
    
    [self.window setToolbar: _toolBar];
}

- (NSToolbarItem *)toolbarItemWithIdentifier:(NSString *)identifier
                                       label:(NSString *)label
                                 paleteLabel:(NSString *)paletteLabel
                                     toolTip:(NSString *)toolTip
                                      target:(id)target
                                 itemContent:(id)imageOrView
                                      action:(SEL)action
                                        menu:(NSMenu *)menu
{
    NSToolbarItem *item = [[[NSToolbarItem alloc] initWithItemIdentifier:identifier] autorelease];
    
    [item setLabel:label];
    [item setPaletteLabel:paletteLabel];
    [item setToolTip:toolTip];
    [item setTarget:target];
    [item setAction:action];
    
    
    if([imageOrView isKindOfClass:[NSImage class]]){
        [item setImage:imageOrView];
    } else if ([imageOrView isKindOfClass:[NSView class]]){
        [item setView:imageOrView];
    }else {
        assert(!"Invalid itemContent: object");
    }
    
    
    if (menu != nil)
    {
        NSMenuItem *mItem = [[[NSMenuItem alloc] init] autorelease];
        [mItem setSubmenu:menu];
        [mItem setTitle:label];
        [item setMenuFormRepresentation:mItem];
    }
    
    return item;
}

- (NSString*) getApplicationPath {
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleExecutable"];
    
    NSWorkspace *wp = [[NSWorkspace alloc] init];
    NSString *bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    NSString *allApp = [wp absolutePathForAppBundleWithIdentifier:bundleId];
    NSMutableString *appPath = [NSMutableString stringWithString:allApp];
    [appPath replaceOccurrencesOfString:[NSString stringWithFormat:@"%@.app", appName]
                             withString:@""
                                options:0
                                  range:NSMakeRange(0, [appPath length])];
    [wp release];
    

    //appPath = [[appPath componentsSeparatedByString: @"Debug/"] objectAtIndex:0];
    
    return appPath;
}

- (void)hideTableFooterView {
    
    [_tableFooterView setProgress:0.0];
    [[_tableFooterView animator] setAlphaValue:0.0];
    [_tableFooterView setHidden:YES];
}

#pragma mark -
#pragma mark VdiskSessionDelegate methods

- (void)sessionAlreadyLinked:(VdiskSession *)session {
    
    
    NSLog(@"sessionAlreadyLinked");
}

// Log in successfully.
- (void)sessionLinkedSuccess:(VdiskSession *)session {
    
    _buttonSignIn.title = @"注销";
    _buttonFileList.title = session.userID;
    [self updateToolBarItemWithitemIdentifier:kButtonSignInID];
    [self updateToolBarItemWithitemIdentifier:kButtonFileListID];
    
    _vdiskRestClient = [[VdiskRestClient alloc] initWithSession:[VdiskSession sharedSession]];
    [_vdiskRestClient setDelegate:self];
    [_vdiskRestClient loadMetadata:@"/"];
    
    NSLog(@"sessionLinkedSuccess");
}


- (void)session:(VdiskSession *)session didFailToLinkWithError:(NSError *)error {
    
    NSLog(@"didFailToLinkWithError:%@", error);
}


- (void)sessionUnlinkedSuccess:(VdiskSession *)session {
    
    _buttonSignIn.title = @"登录";
    _buttonFileList.title = @"未登录";
    [self updateToolBarItemWithitemIdentifier:kButtonSignInID];
    [self updateToolBarItemWithitemIdentifier:kButtonFileListID];
    
    [_metadataArray removeAllObjects];
    [_tableView reloadData];
    
    NSLog(@"sessionUnlinkedSuccess");
}


- (void)sessionNotLink:(VdiskSession *)session {
    
    NSLog(@"sessionNotLink");
}


- (void)sessionExpired:(VdiskSession *)session {
    
    [[VdiskSession sharedSession] refreshLink];
    
    NSLog(@"sessionExpired");
}


- (void)sessionWeiboAccessTokenIsNull:(VdiskSession *)session {
    
    NSLog(@"sessionWeiboAccessTokenIsNull");
}


#pragma mark - VdiskRestClientDelegate

- (void)restClient:(VdiskRestClient *)client loadedMetadata:(VdiskMetadata *)metadata {
    
    if (![[[_metadataArray lastObject] path] isEqualToString:[metadata path]]) {
        
        [_metadataArray addObject:[metadata retain]];
        
    }else {
        [_metadataArray removeLastObject];
        [_metadataArray addObject:[metadata retain]];
    }
    
    
    //_metadata = [metadata retain];
//    for (VdiskMetadata *m in metadata.contents) {
//        
//        NSLog(@"%@", m.filename);
//    }
    
    [_tableView reloadData];
}

- (void)restClient:(VdiskRestClient *)client metadataUnchangedAtPath:(NSString *)path {
    
    
}

- (void)restClient:(VdiskRestClient *)client loadMetadataFailedWithError:(NSError *)error {
    
    
}

- (void)restClient:(VdiskRestClient *)client loadedFile:(NSString *)destPath {
    
    [self performSelector:@selector(hideTableFooterView) withObject:nil afterDelay:1.0];
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"下载成功";
    notification.informativeText = destPath;
    notification.soundName = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    
    if ([QLPreviewPanel sharedPreviewPanelExists] && [[QLPreviewPanel sharedPreviewPanel] isVisible]) {
        [_previewPanel reloadData];
    }else {
        [self togglePreviewPanel:nil];
    }
}

- (void)restClient:(VdiskRestClient *)client loadFileFailedWithError:(NSError *)error {
    
    [_tableFooterView setProgress:0.0];
    [[_tableFooterView animator] setAlphaValue:0.0];
    [_tableFooterView setHidden:YES];
    NSLog(@"%@", error);
}

- (void)restClient:(VdiskRestClient *)client uploadedFile:(NSString *)destPath from:(NSString *)srcPath {
    
    [self performSelector:@selector(hideTableFooterView) withObject:nil afterDelay:1.0];
    
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"上传成功";
    notification.informativeText = destPath;
    notification.soundName = NSUserNotificationDefaultSoundName;
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    
    [_vdiskRestClient loadMetadata:[[_metadataArray lastObject] path]];
}

- (void)restClient:(VdiskRestClient *)client uploadFileFailedWithError:(NSError *)error {
    
    [_tableFooterView setProgress:0.0];
    [[_tableFooterView animator] setAlphaValue:0.0];
    [_tableFooterView setHidden:YES];
    NSLog(@"%@", error);
}

- (void)restClient:(VdiskRestClient *)client loadProgress:(CGFloat)progress forFile:(NSString *)destPath {
    
    [_tableFooterView setProgress:progress];
}

- (void)restClient:(VdiskRestClient *)client uploadProgress:(CGFloat)progress forFile:(NSString *)destPath from:(NSString *)srcPath {
    
    [_tableFooterView setProgress:progress];
}

- (void)restClient:(VdiskRestClient *)client deletedPath:(NSString *)path {
    
    [_vdiskRestClient loadMetadata:[[_metadataArray lastObject] path]];
    
    NSRect rr = [_tableView visibleRect];
    [_tableView scrollRectToVisible:rr];
}

- (void)restClient:(VdiskRestClient *)restClient deletePathFailedWithError:(NSError *)error {
    
    NSLog(@"%@", error);
}

#pragma mark -
#pragma mark NSToolbarItemValidation

- (void)updateToolBarItemWithitemIdentifier:(NSString *)identifier {
    
    NSArray *items = [_toolBar items];
    
    for (NSToolbarItem *item in items) {
        
        if ([item.itemIdentifier isEqualToString:identifier]) {
            
            [self validateToolbarItem:item];
            break;
        }
    }
}

- (BOOL)validateToolbarItem:(NSToolbarItem *)theItem
{
    // You could check [theItem itemIdentifier] here and take appropriate action if you wanted to
    
    if ([[theItem itemIdentifier] isEqualToString:kButtonSignInID]) {
        
        [theItem setLabel:_buttonSignIn.title];
        
    }else if ([[theItem itemIdentifier] isEqualToString:kButtonFileListID]) {
        
        [theItem setLabel:_buttonFileList.title];
    }
    
    return YES;
}


#pragma mark -
#pragma mark NSToolbarDelegate

- (void)toolbarWillAddItem:(NSNotification *)notif
{
    //NSToolbarItem *addedItem = [[notif userInfo] objectForKey:@"item"];
    
    // Is this the printing toolbar item?  If so, then we want to redirect it's action to ourselves
    // so we can handle the printing properly; hence, we give it a new target.
    //
    
    /*
     if ([[addedItem itemIdentifier] isEqual: NSToolbarPrintItemIdentifier])
     {
     [addedItem setToolTip:@"Print your document"];
     [addedItem setTarget:self];
     }
     */
}


- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
    NSToolbarItem *toolbarItem = nil;
    
    if ([itemIdentifier isEqualToString:kButtonFileListID]) {
        
        toolbarItem = [self toolbarItemWithIdentifier:kButtonFileListID
                                                label:_buttonFileList.title
                                          paleteLabel:@"文件列表"
                                              toolTip:@"显示微盘文件列表"
                                               target:self
                                          itemContent:_buttonFileList
                                               action:nil
                                                 menu:nil];
        
    }else if ([itemIdentifier isEqualToString:kButtonSignInID]) {
        
        toolbarItem = [self toolbarItemWithIdentifier:kButtonSignInID
                                                label:_buttonSignIn.title
                                          paleteLabel:@"登录"
                                              toolTip:@"登录到微盘"
                                               target:self
                                          itemContent:_buttonSignIn
                                               action:nil
                                                 menu:nil];
    }
    
    return toolbarItem;
}


- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
    return [NSArray arrayWithObjects:
            kButtonFileListID,
            NSToolbarSpaceItemIdentifier,
            NSToolbarFlexibleSpaceItemIdentifier,
            kButtonSignInID, nil];
}


- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
    return [NSArray arrayWithObjects:
            kButtonFileListID,
            NSToolbarSpaceItemIdentifier,
            NSToolbarFlexibleSpaceItemIdentifier,
            kButtonSignInID, nil];
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    VdiskMetadata *metadata = [_metadataArray lastObject];
    return [[metadata contents] count];
}

- (float)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    
    return 40;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    
    VdiskMetadata *metadataFromArray = [_metadataArray lastObject];
    VdiskMetadata *metadata = [[metadataFromArray contents] objectAtIndex:row];
    
    static NSString *cellIdentifier = @"Name";
    TableCellView *cellView = [tableView makeViewWithIdentifier:cellIdentifier owner:self];
    
    if (cellView == nil) {
        
        cellView = [[[TableCellView alloc] initWithFrame:NSMakeRect(0, 0, tableColumn.width, 40)] autorelease];
        [cellView setIdentifier:cellIdentifier];
    }
    
    cellView.frame = NSMakeRect(0, 0, tableColumn.width, 40);
    cellView.fileNameLabel.frame = NSMakeRect(5 + cellView.frame.size.height - 10 + 5, 0, cellView.frame.size.width - 10 - cellView.frame.size.height - 10, cellView.frame.size.height - 10);
    cellView.fileNameLabel.textColor = [NSColor blackColor];
    [cellView initWithMetadata:metadata];
    
    return cellView;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification{
    
    VdiskMetadata *metadataFromArray = [_metadataArray lastObject];
    self.selectedMetadata = [[metadataFromArray contents] objectAtIndex:[[notification object] selectedRow]];
    
    if ([_selectedMetadata isDirectory]) {
        
        
        
    }else {
    
        self.selectedFilePath = [NSString stringWithFormat:@"%@/%@/%@", _vDiskUserRootPath, _selectedMetadata.fileSha1, _selectedMetadata.filename];
    }
}

- (void)tableViewSelectionIsChanging:(NSNotification *)notification {
    
    VdiskMetadata *metadataFromArray = [_metadataArray lastObject];
    
    for (int i=0; i<[[metadataFromArray contents] count]; i++) {
        
        TableCellView *cell = [[notification object] viewAtColumn:0 row:i makeIfNecessary:YES];
        
        if ([[notification object] selectedRow] == i) {
            cell.fileNameLabel.textColor = [NSColor whiteColor];
        }else {
            cell.fileNameLabel.textColor = [NSColor blackColor];
        }
        
    }
    
    [_selectedMetadata release];
    _selectedMetadata = nil;
}

- (void)tableViewRowDoubleClicked {
    
//    NSInteger rowNumber = [_tableView clickedRow];
    
    if ([_selectedMetadata isDirectory]) {
        
        [_vdiskRestClient loadMetadata:_selectedMetadata.path];
        return;
    }
    
    if ([_metadataArray count] == 0 || _selectedMetadata == nil) {
        return;
    }
    
    NSFileManager *fileManager= [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:_selectedFilePath]) {
        
        if ([QLPreviewPanel sharedPreviewPanelExists] && [[QLPreviewPanel sharedPreviewPanel] isVisible]) {
            [_previewPanel reloadData];
        }else {
            [self togglePreviewPanel:nil];
        }
    }else {
        
        NSString *destPath = [NSString stringWithFormat:@"%@/%@", _vDiskUserRootPath, _selectedMetadata.fileSha1];
        
        if(![fileManager createDirectoryAtPath:destPath withIntermediateDirectories:YES attributes:nil error:NULL]) {
            
            NSLog(@"Error: Create folder failed %@", destPath);
            return;
        }
        
        _tableFooterView.requestState = requestDownload;
        [_tableFooterView setHidden:NO];
        [[_tableFooterView animator] setAlphaValue:1.0];
        [_vdiskRestClient loadFile:_selectedMetadata.path intoPath:_selectedFilePath];
    }
}

- (void)tableViewRowRightClicked:(NSEvent *)event {
    
    NSPoint mousePoint = [_tableView convertPoint:[event locationInWindow] fromView:nil];
    int selectedRow = [_tableView rowAtPoint:mousePoint];
    
    [_tableView selectRowIndexes:[[[NSIndexSet alloc] initWithIndex:selectedRow] autorelease] byExtendingSelection:NO];
    
    //NSLog(@"%d", selectedRow);
    VdiskMetadata *metadataFromArray = [_metadataArray lastObject];
    self.selectedMetadata = [[metadataFromArray contents] objectAtIndex:selectedRow];
    //NSLog(@"%@", _selectedMetadata.path);
    
    for (int i=0; i<[[metadataFromArray contents] count]; i++) {
        
        TableCellView *cell = [_tableView viewAtColumn:0 row:i makeIfNecessary:YES];
        
        if ([_tableView selectedRow] == i) {
            cell.fileNameLabel.textColor = [NSColor whiteColor];
        }else {
            cell.fileNameLabel.textColor = [NSColor blackColor];
        }
    }
    
    
    NSMenu *theMenu = [[NSMenu alloc] initWithTitle:@"Contextual Menu"];
    
    [theMenu insertItemWithTitle:@"删除该文档" action:@selector(deleteItem) keyEquivalent:@"" atIndex:0];
    [theMenu insertItemWithTitle:@"分享给好友" action:@selector(shareToFriends) keyEquivalent:@"" atIndex:1];
    
    [NSMenu popUpContextMenu:theMenu withEvent:event forView:nil];
}

- (void)deleteItem {
    
    NSString *alertMessage = [NSString stringWithFormat:@"确定要删除 %@ 吗?", _selectedMetadata.path];
    
    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    [alert addButtonWithTitle:@"好的"];
    [alert addButtonWithTitle:@"取消"];
    [alert setMessageText:alertMessage];
    [alert setInformativeText:@"该文档将在微盘中被删除，删除掉的文档将无法找回。"];
    [alert setAlertStyle:NSWarningAlertStyle];
    [alert beginSheetModalForWindow:[self window] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void)shareToFriends {
    
    NSSize screenSize=[[NSScreen mainScreen] visibleFrame].size;
	float windowWidth=500;
	float windowHeight=500;
    
    self.shareWindow = [[[ShareWindow alloc] initWithContentRect:NSMakeRect((screenSize.width-windowWidth)/2, (screenSize.height-windowHeight)/2, windowWidth, windowHeight)
                                        styleMask:NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask
                                          backing:NSBackingStoreBuffered
                                            defer:YES] autorelease];
    
    self.shareWindowController = [[[NSWindowController alloc] initWithWindow:_shareWindow] autorelease];
    
    [_shareWindow initShareWindow];
    
    [_shareWindowController showWindow:_shareWindow];
    
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)info
{
	if (returnCode == NSAlertFirstButtonReturn) {
        
        [_vdiskRestClient deletePath:_selectedMetadata.path];
	}
}

#pragma mark - TableHeaderViewDelegate

- (void)onButtonToParent {
    
    if ([_metadataArray count] == 0 || [_metadataArray count] == 1) {
        return;
    }
    
    [_metadataArray removeLastObject];
    [_tableView reloadData];
}

- (void)onButtonToRoot {
    
    if ([_metadataArray count] == 0 || [_metadataArray count] == 1) {
        return;
    }
    
    [_metadataArray removeAllObjects];
    
    [_vdiskRestClient loadMetadata:@"/"];
}

#pragma mark - NSWindowDelegate

- (void)windowDidResize:(NSNotification *)notification {
    
    NSRect rr = [_tableView visibleRect];
    
    NSView *contentView = [_window contentView];
    _scrollView.frame = NSMakeRect(0, 0, contentView.frame.size.width, contentView.frame.size.height);
    
    _tableView.frame = NSMakeRect(0, 0, contentView.frame.size.width, contentView.frame.size.height);
    NSTableColumn *firstColumn = [_tableView.tableColumns objectAtIndex:0];
    firstColumn.width = _tableView.frame.size.width;
    
    [_tableView reloadData];
    [_tableView scrollRectToVisible:rr];
    
    _tableView.headerView.frame = NSMakeRect(0, 0, contentView.frame.size.width, 20);
    TableHeaderView *headerView =  (TableHeaderView *)_tableView.headerView;
    [headerView upDateSubViews];
    
    _tableFooterView.frame = NSMakeRect(0, 0, contentView.frame.size.width, 30);
    [_tableFooterView upDateSubViews];
}

#pragma mark - NSUserNotificationCenterDelegate
- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification{
    return YES;
}



#pragma mark - QLPreviewPanelDelegate

- (BOOL)acceptsPreviewPanelControl:(QLPreviewPanel *)panel;
{
    return YES;
}

- (void)beginPreviewPanelControl:(QLPreviewPanel *)panel
{
    _previewPanel = [panel retain];
    //panel.delegate = self;
    panel.dataSource = self;
}

- (void)endPreviewPanelControl:(QLPreviewPanel *)panel
{
    [_previewPanel release];
    _previewPanel = nil;
}

- (NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel *)panel
{
    return 1;
}

- (id <QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)index
{
    return [NSURL fileURLWithPath:_selectedFilePath];
}

- (BOOL)previewPanel:(QLPreviewPanel *)panel handleEvent:(NSEvent *)event
{
//    if ([event type] == NSKeyDown) {
//        [_tableView keyDown:event];
//        return YES;
//    }
    return NO;
}


- (void)togglePreviewPanel:(id)previewPanel
{
    if ([QLPreviewPanel sharedPreviewPanelExists] && [[QLPreviewPanel sharedPreviewPanel] isVisible]) {
        [[QLPreviewPanel sharedPreviewPanel] orderOut:nil];
    } else {
        [[QLPreviewPanel sharedPreviewPanel] makeKeyAndOrderFront:nil];
    }
}




#pragma mark - Destination Operations

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    _tableView.highlight = YES;
    [_tableView setNeedsDisplay: YES];
    
    return NSDragOperationCopy;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender
{
    _tableView.highlight = NO;
    [_tableView setNeedsDisplay: YES];
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
    _tableView.highlight = NO;
    [_tableView setNeedsDisplay: YES];
    
    return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    
    if ([_metadataArray count] <= 0) {
        return NO;
    }
    
    if ( [sender draggingSource] != self ) {
        
        NSURL* fileURL = [NSURL URLFromPasteboard: [sender draggingPasteboard]];
        _fileURLToUpload = fileURL;
        
        _tableFooterView.requestState = requestUpload;
        [_tableFooterView setHidden:NO];
        [[_tableFooterView animator] setAlphaValue:1.0];
        
        [_vdiskRestClient uploadFile:fileURL.lastPathComponent toPath:[[_metadataArray lastObject] path] withParentRev:nil fromPath:fileURL.path];
    }
    
    return YES;
}


#pragma mark - Source Operations


- (NSDragOperation)draggingSession:(NSDraggingSession *)session sourceOperationMaskForDraggingContext:(NSDraggingContext)context
{
    return NSDragOperationCopy;
}

- (BOOL)acceptsFirstMouse:(NSEvent *)event
{
    return YES;
}

- (void)pasteboard:(NSPasteboard *)pasteboard item:(NSPasteboardItem *)item provideDataForType:(NSString *)type {
    
    return;
}

@end
