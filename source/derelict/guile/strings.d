module derelict.guile.strings;
/* corresponds to strings.h in libguile */

enum {
	SCM_ICONVEH_ERROR = 0,
	SCM_ICONVEH_QUESTION_MARK = 1,
	SCM_ICONVEH_ESCAPE_SEQUENCE = 2
}

alias scm_t_string_failed_conversion_handler = int;

enum : scm_t_string_failed_conversion_handler {
	SCM_FAILED_CONVERSION_ERROR = SCM_ICONVEH_ERROR,
	SCM_FAILED_CONVERSION_ERROR_QUESTION_MARK = SCM_ICONVEH_QUESTION_MARK,
	SCM_FAILED_CONVERSION_ESCAPE_SEQUENCE = SCM_ICONVEH_ESCAPE_SEQUENCE
}

