//
//  BCMacros.c
//  DealSteal
//
//  Created by Seth Kingsley on 4/3/12.
//  Copyright (c) 2012 Bushido Coding. All rights reserved.
//

#include "BCMacros.h"

pthread_key_t _BCLogKey;
uint32_t _BCLogLevel;

void
_BCOpenLog(void)
{
	const char *logLevelString = getenv("BCLogLevel");
	if (logLevelString)
		_BCLogLevel = (uint32_t)fmin(fmax((uint32_t)atol(logLevelString), 0), ASL_LEVEL_DEBUG);
	else
	{
#ifdef DEBUG
		_BCLogLevel = ASL_LEVEL_INFO;
#elif TARGET_OS_EMBEDDED
		// Limit the chatter on iOS:
		_BCLogLevel = ASL_LEVEL_WARNING;
#else
		_BCLogLevel = ASL_LEVEL_NOTICE;
#endif // DEBUG
	}

	pthread_key_create(&_BCLogKey, NULL);
	aslclient asl = asl_open(NULL, NULL, 0);
#ifdef DEBUG
	asl_add_log_file(asl, STDERR_FILENO);
#endif // DEBUG
	asl_set_filter(asl, ASL_FILTER_MASK_UPTO(_BCLogLevel));
	static const char *logLevelNames[] =
	{
		[ASL_LEVEL_EMERG] = ASL_STRING_EMERG,
		[ASL_LEVEL_ALERT] = ASL_STRING_ALERT,
		[ASL_LEVEL_CRIT] = ASL_STRING_CRIT,
		[ASL_LEVEL_ERR] = ASL_STRING_ERR,
		[ASL_LEVEL_WARNING] = ASL_STRING_WARNING,
		[ASL_LEVEL_NOTICE] = ASL_STRING_NOTICE,
		[ASL_LEVEL_INFO] = ASL_STRING_INFO,
		[ASL_LEVEL_DEBUG] = ASL_STRING_DEBUG
	};
	asl_log(asl, NULL, ASL_LEVEL_NOTICE,
			"Log started, filtering messages above <%s>, set BCLogLevel in the environment to change",
			logLevelNames[_BCLogLevel]);
	pthread_setspecific(_BCLogKey, asl);
}