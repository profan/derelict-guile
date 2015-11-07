module derelict.guile.print;
/* corresponds to print.h in libguile */

import derelict.guile.types;

struct scm_print_state {

  SCM handle;			/* Struct handle */
  int revealed;                 /* Has the state escaped to Scheme? */
  c_ulong writingp;	/* Writing? */
  c_ulong fancyp;		/* Fancy printing? */
  c_ulong level;		/* Max level */
  c_ulong length;		/* Max number of objects per level */
  SCM hot_ref;			/* Hot reference */
  c_ulong list_offset;
  c_ulong top;		/* Top of reference stack */
  c_ulong ceiling;	/* Max size of reference stack */
  SCM ref_vect;	 	        /* Stack of references used during
				   				circular reference detection;
				   				a simple vector. */
  SCM highlight_objects;        /* List of objects to be highlighted */

}
