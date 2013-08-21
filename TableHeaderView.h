//
//  TableHeaderView.h
//  ZeroIB
//
//  Created by Littlebox222 on 13-7-17.
//
//

#import <Cocoa/Cocoa.h>

@protocol TableHeaderViewDelegate;


@interface TableHeaderView : NSTableHeaderView {
    
    NSButton *_buttonToParent;
    NSButton *_buttonToRoot;
    id<TableHeaderViewDelegate> _delegate;
}

@property (nonatomic, retain) NSButton *buttonToParent;
@property (nonatomic, retain) NSButton *buttonToRoot;
@property (nonatomic, assign) id<TableHeaderViewDelegate> delegate;

- (void)onButtonToParentPressed;
- (void)onButtonToRootPressed;
- (void)upDateSubViews;

@end


@protocol TableHeaderViewDelegate <NSObject>

- (void)onButtonToParent;
- (void)onButtonToRoot;

@end