#import <Foundation/NSObject.h>
#import <Foundation/NSException.h>

@interface SnapshotRecordingLoadHookInjector : NSObject
@end

@protocol SnapshotRecordingLoadHook

+ (void)loadHook;

@end

@implementation SnapshotRecordingLoadHookInjector
@end

@implementation SnapshotRecordingLoadHookInjector (LoadHook)

+ (void)load;
{
    Class class = NSClassFromString(@"SnapshotRecordingLoadHook");
    NSAssert(class != nil, @"");
    NSAssert([class respondsToSelector:@selector(loadHook)], @"");
    [class performSelector:@selector(loadHook)];
}

@end
