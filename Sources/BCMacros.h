// Common macros for Objective-C programs.
#import <Foundation/NSObject.h>

#define BC_ASSIGN_COPY(a, b) do { \
		const id _a = a, _b = b; \
		if (_a != _b) { \
			_a = (_b) ? [_b copy] : nil; \
		} \
	} while (0)

#define BC_ASSIGN_COPY_TEST(a, b) _BC_ASSIGN_COPY_TEST(&a, b)
static inline BOOL
_BC_ASSIGN_COPY_TEST(__strong id *pSource, id target)
{
	const id source = *pSource;
	if (source != target)
	{
		*pSource = (target) ? [target copy] : nil;
		return YES;
	}
	else
		return NO;
}

#define BC_UNUSED(x) (void)x

#define _(s) NSLocalizedString(s, nil)
#define __(s) s

// Design by contract:
#ifdef DEBUG
#define BC_PRECONDITION(x) NSAssert(x, @"Precondition failed: %s", #x)
#define BC_POSTCONDITION(x) NSAssert(x, @"Postcondition failed: %s", #x)
#define BC_PRECONDITION_C(x) NSCAssert(x, @"Precondition failed: %s", #x)
#define BC_POSTCONDITION_C(x) NSCAssert(x, @"Postcondition failed: %s", #x)
#else // DEBUG
#define BC_PRECONDITION(x)
#define BC_POSTCONDITION(x)
#define BC_PRECONDITION_C(x)
#define BC_POSTCONDITION_C(x)
#endif // DEBUG

// A trick for compile-time checking of property names, borrowed from M. Uli Kusterer
#ifdef DEBUG
#define BC_PROPERTY(p) NSStringFromSelector(@selector(p))
#else
#define BC_PROPERTY(p) @#p
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

// Safe object comparison:
//                 obj1
//          nil | 0x1234 | 0x789a |
// obj2   +-----+--------+--------+
// nil    | YES | NO     | NO     |
// 0x1234 | NO  | YES    | MAYBE  |
// 0x789a | NO  | MAYBE  | YES    |
//        +-----+--------+--------+
//                                                                           obj1
//                             nil                   |                      0x1234                   |                    0x789a                     |
// obj2   +------------------------------------------+-----------------------------------------------+-----------------------------------------------+
// nil    | (nil == nil     || [nil isEqual:nil])    | (0x1234 == nil    || [0x1234 isEqual:nil])    | (0x789a == nil    || [0x789a isEqual:nil])    |
// 0x1234 | (nil == 0x1234) || [nil isEqual:0x1234]) | (0x1234 == 0x1234 || [0x1234 isEqual:0x1234]) | (0x789a == 0x1234 || [0x789a isEqual:0x1234]) |
// 0x789a | (nil == 0x789a) || [nil isEqual:0x789a]) | (0x1234 == 0x789a || [0x1234 isEqual:0x789a]) | (0x789a == 0x789a || [0x789a isEqual:0x789a]) |
//        +------------------------------------------+-----------------------------------------------+-----------------------------------------------+
#define BC_SAFE_OBJECT_IS_EQUAL(obj1, obj2) ((obj1) == (obj2) || [(obj1) isEqual:obj2])

#endif // !BCLOG_USE_ASL

#ifdef DEBUG
#define BC_CONST_TUNABLE volatile
#else
#define BC_CONST_TUNABLE const
#endif // DEBUG

#define BCRectMakeConst(_x, _y, _w, _h) {.origin = {.x = _x, .y = _y}, .size = {.width = _w, .height = _h}}
#define BCSizeMakeConst(_w, _h) {.width = _w, .height = _h}
#define BCEdgeInsetsMakeConst(_t, _l, _b, _r) {.top = _t, .left = _l, .bottom = _b, .right = _r}
