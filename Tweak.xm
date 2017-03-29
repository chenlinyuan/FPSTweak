
#import "FPSLabel.h"
#include <dlfcn.h>

%ctor {
NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.alas.fpstweak.plist"] ;
NSString *libraryPath = @"/Library/MobileSubstrate/DynamicLibraries/FPSTweak.dylib";

NSString *keyPath = [NSString stringWithFormat:@"FPSTweakEnabled-%@", [[NSBundle mainBundle] bundleIdentifier]];
NSLog(@"FPSTweak before loaded %@,keyPath = %@,prefs = %@", libraryPath,keyPath,prefs);
if ([[prefs objectForKey:keyPath] boolValue]) {
if ([[NSFileManager defaultManager] fileExistsAtPath:libraryPath]){
void *haldel = dlopen([libraryPath UTF8String], RTLD_NOW);
if (haldel == NULL) {
char *error = dlerror();
NSLog(@"dlopen error: %s", error);
} else {
NSLog(@"dlopen load framework success.");
[[NSNotificationCenter defaultCenter] addObserver:[FPSLabel class]
selector:@selector(show)
name:UIApplicationDidFinishLaunchingNotification
object:nil];


}

NSLog(@"FPSLabel loaded %@", libraryPath);
} else {
NSLog(@"FPSLabel file not exists %@", libraryPath);
}
}
else {
NSLog(@"FPSLabel not enabled %@", libraryPath);
}

NSLog(@"FPSLabel after loaded %@", libraryPath);


[pool drain];
}
