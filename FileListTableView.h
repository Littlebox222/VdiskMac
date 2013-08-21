//
//  FileListTableView.h
//  ZeroIB
//
//  Created by Littlebox222 on 13-7-19.
//
//

#import <Cocoa/Cocoa.h>

@protocol FileListTableViewDelegate;

@interface FileListTableView : NSTableView {
    
    BOOL _highlight;
    id<FileListTableViewDelegate> _customDelegate;
}

@property BOOL highlight;
@property (nonatomic, assign) id<FileListTableViewDelegate> customDelegate;

@end


@protocol FileListTableViewDelegate <NSObject>

- (void)tableViewRowRightClicked:(NSEvent *)event;

@end