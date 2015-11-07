/* corresponds to array-handle.h in libguile */
module derelict.guile.array_handle;

import derelict.guile.tags;
import derelict.guile.types;

alias scm_t_array_element_type = int;

enum : scm_t_array_element_type {

    SCM_ARRAY_ELEMENT_TYPE_SCM = 0,   /* SCM values */
    SCM_ARRAY_ELEMENT_TYPE_CHAR = 1,  /* characters */
    SCM_ARRAY_ELEMENT_TYPE_BIT = 2,   /* packed numeric values */
    SCM_ARRAY_ELEMENT_TYPE_VU8 = 3,
    SCM_ARRAY_ELEMENT_TYPE_U8 = 4,
    SCM_ARRAY_ELEMENT_TYPE_S8 = 5,
    SCM_ARRAY_ELEMENT_TYPE_U16 = 6,
    SCM_ARRAY_ELEMENT_TYPE_S16 = 7,
    SCM_ARRAY_ELEMENT_TYPE_U32 = 8,
    SCM_ARRAY_ELEMENT_TYPE_S32 = 9,
    SCM_ARRAY_ELEMENT_TYPE_U64 = 10,
    SCM_ARRAY_ELEMENT_TYPE_S64 = 11,
    SCM_ARRAY_ELEMENT_TYPE_F32 = 12,
    SCM_ARRAY_ELEMENT_TYPE_F64 = 13,
    SCM_ARRAY_ELEMENT_TYPE_C32 = 14,
    SCM_ARRAY_ELEMENT_TYPE_C64 = 15,
    SCM_ARRAY_ELEMENT_TYPE_LAST = 15

}

alias scm_i_t_array_ref = extern(C) nothrow @nogc SCM function(scm_t_array_handle*, size_t);
alias scm_i_t_array_set = extern(C) nothrow @nogc void function(scm_t_array_handle*, size_t, SCM);

struct scm_t_array_dim {

	ssize_t lbnd;
	ssize_t ubnd;
	ssize_t inc;

}

struct scm_t_array_implementation {

	scm_t_bits tag;
	scm_t_bits mask;
	scm_i_t_array_ref vref;
	scm_i_t_array_set vset;
	extern(C) nothrow @nogc void function(SCM, scm_t_array_handle*) get_handle;

}

struct scm_t_array_handle {

	SCM array;
	scm_t_array_implementation *impl;
	size_t base;
	size_t ndims;
	scm_t_array_dim* dims;
	scm_t_array_dim dim0;
	scm_t_array_element_type element_type;
	const void* elements;
	void* writable_elements;

}
