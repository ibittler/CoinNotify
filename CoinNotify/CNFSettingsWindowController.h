//
//  CNFSettingsWindowController.h
//  CoinNotify
//

#import <Cocoa/Cocoa.h>

@interface CNFSettingsWindowController : NSWindowController <NSWindowDelegate>

@property (assign) IBOutlet NSSlider* updateFrequencySlider;
@property (assign) IBOutlet NSTextField* updateFrequencyField;
@property (assign) IBOutlet NSPopUpButton* decimalsButton;
@property (assign) IBOutlet NSTextField* versionField;

- (IBAction)updateFrequencySliderUpdated:(NSSlider*)sender;
@end
