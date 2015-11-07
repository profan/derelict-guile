module derelict.guile.throwh;
/* corresponds to throw.h in libguile */

import derelict.guile.tags;
import derelict.guile.types;

alias scm_t_catch_body = extern(C) nothrow @nogc SCM function(void* data);
alias scm_t_catch_handler = extern(C) nothrow @nogc SCM function(void* data, SCM tag, SCM throw_args);
