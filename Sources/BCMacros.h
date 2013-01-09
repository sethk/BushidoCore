// Common macros for Objective-C programs.
#import <Foundation/NSObject.h>

// GNUstep-style retain management:

#ifndef __has_feature // Optional of course.
#define __has_feature(x) 0 // Compatibility with non-clang compilers.
#endif // __has_feature

#if __has_feature(objc_arc)
#define AUTORELEASE(a) a
#define RELEASE(a) (void)a
#define RETAIN(a) a
#define DESTROY(a) do {a = nil;} while (0)
#define SUPER_DEALLOC() /**/

#else // !__has_feature(objc_arc)

#define AUTORELEASE(a) [a autorelease]
#define RELEASE(a) [a release]
#define RETAIN(a) [a retain]

#define ASSIGN(a, b) do {\
		const id _a = a, _b = b; \
		if (_a != _b) { \
			if (_b) [_b retain]; \
			a = _b; \
			if (_a) [_a release]; \
		} \
	} while (0)

#define ASSIGN_TEST(a, b) _ASSIGN_TEST(&a, b)
static inline BOOL
_ASSIGN_TEST(id *pSource, id target)
{
	const id source = *pSource;
	if (source != target)
	{
		if (target)
			[target retain];
		*pSource = target;
		if (source)
			[source release];
		return YES;
	}
	else
		return NO;
}

#define DESTROY(a) do {if (a) {[a release]; a = nil;}} while (0)
#define SUPER_DEALLOC() [super dealloc]

#endif // __has_feature(objc_arc)

#define ASSIGN_COPY(a, b) do { \
		const id _a = a, _b = b; \
		if (_a != _b) { \
			_a = (_b) ? [_b copy] : nil; \
			if (_a) \
				RELEASE(_a); \
		} \
	} while (0)

#define ASSIGN_COPY_TEST(a, b) _ASSIGN_COPY_TEST(&a, b)
static inline BOOL
_ASSIGN_COPY_TEST(__strong id *pSource, id target)
{
	const id source = *pSource;
	if (source != target)
	{
		*pSource = (target) ? [target copy] : nil;
		if (source)
			RELEASE(source);
		return YES;
	}
	else
		return NO;
}

#define UNUSED(x) (void)x

#define _(s) NSLocalizedString(s, nil)
#define __(s) s

// Design by contract:
#ifdef DEBUG
#define PRECONDITION(x) NSAssert(x, @"Precondition failed: %s", #x)
#define POSTCONDITION(x) NSAssert(y, @"Postcondition failed: %s", #x)
#define PRECONDITION_C(x) NSCAssert(x, @"Precondition failed: %s", #x)
#define POSTCONDITION_C(x) NSCAssert(x, @"Postcondition failed: %s", #x)
#else // DEBUG
#define PRECONDITION(x)
#define POSTCONDITION(x)
#define PRECONDITION_C(x)
#define POSTCONDITION_C(x)
#endif // DEBUG

// A trick for compile-time checking of property names, borrowed from M. Uli Kusterer
#ifdef DEBUG
#define PROPERTY(p) NSStringFromSelector(@selector(p))
#else
#define PROPERTY(p) @#p
#endif // DEBUG

#ifdef BCLOG_USE_ASL
#import <pthread.h>
#import <asl.h>

extern pthread_once_t _BCLogKeyOnce;
extern pthread_key_t _BCLogKey;
extern uint32_t BCLogLevel;
extern void _BCCreateLogKey(void);
extern aslclient BCOpenLog(const char *facility);

#define BCLogLevel(level, fmt...) do { \
		pthread_once(&_BCLogKeyOnce, _BCCreateLogKey); \
		aslclient __asl = pthread_getspecific(_BCLogKey); \
		if (!__asl) \
			__asl = BCOpenLog(NULL); \
		if (level <= BCLogLevel) { /* This is used in addition to the asl_set_filter because sterr is unfiltered */ \
			const char *__utf8_log = [[NSString stringWithFormat:fmt] UTF8String]; \
			asl_log(__asl, NULL, level, "%s", __utf8_log); \
		} \
	} while (0)

#define BCLog(fmt...) BCLogLevel(ASL_LEVEL_NOTICE, fmt)
#define BCDebugLog(fmt...) BCLogLevel(ASL_LEVEL_DEBUG, fmt)

#else // !BCLOG_USE_ASL

enum
{
	ASL_LEVEL_EMERG = 0,
	ASL_LEVEL_ALERT = 1,
	ASL_LEVEL_CRIT = 2,
	ASL_LEVEL_ERR = 3,
	ASL_LEVEL_WARNING = 4,
	ASL_LEVEL_NOTICE = 5,
	ASL_LEVEL_INFO = 6,
	ASL_LEVEL_DEBUG = 7
};

#define BCLog NSLog
#ifdef DEBUG
#define BCDebugLog NSLog
#define BCLogLevel(l, fmt...) NSLog(fmt)
#else
#define BCDebugLog(fmt...) /**/
#define BCLogLevel(l, fmt...) do {if (l <= ASL_LEVEL_NOTICE) NSLog(fmt);} while (0)
#endif // DEBUG

#endif // !BCLOG_USE_ASL
