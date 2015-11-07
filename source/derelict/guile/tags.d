module derelict.guile.tags;
/* corresponds to tags.h in libguile */

import derelict.guile.types;

union SCM {
	struct n_ {
		scm_t_bits n;
	} n_ n;
}
