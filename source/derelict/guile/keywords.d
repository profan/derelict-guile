module derelict.guile.keywords;
/* corresponds to keywords.h in libguile */

alias scm_t_keyword_arguments_flags = int;

enum : scm_t_keyword_arguments_flags {
	SCM_ALLOW_OTHER_KEYS = (1U << 0),
	SCM_ALLOW_NON_KEYWORD_ARGUMENTS = (1U << 1)
}
