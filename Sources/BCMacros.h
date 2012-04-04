// Common macros for Objective-C programs.

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

#define ASSIGN_COPY(a, b) do { \
		const id _a = a, _b = b; \
		if (_a != _b) { \
			_a = (_b) ? [_b copy] : nil; \
			if (_a) \
				[_a release]; \
		} \
	} while (0)

#define ASSIGN_COPY_TEST(a, b) _ASSIGN_COPY_TEST(&a, b)
static inline BOOL
_ASSIGN_COPY(id *pSource, id target)
{
	const id source = *pSource;
	if (source != target)
	{
		*pSource = (target) ? [target copy] : nil;
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

#define UNUSED(x) (void)x

#define _(s) NSLocalizedString(s, nil)
#define __(s) s

// A trick for compile-time checking of property names, borrowed from M. Uli Kusterer
#ifdef DEBUG
#define PROPERTY(p) NSStringFromSelector(@selector(p))
#else
#define PROPERTY(p) @#p
#endif // DEBUG

#import <pthread.h>
#import <asl.h>

extern pthread_key_t _BCLogKey;
extern uint32_t _BCLogLevel;
extern void _BCOpenLog(void);

#define BCLogLevel(level, fmt...) do { \
		if (!_BCLogKey) \
			_BCOpenLog(); \
		if (level <= _BCLogLevel) { /* This is used in addition to the asl_set_filter because sterr is unfiltered */ \
			aslclient __asl = pthread_getspecific(_BCLogKey); \
			const char *__utf8_log = [[NSString stringWithFormat:fmt] UTF8String]; \
			asl_log(__asl, NULL, level, "%s", __utf8_log); \
		} \
	} while (0)

#define BCLog(fmt...) BCLogLevel(ASL_LEVEL_NOTICE, fmt)
