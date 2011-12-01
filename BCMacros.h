// Common macros for Objective-C programs.

// GNUstep-style retain management:

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

#define _(s) NSLocalizedString(s, nil)
#define __(s) s

// A trick for compile-time checking of property names, borrowed from M. Uli Kusterer
#ifdef DEBUG
#define PROPERTY(p) NSStringFromSelector(@selector(#p))
#else
#define PROPERTY(p) @#p
#endif // DEBUG

