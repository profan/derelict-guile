module derelict.guile.hooks;
/* corresponds to hooks.h in libguile */

alias scm_t_c_hook_function = extern(C) nothrow @nogc void* function(void* hook_data, void* fn_data, void* data);
alias scm_t_c_hook_type = int;

enum : scm_t_c_hook_type {

	SCM_C_HOOK_NORMAL,
	SCM_C_HOOK_OR,
	SCM_C_HOOK_AND

}

struct scm_t_c_hook_entry {

	scm_t_c_hook_entry* next;
	scm_t_c_hook_function func;
	void* data;

}

struct scm_t_c_hook {

	scm_t_c_hook_entry* first;
	scm_t_c_hook_type type;
	void* data;	

}


