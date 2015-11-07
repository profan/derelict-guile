module derelict.guile.dynstack;
/* corresponds to dynstack.h in libguile */

enum {
	SCM_DYNSTACK_TAG_FLAGS_SHIFT = 4
}

alias scm_t_dynstack_frame_flags = int;

enum : scm_t_dynstack_frame_flags {
	SCM_F_DYNSTACK_FRAME_REWINDABLE = (1 << SCM_DYNSTACK_TAG_FLAGS_SHIFT)
}

alias scm_t_dynstack_winder_flags = int;

enum : scm_t_dynstack_winder_flags {
	SCM_F_DYNSTACK_WINDER_EXPLICIT = (1 << SCM_DYNSTACK_TAG_FLAGS_SHIFT)
}
