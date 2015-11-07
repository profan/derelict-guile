module derelict.guile.boolean;
/* corresponds to boolean.h in libguile */

import derelict.guile.types;

/* BECAUSE THEYRE MACROS, NOT FUNCTIONS ;_; */
__gshared {

	int scm_is_true(SCM obj) {
		return 0;
	}

	int scm_is_false(SCM obj) {
		return 0;
	}

	int scm_is_bool(SCM obj) {
		return 0;
	}

}

