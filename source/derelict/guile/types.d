module derelict.guile.types;

public import core.stdc.config : c_long, c_ulong;
public import std.socket : sockaddr;

alias ssize_t = long;
alias scm_t_intptr = int*;
alias scm_t_uintptr = uint*;
alias scm_t_bits = scm_t_uintptr;
alias scm_t_signed_bits = scm_t_intptr;
alias SCM = scm_t_bits;

alias scm_t_int8 = byte;
alias scm_t_uint8 = ubyte;
alias scm_t_int16 = short;
alias scm_t_uint16 = ushort;
alias scm_t_int32 = int;
alias scm_t_uint32 = uint;
alias scm_t_int64 = long;
alias scm_t_uint64 = ulong;
alias scm_t_intmax = long;
alias scm_t_uintmax = ulong;

alias scm_t_ptrdiff = ptrdiff_t;
alias scm_t_wchar = scm_t_int32;
