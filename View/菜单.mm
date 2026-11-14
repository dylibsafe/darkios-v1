#import "菜单.h"
#import "OverlayView.h"

@implementation mi

@synthesize moduleControl;

- (instancetype)initWithFrame:(ModuleControl*)control {
    self = [super init];
    if (self) {
        moduleControl = control;
    }
    return self;
}

- (void)setOverlayView:(OverlayView*)ov {
    // Örtük pəncərəsini təyin edir
}

- (void)drawMenuWindow {
    if (moduleControl && moduleControl->menuStatus) {
        ImGui::Begin("M7MD Menu", &moduleControl->menuStatus, ImGuiWindowFlags_AlwaysAutoResize);
        ImGui::Text("Welcome to M7MD Mod Menu");
        ImGui::End();
    }
}

- (void)showSystemInfo {}
- (void)showPlayerControl {}
- (void)showAimbotControl {}
- (void)skins {}
- (void)readIniConfig {}

@end
