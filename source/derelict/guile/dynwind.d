module derelict.guile.dynwind;

import derelict.guile.dynstack;

alias scm_t_wind_flags = int;

enum : scm_t_wind_flags {
	SCM_F_WIND_EXPLICITLY = SCM_F_DYNSTACK_WINDER_EXPLICIT
}

alias scm_t_dynwind_flags = int;

enum : scm_t_dynwind_flags {
	SCM_F_DYNWIND_REWINDABLE = SCM_F_DYNSTACK_FRAME_REWINDABLE
}

