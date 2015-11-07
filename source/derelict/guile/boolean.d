module derelict.guile.boolean;
/* corresponds to boolean.h in libguile */

import derelict.guile;

/* BECAUSE THEYRE MACROS, NOT FUNCTIONS ;_; */
__gshared {

	int scm_is_true(SCM obj) {
		return 0;
	}

	int scm_is_false(SCM obj) {
		return 0;
	}

	SCM scm_from_bool(int val) {
		return SCM(SCM.n_(cast(uint*)0));
	}

	char scm_to_char(SCM x) {
		return scm_to_uint8(x);
	}

	byte scm_to_schar(SCM x) {
		return scm_to_int8(x);
	}

	ubyte scm_to_uchar(SCM x) {
		return scm_to_uint8(x);
	}

	short scm_to_short(SCM x) {
		return 0; //look at numbers.h and validate.h
	}

	ushort scm_to_ushort(SCM x) {
		return 0; //ditto
	}

	int scm_to_int(SCM x) {
		return scm_to_int32(x); //or does it need a switch on platform...? probably?
	}

	uint scm_to_uint(SCM x) {
		return scm_to_uint32(x);
	}

	c_long scm_to_long(SCM x) {
		return scm_to_int32(x); //same problem here
	}

	c_ulong scm_to_ulong(SCM x) {
		return scm_to_uint32(x); //ditto
	}

	long scm_to_long_long(SCM x) {
		return scm_to_int64(x);
	}

	ulong scm_to_ulong_long(SCM x) {
		return scm_to_uint64(x);
	}

	size_t scm_to_size_t(SCM x) {

		static if (size_t.sizeof == 8) {
			return scm_to_uint64(x);
		} else static if (size_t.sizeof == 4) {
			return scm_to_uint32(x);
		}

	}

	ssize_t scm_to_ssize_t(SCM x) {
		return 0;
	}

	ptrdiff_t scm_to_ptrdiff_t(SCM x) {
		return 0;
	}

	scm_t_intmax scm_to_intmax(SCM x) {
		return 0;
	}

	scm_t_uintmax scm_to_uintmax(SCM x) {
		return 0;
	}

	SCM scm_from_char(char x) {
		return SCM(SCM.n_(cast(uint*)x));
	}

	SCM scm_from_schar(byte x) {
		return SCM(SCM.n_(cast(uint*)x));
	}

	SCM scm_from_uchar(ubyte x) {
		return SCM(SCM.n_(cast(uint*)x));
	}

	SCM scm_from_short(short x) {
		return SCM(SCM.n_(cast(uint*)x));
	}

	SCM scm_from_ushort(ushort x) {
		return SCM(SCM.n_(cast(uint*)x));
	}

	SCM scm_from_int(int x) {
		return SCM(SCM.n_(cast(uint*)x));
	}

	SCM scm_from_uint(uint x) {
		return SCM(SCM.n_(cast(uint*)x));
	}

	SCM scm_from_long(c_long x) {
		return SCM(SCM.n_(cast(uint*)x));
	}

	SCM scm_from_ulong(c_ulong x) {
		return SCM(SCM.n_(cast(uint*)x));
	}

	SCM scm_from_long_long(long x) {
		return SCM(SCM.n_(cast(uint*)x));
	}

	SCM scm_from_ulong_long(ulong x) {
		return SCM(SCM.n_(cast(uint*)x));
	}

	SCM scm_from_size_t(size_t x) {
		return SCM(SCM.n_(cast(uint*)x));
	}

	SCM scm_from_ssize_t(ssize_t x) {
		return SCM(SCM.n_(cast(uint*)x));
	}

	SCM scm_from_ptrdiff_t(ptrdiff_t x) {
		return SCM(SCM.n_(cast(uint*)x));
	}

	SCM scm_from_intmax(scm_t_intmax x) {
		return SCM(SCM.n_(cast(uint*)x));
	}

	SCM scm_from_uintmax(scm_t_uintmax x) {
		return SCM(SCM.n_(cast(uint*)x));
	}

	int scm_is_symbol(SCM val) {
		return scm_is_true(scm_symbol_p(val));
	}

	int scm_is_null(SCM x) {
		return scm_is_true(scm_null_p(x));
	}

	size_t scm_array_handle_rank(scm_t_array_handle* handle) {
		return handle.ndims;
	}

	const (scm_t_array_dim*) scm_array_handle_dims(scm_t_array_handle* handle) {
		return handle.dims;
	}

	/* gross macro, also labeled SCM_PROGRAM_FREE_VARIABLES, not like it is in the API docs
	SCM scm_program_free_variables(SCM program) {
		???
			return scm_eq_p(x, y);}
	*/

	int scm_is_eq(SCM x, SCM y) {
		return 0;
	}

}

