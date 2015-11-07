module derelict.guile;

private {

	import derelict.util.loader;
	import derelict.util.system;

	static if (Derelict_OS_Posix) {
		enum libNames = "libguile-2.0.so";
	} else {
		static assert(0, "Need to implement Guile libNames for this operating system.");
	}

}

public import derelict.guile.array_handle;
public import derelict.guile.boolean;
public import derelict.guile.dynstack;
public import derelict.guile.dynwind;
public import derelict.guile.hooks;
public import derelict.guile.keywords;
public import derelict.guile.print;
public import derelict.guile.strings;
public import derelict.guile.tags;
public import derelict.guile.throwh;
public import derelict.guile.types;

//globals from C
extern(C) __gshared {

	//6.6.4.6 Standard Character Sets
	SCM scm_char_set_lower_case;
	SCM scm_char_set_upper_case;
	SCM scm_char_set_title_case;
	SCM scm_char_set_letter;
	SCM scm_char_set_digit;
	SCM scm_char_set_letter_and_digit;
	SCM scm_char_set_graphic;
	SCM scm_char_set_printing;
	SCM scm_char_set_whitespace;
	SCM scm_char_set_blank;
	SCM scm_char_set_iso_control;
	SCM scm_char_set_punctuation;
	SCM scm_char_set_symbol;
	SCM scm_char_set_hex_digit;
	SCM scm_char_set_ascii;
	SCM scm_char_set_empty;
	SCM scm_char_set_designated;
	SCM scm_char_set_full;

	//6.6.6.1 Endianness
	SCM scm_endianness_big;
	SCM scm_endianness_little;

}

//function prototypes from C
extern(C) @nogc nothrow {

	//6.4 Initializing Guile
	alias da_scm_with_guile = void* function(void* function(void*), void* data);
	alias da_scm_init_guile = void function();
	alias da_scm_boot_guile = void function(int argc, char **argv, void function(void* data, int argc, char **argv), void* data);
	alias da_scm_shell = void function(int argc, char **argv);

	//6.6.1 Booleans
	alias da_scm_not = SCM function(SCM x);
	alias da_scm_boolean_p = SCM function(SCM obj);
	alias da_scm_is_bool = int function(SCM obj);
	alias da_scm_to_bool = int function(SCM val);

	//6.6.2.2 Integers
	alias da_scm_number_p = SCM function(SCM obj);
	alias da_scm_is_number = int function(SCM obj);
	alias da_scm_integer_p = SCM function(SCM x);
	alias da_scm_is_integer = int function(SCM x);
	alias da_scm_exact_integer_p = SCM function(SCM x);
	alias da_scm_is_exact_integer = int function(SCM x);
	alias da_scm_is_signed_integer = int function(SCM x, scm_t_intmax min, scm_t_intmax max);
	alias da_scm_is_unsigned_integer = int function(SCM x, scm_t_uintmax min, scm_t_uintmax max);
	alias da_scm_to_signed_integer = scm_t_intmax function(SCM x, scm_t_intmax min, scm_t_intmax max);
	alias da_scm_to_unsigned_integer = scm_t_uintmax function(SCM x, scm_t_uintmax min, scm_t_uintmax max);
	alias da_scm_from_signed_integer = SCM function(scm_t_intmax x);
	alias da_scm_from_unsigned_integer = SCM function(scm_t_uintmax x);
	alias da_scm_to_int8 = scm_t_int8 function(SCM x);
	alias da_scm_to_uint8 = scm_t_uint8 function(SCM x);
	alias da_scm_to_int16 = scm_t_int16 function(SCM x);
	alias da_scm_to_uint16 = scm_t_uint16 function(SCM x);
	alias da_scm_to_int32 = scm_t_int32 function(SCM x);
	alias da_scm_to_uint32 = scm_t_uint32 function(SCM x);
	alias da_scm_to_int64 = scm_t_int64 function(SCM x);
	alias da_scm_to_uint64 = scm_t_uint64 function(SCM x);

	alias da_scm_from_int8 = SCM function(scm_t_int8 x);
	alias da_scm_from_uint8 = SCM function(scm_t_uint8 x);
	alias da_scm_from_int16 = SCM function(scm_t_int16 x);
	alias da_scm_from_uint16 = SCM function(scm_t_uint16 x);
	alias da_scm_from_int32 = SCM function(scm_t_int32 x);
	alias da_scm_from_uint32 = SCM function(scm_t_uint32 x);
	alias da_scm_from_int64 = SCM function(scm_t_int64 x);
	alias da_scm_from_uint64 = SCM function(scm_t_uint64 x);

	/* not included FOR NOW
	alias da_scm_to_mpz = void function(SCM val, mpz_t rop);
	alias da_scm_from_mpz = SCM function(mpz_t val);
	*/

	//6.6.2.3 Real and Rational Numbers
	alias da_scm_real_p = SCM function(SCM obj);
	alias da_scm_rational_p = SCM function(SCM x);
	alias da_scm_rationalize = SCM function(SCM x, SCM eps);
	alias da_scm_inf_p = SCM function(SCM x);
	alias da_scm_nan_p = SCM function(SCM x);
	alias da_scm_finite_p = SCM function(SCM x);
	alias da_scm_nan = SCM function();
	alias da_scm_inf = SCM function();
	alias da_scm_numerator = SCM function(SCM x);
	alias da_scm_denominator = SCM function(SCM x);
	alias da_scm_is_real = int function(SCM val);
	alias da_scm_is_rational = int function(SCM val);
	alias da_scm_to_double = double function(SCM val);
	alias da_scm_from_double = SCM function(double val);

	//6.6.2.4 Complex Numbers
	alias da_scm_complex_p = SCM function(SCM z);
	alias da_scm_is_complex = int function(SCM val);

	//6.6.2.5 Exact and Inexact Numbers
	alias da_scm_exact_p = SCM function(SCM z);
	alias da_scm_is_exact = int function(SCM z);
	alias da_scm_inexact_p = int function(SCM z);
	alias da_scm_is_inexact_p = SCM function(SCM z);
	alias da_scm_is_inexact = int function(SCM z);
	alias da_scm_inexact_to_exact = SCM function(SCM z);
	alias da_scm_exact_to_inexact = SCM function(SCM z);

	//6.6.2.7 Operations on Integer Values
	alias da_scm_odd_p = SCM function(SCM n);
	alias da_scm_even_p = SCM function(SCM n);
	alias da_scm_quotient = SCM function(SCM n, SCM d);
	alias da_scm_remainder = SCM function(SCM n, SCM d);
	alias da_scm_modulo = SCM function(SCM n, SCM d);
	alias da_scm_gcd = SCM function(SCM x, SCM y);
	alias da_scm_lcm = SCM function(SCM x, SCM y);
	alias da_scm_modulo_expt = SCM function(SCM n, SCM k, SCM m);
	alias da_scm_exact_integer_sqrt = void function(SCM k, SCM *s, SCM *r);

	//6.6.2.8 Comparison Predicates
	alias da_scm_num_eq_p = SCM function(SCM x, SCM y);
	alias da_scm_less_p = SCM function(SCM x, SCM y);
	alias da_scm_gr_p = SCM function(SCM x, SCM y);
	alias da_scm_leq_p = SCM function(SCM x, SCM y);
	alias da_scm_geq_p = SCM function(SCM x, SCM y);
	alias da_scm_zero_p = SCM function(SCM z);
	alias da_scm_positive_p = SCM function(SCM x);
	alias da_scm_negative_p = SCM function(SCM x);

	//6.6.2.9 Converting Numbers To and From Strings
	alias da_scm_number_to_string = SCM function(SCM n, SCM radix);
	alias da_scm_string_to_number = SCM function(SCM string, SCM radix);
	alias da_scm_c_locale_stringn_to_number = SCM function(const char* string, size_t len, uint radix);

	//6.6.2.10 Complex Number Operations
	alias da_scm_make_rectangular = SCM function(SCM mag, SCM ang);
	alias da_scm_make_polar = SCM function(SCM mag, SCM ang);
	alias da_scm_real_part = SCM function(SCM z);
	alias da_scm_imag_part = SCM function(SCM z);
	alias da_scm_magnitude = SCM function(SCM z);
	alias da_scm_angle = SCM function(SCM z);
	alias da_scm_c_make_rectangular = SCM function(double re, double im);
	alias da_scm_c_make_polar = SCM function(double x, double y);
	alias da_scm_c_real_part = double function(SCM z);
	alias da_scm_c_imag_part = double function(SCM z);
	alias da_scm_c_magnitude = double function(SCM z);
	alias da_scm_c_angle = double function(SCM z);

	//6.6.2.11 Arithmetic Functions
	alias da_scm_sum = SCM function(SCM z1, SCM z2);
	alias da_scm_difference = SCM function(SCM z1, SCM z2);
	alias da_scm_product = SCM function(SCM z1, SCM z2);
	alias da_scm_divide = SCM function(SCM z1, SCM z2);
	alias da_scm_oneplus = SCM function(SCM z);
	alias da_scm_oneminus = SCM function(SCM z);
	alias da_scm_abs = SCM function(SCM x);
	alias da_scm_max = SCM function(SCM x1, SCM x2);
	alias da_scm_min = SCM function(SCM x1, SCM x2);
	alias da_scm_truncate_number = SCM function(SCM x);
	alias da_scm_round_number = SCM function(SCM x);
	alias da_scm_floor = SCM function(SCM x);
	alias da_scm_ceiling = SCM function(SCM x);
	alias da_scm_c_truncate = double function(double x);
	alias da_scm_c_round = double function(double x);
	alias da_scm_euclidean_divide = void function(SCM x, SCM y, SCM *q, SCM *r);
	alias da_scm_euclidean_quotient = SCM function(SCM x, SCM y);
	alias da_scm_euclidean_remainder = SCM function(SCM x, SCM y);
	alias da_scm_floor_divide = void function(SCM x, SCM y, SCM *q, SCM *r);
	alias da_scm_floor_quotient = SCM function(SCM x, SCM y);
	alias da_scm_floor_remainder = SCM function(SCM x, SCM y);
	alias da_scm_ceiling_divide = void function(SCM x, SCM y, SCM *q, SCM *r);
	alias da_scm_ceiling_quotient = SCM function(SCM x, SCM y);
	alias da_scm_ceiling_remainder = SCM function(SCM x, SCM y);
	alias da_scm_truncate_divide = void function(SCM x, SCM y, SCM *q, SCM *r);
	alias da_scm_truncate_quotient = SCM function(SCM x, SCM y);
	alias da_scm_truncate_remainder = SCM function(SCM x, SCM y);
	alias da_scm_centered_divide = void function(SCM x, SCM y, SCM *q, SCM *r);
	alias da_scm_centered_quotient = void function(SCM x, SCM y);
	alias da_scm_centered_remainder = void function(SCM x, SCM y);
	alias da_scm_round_divide = void function(SCM x, SCM y, SCM *q, SCM *r);
	alias da_scm_round_quotient = SCM function(SCM x, SCM y);
	alias da_scm_round_remainder = SCM function(SCM x, SCM y);

	//6.6.2.12 Bitwise Operations
	alias da_scm_logand = SCM function(SCM n1, SCM n2);
	alias da_scm_logior = SCM function(SCM n1, SCM n2);
	alias da_scm_logxor = SCM function(SCM n1, SCM n2);
	alias da_scm_lognot = SCM function(SCM n);
	alias da_scm_logtest = SCM function(SCM j, SCM k);
	alias da_scm_logbit_p = SCM function(SCM index, SCM j);
	alias da_scm_ash = SCM function(SCM n, SCM count);
	alias da_scm_round_ash = SCM function(SCM n, SCM count);
	alias da_scm_logcount = SCM function(SCM n);
	alias da_scm_integer_length = SCM function(SCM n);
	alias da_scm_integer_expt = SCM function(SCM n, SCM k);
	alias da_scm_bit_extract = SCM function(SCM n, SCM start, SCM end);

	//6.6.2.14 Random Number Generation
	alias da_scm_copy_random_state = SCM function(SCM state);
	alias da_scm_random = SCM function(SCM n, SCM state);
	alias da_scm_random_exp = SCM function(SCM state);
	alias da_scm_random_hollow_sphere_x = SCM function(SCM vect, SCM state);
	alias da_scm_random_normal = SCM function(SCM state);
	alias da_scm_random_normal_vector_x = SCM function(SCM vect, SCM state);
	alias da_scm_random_solid_sphere_x = SCM function(SCM vect, SCM state);
	alias da_scm_random_uniform = SCM function(SCM state);
	alias da_scm_seed_to_random_state = SCM function(SCM seed);
	alias da_scm_datum_to_random_state = SCM function(SCM datum);
	alias da_scm_random_state_to_datum = SCM function(SCM state);
	alias da_scm_random_state_from_platform = SCM function();

	//6.6.3 Characters
	alias da_scm_char_p = SCM function(SCM x);
	alias da_scm_char_alphabetic_p = SCM function(SCM chr);
	alias da_scm_char_numeric_p = SCM function(SCM chr);
	alias da_scm_char_whitespace_p = SCM function(SCM chr);
	alias da_scm_char_upper_case_p = SCM function(SCM chr);
	alias da_scm_char_lower_case_p = SCM function(SCM chr);
	alias da_scm_char_is_both_p = SCM function(SCM chr);
	alias da_scm_char_general_category = SCM function(SCM chr);
	alias da_scm_char_to_integer = SCM function(SCM chr);
	alias da_scm_integer_to_char = SCM function(SCM n);
	alias da_scm_char_upcase = SCM function(SCM chr);
	alias da_scm_char_downcase = SCM function(SCM chr);
	alias da_scm_char_titlecase = SCM function(SCM chr);
	alias da_scm_c_upcase = scm_t_wchar function(scm_t_wchar c);
	alias da_scm_c_downcase = scm_t_wchar function(scm_t_wchar c);
	alias da_scm_c_titlecase = scm_t_wchar function(scm_t_wchar c);

	//6.6.4.1 Character Set Predicates/Comparison
	alias da_scm_char_set_p = SCM function(SCM obj);
	alias da_scm_char_set_eq = SCM function(SCM char_sets);
	alias da_scm_char_set_leq = SCM function(SCM char_sets);
	alias da_scm_char_set_hash = SCM function(SCM cs, SCM bound);

	//6.6.4.2 Iterating over Character Sets
	alias da_scm_char_set_cursor = SCM function(SCM cs);
	alias da_scm_char_set_ref = SCM function(SCM cs, SCM cursor);
	alias da_scm_char_set_cursor_next = SCM function(SCM cs, SCM cursor);
	alias da_scm_end_of_char_set_p = SCM function(SCM cursor);
	alias da_scm_char_set_fold = SCM function(SCM kons, SCM knil, SCM cs);
	alias da_scm_char_set_unfold = SCM function(SCM p, SCM f, SCM g, SCM seed, SCM base, SCM base_cs);
	alias da_scm_char_set_unfold_x = SCM function(SCM p, SCM f, SCM g, SCM seed, SCM base, SCM base_cs);
	alias da_scm_char_set_for_each = SCM function(SCM proc, SCM cs);
	alias da_scm_char_set_map = SCM function(SCM proc, SCM cs);

	//6.6.4.3 Creating Character Sets
	alias da_scm_char_set_copy = SCM function(SCM cs);
	alias da_scm_char_set = SCM function(SCM chrs);
	alias da_scm_list_to_char_set = SCM function(SCM list, SCM base_cs);
	alias da_scm_list_to_char_set_x = SCM function(SCM list, SCM base_cs);
	alias da_scm_string_to_char_set = SCM function(SCM str, SCM base_cs);
	alias da_scm_string_to_char_set_x = SCM function(SCM str, SCM base_cs);
	alias da_scm_char_set_filter = SCM function(SCM pred, SCM cs, SCM base_cs);
	alias da_scm_char_set_filter_x = SCM function(SCM pred, SCM cs, SCM base_cs);
	alias da_scm_ucs_range_to_char_set = SCM function(SCM lower, SCM upper, SCM error, SCM base_cs);
	alias da_scm_ucs_range_to_char_set_x = SCM function(SCM lower, SCM upper, SCM error, SCM base_cs);
	alias da_scm_to_char_set = SCM function(SCM x);

	//6.6.4.4 Querying Character Sets
	alias da_scm_char_set_size = SCM function(SCM cs);
	alias da_scm_char_set_count = SCM function(SCM pred, SCM cs);
	alias da_scm_char_set_to_list = SCM function(SCM cs);
	alias da_scm_char_set_to_string = SCM function(SCM cs);
	alias da_scm_char_set_contains_p = SCM function(SCM cs, SCM ch);
	alias da_scm_char_set_every = SCM function(SCM pred, SCM cs);
	alias da_scm_char_set_any = SCM function(SCM pred, SCM cs);

	//6.6.4.5 Character-Set Algebra
	alias da_scm_char_set_adjoin = SCM function(SCM cs, SCM chrs);
	alias da_scm_char_set_delete = SCM function(SCM cs, SCM chrs);
	alias da_scm_char_set_adjoin_x = SCM function(SCM cs, SCM chrs);
	alias da_scm_char_set_delete_x = SCM function(SCM cs, SCM chrs);
	alias da_scm_char_set_complement = SCM function(SCM cs);
	alias da_scm_char_set_union = SCM function(SCM char_sets);
	alias da_scm_char_set_intersection = SCM function(SCM char_sets);
	alias da_scm_char_set_difference = SCM function(SCM cs1, SCM char_sets);
	alias da_scm_char_set_xor = SCM function(SCM char_sets);
	alias da_scm_char_set_diff_plus_intersection = SCM function(SCM cs1, SCM char_sets);
	alias da_scm_char_set_complement_x = SCM function(SCM cs);
	alias da_scm_char_set_union_x = SCM function(SCM cs1, SCM char_sets);
	alias da_scm_char_set_intersection_x = SCM function(SCM cs1, SCM char_sets);
	alias da_scm_char_set_difference_x = SCM function(SCM cs1, SCM char_sets);
	alias da_scm_char_set_xor_x = SCM function(SCM cs1, SCM char_sets);
	alias da_scm_char_set_diff_plus_intersection_x = SCM function(SCM cs1, SCM cs2, SCM char_sets);

	//6.6.5.2 String Predicates
	alias da_scm_string_p = SCM function(SCM obj);
	alias da_scm_is_string = int function(SCM obj);
	alias da_scm_string_null_p = SCM function(SCM str);
	alias da_scm_string_any = SCM function(SCM char_pred, SCM s, SCM start, SCM end);
	alias da_scm_string_every = SCM function(SCM char_pred, SCM s, SCM start, SCM end);

	//6.6.5.3 String Constructors
	alias da_scm_string = SCM function(SCM lst);
	alias da_scm_reverse_list_to_string = SCM function(SCM lst);
	alias da_scm_make_string = SCM function(SCM k, SCM chr);
	alias da_scm_c_make_string = SCM function(size_t len, SCM chr);
	alias da_scm_string_tabulate = SCM function(SCM proc, SCM len);
	alias da_scm_string_join = SCM function(SCM ls, SCM delimiter, SCM grammar);

	//6.6.5.4 List/String conversion
	alias da_scm_substring_to_list = SCM function(SCM str, SCM start, SCM end);
	alias da_scm_string_to_list = SCM function(SCM str);
	alias da_scm_string_split = SCM function(SCM str, SCM char_pred);

	//6.6.5.5 String Selection
	alias da_scm_string_length = SCM function(SCM str);
	alias da_scm_c_string_length = size_t function(SCM str);
	alias da_scm_string_ref = SCM function(SCM str, SCM k);
	alias da_scm_c_string_ref = SCM function(SCM str, size_t k);
	alias da_scm_substring_copy = SCM function(SCM str, SCM start, SCM end);
	alias da_scm_string_copy = SCM function(SCM str);
	alias da_scm_substring = SCM function(SCM str, SCM start, SCM end);
	alias da_scm_substring_shared = SCM function(SCM str, SCM start, SCM end);
	alias da_scm_substring_read_only = SCM function(SCM str, SCM start, SCM end);
	alias da_scm_c_substring = SCM function(SCM str, size_t start, size_t end);
	alias da_scm_c_substring_shared = SCM function(SCM str, size_t start, size_t end);
	alias da_scm_c_substring_copy = SCM function(SCM str, size_t start, size_t end);
	alias da_scm_c_substring_read_only = SCM function(SCM str, size_t start, size_t end);
	alias da_scm_string_take = SCM function(SCM s, SCM n);
	alias da_scm_string_drop = SCM function(SCM s, SCM n);
	alias da_scm_string_take_right = SCM function(SCM s, SCM n);
	alias da_scm_string_drop_right = SCM function(SCM s, SCM n);
	alias da_scm_string_pad = SCM function(SCM s, SCM len, SCM chr, SCM start, SCM end);
	alias da_scm_string_pad_right = SCM function(SCM s, SCM len, SCM chr, SCM start, SCM end);
	alias da_scm_string_trim = SCM function(SCM s, SCM char_pred, SCM start, SCM end);
	alias da_scm_string_trim_right = SCM function(SCM s, SCM char_pred, SCM start, SCM end);
	alias da_scm_string_trim_both = SCM function(SCM s, SCM char_pred, SCM start, SCM end);

	//6.6.5.6 String Modification
	alias da_scm_string_set_x = SCM function(SCM str, SCM k, SCM chr);
	alias da_scm_c_string_set_x = void function(SCM str, size_t k, SCM chr);
	alias da_scm_substring_fill_x = SCM function(SCM str, SCM chr, SCM start, SCM end);
	alias da_scm_string_fill_x = SCM function(SCM str, SCM chr);
	alias da_scm_substring_move_x = SCM function(SCM str1, SCM start1, SCM end1, SCM str2, SCM start2);
	alias da_scm_string_copy_x = SCM function(SCM target, SCM tstart, SCM s, SCM start, SCM end);

	//6.6.5.7 String Comparison
	alias da_scm_string_compare = SCM function(SCM s1, SCM s2, SCM proc_lt, SCM proc_eq, SCM proc_gt, SCM start1, SCM end1, SCM start2, SCM end2);
	alias da_scm_string_compare_ci = SCM function(SCM s1, SCM s2, SCM proc_lt, SCM proc_eq, SCM proc_gt, SCM start1, SCM end1, SCM start2, SCM end2);
	alias da_scm_string_eq = SCM function(SCM s1, SCM s2, SCM start1, SCM end1, SCM start2, SCM end2);
	alias da_scm_string_neq = SCM function(SCM s1, SCM s2, SCM start1, SCM end1, SCM start2, SCM end2);
	alias da_scm_string_lt = SCM function(SCM s1, SCM s2, SCM start1, SCM end1, SCM start2, SCM end2);
	alias da_scm_string_gt = SCM function(SCM s1, SCM s2, SCM start1, SCM end1, SCM start2, SCM end2);
	alias da_scm_string_le = SCM function(SCM s1, SCM s2, SCM start1, SCM end1, SCM start2, SCM end2);
	alias da_scm_string_ge = SCM function(SCM s1, SCM s2, SCM start1, SCM end1, SCM start2, SCM end2);
	alias da_scm_string_ci_eq = SCM function(SCM s1, SCM s2, SCM start1, SCM end1, SCM start2, SCM end2);
	alias da_scm_string_ci_neq = SCM function(SCM s1, SCM s2, SCM start1, SCM end1, SCM start2, SCM end2);
	alias da_scm_string_ci_lt = SCM function(SCM s1, SCM s2, SCM start1, SCM end1, SCM start2, SCM end2);
	alias da_scm_string_ci_gt = SCM function(SCM s1, SCM s2, SCM start1, SCM end1, SCM start2, SCM end2);
	alias da_scm_string_ci_le = SCM function(SCM s1, SCM s2, SCM start1, SCM end1, SCM start2, SCM end2);
	alias da_scm_string_ci_ge = SCM function(SCM s1, SCM s2, SCM start1, SCM end1, SCM start2, SCM end2);
	alias da_scm_substring_hash = SCM function(SCM s, SCM bound, SCM start, SCM end);
	alias da_scm_substring_hash_ci = SCM function(SCM s, SCM bound, SCM start, SCM end);
	alias da_scm_string_normalize_nfd = SCM function(SCM s);
	alias da_scm_string_normalize_nfkd = SCM function(SCM s);
	alias da_scm_string_normalize_nfc = SCM function(SCM s);
	alias da_scm_string_normalize_nfkc = SCM function(SCM s);

	//6.6.5.8 String Searching
	alias da_scm_string_index = SCM function(SCM s, SCM char_pred, SCM start, SCM end);
	alias da_scm_string_rindex = SCM function(SCM s, SCM char_pred, SCM start, SCM end);
	alias da_scm_string_prefix_length = SCM function(SCM s1, SCM s2, SCM start1, SCM end1, SCM start2, SCM end2);
	alias da_scm_string_prefix_length_ci = SCM function(SCM s1, SCM s2, SCM start1, SCM end1, SCM start2, SCM end2);
	alias da_scm_string_suffix_length = SCM function(SCM s1, SCM s2, SCM start1, SCM end1, SCM start2, SCM end2);
	alias da_scm_string_suffix_length_ci = SCM function(SCM s1, SCM s2, SCM start1, SCM end1, SCM start2, SCM end2);
	alias da_scm_string_prefix_p = SCM function(SCM s1, SCM s2, SCM start1, SCM end1, SCM start2, SCM end2);
	alias da_scm_string_prefix_ci_p = SCM function(SCM s1, SCM s2, SCM start1, SCM end1, SCM start2, SCM end2);
	alias da_scm_string_suffix_p = SCM function(SCM s1, SCM s2, SCM start1, SCM end1, SCM start2, SCM end2);
	alias da_scm_string_suffix_ci_p = SCM function(SCM s1, SCM s2, SCM start1, SCM end1, SCM start2, SCM end2);
	alias da_scm_string_index_right = SCM function(SCM s, SCM char_pred, SCM start, SCM end);
	alias da_scm_string_skip = SCM function(SCM s, SCM char_pred, SCM start, SCM end);
	alias da_scm_string_skip_right = SCM function(SCM s, SCM char_pred, SCM start, SCM end);
	alias da_scm_string_count = SCM function(SCM s, SCM char_pred, SCM start, SCM end);
	alias da_scm_string_contains = SCM function(SCM s1, SCM s2, SCM start1, SCM end1, SCM start2, SCM end2);
	alias da_scm_string_contains_ci = SCM function(SCM s1, SCM s2, SCM start1, SCM end1, SCM start2, SCM end2);

	//6.6.5.9 Alphabetic Case Mapping
	alias da_scm_substring_upcase = SCM function(SCM str, SCM start, SCM end);
	alias da_scm_string_upcase = SCM function(SCM str);
	alias da_scm_substring_upcase_x = SCM function(SCM str, SCM start, SCM end);
	alias da_scm_string_upcase_x = SCM function(SCM str);
	alias da_scm_substring_downcase = SCM function(SCM str, SCM start, SCM end);
	alias da_scm_string_downcase = SCM function(SCM str);
	alias da_scm_substring_downcase_x = SCM function(SCM str, SCM start, SCM end);
	alias da_scm_string_downcase_x = SCM function(SCM str);
	alias da_scm_string_capitalize = SCM function(SCM str);
	alias da_scm_string_capitalize_x = SCM function(SCM str);
	alias da_scm_string_titlecase = SCM function(SCM str, SCM start, SCM end);
	alias da_scm_string_titlecase_x = SCM function(SCM str, SCM start, SCM end);

	//6.6.5.10 Reversing and Appending Strings
	alias da_scm_string_reverse = SCM function(SCM str, SCM start, SCM end);
	alias da_scm_string_reverse_x = SCM function(SCM str, SCM start, SCM end);
	alias da_scm_string_append = SCM function(SCM args);
	alias da_scm_string_append_shared = SCM function(SCM args);
	alias da_scm_string_concatenate = SCM function(SCM ls);
	alias da_scm_string_concatenate_reverse = SCM function(SCM ls, SCM final_string, SCM end);
	alias da_scm_string_concatenate_shared = SCM function(SCM ls);
	alias da_scm_string_concatenate_reverse_shared = SCM function(SCM ls, SCM final_string, SCM end);

	//6.6.5.11 Mapping, Folding, and Unfolding
	alias da_scm_string_map = SCM function(SCM proc, SCM s, SCM start, SCM end);
	alias da_scm_string_map_x = SCM function(SCM proc, SCM s, SCM start, SCM end);
	alias da_scm_string_for_each = SCM function(SCM proc, SCM s, SCM start, SCM end);
	alias da_scm_string_for_each_index = SCM function(SCM proc, SCM s, SCM start, SCM end);
	alias da_scm_string_fold = SCM function(SCM kons, SCM knil, SCM s, SCM start, SCM end);
	alias da_scm_string_fold_right = SCM function(SCM kons, SCM knil, SCM s, SCM start, SCM end);
	alias da_scm_string_unfold = SCM function(SCM p, SCM f, SCM g, SCM seed, SCM base, SCM make_final);
	alias da_scm_string_unfold_right = SCM function(SCM p, SCM f, SCM g, SCM seed, SCM base, SCM make_final);

	//6.6.5.12 Miscellaneous String Operations
	alias da_scm_xsubstring = SCM function(SCM s, SCM from, SCM to, SCM start, SCM end);
	alias da_scm_string_xcopy_x = SCM function(SCM target, SCM tstart, SCM s, SCM sfrom, SCM sto, SCM start, SCM end);
	alias da_scm_string_replace = SCM function(SCM s1, SCM s2, SCM start1, SCM end1, SCM start2, SCM end2);
	alias da_scm_string_tokenize = SCM function(SCM s, SCM token_set, SCM start, SCM end);
	alias da_scm_string_filter = SCM function(SCM char_pred, SCM s, SCM start, SCM end);
	alias da_scm_string_delete = SCM function(SCM char_pred, SCM s, SCM start, SCM end);

	//6.6.5.14 Conversion to/from C
	alias da_scm_from_locale_string = SCM function(const char * str);
	alias da_scm_from_locale_stringn = SCM function(const char * str, size_t len);
	alias da_scm_take_locale_string = SCM function(char * str);
	alias da_scm_take_locale_stringn = SCM function(char * str, size_t len);
	alias da_scm_to_locale_string = char * function(SCM str);
	alias da_scm_to_locale_stringn = char * function(SCM str, size_t * lenp);
	alias da_scm_to_locale_stringbuf = size_t function(SCM str, char * buf, size_t max_len);
	alias da_scm_to_stringn = char * function(SCM str, size_t * lenp, const char * encoding, scm_t_string_failed_conversion_handler handler);
	alias da_scm_from_stringn = SCM function(const char * str, size_t len, const char * encoding, scm_t_string_failed_conversion_handler handler);
	alias da_scm_from_latin1_string = SCM function(const char * str);
	alias da_scm_from_utf8_string = SCM function(const char * str);
	alias da_scm_from_utf32_string = SCM function(const scm_t_wchar * str);
	alias da_scm_from_latin1_stringn = SCM function(const char * str, size_t len);
	alias da_scm_from_utf8_stringn = SCM function(const char * str, size_t len);
	alias da_scm_from_utf32_stringn = SCM function(const scm_t_wchar * str, size_t len);

	//6.6.5.15 String Internals
	alias da_scm_string_bytes_per_char = SCM function(SCM str);
	alias da_scm_sys_string_dump = SCM function(SCM str);
	
	//6.6.6.1 Endianness
	alias da_scm_native_endianness = SCM function();

	//6.6.6.2 Manipulating Bytevectors
	alias da_scm_make_bytevector = SCM function(SCM len, SCM fill);
	alias da_scm_c_make_bytevector = SCM function(size_t len);
	alias da_scm_bytevector_p = SCM function(SCM obj);
	alias da_scm_is_bytevector = int function(SCM obj);
	alias da_scm_bytevector_length = SCM function(SCM bv);
	alias da_scm_c_bytevector_length = size_t function(SCM bv);
	alias da_scm_bytevector_eq_p = SCM function(SCM bv1, SCM bv2);
	alias da_scm_bytevector_fill_x = SCM function(SCM bv, SCM fill);
	alias da_scm_bytevector_copy_x = SCM function(SCM source, SCM source_start, SCM target, SCM target_start, SCM len);
	alias da_scm_bytevector_copy = SCM function(SCM bv);
	alias da_scm_c_bytevector_ref = scm_t_uint8 function(SCM bv, size_t index);
	alias da_scm_c_bytevector_set_x = void function(SCM bv, size_t index, scm_t_uint8 value);

	//6.6.6.3 Interpreting Bytevector Contents as Integers
	alias da_scm_bytevector_uint_ref = SCM function(SCM bv, SCM index, SCM endianness, SCM size);
	alias da_scm_bytevector_sint_ref = SCM function(SCM bv, SCM index, SCM endianness, SCM size);
	alias da_scm_bytevector_uint_set_x = SCM function(SCM bv, SCM index, SCM value, SCM endianness, SCM size);
	alias da_scm_bytevector_sint_set_x = SCM function(SCM bv, SCM index, SCM value, SCM endianness, SCM size);
	alias da_scm_bytevector_u8_ref = SCM function(SCM bv, SCM index);
	alias da_scm_bytevector_s8_ref = SCM function(SCM bv, SCM index);
	alias da_scm_bytevector_u16_ref = SCM function(SCM bv, SCM index, SCM endianness);
	alias da_scm_bytevector_s16_ref = SCM function(SCM bv, SCM index, SCM endianness);
	alias da_scm_bytevector_u32_ref = SCM function(SCM bv, SCM index, SCM endianness);
	alias da_scm_bytevector_s32_ref = SCM function(SCM bv, SCM index, SCM endianness);
	alias da_scm_bytevector_u64_ref = SCM function(SCM bv, SCM index, SCM endianness);
	alias da_scm_bytevector_s64_ref = SCM function(SCM bv, SCM index, SCM endianness);
	alias da_scm_bytevector_u8_set_x = SCM function(SCM bv, SCM index, SCM value);
	alias da_scm_bytevector_s8_set_x = SCM function(SCM bv, SCM index, SCM value);
	alias da_scm_bytevector_u16_set_x = SCM function(SCM bv, SCM index, SCM value, SCM endianness);
	alias da_scm_bytevector_s16_set_x = SCM function(SCM bv, SCM index, SCM value, SCM endianness);
	alias da_scm_bytevector_u32_set_x = SCM function(SCM bv, SCM index, SCM value, SCM endianness);
	alias da_scm_bytevector_s32_set_x = SCM function(SCM bv, SCM index, SCM value, SCM endianness);
	alias da_scm_bytevector_u64_set_x = SCM function(SCM bv, SCM index, SCM value, SCM endianness);
	alias da_scm_bytevector_s64_set_x = SCM function(SCM bv, SCM index, SCM value, SCM endianness);
	alias da_scm_bytevector_u16_native_ref = SCM function(SCM bv, SCM index);
	alias da_scm_bytevector_s16_native_ref = SCM function(SCM bv, SCM index);
	alias da_scm_bytevector_u32_native_ref = SCM function(SCM bv, SCM index);
	alias da_scm_bytevector_s32_native_ref = SCM function(SCM bv, SCM index);
	alias da_scm_bytevector_u64_native_ref = SCM function(SCM bv, SCM index);
	alias da_scm_bytevector_s64_native_ref = SCM function(SCM bv, SCM index);
	alias da_scm_bytevector_u16_native_set_x = SCM function(SCM bv, SCM index, SCM value);
	alias da_scm_bytevector_s16_native_set_x = SCM function(SCM bv, SCM index, SCM value);
	alias da_scm_bytevector_u32_native_set_x = SCM function(SCM bv, SCM index, SCM value);
	alias da_scm_bytevector_s32_native_set_x = SCM function(SCM bv, SCM index, SCM value);
	alias da_scm_bytevector_u64_native_set_x = SCM function(SCM bv, SCM index, SCM value);
	alias da_scm_bytevector_s64_native_set_x = SCM function(SCM bv, SCM index, SCM value);

	//6.6.6.4 Converting Bytevectors to/from Integer Lists
	alias da_scm_bytevector_to_u8_list = SCM function(SCM bv);
	alias da_scm_u8_list_to_bytevector = SCM function(SCM lst);
	alias da_scm_bytevector_to_uint_list = SCM function(SCM bv, SCM endianness, SCM size);
	alias da_scm_bytevector_to_sint_list = SCM function(SCM bv, SCM endianness, SCM size);
	alias da_scm_uint_list_to_bytevector = SCM function(SCM lst, SCM endianness, SCM size);
	alias da_scm_sint_list_to_bytevector = SCM function(SCM lst, SCM endianness, SCM size);

	//6.6.6.5 Interpreting Bytevector Contents as Floating Point Numbers
	alias da_scm_bytevector_ieee_single_ref = SCM function(SCM bv, SCM index, SCM endianness);
	alias da_scm_bytevector_ieee_double_ref = SCM function(SCM bv, SCM index, SCM endianness);
	alias da_scm_bytevector_ieee_single_set_x = SCM function(SCM bv, SCM index, SCM value, SCM endianness);
	alias da_scm_bytevector_ieee_double_set_x = SCM function(SCM bv, SCM index, SCM value, SCM endianness);
	alias da_scm_bytevector_ieee_single_native_ref = SCM function(SCM bv, SCM index);
	alias da_scm_bytevector_ieee_double_native_ref = SCM function(SCM bv, SCM index);
	alias da_scm_bytevector_ieee_single_native_set_x = SCM function(SCM bv, SCM index, SCM value);
	alias da_scm_bytevector_ieee_double_native_set_x = SCM function(SCM bv, SCM index, SCM value);

	//6.6.6.6 Interpreting Bytevector Contents as Unicode Strings
	alias da_scm_string_to_utf8 = SCM function(SCM str);
	alias da_scm_string_to_utf16 = SCM function(SCM str, SCM endianness);
	alias da_scm_string_to_utf32 = SCM function(SCM str, SCM endianness);
	alias da_scm_utf8_to_string = SCM function(SCM utf);
	alias da_scm_utf16_to_string = SCM function(SCM utf, SCM endianness);
	alias da_scm_utf32_to_string = SCM function(SCM utf, SCM endianness);

	//6.6.7.2 Symbols as Lookup Keys
	alias da_scm_symbol_hash = SCM function(SCM symbol);

	//6.6.7.4 Operations Related to Symbols
	alias da_scm_symbol_p = SCM function(SCM obj);
	alias da_scm_symbol_to_string = SCM function(SCM s);
	alias da_scm_string_to_symbol = SCM function(SCM str);
	alias da_scm_string_ci_to_symbol = SCM function(SCM str);
	alias da_scm_from_latin1_symbol = SCM function(const char * name);
	alias da_scm_from_utf8_symbol = SCM function(const char * name);
	alias da_scm_from_locale_symbol = SCM function(const char * name);
	alias da_scm_from_locale_symboln = SCM function(const char * name, size_t len);
	alias da_scm_take_locale_symbol = SCM function(char * str);
	alias da_scm_take_locale_symboln = SCM function(char * str, size_t len);
	alias da_scm_c_symbol_length = size_t function(SCM sym);
	alias da_scm_gensym = SCM function(SCM prefix);

	//6.6.7.5 Function Slots and Property Lists
	alias da_scm_symbol_fref = SCM function(SCM symbol);
	alias da_scm_symbol_fset_x = SCM function(SCM symbol, SCM value);
	alias da_scm_symbol_pref = SCM function(SCM symbol);
	alias da_scm_symbol_pset_x = SCM function(SCM symbol, SCM value);

	//6.6.7.7 Uninterned Symbols
	alias da_scm_make_symbol = SCM function(SCM name);
	alias da_scm_symbol_interned_p = SCM function(SCM symbol);

	//6.6.8.4 Keyword Procedures
	alias da_scm_keyword_p = SCM function(SCM obj);
	alias da_scm_keyword_to_symbol = SCM function(SCM keyword);
	alias da_scm_symbol_to_keyword = SCM function(SCM symbol);
	alias da_scm_is_keyword = int function(SCM obj);
	alias da_scm_from_locale_keyword = SCM function(const char * name);
	alias da_scm_from_locale_keywordn = SCM function(const char * name, size_t len);
	alias da_scm_from_latin1_keyword = SCM function(const char * name);
	alias da_scm_from_utf8_keyword = SCM function(const char * name);
	alias da_scm_c_bind_keyword_arguments = void function(const char * subr, SCM rest, scm_t_keyword_arguments_flags flags, SCM keyword1, SCM * argp1, ...);

	//6.7.1 Pairs
	alias da_scm_cons = SCM function(SCM x, SCM y);
	alias da_scm_pair_p = SCM function(SCM x);
	alias da_scm_is_pair = int function(SCM x);
	alias da_scm_car = SCM function(SCM pair);
	alias da_scm_cdr = SCM function(SCM pair);
	alias da_scm_cddr = SCM function(SCM pair);
	alias da_scm_cdar = SCM function(SCM pair);
	alias da_scm_cadr = SCM function(SCM pair);
	alias da_scm_caar = SCM function(SCM pair);
	alias da_scm_cdddr = SCM function(SCM pair);
	alias da_scm_cddar = SCM function(SCM pair);
	alias da_scm_cdadr = SCM function(SCM pair);
	alias da_scm_cdaar = SCM function(SCM pair);
	alias da_scm_caddr = SCM function(SCM pair);
	alias da_scm_cadar = SCM function(SCM pair);
	alias da_scm_caadr = SCM function(SCM pair);
	alias da_scm_caaar = SCM function(SCM pair);
	alias da_scm_cddddr = SCM function(SCM pair);
	alias da_scm_cdddar = SCM function(SCM pair);
	alias da_scm_cddadr = SCM function(SCM pair);
	alias da_scm_cddaar = SCM function(SCM pair);
	alias da_scm_cdaddr = SCM function(SCM pair);
	alias da_scm_cdadar = SCM function(SCM pair);
	alias da_scm_cdaadr = SCM function(SCM pair);
	alias da_scm_cdaaar = SCM function(SCM pair);
	alias da_scm_cadddr = SCM function(SCM pair);
	alias da_scm_caddar = SCM function(SCM pair);
	alias da_scm_cadadr = SCM function(SCM pair);
	alias da_scm_cadaar = SCM function(SCM pair);
	alias da_scm_caaddr = SCM function(SCM pair);
	alias da_scm_caadar = SCM function(SCM pair);
	alias da_scm_caaadr = SCM function(SCM pair);
	alias da_scm_caaaar = SCM function(SCM pair);
	alias da_scm_set_car_x = SCM function(SCM pair, SCM value);
	alias da_scm_set_cdr_x = SCM function(SCM pair, SCM value);

	//6.7.2.2 List Predicates
	alias da_scm_list_p = SCM function(SCM x);
	alias da_scm_null_p = SCM function(SCM x);

	//6.7.2.3 List Constructors
	alias da_scm_list_1 = SCM function(SCM elem1);
	alias da_scm_list_2 = SCM function(SCM elem1, SCM elem2);
	alias da_scm_list_3 = SCM function(SCM elem1, SCM elem2, SCM elem3);
	alias da_scm_list_4 = SCM function(SCM elem1, SCM elem2, SCM elem3, SCM elem4);
	alias da_scm_list_5 = SCM function(SCM elem1, SCM elem2, SCM elem3, SCM elem4, SCM elem5);
	alias da_scm_list_n = SCM function(SCM elem1, ...);
	alias da_scm_list_copy = SCM function(SCM lst);

	//6.7.2.4 List Selection
	alias da_scm_length = SCM function(SCM lst);
	alias da_scm_last_pair = SCM function(SCM lst);
	alias da_scm_list_ref = SCM function(SCM list, SCM k);
	alias da_scm_list_tail = SCM function(SCM lst, SCM k);
	alias da_scm_list_head = SCM function(SCM lst, SCM k);

	//6.7.2.5 Append and Reverse
	alias da_scm_append = SCM function(SCM lstlst);
	alias da_scm_append_x = SCM function(SCM lstlst);
	alias da_scm_reverse = SCM function(SCM lst);
	alias da_scm_reverse_x = SCM function(SCM lst, SCM newtail);

	//6.7.2.6 List Modification
	alias da_scm_list_set_x = SCM function(SCM list, SCM k, SCM val);
	alias da_scm_list_cdr_set_x = SCM function(SCM list, SCM k, SCM val);
	alias da_scm_delq = SCM function(SCM item, SCM lst);
	alias da_scm_delv = SCM function(SCM item, SCM lst);
	alias da_scm_delete = SCM function(SCM item, SCM lst);
	alias da_scm_delq_x = SCM function(SCM item, SCM lst);
	alias da_scm_delv_x = SCM function(SCM item, SCM lst);
	alias da_scm_delete_x = SCM function(SCM item, SCM lst);
	alias da_scm_delq1_x = SCM function(SCM item, SCM lst);
	alias da_scm_delv1_x = SCM function(SCM item, SCM lst);
	alias da_scm_delete1_x = SCM function(SCM item, SCM lst);

	//6.7.2.7 List Searching
	alias da_scm_memq = SCM function(SCM x, SCM lst);
	alias da_scm_memv = SCM function(SCM x, SCM lst);
	alias da_scm_member = SCM function(SCM x, SCM lst);

	//6.7.2.8 List Mapping
	alias da_scm_map = SCM function(SCM proc, SCM arg1, SCM args);

	//6.7.3.2 Dynamic Vector Creation and Validation
	alias da_scm_vector = SCM function(SCM l);
	alias da_scm_vector_to_list = SCM function(SCM v);
	alias da_scm_make_vector = SCM function(SCM len, SCM fill);
	alias da_scm_c_make_vector = SCM function(size_t k, SCM fill);
	alias da_scm_vector_p = SCM function(SCM obj);
	alias da_scm_is_vector = int function(SCM obj);

	//6.7.3.3 Accessing and Modifying Vector Contents
	alias da_scm_vector_length = SCM function(SCM vector);
	alias da_scm_c_vector_length = size_t function(SCM vec);
	alias da_scm_vector_ref = SCM function(SCM vec, SCM k);
	alias da_scm_c_vector_ref = SCM function(SCM vec, size_t k);
	alias da_scm_vector_set_x = SCM function(SCM vec, SCM k, SCM obj);
	alias da_scm_c_vector_set_x = void function(SCM vec, size_t k, SCM obj);
	alias da_scm_vector_fill_x = SCM function(SCM vec, SCM fill);
	alias da_scm_vector_copy = SCM function(SCM vec);
	alias da_scm_vector_move_left_x = SCM function(SCM vec1, SCM start1, SCM end1, SCM vec2, SCM start2);
	alias da_scm_vector_move_right_x = SCM function(SCM vec1, SCM start1, SCM end1, SCM vec2, SCM start2);

	//6.7.3.4 Vector Accessing from C
	alias da_scm_is_simple_vector = int function(SCM obj);
	alias da_scm_vector_elements = const SCM * function(SCM vec, scm_t_array_handle * handle, size_t * lenp, ssize_t * incp);
	alias da_scm_vector_writable_elements = SCM * function(SCM vec, scm_t_array_handle * handle, size_t * lenp, ssize_t * incp);

	//6.7.4 Bit Vectors
	alias da_scm_bitvector_p = SCM function(SCM obj);
	alias da_scm_is_bitvector = int function(SCM obj);
	alias da_scm_make_bitvector = SCM function(SCM len, SCM fill);
	alias da_scm_c_make_bitvector = SCM function(size_t len, SCM fill);
	alias da_scm_bitvector = SCM function(SCM bits);
	alias da_scm_bitvector_length = SCM function(SCM vec);
	alias da_scm_c_bitvector_length = size_t function(SCM vec);
	alias da_scm_bitvector_ref = SCM function(SCM vec, SCM idx);
	alias da_scm_c_bitvector_ref = SCM function(SCM vec, size_t idx);
	alias da_scm_bitvector_set_x = SCM function(SCM vec, SCM idx, SCM val);
	alias da_scm_c_bitvector_set_x = SCM function(SCM vec, size_t idx, SCM val);
	alias da_scm_bitvector_fill_x = SCM function(SCM vec, SCM val);
	alias da_scm_list_to_bitvector = SCM function(SCM list);
	alias da_scm_bitvector_to_list = SCM function(SCM vec);
	alias da_scm_bit_count = SCM function(SCM boolean, SCM bitvector);
	alias da_scm_bit_position = SCM function(SCM boolean, SCM bitvector, SCM start);
	alias da_scm_bit_invert_x = SCM function(SCM bitvector);
	alias da_scm_bit_set_star_x = SCM function(SCM bitvector, SCM uvec, SCM boolean);
	alias da_scm_bit_count_star = SCM function(SCM bitvector, SCM uvec, SCM boolean);
	alias da_scm_bitvector_elements = const scm_t_uint32 * function(SCM vec, scm_t_array_handle * handle, size_t * offp, size_t * lenp, ssize_t * incp);
	alias da_scm_bitvector_writable_elements = scm_t_uint32 * function(SCM vec, scm_t_array_handle * handle, size_t * offp, size_t * lenp, ssize_t * incp);

	//6.7.5.2 Array Procedures
	alias da_scm_array_p = SCM function(SCM obj, SCM unused);
	alias da_scm_typed_array_p = SCM function(SCM obj, SCM type);
	alias da_scm_is_array = int function(SCM obj);
	alias da_scm_is_typed_array = int function(SCM obj, SCM type);
	alias da_scm_make_array = SCM function(SCM fill, SCM bounds);
	alias da_scm_make_typed_array = SCM function(SCM type, SCM fill, SCM bounds);
	alias da_scm_list_to_typed_array = SCM function(SCM type, SCM dimspec, SCM list);
	alias da_scm_array_type = SCM function(SCM array);
	alias da_scm_array_ref = SCM function(SCM array, SCM idxlist);
	alias da_scm_array_in_bounds_p = SCM function(SCM array, SCM idxlist);
	alias da_scm_array_set_x = SCM function(SCM array, SCM obj, SCM idxlist);
	alias da_scm_array_dimensions = SCM function(SCM array);
	alias da_scm_array_length = SCM function(SCM array);
	alias da_scm_c_array_length = size_t function(SCM array);
	alias da_scm_array_rank = SCM function(SCM array);
	alias da_scm_c_array_rank = size_t function(SCM array);
	alias da_scm_array_to_list = SCM function(SCM array);
	alias da_scm_array_copy_x = SCM function(SCM src, SCM dst);
	alias da_scm_array_fill_x = SCM function(SCM array, SCM fill);
	alias da_scm_array_map_x = SCM function(SCM dst, SCM proc, SCM srclist);
	alias da_scm_array_for_each = SCM function(SCM proc, SCM src1, SCM srclist);
	alias da_scm_array_index_map_x = SCM function(SCM dst, SCM proc);
	alias da_scm_uniform_array_read_x = SCM function(SCM ra, SCM port_or_fd, SCM start, SCM end);
	alias da_scm_uniform_array_write = SCM function(SCM ra, SCM port_or_fd, SCM start, SCM end);

	//6.7.5.3 Shared Arrays
	alias da_scm_make_shared_array = SCM function(SCM oldarray, SCM mapfunc, SCM boundlist);
	alias da_scm_shared_array_increments = SCM function(SCM array);
	alias da_scm_shared_array_offset = SCM function(SCM array);
	alias da_scm_shared_array_root = SCM function(SCM array);
	alias da_scm_array_contents = SCM function(SCM array, SCM strict);
	alias da_scm_transpose_array = SCM function(SCM array, SCM dimlist);

	//6.7.5.4 Accessing Arrays from C
	alias da_scm_array_get_handle = void function(SCM array, scm_t_array_handle * handle);
	alias da_scm_array_handle_release = void function(scm_t_array_handle * handle);
	alias da_scm_array_handle_pos = ssize_t function(scm_t_array_handle * handle, SCM indices);
	alias da_scm_array_handle_ref = SCM function(scm_t_array_handle * handle, ssize_t pos);
	alias da_scm_array_handle_set = void function(scm_t_array_handle * handle, ssize_t pos, SCM val);
	alias da_scm_array_handle_elements = const SCM * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_writable_elements = SCM * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_uniform_elements = const void * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_uniform_writable_elements = void * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_uniform_element_size = size_t function(scm_t_array_handle * handle);
	alias da_scm_array_handle_u8_elements = const scm_t_uint8 * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_s8_elements = const scm_t_int8 * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_u16_elements = const scm_t_uint16 * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_s16_elements = const scm_t_int16 * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_u32_elements = const scm_t_uint32 * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_s32_elements = const scm_t_int32 * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_u64_elements = const scm_t_uint64 * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_s64_elements = const scm_t_int64 * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_f32_elements = const float * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_f64_elements = const double * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_c32_elements = const float * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_c64_elements = const double * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_u8_writable_elements = scm_t_uint8 * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_s8_writable_elements = scm_t_int8 * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_u16_writable_elements = scm_t_uint16 * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_s16_writable_elements = scm_t_int16 * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_u32_writable_elements = scm_t_uint32 * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_s32_writable_elements = scm_t_int32 * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_u64_writable_elements = scm_t_uint64 * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_s64_writable_elements = scm_t_int64 * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_f32_writable_elements = float * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_f64_writable_elements = double * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_c32_writable_elements = float * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_c64_writable_elements = double * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_bit_elements = const scm_t_uint32 * function(scm_t_array_handle * handle);
	alias da_scm_array_handle_bit_writable_elements = scm_t_uint32 * function(scm_t_array_handle * handle);

	//6.7.10.2 Structure Basics
	alias da_scm_make_struct = SCM function(SCM vtable, SCM tail_size, SCM init_list);
	alias da_scm_c_make_struct = SCM function(SCM vtable, SCM tail_size, SCM init, ...);
	alias da_scm_c_make_structv = SCM function(SCM vtable, SCM tail_size, size_t n_inits, scm_t_bits* init);
	alias da_scm_struct_p = SCM function(SCM obj);
	alias da_scm_struct_ref = SCM function(SCM strct, SCM n);
	alias da_scm_struct_set_x = SCM function(SCM strct, SCM n, SCM value);
	alias da_scm_struct_vtable = SCM function(SCM strct);

	//6.7.10.3 Vtable Contents
	alias da_scm_struct_vtable_name = SCM function(SCM vtable);
	alias da_scm_set_struct_vtable_name_x = SCM function(SCM vtable, SCM name);

	//6.7.10.4 Meta-Vtables
	alias da_scm_struct_vtable_p = SCM function(SCM obj);
	alias da_scm_make_struct_layout = SCM function(SCM fields);

	//6.7.12.2 Adding or Setting Alist Entries
	alias da_scm_acons = SCM function(SCM key, SCM value, SCM alist);
	alias da_scm_assq_set_x = SCM function(SCM alist, SCM key, SCM val);
	alias da_scm_assv_set_x = SCM function(SCM alist, SCM key, SCM val);
	alias da_scm_assoc_set_x = SCM function(SCM alist, SCM key, SCM val);

	//6.7.12.3 Retrieving Alist Entries
	alias da_scm_assq = SCM function(SCM key, SCM alist);
	alias da_scm_assv = SCM function(SCM key, SCM alist);
	alias da_scm_assoc = SCM function(SCM key, SCM alist);
	alias da_scm_assq_ref = SCM function(SCM alist, SCM key);
	alias da_scm_assv_ref = SCM function(SCM alist, SCM key);
	alias da_scm_assoc_ref = SCM function(SCM alist, SCM key);

	//6.7.12.4 Removing Alist Entries
	alias da_scm_assq_remove_x = SCM function(SCM alist, SCM key);
	alias da_scm_assv_remove_x = SCM function(SCM alist, SCM key);
	alias da_scm_assoc_remove_x = SCM function(SCM alist, SCM key);

	//6.7.12.5 Sloppy Alist Functions
	alias da_scm_sloppy_assq = SCM function(SCM key, SCM alist);
	alias da_scm_sloppy_assv = SCM function(SCM key, SCM alist);
	alias da_scm_sloppy_assoc = SCM function(SCM key, SCM alist);

	//6.7.14.2 Hash Table Reference
	alias da_scm_hash_table_p = SCM function(SCM obj);
	alias da_scm_hash_clear_x = SCM function(SCM table);
	alias da_scm_hash_ref = SCM function(SCM table, SCM key, SCM dflt);
	alias da_scm_hashq_ref = SCM function(SCM table, SCM key, SCM dflt);
	alias da_scm_hashv_ref = SCM function(SCM table, SCM key, SCM dflt);
	alias da_scm_hashx_ref = SCM function(SCM hash, SCM assoc, SCM table, SCM key, SCM dflt);
	alias da_scm_hash_set_x = SCM function(SCM table, SCM key, SCM val);
	alias da_scm_hashq_set_x = SCM function(SCM table, SCM key, SCM val);
	alias da_scm_hashv_set_x = SCM function(SCM table, SCM key, SCM val);
	alias da_scm_hashx_set_x = SCM function(SCM hash, SCM assoc, SCM table, SCM key, SCM val);
	alias da_scm_hash_remove_x = SCM function(SCM table, SCM key);
	alias da_scm_hashq_remove_x = SCM function(SCM table, SCM key);
	alias da_scm_hashv_remove_x = SCM function(SCM table, SCM key);
	alias da_scm_hashx_remove_x = SCM function(SCM hash, SCM assoc, SCM table, SCM key);
	alias da_scm_hash = SCM function(SCM key, SCM size);
	alias da_scm_hashq = SCM function(SCM key, SCM size);
	alias da_scm_hashv = SCM function(SCM key, SCM size);
	alias da_scm_hash_get_handle = SCM function(SCM table, SCM key);
	alias da_scm_hashq_get_handle = SCM function(SCM table, SCM key);
	alias da_scm_hashv_get_handle = SCM function(SCM table, SCM key);
	alias da_scm_hashx_get_handle = SCM function(SCM hash, SCM assoc, SCM table, SCM key);
	alias da_scm_hash_create_handle_x = SCM function(SCM table, SCM key, SCM init);
	alias da_scm_hashq_create_handle_x = SCM function(SCM table, SCM key, SCM init);
	alias da_scm_hashv_create_handle_x = SCM function(SCM table, SCM key, SCM init);
	alias da_scm_hashx_create_handle_x = SCM function(SCM hash, SCM assoc, SCM table, SCM key, SCM init);
	alias da_scm_hash_map_to_list = SCM function(SCM proc, SCM table);
	alias da_scm_hash_for_each = SCM function(SCM proc, SCM table);
	alias da_scm_hash_for_each_handle = SCM function(SCM proc, SCM table);
	alias da_scm_hash_fold = SCM function(SCM proc, SCM init, SCM table);
	alias da_scm_hash_count = SCM function(SCM pred, SCM table);

	//6.8 Smobs
	alias da_scm_set_smob_free = void function(scm_t_bits tc, size_t function(SCM obj) free);
	alias da_scm_set_smob_mark = void function(scm_t_bits tc, SCM function(SCM obj) mark);
	alias da_scm_set_smob_print = void function(scm_t_bits tc, int function(SCM obj, SCM port, scm_print_state* pstate) print);
	alias da_scm_set_smob_equalp = void function(scm_t_bits tc, SCM function (SCM obj1, SCM obj2) equalp);
	alias da_scm_assert_smob_type = void function(scm_t_bits tag, SCM val);
	alias da_scm_new_smob = SCM function(scm_t_bits tag, void * data);
	alias da_scm_new_double_smob = SCM function(scm_t_bits tag, void * data, void * data2, void * data3);

	//6.9.3 Compiled Procedures
	alias da_scm_program_p = SCM function(SCM obj);
	alias da_scm_program_objcode = SCM function(SCM program);
	alias da_scm_program_objects = SCM function(SCM program);
	alias da_scm_program_module = SCM function(SCM program);
	alias da_scm_program_meta = SCM function(SCM program);
	alias da_scm_program_arities = SCM function(SCM program);

	//6.9.7 Procedure Properties and Meta-information
	alias da_scm_procedure_p = SCM function(SCM obj);
	alias da_scm_thunk_p = SCM function(SCM obj);
	alias da_scm_procedure_name = SCM function(SCM proc);
	alias da_scm_procedure_source = SCM function(SCM proc);
	alias da_scm_procedure_properties = SCM function(SCM proc);
	alias da_scm_procedure_property = SCM function(SCM proc, SCM key);
	alias da_scm_set_procedure_properties_x = SCM function(SCM proc, SCM alist);
	alias da_scm_set_procedure_property_x = SCM function(SCM proc, SCM key, SCM value);
	alias da_scm_procedure_documentation = SCM function(SCM proc);

	//6.9.8 Procedures with Setters
	alias da_scm_make_procedure_with_setter = SCM function(SCM procedure, SCM setter);
	alias da_scm_procedure_with_setter_p = SCM function(SCM obj);
	alias da_scm_procedure = SCM function(SCM proc);

	//6.10.9 Internal Macros
	alias da_scm_macro_p = SCM function(SCM obj);
	alias da_scm_macro_type = SCM function(SCM m);
	alias da_scm_macro_name = SCM function(SCM m);
	alias da_scm_macro_binding = SCM function(SCM m);
	alias da_scm_macro_transformer = SCM function(SCM m);

	//6.11.1 Equality
	alias da_scm_eq_p = SCM function(SCM x, SCM y);
	alias da_scm_eqv_p = SCM function(SCM x, SCM y);
	alias da_scm_equal_p = SCM function(SCM x, SCM y);

	//6.11.2 Object Properties
	alias da_scm_object_properties = SCM function(SCM obj);
	alias da_scm_set_object_properties_x = SCM function(SCM obj, SCM alist);
	alias da_scm_object_property = SCM function(SCM obj, SCM key);
	alias da_scm_set_object_property_x = SCM function(SCM obj, SCM key, SCM value);

	//6.11.3 Sorting
	alias da_scm_merge = SCM function(SCM alist, SCM blist, SCM less);
	alias da_scm_merge_x = SCM function(SCM alist, SCM blist, SCM less);
	alias da_scm_sorted_p = SCM function(SCM items, SCM less);
	alias da_scm_sort = SCM function(SCM items, SCM less);
	alias da_scm_sort_x = SCM function(SCM items, SCM less);
	alias da_scm_stable_sort = SCM function(SCM items, SCM less);
	alias da_scm_stable_sort_x = SCM function(SCM items, SCM less);
	alias da_scm_sort_list = SCM function(SCM items, SCM less);
	alias da_scm_sort_list_x = SCM function(SCM items, SCM less);
	alias da_scm_restricted_vector_sort_x = SCM function(SCM vec, SCM less, SCM startpos, SCM endpos);

	//6.11.4 Copying Deep Structures
	alias da_scm_copy_tree = SCM function(SCM obj);

	//6.11.5 General String Conversion
	alias da_scm_object_to_string = SCM function(SCM obj, SCM printer);

	//6.11.6.2 Hook Reference
	alias da_scm_make_hook = SCM function(SCM n_args);
	alias da_scm_hook_p = SCM function(SCM x);
	alias da_scm_hook_empty_p = SCM function(SCM hook);
	alias da_scm_add_hook_x = SCM function(SCM hook, SCM proc, SCM append_p);
	alias da_scm_remove_hook_x = SCM function(SCM hook, SCM proc);
	alias da_scm_reset_hook_x = SCM function(SCM hook);
	alias da_scm_hook_to_list = SCM function(SCM hook);
	alias da_scm_run_hook = SCM function(SCM hook, SCM args);
	alias da_scm_c_run_hook = void function(SCM hook, SCM args);

	//6.11.6.4 Hooks For C Code.
	alias da_scm_c_hook_init = void function(scm_t_c_hook * hook, void * hook_data, scm_t_c_hook_type type);
	alias da_scm_c_hook_add = void function(scm_t_c_hook * hook, scm_t_c_hook_function func, void * func_data, int appendp);
	alias da_scm_c_hook_remove = void function(scm_t_c_hook * hook, scm_t_c_hook_function func, void * func_data);
	alias da_scm_c_hook_run = void * function(scm_t_c_hook * hook, void * data);

	//6.12.1 Top Level Variable Definitions
	alias da_scm_define = SCM function(SCM sym, SCM value);
	alias da_scm_c_define = SCM function(const char * name, SCM value);

	//6.12.4 Querying variable bindings
	alias da_scm_defined_p = SCM function(SCM sym, SCM modle);

	//6.13.7 Returning and Accepting Multiple Values
	alias da_scm_values = SCM function(SCM args);
	alias da_scm_c_values = SCM function(SCM * base, size_t n);
	alias da_scm_c_nvalues = size_t function(SCM obj);
	alias da_scm_c_value_ref = SCM function(SCM obj, size_t idx);

	//6.13.8.2 Catching Exceptions
	alias da_scm_catch_with_pre_unwind_handler = SCM function(SCM key, SCM thunk, SCM handler, SCM pre_unwind_handler);
	alias da_scm_catch = SCM function(SCM key, SCM thunk, SCM handler);
	alias da_scm_c_catch = SCM function(SCM tag, scm_t_catch_body c_body, void * body_data, scm_t_catch_handler handler, void * handler_data, scm_t_catch_handler pre_unwind_handler, void * pre_unwind_handler_data);
	alias da_scm_internal_catch = SCM function(SCM tag, scm_t_catch_body c_body, void * body_data, scm_t_catch_handler handler, void * handler_data);

	//6.13.8.3 Throw Handlers
	alias da_scm_with_throw_handler = SCM function(SCM key, SCM thunk, SCM handler);
	alias da_scm_c_with_throw_handler = SCM function(SCM tag, scm_t_catch_body c_body, void * body_data, scm_t_catch_handler handler, void * handler_data, int lazy_catch_p);

	//6.13.8.4 Throwing Exceptions
	alias da_scm_throw = SCM function(SCM key, SCM args);

	//6.13.9 Procedures for Signaling Errors
	alias da_scm_error_scm = SCM function(SCM key, SCM subr, SCM message, SCM args, SCM data);
	alias da_scm_strerror = SCM function(SCM err);

	//6.13.10 Dynamic Wind
	alias da_scm_dynamic_wind = SCM function(SCM in_guard, SCM thunk, SCM out_guard);
	alias da_scm_dynwind_begin = void function(scm_t_dynwind_flags flags);
	alias da_scm_dynwind_end = void function();
	alias da_scm_dynwind_unwind_handler = void function(void function(void * ) func, void * data, scm_t_wind_flags flags);
	alias da_scm_dynwind_unwind_handler_with_scm = void function(void function(SCM) func, SCM data, scm_t_wind_flags flags);
	alias da_scm_dynwind_rewind_handler = void function(void function(void * ) func, void * data, scm_t_wind_flags flags);
	alias da_scm_dynwind_rewind_handler_with_scm = void function(void function(SCM) func, SCM data, scm_t_wind_flags flags);
	alias da_scm_dynwind_free = void function(void * mem);

	//6.13.11 How to Handle Errors
	alias da_scm_display_error = SCM function(SCM frame, SCM port, SCM subr, SCM message, SCM args, SCM rest);

	//6.13.11.1 C Support
	alias da_scm_error = SCM function(SCM key, char * subr, char * message, SCM args, SCM rest);
	alias da_scm_syserror = void function(char * subr);
	alias da_scm_syserror_msg = void function(char * subr, char * message, SCM args);
	alias da_scm_num_overflow = void function(char * subr);
	alias da_scm_out_of_range = void function(char * subr, SCM bad_value);
	alias da_scm_wrong_num_args = void function(SCM proc);
	alias da_scm_wrong_type_arg = void function(char * subr, int argnum, SCM bad_value);
	alias da_scm_wrong_type_arg_msg = void function(char * subr, int argnum, SCM bad_value, const char * expected);
	alias da_scm_memory_error = void function(char * subr);
	alias da_scm_misc_error = void function(const char * subr, const char * message, SCM args);

	//6.13.12 Continuation Barriers
	alias da_scm_with_continuation_barrier = SCM function(SCM proc);
	alias da_scm_c_with_continuation_barrier = void * function(void * function(void *) func, void * data);

	//6.14.1 Ports
	alias da_scm_input_port_p = SCM function(SCM x);
	alias da_scm_output_port_p = SCM function(SCM x);
	alias da_scm_port_p = SCM function(SCM x);
	alias da_scm_set_port_encoding_x = SCM function(SCM port, SCM enc);
	alias da_scm_port_encoding = SCM function(SCM port);
	alias da_scm_set_port_conversion_strategy_x = SCM function(SCM port, SCM sym);
	alias da_scm_port_conversion_strategy = SCM function(SCM port);

	//6.14.2 Reading
	alias da_scm_char_ready_p = SCM function(SCM port);
	alias da_scm_read_char = SCM function(SCM port);
	alias da_scm_c_read = size_t function(SCM port, void * buffer, size_t size);
	alias da_scm_peek_char = SCM function(SCM port);
	alias da_scm_unread_char = SCM function(SCM cobj, SCM port);
	alias da_scm_unread_string = SCM function(SCM str, SCM port);
	alias da_scm_drain_input = SCM function(SCM port);
	alias da_scm_port_column = SCM function(SCM port);
	alias da_scm_port_line = SCM function(SCM port);
	alias da_scm_set_port_column_x = SCM function(SCM port, SCM column);
	alias da_scm_set_port_line_x = SCM function(SCM port, SCM line);

	//6.14.3 Writing
	alias da_scm_get_print_state = SCM function(SCM port);
	alias da_scm_newline = SCM function(SCM port);
	alias da_scm_port_with_print_state = SCM function(SCM port, SCM pstate);
	alias da_scm_simple_format = SCM function(SCM destination, SCM message, SCM args);
	alias da_scm_write_char = SCM function(SCM chr, SCM port);
	alias da_scm_c_write = void function(SCM port, const void * buffer, size_t size);
	alias da_scm_force_output = SCM function(SCM port);
	alias da_scm_flush_all_ports = SCM function();

	//6.14.4 Closing
	alias da_scm_close_port = SCM function(SCM port);
	alias da_scm_close_input_port = SCM function(SCM port);
	alias da_scm_close_output_port = SCM function(SCM port);
	alias da_scm_port_closed_p = SCM function(SCM port);

	//6.14.5 Random Access
	alias da_scm_seek = SCM function(SCM fd_port, SCM offset, SCM whence);
	alias da_scm_ftell = SCM function(SCM fd_port);
	alias da_scm_truncate_file = SCM function(SCM file, SCM length);

	//6.14.6 Line Oriented and Delimited Text
	alias da_scm_write_line = SCM function(SCM obj, SCM port);
	alias da_scm_read_delimited_x = SCM function(SCM delims, SCM str, SCM gobble, SCM port, SCM start, SCM end);
	alias da_scm_read_line = SCM function(SCM port);

	//6.14.7 Block reading and writing
	alias da_scm_read_string_x_partial = SCM function(SCM str, SCM port_or_fdes, SCM start, SCM end);
	alias da_scm_write_string_partial = SCM function(SCM str, SCM port_or_fdes, SCM start, SCM end);

	//6.14.8 Default Ports for Input, Output and Errors
	alias da_scm_current_input_port = SCM function();
	alias da_scm_current_output_port = SCM function();
	alias da_scm_current_error_port = SCM function();
	alias da_scm_set_current_input_port = SCM function(SCM port);
	alias da_scm_set_current_output_port = SCM function(SCM port);
	alias da_scm_set_current_error_port = SCM function(SCM port);
	alias da_scm_dynwind_current_input_port = void function(SCM port);
	alias da_scm_dynwind_current_output_port = void function(SCM port);
	alias da_scm_dynwind_current_error_port = void function(SCM port);

	//6.14.9.1 File Ports
	alias da_scm_open_file_with_encoding = SCM function(SCM filename, SCM mode, SCM guess_encoding, SCM encoding);
	alias da_scm_open_file = SCM function(SCM filename, SCM mode);
	alias da_scm_port_mode = SCM function(SCM port);
	alias da_scm_port_filename = SCM function(SCM port);
	alias da_scm_set_port_filename_x = SCM function(SCM port, SCM filename);
	alias da_scm_file_port_p = SCM function(SCM obj);

	//6.14.9.2 String Ports
	alias da_scm_call_with_output_string = SCM function(SCM proc);
	alias da_scm_call_with_input_string = SCM function(SCM str, SCM proc);
	alias da_scm_open_input_string = SCM function(SCM str);
	alias da_scm_open_output_string = SCM function();
	alias da_scm_get_output_string = SCM function(SCM port);

	//6.14.9.3 Soft Ports
	alias da_scm_make_soft_port = SCM function(SCM pv, SCM modes);

	//6.14.9.4 Void Ports
	alias da_scm_sys_make_void_port = SCM function(SCM mode);

	//6.14.10.5 The End-of-File Object
	alias da_scm_eof_object = SCM function();
	alias da_scm_eof_object_p = SCM function(SCM obj);

	//6.14.10.8 Binary Input
	alias da_scm_open_bytevector_input_port = SCM function(SCM bv, SCM transcoder);
	alias da_scm_make_custom_binary_input_port = SCM function(SCM id, SCM read, SCM get_position, SCM set_position, SCM close);
	alias da_scm_get_u8 = SCM function(SCM port);
	alias da_scm_lookahead_u8 = SCM function(SCM port);
	alias da_scm_get_bytevector_n = SCM function(SCM port, SCM count);
	alias da_scm_get_bytevector_n_x = SCM function(SCM port, SCM bv, SCM start, SCM count);
	alias da_scm_get_bytevector_some = SCM function(SCM port);
	alias da_scm_get_bytevector_all = SCM function(SCM port);
	alias da_scm_unget_bytevector = SCM function(SCM port, SCM bv, SCM start, SCM count);

	//6.14.10.11 Binary Output
	alias da_scm_open_bytevector_output_port = SCM function(SCM transcoder);
	alias da_scm_make_custom_binary_output_port = SCM function(SCM id, SCM write, SCM get_position, SCM set_position, SCM close);
	alias da_scm_put_u8 = SCM function(SCM port, SCM octet);
	alias da_scm_put_bytevector = SCM function(SCM port, SCM bv, SCM start, SCM count);

	//6.15.1 Regexp Functions
	alias da_scm_make_regexp = SCM function(SCM pat, SCM flaglst);
	alias da_scm_regexp_exec = SCM function(SCM rx, SCM str, SCM start, SCM flags);
	alias da_scm_regexp_p = SCM function(SCM obj);

	//6.17.1.6 Reader Extensions
	alias da_scm_read_hash_extend = SCM function(SCM chr, SCM proc);

	//6.17.2 Reading Scheme Code
	alias da_scm_read = SCM function(SCM port);

	//6.17.4 Procedures for On the Fly Evaluation
	alias da_scm_eval = SCM function(SCM exp, SCM module_or_state);
	alias da_scm_interaction_environment = SCM function();
	alias da_scm_eval_string = SCM function(SCM string);
	alias da_scm_eval_string_in_module = SCM function(SCM string, SCM modle);
	alias da_scm_c_eval_string = SCM function(const char * string);
	alias da_scm_apply_0 = SCM function(SCM proc, SCM arglst);
	alias da_scm_apply_1 = SCM function(SCM proc, SCM arg1, SCM arglst);
	alias da_scm_apply_2 = SCM function(SCM proc, SCM arg1, SCM arg2, SCM arglst);
	alias da_scm_apply_3 = SCM function(SCM proc, SCM arg1, SCM arg2, SCM arg3, SCM arglst);
	alias da_scm_apply = SCM function(SCM proc, SCM arg, SCM rest);
	alias da_scm_call_0 = SCM function(SCM proc);
	alias da_scm_call_1 = SCM function(SCM proc, SCM arg1);
	alias da_scm_call_2 = SCM function(SCM proc, SCM arg1, SCM arg2);
	alias da_scm_call_3 = SCM function(SCM proc, SCM arg1, SCM arg2, SCM arg3);
	alias da_scm_call_4 = SCM function(SCM proc, SCM arg1, SCM arg2, SCM arg3, SCM arg4);
	alias da_scm_call_5 = SCM function(SCM proc, SCM arg1, SCM arg2, SCM arg3, SCM arg4, SCM arg5);
	alias da_scm_call_6 = SCM function(SCM proc, SCM arg1, SCM arg2, SCM arg3, SCM arg4, SCM arg5, SCM arg6);
	alias da_scm_call_7 = SCM function(SCM proc, SCM arg1, SCM arg2, SCM arg3, SCM arg4, SCM arg5, SCM arg6, SCM arg7);
	alias da_scm_call_8 = SCM function(SCM proc, SCM arg1, SCM arg2, SCM arg3, SCM arg4, SCM arg5, SCM arg6, SCM arg7, SCM arg8);
	alias da_scm_call_9 = SCM function(SCM proc, SCM arg1, SCM arg2, SCM arg3, SCM arg4, SCM arg5, SCM arg6, SCM arg7, SCM arg8, SCM arg9);
	alias da_scm_call = SCM function(SCM proc, ...);
	alias da_scm_call_n = SCM function(SCM proc, SCM argv, SCM nargs);
	alias da_scm_nconc2last = SCM function(SCM lst);
	alias da_scm_primitive_eval = SCM function(SCM exp);

	//6.17.6 Loading Scheme Code from File
	alias da_scm_primitive_load = SCM function(SCM filename);
	alias da_scm_c_primitive_load = SCM function(const char * filename);
	alias da_scm_current_load_port = SCM function();

	//6.17.7 Load Paths
	alias da_scm_primitive_load_path = SCM function(SCM filename);
	alias da_scm_sys_search_load_path = SCM function(SCM filename);
	alias da_scm_parse_path = SCM function(SCM path, SCM tail);
	alias da_scm_parse_path_with_ellipsis = SCM function(SCM path, SCM base);
	alias da_scm_search_path = SCM function(SCM path, SCM filename, SCM rest);

	//6.17.8 Character Encoding of Source Files
	alias da_scm_file_encoding = SCM function(SCM port);

	//6.17.9 Delayed Evaluation
	alias da_scm_promise_p = SCM function(SCM obj);
	alias da_scm_force = SCM function(SCM p);

	//6.17.10 Local Evaluation
	alias da_scm_local_eval = SCM function(SCM exp, SCM env);

	//6.18.1 Function related to Garbage Collection
	alias da_scm_gc = SCM function();
	alias da_scm_gc_protect_object = SCM function(SCM obj);
	alias da_scm_gc_unprotect_object = SCM function(SCM obj);
	alias da_scm_permanent_object = SCM function(SCM obj);
	alias da_scm_gc_stats = SCM function();
	alias da_scm_gc_live_object_stats = SCM function();

	//6.18.2 Memory Blocks
	alias da_scm_malloc = void * function(size_t size);
	alias da_scm_calloc = void * function(size_t size);
	alias da_scm_realloc = void * function(void * mem, size_t new_size);
	alias da_scm_gc_malloc = void * function(size_t size, const char * what);
	alias da_scm_gc_malloc_pointerless = void * function(size_t size, const char * what);
	alias da_scm_gc_realloc = void * function(void * mem, size_t old_size, size_t new_size, const char * what);
	alias da_scm_gc_calloc = void * function(size_t size, const char * what);
	alias da_scm_gc_free = void function(void * mem, size_t size, const char * what);
	alias da_scm_gc_register_allocation = void function(size_t size);

	//6.18.3.1 Weak hash tables
	alias da_scm_make_weak_key_hash_table = SCM function(SCM size);
	alias da_scm_make_weak_value_hash_table = SCM function(SCM size);
	alias da_scm_make_doubly_weak_hash_table = SCM function(SCM size);
	alias da_scm_weak_key_hash_table_p = SCM function(SCM obj);
	alias da_scm_weak_value_hash_table_p = SCM function(SCM obj);
	alias da_scm_doubly_weak_hash_table_p = SCM function(SCM obj);

	//6.18.3.2 Weak vectors
	alias da_scm_make_weak_vector = SCM function(SCM size, SCM fill);
	alias da_scm_weak_vector = SCM function(SCM l);
	alias da_scm_weak_vector_p = SCM function(SCM obj);
	alias da_scm_weak_vector_ref = SCM function(SCM wvect, SCM k);
	alias da_scm_weak_vector_set_x = SCM function(SCM wvect, SCM k, SCM elt);

	//6.18.4 Guardians
	alias da_scm_make_guardian = SCM function();

	//6.19.7 Variables
	alias da_scm_make_undefined_variable = SCM function();
	alias da_scm_make_variable = SCM function(SCM init);
	alias da_scm_variable_bound_p = SCM function(SCM var);
	alias da_scm_variable_ref = SCM function(SCM var);
	alias da_scm_variable_set_x = SCM function(SCM var, SCM val);
	alias da_scm_variable_unset_x = SCM function(SCM var);
	alias da_scm_variable_p = SCM function(SCM obj);

	//6.19.8 Module System Reflection
	alias da_scm_current_module = SCM function();
	alias da_scm_set_current_module = SCM function(SCM modle);
	alias da_scm_resolve_module = SCM function(SCM name);

	//6.19.9 Accessing Modules from C
	alias da_scm_c_call_with_current_module = SCM function(SCM modle, SCM function(void *) func, void * data);
	alias da_scm_public_variable = SCM function(SCM module_name, SCM name);
	alias da_scm_c_public_variable = SCM function(const char * module_name, const char * name);
	alias da_scm_private_variable = SCM function(SCM module_name, SCM name);
	alias da_scm_c_private_variable = SCM function(const char * module_name, const char * name);
	alias da_scm_public_lookup = SCM function(SCM module_name, SCM name);
	alias da_scm_c_public_lookup = SCM function(const char * module_name, const char * name);
	alias da_scm_private_lookup = SCM function(SCM module_name, SCM name);
	alias da_scm_c_private_lookup = SCM function(const char * module_name, const char * name);
	alias da_scm_public_ref = SCM function(SCM module_name, SCM name);
	alias da_scm_c_public_ref = SCM function(const char * module_name, const char * name);
	alias da_scm_private_ref = SCM function(SCM module_name, SCM name);
	alias da_scm_c_private_ref = SCM function(const char * module_name, const char * name);
	alias da_scm_c_lookup = SCM function(const char * name);
	alias da_scm_lookup = SCM function(SCM name);
	alias da_scm_c_module_lookup = SCM function(SCM modle, const char * name);
	alias da_scm_module_lookup = SCM function(SCM modle, SCM name);
	alias da_scm_module_variable = SCM function(SCM modle, SCM name);
	alias da_scm_c_module_define = SCM function(SCM modle, const char * name, SCM val);
	alias da_scm_module_define = SCM function(SCM modle, SCM name, SCM val);
	alias da_scm_module_ensure_local_variable = SCM function(SCM modle, SCM sym);
	alias da_scm_module_reverse_lookup = SCM function(SCM modle, SCM variable);
	alias da_scm_c_define_module = SCM function(const char * name, void function(void *) init, void * data);
	alias da_scm_c_resolve_module = SCM function(const char * name);
	alias da_scm_c_use_module = SCM function(const char * name);
	alias da_scm_c_export = SCM function(const char * name, ...);

	//6.20.1 Foreign Libraries
	alias da_scm_dynamic_link = SCM function(SCM library);
	alias da_scm_dynamic_object_p = SCM function(SCM obj);
	alias da_scm_dynamic_unlink = SCM function(SCM dobj);

	//6.20.2 Foreign Functions
	alias da_scm_dynamic_func = SCM function(SCM name, SCM dobj);
	alias da_scm_dynamic_call = SCM function(SCM func, SCM dobj);
	alias da_scm_load_extension = SCM function(SCM lib, SCM init);

	//6.20.5.2 Foreign Variables
	alias da_scm_dynamic_pointer = SCM function(SCM name, SCM dobj);
	alias da_scm_pointer_address = SCM function(SCM pointer);
	alias da_scm_from_pointer = SCM function(void * ptr, void function (void*) finalizer);
	alias da_scm_to_pointer = void* function(SCM obj);

	//6.20.5.3 Void Pointers and Byte Access
	alias da_scm_pointer_to_bytevector = SCM function(SCM pointer, SCM len, SCM offset, SCM uvec_type);
	alias da_scm_bytevector_to_pointer = SCM function(SCM bv, SCM offset);

	//6.20.5.4 Foreign Structs
	alias da_scm_sizeof = SCM function(SCM type);
	alias da_scm_alignof = SCM function(SCM type);

	//6.20.6 Dynamic FFI
	alias da_scm_procedure_to_pointer = SCM function(SCM return_type, SCM proc, SCM arg_types);

	//6.21.1 Arbiters
	alias da_scm_make_arbiter = SCM function(SCM name);
	alias da_scm_try_arbiter = SCM function(SCM arb);
	alias da_scm_release_arbiter = SCM function(SCM arb);

	//6.21.2.1 System asyncs
	alias da_scm_system_async_mark = SCM function(SCM proc);
	alias da_scm_system_async_mark_for_thread = SCM function(SCM proc, SCM thread);
	alias da_scm_call_with_blocked_asyncs = SCM function(SCM proc);
	alias da_scm_c_call_with_blocked_asyncs = void * function(void * function(void * data) proc, void * data);
	alias da_scm_call_with_unblocked_asyncs = SCM function(SCM proc);
	alias da_scm_c_call_with_unblocked_asyncs = void * function(void * function(void * data) proc, void * data);
	alias da_scm_dynwind_block_asyncs = void function();
	alias da_scm_dynwind_unblock_asyncs = void function();

	//6.21.2.2 User asyncs
	alias da_scm_async = SCM function(SCM thunk);
	alias da_scm_async_mark = SCM function(SCM a);
	alias da_scm_run_asyncs = SCM function(SCM list_of_a);

	//6.21.3 Threads
	alias da_scm_all_threads = SCM function();
	alias da_scm_current_thread = SCM function();
	alias da_scm_spawn_thread = SCM function(scm_t_catch_body c_body, void * body_data, scm_t_catch_handler handler, void * handler_data);
	alias da_scm_thread_p = SCM function(SCM obj);
	alias da_scm_join_thread = SCM function(SCM thread);
	alias da_scm_join_thread_timed = SCM function(SCM thread, SCM timeout, SCM timeoutval);
	alias da_scm_thread_exited_p = SCM function(SCM thread);
	alias da_scm_cancel_thread = SCM function(SCM thread);
	alias da_scm_set_thread_cleanup_x = SCM function(SCM thread, SCM proc);
	alias da_scm_thread_cleanup = SCM function(SCM thread);

	//6.21.4 Mutexes and Condition Variables
	alias da_scm_make_mutex = SCM function();
	alias da_scm_make_mutex_with_flags = SCM function(SCM flags);
	alias da_scm_mutex_p = SCM function(SCM obj);
	alias da_scm_lock_mutex = SCM function(SCM mutex);
	alias da_scm_lock_mutex_timed = SCM function(SCM mutex, SCM timeout, SCM owner);
	alias da_scm_dynwind_lock_mutex = void function(SCM mutex);
	alias da_scm_try_mutex = SCM function(SCM mx);
	alias da_scm_unlock_mutex = SCM function(SCM mutex);
	alias da_scm_unlock_mutex_timed = SCM function(SCM mutex, SCM condvar, SCM timeout);
	alias da_scm_mutex_owner = SCM function(SCM mutex);
	alias da_scm_mutex_level = SCM function(SCM mutex);
	alias da_scm_mutex_locked_p = SCM function(SCM mutex);
	alias da_scm_make_condition_variable = SCM function();
	alias da_scm_condition_variable_p = SCM function(SCM obj);
	alias da_scm_wait_condition_variable = SCM function(SCM condvar, SCM mutex, SCM time);
	alias da_scm_signal_condition_variable = SCM function(SCM condvar);
	alias da_scm_broadcast_condition_variable = SCM function(SCM condvar);

	//6.21.5 Blocking in Guile Mode
	/* not included at the moment.
	alias da_scm_without_guile = void * function(void *(*func) (void * ), void * data);
	alias da_scm_pthread_mutex_lock = int function(pthread_mutex_t * mutex);
	alias da_scm_pthread_cond_wait = int function(pthread_cond_t * cond, pthread_mutex_t * mutex);
	alias da_scm_pthread_cond_timedwait = int function(pthread_cond_t * cond, pthread_mutex_t * mutex, struct timespec * abstime);
	alias da_scm_std_select = int function(int nfds, fd_set * readfds, fd_set * writefds, fd_set * exceptfds, struct timeval * timeout);
	alias da_scm_std_sleep = unsigned int function(unsigned int seconds);
	alias da_scm_std_usleep = unsigned long function(unsigned long usecs);
	*/

	//6.21.6 Critical Sections
	alias da_scm_dynwind_critical_section = void function(SCM mutex);

	//6.21.7 Fluids and Dynamic States
	alias da_scm_make_fluid = SCM function();
	alias da_scm_make_fluid_with_default = SCM function(SCM dflt);
	alias da_scm_make_unbound_fluid = SCM function();
	alias da_scm_fluid_p = SCM function(SCM obj);
	alias da_scm_fluid_ref = SCM function(SCM fluid);
	alias da_scm_fluid_set_x = SCM function(SCM fluid, SCM value);
	alias da_scm_fluid_unset_x = SCM function(SCM fluid);
	alias da_scm_fluid_bound_p = SCM function(SCM fluid);
	alias da_scm_with_fluid = SCM function(SCM fluid, SCM value, SCM thunk);
	alias da_scm_with_fluids = SCM function(SCM fluids, SCM values, SCM thunk);
	alias da_scm_c_with_fluids = SCM function(SCM fluids, SCM vals, SCM function(void *) cproc, void * data);
	alias da_scm_c_with_fluid = SCM function(SCM fluid, SCM val, SCM function(void * ) cproc, void * data);
	alias da_scm_dynwind_fluid = void function(SCM fluid, SCM val);
	alias da_scm_make_dynamic_state = SCM function(SCM parent);
	alias da_scm_dynamic_state_p = SCM function(SCM obj);
	alias da_scm_current_dynamic_state = SCM function();
	alias da_scm_set_current_dynamic_state = SCM function(SCM state);
	alias da_scm_with_dynamic_state = SCM function(SCM state, SCM proc);

	//6.22.1 Configuration, Build and Installation
	alias da_scm_version = SCM function();
	alias da_scm_effective_version = SCM function();
	alias da_scm_major_version = SCM function();
	alias da_scm_minor_version = SCM function();
	alias da_scm_micro_version = SCM function();
	alias da_scm_sys_package_data_dir = SCM function();
	alias da_scm_sys_library_dir = SCM function();
	alias da_scm_sys_site_dir = SCM function();
	alias da_scm_sys_site_ccache_dir = SCM function();

	//6.22.2.1 Feature Manipulation
	alias da_scm_add_feature = void function(const char * str);

	//6.24.1 Internationalization with Guile
	alias da_scm_make_locale = SCM function(SCM category_list, SCM locale_name, SCM base_locale);
	alias da_scm_locale_p = SCM function(SCM obj);

	//6.24.2 Text Collation
	alias da_scm_string_locale_lt = SCM function(SCM s1, SCM s2, SCM locale);
	alias da_scm_string_locale_gt = SCM function(SCM s1, SCM s2, SCM locale);
	alias da_scm_string_locale_ci_lt = SCM function(SCM s1, SCM s2, SCM locale);
	alias da_scm_string_locale_ci_gt = SCM function(SCM s1, SCM s2, SCM locale);
	alias da_scm_string_locale_ci_eq = SCM function(SCM s1, SCM s2, SCM locale);
	alias da_scm_char_locale_lt = SCM function(SCM c1, SCM c2, SCM locale);
	alias da_scm_char_locale_gt = SCM function(SCM c1, SCM c2, SCM locale);
	alias da_scm_char_locale_ci_lt = SCM function(SCM c1, SCM c2, SCM locale);
	alias da_scm_char_locale_ci_gt = SCM function(SCM c1, SCM c2, SCM locale);
	alias da_scm_char_locale_ci_eq = SCM function(SCM c1, SCM c2, SCM locale);

	//6.24.3 Character Case Mapping
	alias da_scm_char_locale_upcase = SCM function(SCM chr, SCM locale);
	alias da_scm_char_locale_downcase = SCM function(SCM chr, SCM locale);
	alias da_scm_char_locale_titlecase = SCM function(SCM chr, SCM locale);
	alias da_scm_string_locale_upcase = SCM function(SCM str, SCM locale);
	alias da_scm_string_locale_downcase = SCM function(SCM str, SCM locale);
	alias da_scm_string_locale_titlecase = SCM function(SCM str, SCM locale);

	//6.24.4 Number Input and Output
	alias da_scm_locale_string_to_integer = SCM function(SCM str, SCM base, SCM locale);
	alias da_scm_locale_string_to_inexact = SCM function(SCM str, SCM locale);

	//6.24.6 Gettext Support
	alias da_scm_gettext = SCM function(SCM msg, SCM domain, SCM category);
	alias da_scm_ngettext = SCM function(SCM msg, SCM msgplural, SCM n, SCM domain, SCM category);
	alias da_scm_textdomain = SCM function(SCM domain);
	alias da_scm_bindtextdomain = SCM function(SCM domain, SCM directory);
	alias da_scm_bind_textdomain_codeset = SCM function(SCM domain, SCM encoding);

	//6.25.1.1 Stack Capture
	alias da_scm_make_stack = SCM function(SCM obj, SCM args);

	//6.25.1.2 Stacks
	alias da_scm_stack_p = SCM function(SCM obj);
	alias da_scm_stack_id = SCM function(SCM stack);
	alias da_scm_stack_length = SCM function(SCM stack);
	alias da_scm_stack_ref = SCM function(SCM stack, SCM index);
	alias da_scm_display_backtrace_with_highlights = SCM function(SCM stack, SCM port, SCM first, SCM depth, SCM highlights);
	alias da_scm_display_backtrace = SCM function(SCM stack, SCM port, SCM first, SCM depth);

	//6.25.1.3 Frames
	alias da_scm_frame_p = SCM function(SCM obj);
	alias da_scm_frame_previous = SCM function(SCM frame);
	alias da_scm_frame_procedure = SCM function(SCM frame);
	alias da_scm_frame_arguments = SCM function(SCM frame);
	alias da_scm_display_application = SCM function(SCM frame, SCM port, SCM indent);

	//6.25.2 Source Properties
	alias da_scm_supports_source_properties_p = SCM function(SCM obj);
	alias da_scm_set_source_properties_x = SCM function(SCM obj, SCM alist);
	alias da_scm_set_source_property_x = SCM function(SCM obj, SCM key, SCM datum);
	alias da_scm_source_properties = SCM function(SCM obj);
	alias da_scm_source_property = SCM function(SCM obj, SCM key);
	alias da_scm_cons_source = SCM function(SCM xorig, SCM x, SCM y);

	//6.25.3.3 Pre-Unwind Debugging
	alias da_scm_backtrace_with_highlights = SCM function(SCM highlights);
	alias da_scm_backtrace = SCM function();

	//7.2.2 Ports and File Descriptors
	alias da_scm_port_revealed = SCM function(SCM port);
	alias da_scm_set_port_revealed_x = SCM function(SCM port, SCM rcount);
	alias da_scm_fileno = SCM function(SCM port);
	alias da_scm_fdopen = SCM function(SCM fdes, SCM modes);
	alias da_scm_fdes_to_ports = SCM function(SCM fdes);
	alias da_scm_primitive_move_to_fdes = SCM function(SCM port, SCM fdes);
	alias da_scm_fsync = SCM function(SCM port_or_fd);
	alias da_scm_open = SCM function(SCM path, SCM flags, SCM mode);
	alias da_scm_open_fdes = SCM function(SCM path, SCM flags, SCM mode);
	alias da_scm_close = SCM function(SCM fd_or_port);
	alias da_scm_close_fdes = SCM function(SCM fd);
	alias da_scm_pipe = SCM function();
	alias da_scm_dup_to_fdes = SCM function(SCM fd_or_port, SCM fd);
	alias da_scm_redirect_port = SCM function(SCM old_port, SCM new_port);
	alias da_scm_dup2 = SCM function(SCM oldfd, SCM newfd);
	alias da_scm_port_for_each = SCM function(SCM proc);
	alias da_scm_c_port_for_each = SCM function(void function(void *, SCM SCM) proc, void * data);
	alias da_scm_setvbuf = SCM function(SCM port, SCM mode, SCM size);
	alias da_scm_fcntl = SCM function(SCM object, SCM cmd, SCM value);
	alias da_scm_flock = SCM function(SCM file, SCM operation);
	alias da_scm_select = SCM function(SCM reads, SCM writes, SCM excepts, SCM secs, SCM usecs);

	//7.2.3 File System
	alias da_scm_access = SCM function(SCM path, SCM how);
	alias da_scm_stat = SCM function(SCM object);
	alias da_scm_lstat = SCM function(SCM path);
	alias da_scm_readlink = SCM function(SCM path);
	alias da_scm_chown = SCM function(SCM object, SCM owner, SCM group);
	alias da_scm_chmod = SCM function(SCM object, SCM mode);
	alias da_scm_utime = SCM function(SCM pathname, SCM actime, SCM modtime, SCM actimens, SCM modtimens, SCM flags);
	alias da_scm_delete_file = SCM function(SCM str);
	alias da_scm_copy_file = SCM function(SCM oldfile, SCM newfile);
	alias da_scm_sendfile = SCM function(SCM outf, SCM inf, SCM count, SCM offset);
	alias da_scm_rename = SCM function(SCM oldname, SCM newname);
	alias da_scm_link = SCM function(SCM oldpath, SCM newpath);
	alias da_scm_symlink = SCM function(SCM oldpath, SCM newpath);
	alias da_scm_mkdir = SCM function(SCM path, SCM mode);
	alias da_scm_rmdir = SCM function(SCM path);
	alias da_scm_opendir = SCM function(SCM dirname);
	alias da_scm_directory_stream_p = SCM function(SCM object);
	alias da_scm_readdir = SCM function(SCM stream);
	alias da_scm_rewinddir = SCM function(SCM stream);
	alias da_scm_closedir = SCM function(SCM stream);
	alias da_scm_sync = SCM function();
	alias da_scm_tmpnam = SCM function();
	alias da_scm_mknod = SCM function(SCM path, SCM type, SCM perms, SCM dev);
	alias da_scm_mkstemp = SCM function(SCM tmpl);
	alias da_scm_tmpfile = SCM function();
	alias da_scm_dirname = SCM function(SCM filename);
	alias da_scm_basename = SCM function(SCM filename, SCM suffix);

	//7.2.4 User Information
	alias da_scm_setpwent = SCM function(SCM arg);
	alias da_scm_getpwuid = SCM function(SCM user);
	alias da_scm_setgrent = SCM function(SCM arg);
	alias da_scm_getgrgid = SCM function(SCM group);
	alias da_scm_getlogin = SCM function();

	//7.2.5 Time
	alias da_scm_current_time = SCM function();
	alias da_scm_gettimeofday = SCM function();
	alias da_scm_localtime = SCM function(SCM time, SCM zone);
	alias da_scm_gmtime = SCM function(SCM time);
	alias da_scm_mktime = SCM function(SCM sbd_time, SCM zone);
	alias da_scm_tzset = SCM function();
	alias da_scm_strftime = SCM function(SCM format, SCM tm);
	alias da_scm_strptime = SCM function(SCM format, SCM str);
	alias da_scm_times = SCM function();
	alias da_scm_get_internal_real_time = SCM function();
	alias da_scm_get_internal_run_time = SCM function();

	//7.2.6 Runtime Environment
	alias da_scm_program_arguments = SCM function();
	alias da_scm_set_program_arguments_scm = SCM function(SCM lst);
	alias da_scm_set_program_arguments = void function(int argc, char ** argv, char * first);
	alias da_scm_getenv = SCM function(SCM name);
	alias da_scm_environ = SCM function(SCM env);
	alias da_scm_putenv = SCM function(SCM str);

	//7.2.7 Processes
	alias da_scm_chdir = SCM function(SCM str);
	alias da_scm_getcwd = SCM function();
	alias da_scm_umask = SCM function(SCM mode);
	alias da_scm_chroot = SCM function(SCM path);
	alias da_scm_getpid = SCM function();
	alias da_scm_getgroups = SCM function();
	alias da_scm_getppid = SCM function();
	alias da_scm_getuid = SCM function();
	alias da_scm_getgid = SCM function();
	alias da_scm_geteuid = SCM function();
	alias da_scm_getegid = SCM function();
	alias da_scm_setgroups = SCM function(SCM vec);
	alias da_scm_setuid = SCM function(SCM id);
	alias da_scm_setgid = SCM function(SCM id);
	alias da_scm_seteuid = SCM function(SCM id);
	alias da_scm_setegid = SCM function(SCM id);
	alias da_scm_getpgrp = SCM function();
	alias da_scm_setpgid = SCM function(SCM pid, SCM pgid);
	alias da_scm_setsid = SCM function();
	alias da_scm_getsid = SCM function(SCM pid);
	alias da_scm_waitpid = SCM function(SCM pid, SCM options);
	alias da_scm_status_exit_val = SCM function(SCM status);
	alias da_scm_status_term_sig = SCM function(SCM status);
	alias da_scm_status_stop_sig = SCM function(SCM status);
	alias da_scm_system = SCM function(SCM cmd);
	alias da_scm_system_star = SCM function(SCM args);
	alias da_scm_primitive_exit = SCM function(SCM status);
	alias da_scm_primitive__exit = SCM function(SCM status);
	alias da_scm_execl = SCM function(SCM filename, SCM args);
	alias da_scm_execlp = SCM function(SCM filename, SCM args);
	alias da_scm_execle = SCM function(SCM filename, SCM env, SCM args);
	alias da_scm_fork = SCM function();
	alias da_scm_nice = SCM function(SCM incr);
	alias da_scm_setpriority = SCM function(SCM which, SCM who, SCM prio);
	alias da_scm_getpriority = SCM function(SCM which, SCM who);
	alias da_scm_getaffinity = SCM function(SCM pid);
	alias da_scm_setaffinity = SCM function(SCM pid, SCM mask);
	alias da_scm_total_processor_count = SCM function();
	alias da_scm_current_processor_count = SCM function();

	//7.2.8 Signals
	alias da_scm_kill = SCM function(SCM pid, SCM sig);
	alias da_scm_raise = SCM function(SCM sig);
	alias da_scm_sigaction = SCM function(SCM signum, SCM handler, SCM flags);
	alias da_scm_sigaction_for_thread = SCM function(SCM signum, SCM handler, SCM flags, SCM thread);
	alias da_scm_alarm = SCM function(SCM i);
	alias da_scm_pause = SCM function();
	alias da_scm_sleep = SCM function(SCM secs);
	alias da_scm_usleep = SCM function(SCM usecs);
	alias da_scm_getitimer = SCM function(SCM which_timer);
	alias da_scm_setitimer = SCM function(SCM which_timer, SCM interval_seconds, SCM interval_microseconds, SCM periodic_seconds, SCM periodic_microseconds);

	//7.2.9 Terminals and Ptys
	alias da_scm_isatty_p = SCM function(SCM port);
	alias da_scm_ttyname = SCM function(SCM port);
	alias da_scm_ctermid = SCM function();
	alias da_scm_tcgetpgrp = SCM function(SCM port);
	alias da_scm_tcsetpgrp = SCM function(SCM port, SCM pgid);

	//7.2.11.1 Network Address Conversion
	alias da_scm_inet_aton = SCM function(SCM address);
	alias da_scm_inet_ntoa = SCM function(SCM inetid);
	alias da_scm_inet_netof = SCM function(SCM address);
	alias da_scm_lnaof = SCM function(SCM address);
	alias da_scm_inet_makeaddr = SCM function(SCM net, SCM lna);
	alias da_scm_inet_ntop = SCM function(SCM family, SCM address);
	alias da_scm_inet_pton = SCM function(SCM family, SCM address);

	//7.2.11.2 Network Databases
	alias da_scm_getaddrinfo = SCM function(SCM name, SCM service, SCM hint_flags, SCM hint_family, SCM hint_socktype, SCM hint_protocol);
	alias da_scm_gethost = SCM function(SCM host);
	alias da_scm_sethost = SCM function(SCM stayopen);
	alias da_scm_getnet = SCM function(SCM net);
	alias da_scm_setnet = SCM function(SCM stayopen);
	alias da_scm_getproto = SCM function(SCM protocol);
	alias da_scm_setproto = SCM function(SCM stayopen);
	alias da_scm_getserv = SCM function(SCM name, SCM protocol);
	alias da_scm_setserv = SCM function(SCM stayopen);

	//7.2.11.3 Network Socket Address
	alias da_scm_make_socket_address = SCM function(SCM family, SCM address, SCM arglist);
	alias da_scm_c_make_socket_address = sockaddr * function(SCM family, SCM address, SCM args, size_t * outsize);
	alias da_scm_from_sockaddr = SCM function(const sockaddr * address, uint address_size);
	alias da_scm_to_sockaddr = sockaddr * function(SCM address, size_t * address_size);

	//7.2.11.4 Network Sockets and Communication
	alias da_scm_socket = SCM function(SCM family, SCM style, SCM proto);
	alias da_scm_socketpair = SCM function(SCM family, SCM style, SCM proto);
	alias da_scm_getsockopt = SCM function(SCM sock, SCM level, SCM optname);
	alias da_scm_setsockopt = SCM function(SCM sock, SCM level, SCM optname, SCM value);
	alias da_scm_shutdown = SCM function(SCM sock, SCM how);
	alias da_scm_connect = SCM function(SCM sock, SCM fam, SCM address, SCM args);
	alias da_scm_bind = SCM function(SCM sock, SCM fam, SCM address, SCM args);
	alias da_scm_listen = SCM function(SCM sock, SCM backlog);
	alias da_scm_accept = SCM function(SCM sock);
	alias da_scm_getsockname = SCM function(SCM sock);
	alias da_scm_getpeername = SCM function(SCM sock);
	alias da_scm_recv = SCM function(SCM sock, SCM buf, SCM flags);
	alias da_scm_send = SCM function(SCM sock, SCM message, SCM flags);
	alias da_scm_recvfrom = SCM function(SCM sock, SCM buf, SCM flags, SCM start, SCM end);
	alias da_scm_sendto = SCM function(SCM sock, SCM message, SCM fam, SCM address, SCM args_and_flags);

	//7.2.12 System Identification
	alias da_scm_uname = SCM function();
	alias da_scm_gethostname = SCM function();
	alias da_scm_sethostname = SCM function(SCM name);

	//7.2.13 Locales
	alias da_scm_setlocale = SCM function(SCM category, SCM locale);

	//7.2.14 Encryption
	alias da_scm_crypt = SCM function(SCM key, SCM salt);
	alias da_scm_getpass = SCM function(SCM prompt);

	//7.5.5.2 SRFI-4 - API
	alias da_scm_u8vector_p = SCM function(SCM obj);
	alias da_scm_s8vector_p = SCM function(SCM obj);
	alias da_scm_u16vector_p = SCM function(SCM obj);
	alias da_scm_s16vector_p = SCM function(SCM obj);
	alias da_scm_u32vector_p = SCM function(SCM obj);
	alias da_scm_s32vector_p = SCM function(SCM obj);
	alias da_scm_u64vector_p = SCM function(SCM obj);
	alias da_scm_s64vector_p = SCM function(SCM obj);
	alias da_scm_f32vector_p = SCM function(SCM obj);
	alias da_scm_f64vector_p = SCM function(SCM obj);
	alias da_scm_c32vector_p = SCM function(SCM obj);
	alias da_scm_c64vector_p = SCM function(SCM obj);
	alias da_scm_make_u8vector = SCM function(SCM n, SCM value);
	alias da_scm_make_s8vector = SCM function(SCM n, SCM value);
	alias da_scm_make_u16vector = SCM function(SCM n, SCM value);
	alias da_scm_make_s16vector = SCM function(SCM n, SCM value);
	alias da_scm_make_u32vector = SCM function(SCM n, SCM value);
	alias da_scm_make_s32vector = SCM function(SCM n, SCM value);
	alias da_scm_make_u64vector = SCM function(SCM n, SCM value);
	alias da_scm_make_s64vector = SCM function(SCM n, SCM value);
	alias da_scm_make_f32vector = SCM function(SCM n, SCM value);
	alias da_scm_make_f64vector = SCM function(SCM n, SCM value);
	alias da_scm_make_c32vector = SCM function(SCM n, SCM value);
	alias da_scm_make_c64vector = SCM function(SCM n, SCM value);
	alias da_scm_u8vector = SCM function(SCM values);
	alias da_scm_s8vector = SCM function(SCM values);
	alias da_scm_u16vector = SCM function(SCM values);
	alias da_scm_s16vector = SCM function(SCM values);
	alias da_scm_u32vector = SCM function(SCM values);
	alias da_scm_s32vector = SCM function(SCM values);
	alias da_scm_u64vector = SCM function(SCM values);
	alias da_scm_s64vector = SCM function(SCM values);
	alias da_scm_f32vector = SCM function(SCM values);
	alias da_scm_f64vector = SCM function(SCM values);
	alias da_scm_c32vector = SCM function(SCM values);
	alias da_scm_c64vector = SCM function(SCM values);
	alias da_scm_u8vector_length = SCM function(SCM vec);
	alias da_scm_s8vector_length = SCM function(SCM vec);
	alias da_scm_u16vector_length = SCM function(SCM vec);
	alias da_scm_s16vector_length = SCM function(SCM vec);
	alias da_scm_u32vector_length = SCM function(SCM vec);
	alias da_scm_s32vector_length = SCM function(SCM vec);
	alias da_scm_u64vector_length = SCM function(SCM vec);
	alias da_scm_s64vector_length = SCM function(SCM vec);
	alias da_scm_f32vector_length = SCM function(SCM vec);
	alias da_scm_f64vector_length = SCM function(SCM vec);
	alias da_scm_c32vector_length = SCM function(SCM vec);
	alias da_scm_c64vector_length = SCM function(SCM vec);
	alias da_scm_u8vector_ref = SCM function(SCM vec, SCM i);
	alias da_scm_s8vector_ref = SCM function(SCM vec, SCM i);
	alias da_scm_u16vector_ref = SCM function(SCM vec, SCM i);
	alias da_scm_s16vector_ref = SCM function(SCM vec, SCM i);
	alias da_scm_u32vector_ref = SCM function(SCM vec, SCM i);
	alias da_scm_s32vector_ref = SCM function(SCM vec, SCM i);
	alias da_scm_u64vector_ref = SCM function(SCM vec, SCM i);
	alias da_scm_s64vector_ref = SCM function(SCM vec, SCM i);
	alias da_scm_f32vector_ref = SCM function(SCM vec, SCM i);
	alias da_scm_f64vector_ref = SCM function(SCM vec, SCM i);
	alias da_scm_c32vector_ref = SCM function(SCM vec, SCM i);
	alias da_scm_c64vector_ref = SCM function(SCM vec, SCM i);
	alias da_scm_u8vector_set_x = SCM function(SCM vec, SCM i, SCM value);
	alias da_scm_s8vector_set_x = SCM function(SCM vec, SCM i, SCM value);
	alias da_scm_u16vector_set_x = SCM function(SCM vec, SCM i, SCM value);
	alias da_scm_s16vector_set_x = SCM function(SCM vec, SCM i, SCM value);
	alias da_scm_u32vector_set_x = SCM function(SCM vec, SCM i, SCM value);
	alias da_scm_s32vector_set_x = SCM function(SCM vec, SCM i, SCM value);
	alias da_scm_u64vector_set_x = SCM function(SCM vec, SCM i, SCM value);
	alias da_scm_s64vector_set_x = SCM function(SCM vec, SCM i, SCM value);
	alias da_scm_f32vector_set_x = SCM function(SCM vec, SCM i, SCM value);
	alias da_scm_f64vector_set_x = SCM function(SCM vec, SCM i, SCM value);
	alias da_scm_c32vector_set_x = SCM function(SCM vec, SCM i, SCM value);
	alias da_scm_c64vector_set_x = SCM function(SCM vec, SCM i, SCM value);
	alias da_scm_u8vector_to_list = SCM function(SCM vec);
	alias da_scm_s8vector_to_list = SCM function(SCM vec);
	alias da_scm_u16vector_to_list = SCM function(SCM vec);
	alias da_scm_s16vector_to_list = SCM function(SCM vec);
	alias da_scm_u32vector_to_list = SCM function(SCM vec);
	alias da_scm_s32vector_to_list = SCM function(SCM vec);
	alias da_scm_u64vector_to_list = SCM function(SCM vec);
	alias da_scm_s64vector_to_list = SCM function(SCM vec);
	alias da_scm_f32vector_to_list = SCM function(SCM vec);
	alias da_scm_f64vector_to_list = SCM function(SCM vec);
	alias da_scm_c32vector_to_list = SCM function(SCM vec);
	alias da_scm_c64vector_to_list = SCM function(SCM vec);
	alias da_scm_list_to_u8vector = SCM function(SCM lst);
	alias da_scm_list_to_s8vector = SCM function(SCM lst);
	alias da_scm_list_to_u16vector = SCM function(SCM lst);
	alias da_scm_list_to_s16vector = SCM function(SCM lst);
	alias da_scm_list_to_u32vector = SCM function(SCM lst);
	alias da_scm_list_to_s32vector = SCM function(SCM lst);
	alias da_scm_list_to_u64vector = SCM function(SCM lst);
	alias da_scm_list_to_s64vector = SCM function(SCM lst);
	alias da_scm_list_to_f32vector = SCM function(SCM lst);
	alias da_scm_list_to_f64vector = SCM function(SCM lst);
	alias da_scm_list_to_c32vector = SCM function(SCM lst);
	alias da_scm_list_to_c64vector = SCM function(SCM lst);
	alias da_scm_take_u8vector = SCM function(const scm_t_uint8 * data, size_t len);
	alias da_scm_take_s8vector = SCM function(const scm_t_int8 * data, size_t len);
	alias da_scm_take_u16vector = SCM function(const scm_t_uint16 * data, size_t len);
	alias da_scm_take_s16vector = SCM function(const scm_t_int16 * data, size_t len);
	alias da_scm_take_u32vector = SCM function(const scm_t_uint32 * data, size_t len);
	alias da_scm_take_s32vector = SCM function(const scm_t_int32 * data, size_t len);
	alias da_scm_take_u64vector = SCM function(const scm_t_uint64 * data, size_t len);
	alias da_scm_take_s64vector = SCM function(const scm_t_int64 * data, size_t len);
	alias da_scm_take_f32vector = SCM function(const float * data, size_t len);
	alias da_scm_take_f64vector = SCM function(const double * data, size_t len);
	alias da_scm_take_c32vector = SCM function(const float * data, size_t len);
	alias da_scm_take_c64vector = SCM function(const double * data, size_t len);
	alias da_scm_u8vector_elements = const scm_t_uint8 * function(SCM vec, scm_t_array_handle * handle, size_t * lenp, ssize_t * incp);
	alias da_scm_s8vector_elements = const scm_t_int8 * function(SCM vec, scm_t_array_handle * handle, size_t * lenp, ssize_t * incp);
	alias da_scm_u16vector_elements = const scm_t_uint16 * function(SCM vec, scm_t_array_handle * handle, size_t * lenp, ssize_t * incp);
	alias da_scm_s16vector_elements = const scm_t_int16 * function(SCM vec, scm_t_array_handle * handle, size_t * lenp, ssize_t * incp);
	alias da_scm_u32vector_elements = const scm_t_uint32 * function(SCM vec, scm_t_array_handle * handle, size_t * lenp, ssize_t * incp);
	alias da_scm_s32vector_elements = const scm_t_int32 * function(SCM vec, scm_t_array_handle * handle, size_t * lenp, ssize_t * incp);
	alias da_scm_u64vector_elements = const scm_t_uint64 * function(SCM vec, scm_t_array_handle * handle, size_t * lenp, ssize_t * incp);
	alias da_scm_s64vector_elements = const scm_t_int64 * function(SCM vec, scm_t_array_handle * handle, size_t * lenp, ssize_t * incp);
	alias da_scm_f32vector_elements = const float * function(SCM vec, scm_t_array_handle * handle, size_t * lenp, ssize_t * incp);
	alias da_scm_f64vector_elements = const double * function(SCM vec, scm_t_array_handle * handle, size_t * lenp, ssize_t * incp);
	alias da_scm_c32vector_elements = const float * function(SCM vec, scm_t_array_handle * handle, size_t * lenp, ssize_t * incp);
	alias da_scm_c64vector_elements = const double * function(SCM vec, scm_t_array_handle * handle, size_t * lenp, ssize_t * incp);
	alias da_scm_u8vector_writable_elements = scm_t_uint8 * function(SCM vec, scm_t_array_handle * handle, size_t * lenp, ssize_t * incp);
	alias da_scm_s8vector_writable_elements = scm_t_int8 * function(SCM vec, scm_t_array_handle * handle, size_t * lenp, ssize_t * incp);
	alias da_scm_u16vector_writable_elements = scm_t_uint16 * function(SCM vec, scm_t_array_handle * handle, size_t * lenp, ssize_t * incp);
	alias da_scm_s16vector_writable_elements = scm_t_int16 * function(SCM vec, scm_t_array_handle * handle, size_t * lenp, ssize_t * incp);
	alias da_scm_u32vector_writable_elements = scm_t_uint32 * function(SCM vec, scm_t_array_handle * handle, size_t * lenp, ssize_t * incp);
	alias da_scm_s32vector_writable_elements = scm_t_int32 * function(SCM vec, scm_t_array_handle * handle, size_t * lenp, ssize_t * incp);
	alias da_scm_u64vector_writable_elements = scm_t_uint64 * function(SCM vec, scm_t_array_handle * handle, size_t * lenp, ssize_t * incp);
	alias da_scm_s64vector_writable_elements = scm_t_int64 * function(SCM vec, scm_t_array_handle * handle, size_t * lenp, ssize_t * incp);
	alias da_scm_f32vector_writable_elements = float * function(SCM vec, scm_t_array_handle * handle, size_t * lenp, ssize_t * incp);
	alias da_scm_f64vector_writable_elements = double * function(SCM vec, scm_t_array_handle * handle, size_t * lenp, ssize_t * incp);
	alias da_scm_c32vector_writable_elements = float * function(SCM vec, scm_t_array_handle * handle, size_t * lenp, ssize_t * incp);
	alias da_scm_c64vector_writable_elements = double * function(SCM vec, scm_t_array_handle * handle, size_t * lenp, ssize_t * incp);

	//7.5.5.4 SRFI-4 - Guile extensions
	alias da_scm_any_to_u8vector = SCM function(SCM obj);
	alias da_scm_any_to_s8vector = SCM function(SCM obj);
	alias da_scm_any_to_u16vector = SCM function(SCM obj);
	alias da_scm_any_to_s16vector = SCM function(SCM obj);
	alias da_scm_any_to_u32vector = SCM function(SCM obj);
	alias da_scm_any_to_s32vector = SCM function(SCM obj);
	alias da_scm_any_to_u64vector = SCM function(SCM obj);
	alias da_scm_any_to_s64vector = SCM function(SCM obj);
	alias da_scm_any_to_f32vector = SCM function(SCM obj);
	alias da_scm_any_to_f64vector = SCM function(SCM obj);
	alias da_scm_any_to_c32vector = SCM function(SCM obj);
	alias da_scm_any_to_c64vector = SCM function(SCM obj);

	//9.4.6 Bytecode and Objcode
	alias da_scm_objcode_p = SCM function(SCM obj);
	alias da_scm_bytecode_to_objcode = SCM function(SCM bytecode);
	alias da_scm_load_objcode = SCM function(SCM file);
	alias da_scm_write_objcode = SCM function(SCM objcode);
	alias da_scm_objcode_to_bytecode = SCM function(SCM objcode);
	alias da_scm_make_program = SCM function(SCM objcode, SCM objtable, SCM free_vars);

}

__gshared {

	//6.4 Initializing Guile
	da_scm_with_guile scm_with_guile;
	da_scm_init_guile scm_init_guile;
	da_scm_boot_guile scm_boot_guile;
	da_scm_shell scm_shell;

	//6.6.1 Booleans
	da_scm_not scm_not;
	da_scm_boolean_p scm_boolean_p;
	da_scm_is_bool scm_is_bool;
	da_scm_to_bool scm_to_bool;

	//6.6.2.1 Scheme’s Numerical “Tower”
	da_scm_number_p scm_number_p;
	da_scm_is_number scm_is_number;

	//6.6.2.2 Integers
	da_scm_integer_p scm_integer_p;
	da_scm_is_integer scm_is_integer;
	da_scm_exact_integer_p scm_exact_integer_p;
	da_scm_is_exact_integer scm_is_exact_integer;
	da_scm_is_signed_integer scm_is_signed_integer;
	da_scm_is_unsigned_integer scm_is_unsigned_integer;
	da_scm_to_signed_integer scm_to_signed_integer;
	da_scm_to_unsigned_integer scm_to_unsigned_integer;
	da_scm_from_signed_integer scm_from_signed_integer;
	da_scm_from_unsigned_integer scm_from_unsigned_integer;
	da_scm_to_int8 scm_to_int8;
	da_scm_to_uint8 scm_to_uint8;
	da_scm_to_int16 scm_to_int16;
	da_scm_to_uint16 scm_to_uint16;
	da_scm_to_int32 scm_to_int32;
	da_scm_to_uint32 scm_to_uint32;
	da_scm_to_int64 scm_to_int64;
	da_scm_to_uint64 scm_to_uint64;
	da_scm_from_int8 scm_from_int8;
	da_scm_from_uint8 scm_from_uint8;
	da_scm_from_int16 scm_from_int16;
	da_scm_from_uint16 scm_from_uint16;
	da_scm_from_int32 scm_from_int32;
	da_scm_from_uint32 scm_from_uint32;
	da_scm_from_int64 scm_from_int64;
	da_scm_from_uint64 scm_from_uint64;

	/* excluded for now 
	da_scm_to_mpz scm_to_mpz;
	da_scm_from_mpz scm_from_mpz;
	*/

	//6.6.2.3 Real and Rational Numbers
	da_scm_real_p scm_real_p;
	da_scm_rational_p scm_rational_p;
	da_scm_rationalize scm_rationalize;
	da_scm_inf_p scm_inf_p;
	da_scm_nan_p scm_nan_p;
	da_scm_finite_p scm_finite_p;
	da_scm_nan scm_nan;
	da_scm_inf scm_inf;
	da_scm_numerator scm_numerator;
	da_scm_denominator scm_denominator;
	da_scm_is_real scm_is_real;
	da_scm_is_rational scm_is_rational;
	da_scm_to_double scm_to_double;
	da_scm_from_double scm_from_double;

	//6.6.2.4 Complex Numbers
	da_scm_complex_p scm_complex_p;
	da_scm_is_complex scm_is_complex;

	//6.6.2.5 Exact and Inexact Numbers
	da_scm_exact_p scm_exact_p;
	da_scm_is_exact scm_is_exact;
	da_scm_inexact_p scm_inexact_p;
	da_scm_is_inexact scm_is_inexact;
	da_scm_inexact_to_exact scm_inexact_to_exact;
	da_scm_exact_to_inexact scm_exact_to_inexact;

	//6.6.2.7 Operations on Integer Values
	da_scm_odd_p scm_odd_p;
	da_scm_even_p scm_even_p;
	da_scm_quotient scm_quotient;
	da_scm_remainder scm_remainder;
	da_scm_modulo scm_modulo;
	da_scm_gcd scm_gcd;
	da_scm_lcm scm_lcm;
	da_scm_modulo_expt scm_modulo_expt;
	da_scm_exact_integer_sqrt scm_exact_integer_sqrt;

	//6.6.2.8 Comparison Predicates
	da_scm_num_eq_p scm_num_eq_p;
	da_scm_less_p scm_less_p;
	da_scm_gr_p scm_gr_p;
	da_scm_leq_p scm_leq_p;
	da_scm_geq_p scm_geq_p;
	da_scm_zero_p scm_zero_p;
	da_scm_positive_p scm_positive_p;
	da_scm_negative_p scm_negative_p;

	//6.6.2.9 Converting Numbers To and From Strings
	da_scm_number_to_string scm_number_to_string;
	da_scm_string_to_number scm_string_to_number;
	da_scm_c_locale_stringn_to_number scm_c_locale_stringn_to_number;

	//6.6.2.10 Complex Number Operations
	da_scm_make_rectangular scm_make_rectangular;
	da_scm_make_polar scm_make_polar;
	da_scm_real_part scm_real_part;
	da_scm_imag_part scm_imag_part;
	da_scm_magnitude scm_magnitude;
	da_scm_angle scm_angle;
	da_scm_c_make_rectangular scm_c_make_rectangular;
	da_scm_c_make_polar scm_c_make_polar;
	da_scm_c_real_part scm_c_real_part;
	da_scm_c_imag_part scm_c_imag_part;
	da_scm_c_magnitude scm_c_magnitude;
	da_scm_c_angle scm_c_angle;

	//6.6.2.11 Arithmetic Functions
	da_scm_sum scm_sum;
	da_scm_difference scm_difference;
	da_scm_product scm_product;
	da_scm_divide scm_divide;
	da_scm_oneplus scm_oneplus;
	da_scm_abs scm_abs;
	da_scm_max scm_max;
	da_scm_min scm_min;
	da_scm_truncate_number scm_truncate_number;
	da_scm_round_number scm_round_number;
	da_scm_floor scm_floor;
	da_scm_ceiling scm_ceiling;
	da_scm_c_truncate scm_c_truncate;
	da_scm_c_round scm_c_round;
	da_scm_euclidean_divide scm_euclidean_divide;
	da_scm_euclidean_quotient scm_euclidean_quotient;
	da_scm_euclidean_remainder scm_euclidean_remainder;
	da_scm_floor_divide scm_floor_divide;
	da_scm_floor_quotient scm_floor_quotient;
	da_scm_floor_remainder scm_floor_remainder;
	da_scm_ceiling_divide scm_ceiling_divide;
	da_scm_ceiling_quotient scm_ceiling_quotient;
	da_scm_ceiling_remainder scm_ceiling_remainder;
	da_scm_truncate_divide scm_truncate_divide;
	da_scm_truncate_quotient scm_truncate_quotient;
	da_scm_truncate_remainder scm_truncate_remainder;
	da_scm_centered_divide scm_centered_divide;
	da_scm_centered_quotient scm_centered_quotient;
	da_scm_centered_remainder scm_centered_remainder;
	da_scm_round_divide scm_round_divide;
	da_scm_round_quotient scm_round_quotient;
	da_scm_round_remainder scm_round_remainder;

	//6.6.2.13 Bitwise Operations
	da_scm_logand scm_logand;
	da_scm_logior scm_logior;
	da_scm_logxor scm_logxor;
	da_scm_lognot scm_lognot;
	da_scm_logtest scm_logtest;
	da_scm_logbit_p scm_logbit_p;
	da_scm_ash scm_ash;
	da_scm_round_ash scm_round_ash;
	da_scm_logcount scm_logcount;
	da_scm_integer_length scm_integer_length;
	da_scm_integer_expt scm_integer_expt;
	da_scm_bit_extract scm_bit_extract;

	//6.6.2.14 Random Number Generation
	da_scm_copy_random_state scm_copy_random_state;
	da_scm_random scm_random;
	da_scm_random_exp scm_random_exp;
	da_scm_random_hollow_sphere_x scm_random_hollow_sphere_x;
	da_scm_random_normal scm_random_normal;
	da_scm_random_normal_vector_x scm_random_normal_vector_x;
	da_scm_random_solid_sphere_x scm_random_solid_sphere_x;
	da_scm_random_uniform scm_random_uniform;
	da_scm_seed_to_random_state scm_seed_to_random_state;
	da_scm_datum_to_random_state scm_datum_to_random_state;
	da_scm_random_state_to_datum scm_random_state_to_datum;
	da_scm_random_state_from_platform scm_random_state_from_platform;

	//6.6.3 Characters
	da_scm_char_p scm_char_p;
	da_scm_char_alphabetic_p scm_char_alphabetic_p;
	da_scm_char_numeric_p scm_char_numeric_p;
	da_scm_char_whitespace_p scm_char_whitespace_p;
	da_scm_char_upper_case_p scm_char_upper_case_p;
	da_scm_char_lower_case_p scm_char_lower_case_p;
	da_scm_char_is_both_p scm_char_is_both_p;
	da_scm_char_general_category scm_char_general_category;
	da_scm_char_to_integer scm_char_to_integer;
	da_scm_integer_to_char scm_integer_to_char;
	da_scm_char_upcase scm_char_upcase;
	da_scm_char_downcase scm_char_downcase;
	da_scm_char_titlecase scm_char_titlecase;
	da_scm_c_upcase scm_c_upcase;
	da_scm_c_downcase scm_c_downcase;
	da_scm_c_titlecase scm_c_titlecase;

	//6.6.4.1 Character Set Predicates/Comparison
	da_scm_char_set_p scm_char_set_p;
	da_scm_char_set_eq scm_char_set_eq;
	da_scm_char_set_leq scm_char_set_leq;
	da_scm_char_set_hash scm_char_set_hash;

	//6.6.4.2 Iterating Over Character Sets
	da_scm_char_set_cursor scm_char_set_cursor;
	da_scm_char_set_ref scm_char_set_ref;
	da_scm_char_set_cursor_next scm_char_set_cursor_next;
	da_scm_end_of_char_set_p scm_end_of_char_set_p;
	da_scm_char_set_fold scm_char_set_fold;
	da_scm_char_set_unfold scm_char_set_unfold;
	da_scm_char_set_unfold_x scm_char_set_unfold_x;
	da_scm_char_set_for_each scm_char_set_for_each;
	da_scm_char_set_map scm_char_set_map;

	//6.6.4.3 Creating Character Sets
	da_scm_char_set_copy scm_char_set_copy;
	da_scm_char_set scm_char_set;
	da_scm_list_to_char_set scm_list_to_char_set;
	da_scm_list_to_char_set_x scm_list_to_char_set_x;
	da_scm_string_to_char_set scm_string_to_char_set;
	da_scm_string_to_char_set_x scm_string_to_char_set_x;
	da_scm_char_set_filter scm_char_set_filter;
	da_scm_char_set_filter_x scm_char_set_filter_x;
	da_scm_ucs_range_to_char_set scm_ucs_range_to_char_set;
	da_scm_ucs_range_to_char_set_x scm_ucs_range_to_char_set_x;
	da_scm_to_char_set scm_to_char_set;

	//6.6.4.4 Querying Character Sets
	da_scm_char_set_size scm_char_set_size;
	da_scm_char_set_count scm_char_set_count;
	da_scm_char_set_to_list scm_char_set_to_list;
	da_scm_char_set_to_string scm_char_set_to_string;
	da_scm_char_set_contains_p scm_char_set_contains_p;
	da_scm_char_set_every scm_char_set_every;
	da_scm_char_set_any scm_char_set_any;

	//6.6.4.5 Character-Set Algebra
	da_scm_char_set_adjoin scm_char_set_adjoin;
	da_scm_char_set_delete scm_char_set_delete;
	da_scm_char_set_adjoin_x scm_char_set_adjoin_x;
	da_scm_char_set_delete_x scm_char_set_delete_x;
	da_scm_char_set_complement scm_char_set_complement;
	da_scm_char_set_union scm_char_set_union;
	da_scm_char_set_intersection scm_char_set_intersection;
	da_scm_char_set_difference scm_char_set_difference;
	da_scm_char_set_xor scm_char_set_xor;
	da_scm_char_set_diff_plus_intersection scm_char_set_diff_plus_intersection;
	da_scm_char_set_complement_x scm_char_set_complement_x;
	da_scm_char_set_union_x scm_char_set_union_x;
	da_scm_char_set_intersection_x scm_char_set_intersection_x;
	da_scm_char_set_difference_x scm_char_set_difference_x;
	da_scm_char_set_xor_x scm_char_set_xor_x;
	da_scm_char_set_diff_plus_intersection_x scm_char_set_diff_plus_intersection_x;

	//6.6.5.2 String Predicates
	da_scm_string_p scm_string_p;
	da_scm_is_string scm_is_string;
	da_scm_string_null_p scm_string_null_p;
	da_scm_string_any scm_string_any;
	da_scm_string_every scm_string_every;

	//6.6.5.3 String Constructors
	da_scm_string scm_string;
	da_scm_reverse_list_to_string scm_reverse_list_to_string;
	da_scm_make_string scm_make_string;
	da_scm_c_make_string scm_c_make_string;
	da_scm_string_tabulate scm_string_tabulate;
	da_scm_string_join scm_string_join;

	//6.6.5.4 List/String conversion
	da_scm_substring_to_list scm_substring_to_list;
	da_scm_string_to_list scm_string_to_list;
	da_scm_string_split scm_string_split;

	//6.6.5.5 String Selection
	da_scm_string_length scm_string_length;
	da_scm_c_string_length scm_c_string_length;
	da_scm_string_ref scm_string_ref;
	da_scm_c_string_ref scm_c_string_ref;
	da_scm_substring_copy scm_substring_copy;
	da_scm_substring scm_substring;
	da_scm_substring_shared scm_substring_shared;
	da_scm_substring_read_only scm_substring_read_only;
	da_scm_c_substring scm_c_substring;
	da_scm_c_substring_shared scm_c_substring_shared;
	da_scm_c_substring_copy scm_c_substring_copy;
	da_scm_c_substring_read_only scm_c_substring_read_only;
	da_scm_string_take scm_string_take;
	da_scm_string_drop scm_string_drop;
	da_scm_string_take_right scm_string_take_right;
	da_scm_string_drop_right scm_string_drop_right;
	da_scm_string_pad scm_string_pad;
	da_scm_string_pad_right scm_string_pad_right;
	da_scm_string_trim scm_string_trim;
	da_scm_string_trim_right scm_string_trim_right;
	da_scm_string_trim_both scm_string_trim_both;

	//6.6.5.6 String Modification
	da_scm_string_set_x scm_string_set_x;
	da_scm_c_string_set_x scm_c_string_set_x;
	da_scm_substring_fill_x scm_substring_fill_x;
	da_scm_string_fill_x scm_string_fill_x;
	da_scm_substring_move_x scm_substring_move_x;
	da_scm_string_copy_x scm_string_copy_x;
	da_scm_string_copy scm_string_copy;

	//6.6.5.7 String Comparison
	da_scm_string_compare scm_string_compare;
	da_scm_string_compare_ci scm_string_compare_ci;
	da_scm_string_eq scm_string_eq;
	da_scm_string_neq scm_string_neq;
	da_scm_string_lt scm_string_lt;
	da_scm_string_gt scm_string_gt;
	da_scm_string_le scm_string_le;
	da_scm_string_ge scm_string_ge;
	da_scm_string_ci_eq scm_string_ci_eq;
	da_scm_string_ci_neq scm_string_ci_neq;
	da_scm_string_ci_lt scm_string_ci_lt;
	da_scm_string_ci_gt scm_string_ci_gt;
	da_scm_string_ci_le scm_string_ci_le;
	da_scm_string_ci_ge scm_string_ci_ge;
	da_scm_substring_hash scm_substring_hash;
	da_scm_substring_hash_ci scm_substring_hash_ci;
	da_scm_string_normalize_nfd scm_string_normalize_nfd;
	da_scm_string_normalize_nfkd scm_string_normalize_nfkd;
	da_scm_string_normalize_nfc scm_string_normalize_nfc;
	da_scm_string_normalize_nfkc scm_string_normalize_nfkc;

	//6.6.5.8 String Searching
	da_scm_string_index scm_string_index;
	da_scm_string_rindex scm_string_rindex;
	da_scm_string_prefix_length scm_string_prefix_length;
	da_scm_string_prefix_length_ci scm_string_prefix_length_ci;
	da_scm_string_suffix_length scm_string_suffix_length;
	da_scm_string_suffix_length_ci scm_string_suffix_length_ci;
	da_scm_string_prefix_p scm_string_prefix_p;
	da_scm_string_prefix_ci_p scm_string_prefix_ci_p;
	da_scm_string_suffix_p scm_string_suffix_p;
	da_scm_string_suffix_ci_p scm_string_suffix_ci_p;
	da_scm_string_index_right scm_string_index_right;
	da_scm_string_skip scm_string_skip;
	da_scm_string_skip_right scm_string_skip_right;
	da_scm_string_count scm_string_count;
	da_scm_string_contains scm_string_contains;
	da_scm_string_contains_ci scm_string_contains_ci;

	//6.6.5.9 Alphabetic Case Mapping
	da_scm_substring_upcase scm_substring_upcase;
	da_scm_string_upcase scm_string_upcase;
	da_scm_substring_upcase_x scm_substring_upcase_x;
	da_scm_string_upcase_x scm_string_upcase_x;
	da_scm_substring_downcase scm_substring_downcase;
	da_scm_string_downcase scm_string_downcase;
	da_scm_substring_downcase_x scm_substring_downcase_x;
	da_scm_string_downcase_x scm_string_downcase_x;
	da_scm_string_capitalize scm_string_capitalize;
	da_scm_string_capitalize_x scm_string_capitalize_x;
	da_scm_string_titlecase scm_string_titlecase;
	da_scm_string_titlecase_x scm_string_titlecase_x;

	//6.6.5.10 Reversing and Appending Strings
	da_scm_string_reverse scm_string_reverse;
	da_scm_string_reverse_x scm_string_reverse_x;
	da_scm_string_append scm_string_append;
	da_scm_string_append_shared scm_string_append_shared;
	da_scm_string_concatenate scm_string_concatenate;
	da_scm_string_concatenate_reverse scm_string_concatenate_reverse;
	da_scm_string_concatenate_shared scm_string_concatenate_shared;
	da_scm_string_concatenate_reverse_shared scm_string_concatenate_reverse_shared;

	//6.6.5.11 Mapping, Folding, and Unfolding
	da_scm_string_map scm_string_map;
	da_scm_string_map_x scm_string_map_x;
	da_scm_string_for_each scm_string_for_each;
	da_scm_string_for_each_index scm_string_for_each_index;
	da_scm_string_fold scm_string_fold;
	da_scm_string_fold_right scm_string_fold_right;
	da_scm_string_unfold scm_string_unfold;
	da_scm_string_unfold_right scm_string_unfold_right;

	//6.6.5.12 Miscellaneous String Operations
	da_scm_xsubstring scm_xsubstring;
	da_scm_string_xcopy_x scm_string_xcopy_x;
	da_scm_string_replace scm_string_replace;
	da_scm_string_tokenize scm_string_tokenize;
	da_scm_string_filter scm_string_filter;
	da_scm_string_delete scm_string_delete;

	//6.6.5.14 Conversion to/from C
	da_scm_from_locale_string scm_from_locale_string;
	da_scm_from_locale_stringn scm_from_locale_stringn;
	da_scm_take_locale_string scm_take_locale_string;
	da_scm_take_locale_stringn scm_take_locale_stringn;
	da_scm_to_locale_string scm_to_locale_string;
	da_scm_to_locale_stringn scm_to_locale_stringn;
	da_scm_to_locale_stringbuf scm_to_locale_stringbuf;
	da_scm_to_stringn scm_to_stringn;
	da_scm_from_stringn scm_from_stringn;
	da_scm_from_latin1_string scm_from_latin1_string;
	da_scm_from_utf8_string scm_from_utf8_string;
	da_scm_from_utf32_string scm_from_utf32_string;
	da_scm_from_latin1_stringn scm_from_latin1_stringn;
	da_scm_from_utf8_stringn scm_from_utf8_stringn;
	da_scm_from_utf32_stringn scm_from_utf32_stringn;

	//6.6.5.15 String Internals
	da_scm_string_bytes_per_char scm_string_bytes_per_char;
	da_scm_sys_string_dump scm_sys_string_dump;

	//6.6.6.1 Endianness
	da_scm_native_endianness scm_native_endianness;

	//6.6.6.2 Manipulating Bytevectors
	da_scm_make_bytevector scm_make_bytevector;
	da_scm_c_make_bytevector scm_c_make_bytevector;
	da_scm_bytevector_p scm_bytevector_p;
	da_scm_is_bytevector scm_is_bytevector;
	da_scm_bytevector_length scm_bytevector_length;
	da_scm_c_bytevector_length scm_c_bytevector_length;
	da_scm_bytevector_eq_p scm_bytevector_eq_p;
	da_scm_bytevector_fill_x scm_bytevector_fill_x;
	da_scm_bytevector_copy_x scm_bytevector_copy_x;
	da_scm_bytevector_copy scm_bytevector_copy;
	da_scm_c_bytevector_ref scm_c_bytevector_ref;
	da_scm_c_bytevector_set_x scm_c_bytevector_set_x;

	//6.6.6.3 Interpreting Bytevector Contents as Integers
	da_scm_bytevector_uint_ref scm_bytevector_uint_ref;
	da_scm_bytevector_sint_ref scm_bytevector_sint_ref;
	da_scm_bytevector_uint_set_x scm_bytevector_uint_set_x;
	da_scm_bytevector_sint_set_x scm_bytevector_sint_set_x;
	da_scm_bytevector_u8_ref scm_bytevector_u8_ref;
	da_scm_bytevector_s8_ref scm_bytevector_s8_ref;
	da_scm_bytevector_u16_ref scm_bytevector_u16_ref;
	da_scm_bytevector_s16_ref scm_bytevector_s16_ref;
	da_scm_bytevector_u32_ref scm_bytevector_u32_ref;
	da_scm_bytevector_s32_ref scm_bytevector_s32_ref;
	da_scm_bytevector_u64_ref scm_bytevector_u64_ref;
	da_scm_bytevector_s64_ref scm_bytevector_s64_ref;
	da_scm_bytevector_u8_set_x scm_bytevector_u8_set_x;
	da_scm_bytevector_s8_set_x scm_bytevector_s8_set_x;
	da_scm_bytevector_u16_set_x scm_bytevector_u16_set_x;
	da_scm_bytevector_s16_set_x scm_bytevector_s16_set_x;
	da_scm_bytevector_u32_set_x scm_bytevector_u32_set_x;
	da_scm_bytevector_s32_set_x scm_bytevector_s32_set_x;
	da_scm_bytevector_u64_set_x scm_bytevector_u64_set_x;
	da_scm_bytevector_s64_set_x scm_bytevector_s64_set_x;
	da_scm_bytevector_u16_native_ref scm_bytevector_u16_native_ref;
	da_scm_bytevector_s16_native_ref scm_bytevector_s16_native_ref;
	da_scm_bytevector_u32_native_ref scm_bytevector_u32_native_ref;
	da_scm_bytevector_s32_native_ref scm_bytevector_s32_native_ref;
	da_scm_bytevector_u64_native_ref scm_bytevector_u64_native_ref;
	da_scm_bytevector_s64_native_ref scm_bytevector_s64_native_ref;
	da_scm_bytevector_u16_native_set_x scm_bytevector_u16_native_set_x;
	da_scm_bytevector_s16_native_set_x scm_bytevector_s16_native_set_x;
	da_scm_bytevector_u32_native_set_x scm_bytevector_u32_native_set_x;
	da_scm_bytevector_s32_native_set_x scm_bytevector_s32_native_set_x;
	da_scm_bytevector_u64_native_set_x scm_bytevector_u64_native_set_x;
	da_scm_bytevector_s64_native_set_x scm_bytevector_s64_native_set_x;

	//6.6.6.4 Converting Bytevectors to/from Integer Lists
	da_scm_bytevector_to_u8_list scm_bytevector_to_u8_list;
	da_scm_u8_list_to_bytevector scm_u8_list_to_bytevector;
	da_scm_bytevector_to_uint_list scm_bytevector_to_uint_list;
	da_scm_bytevector_to_sint_list scm_bytevector_to_sint_list;
	da_scm_uint_list_to_bytevector scm_uint_list_to_bytevector;
	da_scm_sint_list_to_bytevector scm_sint_list_to_bytevector;

	//6.6.6.5 Interpreting Bytevector Contents as Floating Point Numbers
	da_scm_bytevector_ieee_single_ref scm_bytevector_ieee_single_ref;
	da_scm_bytevector_ieee_double_ref scm_bytevector_ieee_double_ref;
	da_scm_bytevector_ieee_single_set_x scm_bytevector_ieee_single_set_x;
	da_scm_bytevector_ieee_double_set_x scm_bytevector_ieee_double_set_x;
	da_scm_bytevector_ieee_single_native_ref scm_bytevector_ieee_single_native_ref;
	da_scm_bytevector_ieee_double_native_ref scm_bytevector_ieee_double_native_ref;
	da_scm_bytevector_ieee_single_native_set_x scm_bytevector_ieee_single_native_set_x;
	da_scm_bytevector_ieee_double_native_set_x scm_bytevector_ieee_double_native_set_x;

	//6.6.6.6 Interpreting Bytevector Contents as Unicode Strings
	da_scm_string_to_utf8 scm_string_to_utf8;
	da_scm_string_to_utf16 scm_string_to_utf16;
	da_scm_string_to_utf32 scm_string_to_utf32;
	da_scm_utf8_to_string scm_utf8_to_string;
	da_scm_utf16_to_string scm_utf16_to_string;
	da_scm_utf32_to_string scm_utf32_to_string;

	//6.6.7.2 Symbols as Lookup Keys
	da_scm_symbol_hash scm_symbol_hash;

	//6.6.7.4 Operations Related to Symbols
	da_scm_symbol_p scm_symbol_p;
	da_scm_symbol_to_string scm_symbol_to_string;
	da_scm_string_to_symbol scm_string_to_symbol;
	da_scm_string_ci_to_symbol scm_string_ci_to_symbol;
	da_scm_from_latin1_symbol scm_from_latin1_symbol;
	da_scm_from_utf8_symbol scm_from_utf8_symbol;
	da_scm_from_locale_symbol scm_from_locale_symbol;
	da_scm_from_locale_symboln scm_from_locale_symboln;
	da_scm_take_locale_symbol scm_take_locale_symbol;
	da_scm_take_locale_symboln scm_take_locale_symboln;
	da_scm_c_symbol_length scm_c_symbol_length;
	da_scm_gensym scm_gensym;

	//6.6.7.5 Function Slots and Property Lists
	da_scm_symbol_fref scm_symbol_fref;
	da_scm_symbol_fset_x scm_symbol_fset_x;
	da_scm_symbol_pref scm_symbol_pref;
	da_scm_symbol_pset_x scm_symbol_pset_x;

	//6.6.7.7 Uninterned Symbols
	da_scm_make_symbol scm_make_symbol;
	da_scm_symbol_interned_p scm_symbol_interned_p;

	//6.6.8.4 Keyword Procedures
	da_scm_keyword_p scm_keyword_p;
	da_scm_keyword_to_symbol scm_keyword_to_symbol;
	da_scm_symbol_to_keyword scm_symbol_to_keyword;
	da_scm_is_keyword scm_is_keyword;
	da_scm_from_locale_keyword scm_from_locale_keyword;
	da_scm_from_locale_keywordn scm_from_locale_keywordn;
	da_scm_from_latin1_keyword scm_from_latin1_keyword;
	da_scm_from_utf8_keyword scm_from_utf8_keyword;
	da_scm_c_bind_keyword_arguments scm_c_bind_keyword_arguments;

	//6.7.1 Pairs
	da_scm_cons scm_cons;
	da_scm_pair_p scm_pair_p;
	da_scm_is_pair scm_is_pair;
	da_scm_car scm_car;
	da_scm_cdr scm_cdr;
	da_scm_cddr scm_cddr;
	da_scm_cdar scm_cdar;
	da_scm_cadr scm_cadr;
	da_scm_caar scm_caar;
	da_scm_cdddr scm_cdddr;
	da_scm_cddar scm_cddar;
	da_scm_cdadr scm_cdadr;
	da_scm_cdaar scm_cdaar;
	da_scm_caddr scm_caddr;
	da_scm_cadar scm_cadar;
	da_scm_caadr scm_caadr;
	da_scm_caaar scm_caaar;
	da_scm_cddddr scm_cddddr;
	da_scm_cdddar scm_cdddar;
	da_scm_cddadr scm_cddadr;
	da_scm_cddaar scm_cddaar;
	da_scm_cdaddr scm_cdaddr;
	da_scm_cdadar scm_cdadar;
	da_scm_cdaadr scm_cdaadr;
	da_scm_cdaaar scm_cdaaar;
	da_scm_cadddr scm_cadddr;
	da_scm_caddar scm_caddar;
	da_scm_cadadr scm_cadadr;
	da_scm_cadaar scm_cadaar;
	da_scm_caaddr scm_caaddr;
	da_scm_caadar scm_caadar;
	da_scm_caaadr scm_caaadr;
	da_scm_caaaar scm_caaaar;
	da_scm_set_car_x scm_set_car_x;
	da_scm_set_cdr_x scm_set_cdr_x;

	//6.7.2.2 List Predicates
	da_scm_list_p scm_list_p;
	da_scm_null_p scm_null_p;

	//6.7.2.3 List Constructors
	da_scm_list_1 scm_list_1;
	da_scm_list_2 scm_list_2;
	da_scm_list_3 scm_list_3;
	da_scm_list_4 scm_list_4;
	da_scm_list_5 scm_list_5;
	da_scm_list_n scm_list_n;
	da_scm_list_copy scm_list_copy;

	//6.7.2.4 List Selection
	da_scm_length scm_length;
	da_scm_last_pair scm_last_pair;
	da_scm_list_ref scm_list_ref;
	da_scm_list_tail scm_list_tail;
	da_scm_list_head scm_list_head;

	//6.7.2.5 Append and Reverse
	da_scm_append scm_append;
	da_scm_append_x scm_append_x;
	da_scm_reverse scm_reverse;
	da_scm_reverse_x scm_reverse_x;

	//6.7.2.6 List Modification
	da_scm_list_set_x scm_list_set_x;
	da_scm_list_cdr_set_x scm_list_cdr_set_x;
	da_scm_delq scm_delq;
	da_scm_delv scm_delv;
	da_scm_delete scm_delete;
	da_scm_delq_x scm_delq_x;
	da_scm_delv_x scm_delv_x;
	da_scm_delete_x scm_delete_x;
	da_scm_delq1_x scm_delq1_x;
	da_scm_delv1_x scm_delv1_x;
	da_scm_delete1_x scm_delete1_x;

	//6.7.2.7 List Searching
	da_scm_memq scm_memq;
	da_scm_memv scm_memv;
	da_scm_member scm_member;

	//6.7.2.8 List Mapping
	da_scm_map scm_map;

	//6.7.3.2 Dynamic Vector Creation and Validation
	da_scm_vector scm_vector;
	da_scm_vector_to_list scm_vector_to_list;
	da_scm_make_vector scm_make_vector;
	da_scm_c_make_vector scm_c_make_vector;
	da_scm_vector_p scm_vector_p;
	da_scm_is_vector scm_is_vector;

	//6.7.3.3 Accessing and Modifying Vector Contents
	da_scm_vector_length scm_vector_length;
	da_scm_c_vector_length scm_c_vector_length;
	da_scm_vector_ref scm_vector_ref;
	da_scm_c_vector_ref scm_c_vector_ref;
	da_scm_vector_set_x scm_vector_set_x;
	da_scm_c_vector_set_x scm_c_vector_set_x;
	da_scm_vector_fill_x scm_vector_fill_x;
	da_scm_vector_copy scm_vector_copy;
	da_scm_vector_move_left_x scm_vector_move_left_x;
	da_scm_vector_move_right_x scm_vector_move_right_x;

	//6.7.3.4 Vector Accessing from C
	da_scm_is_simple_vector scm_is_simple_vector;
	da_scm_vector_elements scm_vector_elements;
	da_scm_vector_writable_elements scm_vector_writable_elements;

	//6.7.4 Bit Vectors
	da_scm_bitvector_p scm_bitvector_p;
	da_scm_is_bitvector scm_is_bitvector;
	da_scm_make_bitvector scm_make_bitvector;
	da_scm_c_make_bitvector scm_c_make_bitvector;
	da_scm_bitvector scm_bitvector;
	da_scm_bitvector_length scm_bitvector_length;
	da_scm_c_bitvector_length scm_c_bitvector_length;
	da_scm_bitvector_ref scm_bitvector_ref;
	da_scm_c_bitvector_ref scm_c_bitvector_ref;
	da_scm_bitvector_set_x scm_bitvector_set_x;
	da_scm_c_bitvector_set_x scm_c_bitvector_set_x;
	da_scm_bitvector_fill_x scm_bitvector_fill_x;
	da_scm_list_to_bitvector scm_list_to_bitvector;
	da_scm_bitvector_to_list scm_bitvector_to_list;
	da_scm_bit_count scm_bit_count;
	da_scm_bit_position scm_bit_position;
	da_scm_bit_invert_x scm_bit_invert_x;
	da_scm_bit_set_star_x scm_bit_set_star_x;
	da_scm_bit_count_star scm_bit_count_star;
	da_scm_bitvector_elements scm_bitvector_elements;
	da_scm_bitvector_writable_elements scm_bitvector_writable_elements;

	//6.7.5.2 Array Procedures
	da_scm_array_p scm_array_p;
	da_scm_typed_array_p scm_typed_array_p;
	da_scm_is_array scm_is_array;
	da_scm_is_typed_array scm_is_typed_array;
	da_scm_make_array scm_make_array;
	da_scm_make_typed_array scm_make_typed_array;
	da_scm_list_to_typed_array scm_list_to_typed_array;
	da_scm_array_type scm_array_type;
	da_scm_array_ref scm_array_ref;
	da_scm_array_in_bounds_p scm_array_in_bounds_p;
	da_scm_array_set_x scm_array_set_x;
	da_scm_array_dimensions scm_array_dimensions;
	da_scm_array_length scm_array_length;
	da_scm_c_array_length scm_c_array_length;
	da_scm_array_rank scm_array_rank;
	da_scm_c_array_rank scm_c_array_rank;
	da_scm_array_to_list scm_array_to_list;
	da_scm_array_copy_x scm_array_copy_x;
	da_scm_array_fill_x scm_array_fill_x;
	da_scm_array_map_x scm_array_map_x;
	da_scm_array_for_each scm_array_for_each;
	da_scm_array_index_map_x scm_array_index_map_x;
	da_scm_uniform_array_read_x scm_uniform_array_read_x;
	da_scm_uniform_array_write scm_uniform_array_write;

	//6.7.5.3 Shared Arrays
	da_scm_make_shared_array scm_make_shared_array;
	da_scm_shared_array_increments scm_shared_array_increments;
	da_scm_shared_array_offset scm_shared_array_offset;
	da_scm_shared_array_root scm_shared_array_root;
	da_scm_array_contents scm_array_contents;
	da_scm_transpose_array scm_transpose_array;

	//6.7.5.4 Accessing Arrays from C
	da_scm_array_get_handle scm_array_get_handle;
	da_scm_array_handle_release scm_array_handle_release;
	da_scm_array_handle_pos scm_array_handle_pos;
	da_scm_array_handle_ref scm_array_handle_ref;
	da_scm_array_handle_set scm_array_handle_set;
	da_scm_array_handle_elements scm_array_handle_elements;
	da_scm_array_handle_writable_elements scm_array_handle_writable_elements;
	da_scm_array_handle_uniform_elements scm_array_handle_uniform_elements;
	da_scm_array_handle_uniform_writable_elements scm_array_handle_uniform_writable_elements;
	da_scm_array_handle_uniform_element_size scm_array_handle_uniform_element_size;
	da_scm_array_handle_u8_elements scm_array_handle_u8_elements;
	da_scm_array_handle_s8_elements scm_array_handle_s8_elements;
	da_scm_array_handle_u16_elements scm_array_handle_u16_elements;
	da_scm_array_handle_s16_elements scm_array_handle_s16_elements;
	da_scm_array_handle_u32_elements scm_array_handle_u32_elements;
	da_scm_array_handle_s32_elements scm_array_handle_s32_elements;
	da_scm_array_handle_u64_elements scm_array_handle_u64_elements;
	da_scm_array_handle_s64_elements scm_array_handle_s64_elements;
	da_scm_array_handle_f32_elements scm_array_handle_f32_elements;
	da_scm_array_handle_f64_elements scm_array_handle_f64_elements;
	da_scm_array_handle_c32_elements scm_array_handle_c32_elements;
	da_scm_array_handle_c64_elements scm_array_handle_c64_elements;
	da_scm_array_handle_u8_writable_elements scm_array_handle_u8_writable_elements;
	da_scm_array_handle_s8_writable_elements scm_array_handle_s8_writable_elements;
	da_scm_array_handle_u16_writable_elements scm_array_handle_u16_writable_elements;
	da_scm_array_handle_s16_writable_elements scm_array_handle_s16_writable_elements;
	da_scm_array_handle_u32_writable_elements scm_array_handle_u32_writable_elements;
	da_scm_array_handle_s32_writable_elements scm_array_handle_s32_writable_elements;
	da_scm_array_handle_u64_writable_elements scm_array_handle_u64_writable_elements;
	da_scm_array_handle_s64_writable_elements scm_array_handle_s64_writable_elements;
	da_scm_array_handle_f32_writable_elements scm_array_handle_f32_writable_elements;
	da_scm_array_handle_f64_writable_elements scm_array_handle_f64_writable_elements;
	da_scm_array_handle_c32_writable_elements scm_array_handle_c32_writable_elements;
	da_scm_array_handle_c64_writable_elements scm_array_handle_c64_writable_elements;
	da_scm_array_handle_bit_elements scm_array_handle_bit_elements;
	da_scm_array_handle_bit_writable_elements scm_array_handle_bit_writable_elements;

	//6.7.10.2 Structure Basics
	da_scm_make_struct scm_make_struct;
	da_scm_c_make_struct scm_c_make_struct;
	da_scm_c_make_structv scm_c_make_structv;
	da_scm_struct_p scm_struct_p;
	da_scm_struct_ref scm_struct_ref;
	da_scm_struct_set_x scm_struct_set_x;
	da_scm_struct_vtable scm_struct_vtable;

	//6.7.10.3 Vtable Contents
	da_scm_struct_vtable_name scm_struct_vtable_name;
	da_scm_set_struct_vtable_name_x scm_set_struct_vtable_name_x;

	//6.7.10.4 Meta-Vtables
	da_scm_struct_vtable_p scm_struct_vtable_p;
	da_scm_make_struct_layout scm_make_struct_layout;

	//6.7.12.2 Adding or Setting Alist Entries
	da_scm_acons scm_acons;
	da_scm_assq_set_x scm_assq_set_x;
	da_scm_assv_set_x scm_assv_set_x;
	da_scm_assoc_set_x scm_assoc_set_x;

	//6.7.12.3 Retrieving Alist Entries
	da_scm_assq scm_assq;
	da_scm_assv scm_assv;
	da_scm_assoc scm_assoc;
	da_scm_assq_ref scm_assq_ref;
	da_scm_assv_ref scm_assv_ref;
	da_scm_assoc_ref scm_assoc_ref;

	//6.7.12.4 Removing Alist Entries
	da_scm_assq_remove_x scm_assq_remove_x;
	da_scm_assv_remove_x scm_assv_remove_x;
	da_scm_assoc_remove_x scm_assoc_remove_x;

	//6.7.12.5 Sloppy Alist Functions
	da_scm_sloppy_assq scm_sloppy_assq;
	da_scm_sloppy_assv scm_sloppy_assv;
	da_scm_sloppy_assoc scm_sloppy_assoc;

	//6.7.14.2 Hash Table Reference
	da_scm_hash_table_p scm_hash_table_p;
	da_scm_hash_clear_x scm_hash_clear_x;
	da_scm_hash_ref scm_hash_ref;
	da_scm_hashq_ref scm_hashq_ref;
	da_scm_hashv_ref scm_hashv_ref;
	da_scm_hashx_ref scm_hashx_ref;
	da_scm_hash_set_x scm_hash_set_x;
	da_scm_hashq_set_x scm_hashq_set_x;
	da_scm_hashv_set_x scm_hashv_set_x;
	da_scm_hashx_set_x scm_hashx_set_x;
	da_scm_hash_remove_x scm_hash_remove_x;
	da_scm_hashq_remove_x scm_hashq_remove_x;
	da_scm_hashv_remove_x scm_hashv_remove_x;
	da_scm_hashx_remove_x scm_hashx_remove_x;
	da_scm_hash scm_hash;
	da_scm_hashq scm_hashq;
	da_scm_hashv scm_hashv;
	da_scm_hash_get_handle scm_hash_get_handle;
	da_scm_hashq_get_handle scm_hashq_get_handle;
	da_scm_hashv_get_handle scm_hashv_get_handle;
	da_scm_hashx_get_handle scm_hashx_get_handle;
	da_scm_hash_create_handle_x scm_hash_create_handle_x;
	da_scm_hashq_create_handle_x scm_hashq_create_handle_x;
	da_scm_hashv_create_handle_x scm_hashv_create_handle_x;
	da_scm_hashx_create_handle_x scm_hashx_create_handle_x;
	da_scm_hash_map_to_list scm_hash_map_to_list;
	da_scm_hash_for_each scm_hash_for_each;
	da_scm_hash_for_each_handle scm_hash_for_each_handle;
	da_scm_hash_fold scm_hash_fold;
	da_scm_hash_count scm_hash_count;

	//6.8 Smobs
	da_scm_set_smob_free scm_set_smob_free;
	da_scm_set_smob_mark scm_set_smob_mark;
	da_scm_set_smob_print scm_set_smob_print;
	da_scm_set_smob_equalp scm_set_smob_equalp;
	da_scm_assert_smob_type scm_assert_smob_type;
	da_scm_new_smob scm_new_smob;
	da_scm_new_double_smob scm_new_double_smob;

	//6.9.3 Compiled Procedures
	da_scm_program_p scm_program_p;
	da_scm_program_objcode scm_program_objcode;
	da_scm_program_objects scm_program_objects;
	da_scm_program_module scm_program_module;
	da_scm_program_meta scm_program_meta;
	da_scm_program_arities scm_program_arities;

	//6.9.7 Procedure Properties and Meta-information
	da_scm_procedure_p scm_procedure_p;
	da_scm_thunk_p scm_thunk_p;
	da_scm_procedure_name scm_procedure_name;
	da_scm_procedure_source scm_procedure_source;
	da_scm_procedure_properties scm_procedure_properties;
	da_scm_procedure_property scm_procedure_property;
	da_scm_set_procedure_properties_x scm_set_procedure_properties_x;
	da_scm_set_procedure_property_x scm_set_procedure_property_x;
	da_scm_procedure_documentation scm_procedure_documentation;

	//6.9.8 Procedures with Setters
	da_scm_make_procedure_with_setter scm_make_procedure_with_setter;
	da_scm_procedure_with_setter_p scm_procedure_with_setter_p;
	da_scm_procedure scm_procedure;

	//6.10.9 Internal Macros
	da_scm_macro_p scm_macro_p;
	da_scm_macro_type scm_macro_type;
	da_scm_macro_name scm_macro_name;
	da_scm_macro_binding scm_macro_binding;
	da_scm_macro_transformer scm_macro_transformer;

	//6.11.1 Equality
	da_scm_eq_p scm_eq_p;
	da_scm_eqv_p scm_eqv_p;
	da_scm_equal_p scm_equal_p;

	//6.11.2 Object Properties
	da_scm_object_properties scm_object_properties;
	da_scm_set_object_properties_x scm_set_object_properties_x;
	da_scm_object_property scm_object_property;
	da_scm_set_object_property_x scm_set_object_property_x;

	//6.11.3 Sorting
	da_scm_merge scm_merge;
	da_scm_merge_x scm_merge_x;
	da_scm_sorted_p scm_sorted_p;
	da_scm_sort scm_sort;
	da_scm_sort_x scm_sort_x;
	da_scm_stable_sort scm_stable_sort;
	da_scm_stable_sort_x scm_stable_sort_x;
	da_scm_sort_list scm_sort_list;
	da_scm_sort_list_x scm_sort_list_x;
	da_scm_restricted_vector_sort_x scm_restricted_vector_sort_x;

	//6.11.4 Copying Deep Structures
	da_scm_copy_tree scm_copy_tree;

	//6.11.5 General String Conversion
	da_scm_object_to_string scm_object_to_string;

	//6.11.6.2 Hook Reference
	da_scm_make_hook scm_make_hook;
	da_scm_hook_p scm_hook_p;
	da_scm_hook_empty_p scm_hook_empty_p;
	da_scm_add_hook_x scm_add_hook_x;
	da_scm_remove_hook_x scm_remove_hook_x;
	da_scm_reset_hook_x scm_reset_hook_x;
	da_scm_hook_to_list scm_hook_to_list;
	da_scm_run_hook scm_run_hook;
	da_scm_c_run_hook scm_c_run_hook;

	//6.11.6.4 Hooks For C Code.
	da_scm_c_hook_init scm_c_hook_init;
	da_scm_c_hook_add scm_c_hook_add;
	da_scm_c_hook_remove scm_c_hook_remove;
	da_scm_c_hook_run scm_c_hook_run;

	//6.12.1 Top Level Variable Definitions
	da_scm_define scm_define;
	da_scm_c_define scm_c_define;

	//6.12.4 Querying variable bindings
	da_scm_defined_p scm_defined_p;

	//6.13.7 Returning and Accepting Multiple Values
	da_scm_values scm_values;
	da_scm_c_values scm_c_values;
	da_scm_c_nvalues scm_c_nvalues;
	da_scm_c_value_ref scm_c_value_ref;

	//6.13.8.2 Catching Exceptions
	da_scm_catch_with_pre_unwind_handler scm_catch_with_pre_unwind_handler;
	da_scm_catch scm_catch;
	da_scm_c_catch scm_c_catch;
	da_scm_internal_catch scm_internal_catch;

	//6.13.8.3 Throw Handlers
	da_scm_with_throw_handler scm_with_throw_handler;
	da_scm_c_with_throw_handler scm_c_with_throw_handler;

	//6.13.8.4 Throwing Exceptions
	da_scm_throw scm_throw;

	//6.13.9 Procedures for Signaling Errors
	da_scm_error_scm scm_error_scm;
	da_scm_strerror scm_strerror;

	//6.13.10 Dynamic Wind
	da_scm_dynamic_wind scm_dynamic_wind;
	da_scm_dynwind_begin scm_dynwind_begin;
	da_scm_dynwind_end scm_dynwind_end;
	da_scm_dynwind_unwind_handler scm_dynwind_unwind_handler;
	da_scm_dynwind_unwind_handler_with_scm scm_dynwind_unwind_handler_with_scm;
	da_scm_dynwind_rewind_handler scm_dynwind_rewind_handler;
	da_scm_dynwind_rewind_handler_with_scm scm_dynwind_rewind_handler_with_scm;
	da_scm_dynwind_free scm_dynwind_free;

	//6.13.11 How to Handle Errors
	da_scm_display_error scm_display_error;

	//6.13.11.1 C Support
	da_scm_error scm_error;
	da_scm_syserror scm_syserror;
	da_scm_syserror_msg scm_syserror_msg;
	da_scm_num_overflow scm_num_overflow;
	da_scm_out_of_range scm_out_of_range;
	da_scm_wrong_num_args scm_wrong_num_args;
	da_scm_wrong_type_arg scm_wrong_type_arg;
	da_scm_wrong_type_arg_msg scm_wrong_type_arg_msg;
	da_scm_memory_error scm_memory_error;
	da_scm_misc_error scm_misc_error;

	//6.13.12 Continuation Barriers
	da_scm_with_continuation_barrier scm_with_continuation_barrier;
	da_scm_c_with_continuation_barrier scm_c_with_continuation_barrier;

	//6.14.1 Ports
	da_scm_input_port_p scm_input_port_p;
	da_scm_output_port_p scm_output_port_p;
	da_scm_port_p scm_port_p;
	da_scm_set_port_encoding_x scm_set_port_encoding_x;
	da_scm_port_encoding scm_port_encoding;
	da_scm_set_port_conversion_strategy_x scm_set_port_conversion_strategy_x;
	da_scm_port_conversion_strategy scm_port_conversion_strategy;

	//6.14.2 Reading
	da_scm_char_ready_p scm_char_ready_p;
	da_scm_read_char scm_read_char;
	da_scm_c_read scm_c_read;
	da_scm_peek_char scm_peek_char;
	da_scm_unread_char scm_unread_char;
	da_scm_unread_string scm_unread_string;
	da_scm_drain_input scm_drain_input;
	da_scm_port_column scm_port_column;
	da_scm_port_line scm_port_line;
	da_scm_set_port_column_x scm_set_port_column_x;
	da_scm_set_port_line_x scm_set_port_line_x;

	//6.14.3 Writing
	da_scm_get_print_state scm_get_print_state;
	da_scm_newline scm_newline;
	da_scm_port_with_print_state scm_port_with_print_state;
	da_scm_simple_format scm_simple_format;
	da_scm_write_char scm_write_char;
	da_scm_c_write scm_c_write;
	da_scm_force_output scm_force_output;
	da_scm_flush_all_ports scm_flush_all_ports;

	//6.14.4 Closing
	da_scm_close_port scm_close_port;
	da_scm_close_input_port scm_close_input_port;
	da_scm_close_output_port scm_close_output_port;
	da_scm_port_closed_p scm_port_closed_p;

	//6.14.5 Random Access
	da_scm_seek scm_seek;
	da_scm_ftell scm_ftell;
	da_scm_truncate_file scm_truncate_file;

	//6.14.6 Line Oriented and Delimited Text
	da_scm_write_line scm_write_line;
	da_scm_read_delimited_x scm_read_delimited_x;
	da_scm_read_line scm_read_line;

	//6.14.7 Block reading and writing
	da_scm_read_string_x_partial scm_read_string_x_partial;
	da_scm_write_string_partial scm_write_string_partial;

	//6.14.8 Default Ports for Input, Output and Errors
	da_scm_current_input_port scm_current_input_port;
	da_scm_current_output_port scm_current_output_port;
	da_scm_current_error_port scm_current_error_port;
	da_scm_set_current_input_port scm_set_current_input_port;
	da_scm_set_current_output_port scm_set_current_output_port;
	da_scm_set_current_error_port scm_set_current_error_port;
	da_scm_dynwind_current_input_port scm_dynwind_current_input_port;
	da_scm_dynwind_current_output_port scm_dynwind_current_output_port;
	da_scm_dynwind_current_error_port scm_dynwind_current_error_port;

	//6.14.9.1 File Ports
	da_scm_open_file_with_encoding scm_open_file_with_encoding;
	da_scm_open_file scm_open_file;
	da_scm_port_mode scm_port_mode;
	da_scm_port_filename scm_port_filename;
	da_scm_set_port_filename_x scm_set_port_filename_x;
	da_scm_file_port_p scm_file_port_p;

	//6.14.9.2 String Ports
	da_scm_call_with_output_string scm_call_with_output_string;
	da_scm_call_with_input_string scm_call_with_input_string;
	da_scm_open_input_string scm_open_input_string;
	da_scm_open_output_string scm_open_output_string;
	da_scm_get_output_string scm_get_output_string;

	//6.14.9.3 Soft Ports
	da_scm_make_soft_port scm_make_soft_port;

	//6.14.9.4 Void Ports
	da_scm_sys_make_void_port scm_sys_make_void_port;

	//6.14.10.5 The End-of-File Object
	da_scm_eof_object_p scm_eof_object_p;
	da_scm_eof_object scm_eof_object;

	//6.14.10.8 Binary Input
	da_scm_open_bytevector_input_port scm_open_bytevector_input_port;
	da_scm_make_custom_binary_input_port scm_make_custom_binary_input_port;
	da_scm_get_u8 scm_get_u8;
	da_scm_lookahead_u8 scm_lookahead_u8;
	da_scm_get_bytevector_n scm_get_bytevector_n;
	da_scm_get_bytevector_n_x scm_get_bytevector_n_x;
	da_scm_get_bytevector_some scm_get_bytevector_some;
	da_scm_get_bytevector_all scm_get_bytevector_all;
	da_scm_unget_bytevector scm_unget_bytevector;

	//6.14.10.11 Binary Output
	da_scm_open_bytevector_output_port scm_open_bytevector_output_port;
	da_scm_make_custom_binary_output_port scm_make_custom_binary_output_port;
	da_scm_put_u8 scm_put_u8;
	da_scm_put_bytevector scm_put_bytevector;

	//6.15.1 Regexp Functions
	da_scm_make_regexp scm_make_regexp;
	da_scm_regexp_exec scm_regexp_exec;
	da_scm_regexp_p scm_regexp_p;

	//6.17.1.6 Reader Extensions
	da_scm_read_hash_extend scm_read_hash_extend;

	//6.17.2 Reading Scheme Code
	da_scm_read scm_read;

	//6.17.4 Procedures for On the Fly Evaluation
	da_scm_eval scm_eval;
	da_scm_interaction_environment scm_interaction_environment;
	da_scm_eval_string scm_eval_string;
	da_scm_eval_string_in_module scm_eval_string_in_module;
	da_scm_c_eval_string scm_c_eval_string;
	da_scm_apply_0 scm_apply_0;
	da_scm_apply_1 scm_apply_1;
	da_scm_apply_2 scm_apply_2;
	da_scm_apply_3 scm_apply_3;
	da_scm_apply scm_apply;
	da_scm_call_0 scm_call_0;
	da_scm_call_1 scm_call_1;
	da_scm_call_2 scm_call_2;
	da_scm_call_3 scm_call_3;
	da_scm_call_4 scm_call_4;
	da_scm_call_5 scm_call_5;
	da_scm_call_6 scm_call_6;
	da_scm_call_7 scm_call_7;
	da_scm_call_8 scm_call_8;
	da_scm_call_9 scm_call_9;
	da_scm_call scm_call;
	da_scm_call_n scm_call_n;
	da_scm_nconc2last scm_nconc2last;
	da_scm_primitive_eval scm_primitive_eval;

	//6.17.6 Loading Scheme Code from File
	da_scm_primitive_load scm_primitive_load;
	da_scm_c_primitive_load scm_c_primitive_load;
	da_scm_current_load_port scm_current_load_port;

	//6.17.7 Load Paths
	da_scm_primitive_load_path scm_primitive_load_path;
	da_scm_sys_search_load_path scm_sys_search_load_path;
	da_scm_parse_path scm_parse_path;
	da_scm_parse_path_with_ellipsis scm_parse_path_with_ellipsis;
	da_scm_search_path scm_search_path;

	//6.17.8 Character Encoding of Source Files
	da_scm_file_encoding scm_file_encoding;

	//6.17.9 Delayed Evaluation
	da_scm_promise_p scm_promise_p;
	da_scm_force scm_force;

	//6.17.10 Local Evaluation
	da_scm_local_eval scm_local_eval;

	//6.18.1 Function related to Garbage Collection
	da_scm_gc scm_gc;
	da_scm_gc_protect_object scm_gc_protect_object;
	da_scm_gc_unprotect_object scm_gc_unprotect_object;
	da_scm_permanent_object scm_permanent_object;
	da_scm_gc_stats scm_gc_stats;
	da_scm_gc_live_object_stats scm_gc_live_object_stats;

	//6.18.2 Memory Blocks
	da_scm_malloc scm_malloc;
	da_scm_calloc scm_calloc;
	da_scm_realloc scm_realloc;
	da_scm_gc_malloc scm_gc_malloc;
	da_scm_gc_malloc_pointerless scm_gc_malloc_pointerless;
	da_scm_gc_realloc scm_gc_realloc;
	da_scm_gc_calloc scm_gc_calloc;
	da_scm_gc_free scm_gc_free;
	da_scm_gc_register_allocation scm_gc_register_allocation;

	//6.18.3.1 Weak hash tables
	da_scm_make_weak_key_hash_table scm_make_weak_key_hash_table;
	da_scm_make_weak_value_hash_table scm_make_weak_value_hash_table;
	da_scm_make_doubly_weak_hash_table scm_make_doubly_weak_hash_table;
	da_scm_weak_key_hash_table_p scm_weak_key_hash_table_p;
	da_scm_weak_value_hash_table_p scm_weak_value_hash_table_p;
	da_scm_doubly_weak_hash_table_p scm_doubly_weak_hash_table_p;

	//6.18.3.2 Weak vectors
	da_scm_make_weak_vector scm_make_weak_vector;
	da_scm_weak_vector scm_weak_vector;
	da_scm_weak_vector_p scm_weak_vector_p;
	da_scm_weak_vector_ref scm_weak_vector_ref;
	da_scm_weak_vector_set_x scm_weak_vector_set_x;

	//6.18.4 Guardians
	da_scm_make_guardian scm_make_guardian;

	//6.19.7 Variables
	da_scm_make_undefined_variable scm_make_undefined_variable;
	da_scm_make_variable scm_make_variable;
	da_scm_variable_bound_p scm_variable_bound_p;
	da_scm_variable_ref scm_variable_ref;
	da_scm_variable_set_x scm_variable_set_x;
	da_scm_variable_unset_x scm_variable_unset_x;
	da_scm_variable_p scm_variable_p;

	//6.19.8 Module System Reflection
	da_scm_current_module scm_current_module;
	da_scm_set_current_module scm_set_current_module;
	da_scm_resolve_module scm_resolve_module;

	//6.19.9 Accessing Modules from C
	da_scm_c_call_with_current_module scm_c_call_with_current_module;
	da_scm_public_variable scm_public_variable;
	da_scm_c_public_variable scm_c_public_variable;
	da_scm_private_variable scm_private_variable;
	da_scm_c_private_variable scm_c_private_variable;
	da_scm_public_lookup scm_public_lookup;
	da_scm_c_public_lookup scm_c_public_lookup;
	da_scm_private_lookup scm_private_lookup;
	da_scm_c_private_lookup scm_c_private_lookup;
	da_scm_public_ref scm_public_ref;
	da_scm_c_public_ref scm_c_public_ref;
	da_scm_private_ref scm_private_ref;
	da_scm_c_private_ref scm_c_private_ref;
	da_scm_c_lookup scm_c_lookup;
	da_scm_lookup scm_lookup;
	da_scm_c_module_lookup scm_c_module_lookup;
	da_scm_module_lookup scm_module_lookup;
	da_scm_module_variable scm_module_variable;
	da_scm_c_module_define scm_c_module_define;
	da_scm_module_define scm_module_define;
	da_scm_module_ensure_local_variable scm_module_ensure_local_variable;
	da_scm_module_reverse_lookup scm_module_reverse_lookup;
	da_scm_c_define_module scm_c_define_module;
	da_scm_c_resolve_module scm_c_resolve_module;
	da_scm_c_use_module scm_c_use_module;
	da_scm_c_export scm_c_export;

	//6.20.1 Foreign Libraries
	da_scm_dynamic_link scm_dynamic_link;
	da_scm_dynamic_object_p scm_dynamic_object_p;
	da_scm_dynamic_unlink scm_dynamic_unlink;

	//6.20.2 Foreign Functions
	da_scm_dynamic_func scm_dynamic_func;
	da_scm_dynamic_call scm_dynamic_call;
	da_scm_load_extension scm_load_extension;

	//6.20.5.2 Foreign Variables
	da_scm_dynamic_pointer scm_dynamic_pointer;
	da_scm_pointer_address scm_pointer_address;
	da_scm_from_pointer scm_from_pointer;
	da_scm_to_pointer scm_to_pointer;

	//6.20.5.3 Void Pointers and Byte Access
	da_scm_pointer_to_bytevector scm_pointer_to_bytevector;
	da_scm_bytevector_to_pointer scm_bytevector_to_pointer;

	//6.20.5.4 Foreign Structs
	da_scm_sizeof scm_sizeof;
	da_scm_alignof scm_alignof;

	//6.20.6 Dynamic FFI
	da_scm_procedure_to_pointer scm_procedure_to_pointer;

	//6.21.1 Arbiters
	da_scm_make_arbiter scm_make_arbiter;
	da_scm_try_arbiter scm_try_arbiter;
	da_scm_release_arbiter scm_release_arbiter;

	//6.21.2 Asyncs

	//6.21.2.1 System asyncs
	da_scm_system_async_mark scm_system_async_mark;
	da_scm_system_async_mark_for_thread scm_system_async_mark_for_thread;
	da_scm_call_with_blocked_asyncs scm_call_with_blocked_asyncs;
	da_scm_c_call_with_blocked_asyncs scm_c_call_with_blocked_asyncs;
	da_scm_call_with_unblocked_asyncs scm_call_with_unblocked_asyncs;
	da_scm_c_call_with_unblocked_asyncs scm_c_call_with_unblocked_asyncs;
	da_scm_dynwind_block_asyncs scm_dynwind_block_asyncs;
	da_scm_dynwind_unblock_asyncs scm_dynwind_unblock_asyncs;

	//6.21.2.2 User asyncs
	da_scm_async scm_async;
	da_scm_async_mark scm_async_mark;
	da_scm_run_asyncs scm_run_asyncs;

	//6.21.3 Threads
	da_scm_all_threads scm_all_threads;
	da_scm_current_thread scm_current_thread;
	da_scm_spawn_thread scm_spawn_thread;
	da_scm_thread_p scm_thread_p;
	da_scm_join_thread scm_join_thread;
	da_scm_join_thread_timed scm_join_thread_timed;
	da_scm_thread_exited_p scm_thread_exited_p;
	da_scm_cancel_thread scm_cancel_thread;
	da_scm_set_thread_cleanup_x scm_set_thread_cleanup_x;
	da_scm_thread_cleanup scm_thread_cleanup;

	//6.21.4 Mutexes and Condition Variables
	da_scm_make_mutex scm_make_mutex;
	da_scm_make_mutex_with_flags scm_make_mutex_with_flags;
	da_scm_mutex_p scm_mutex_p;
	da_scm_lock_mutex scm_lock_mutex;
	da_scm_lock_mutex_timed scm_lock_mutex_timed;
	da_scm_dynwind_lock_mutex scm_dynwind_lock_mutex;
	da_scm_try_mutex scm_try_mutex;
	da_scm_unlock_mutex scm_unlock_mutex;
	da_scm_unlock_mutex_timed scm_unlock_mutex_timed;
	da_scm_mutex_owner scm_mutex_owner;
	da_scm_mutex_level scm_mutex_level;
	da_scm_mutex_locked_p scm_mutex_locked_p;
	da_scm_make_condition_variable scm_make_condition_variable;
	da_scm_condition_variable_p scm_condition_variable_p;
	da_scm_wait_condition_variable scm_wait_condition_variable;
	da_scm_signal_condition_variable scm_signal_condition_variable;
	da_scm_broadcast_condition_variable scm_broadcast_condition_variable;

	//6.21.5 Blocking in Guile Mode
	/* not included at the moment
	da_scm_without_guile scm_without_guile;
	da_scm_pthread_mutex_lock scm_pthread_mutex_lock;
	da_scm_pthread_cond_wait scm_pthread_cond_wait;
	da_scm_pthread_cond_timedwait scm_pthread_cond_timedwait;
	da_scm_std_select scm_std_select;
	da_scm_std_sleep scm_std_sleep;
	da_scm_std_usleep scm_std_usleep;
	*/

	//6.21.6 Critical Sections
	da_scm_dynwind_critical_section scm_dynwind_critical_section;

	//6.21.7 Fluids and Dynamic States
	da_scm_make_fluid scm_make_fluid;
	da_scm_make_fluid_with_default scm_make_fluid_with_default;
	da_scm_make_unbound_fluid scm_make_unbound_fluid;
	da_scm_fluid_p scm_fluid_p;
	da_scm_fluid_ref scm_fluid_ref;
	da_scm_fluid_set_x scm_fluid_set_x;
	da_scm_fluid_unset_x scm_fluid_unset_x;
	da_scm_fluid_bound_p scm_fluid_bound_p;
	da_scm_with_fluid scm_with_fluid;
	da_scm_with_fluids scm_with_fluids;
	da_scm_c_with_fluids scm_c_with_fluids;
	da_scm_c_with_fluid scm_c_with_fluid;
	da_scm_dynwind_fluid scm_dynwind_fluid;
	da_scm_make_dynamic_state scm_make_dynamic_state;
	da_scm_dynamic_state_p scm_dynamic_state_p;
	da_scm_current_dynamic_state scm_current_dynamic_state;
	da_scm_set_current_dynamic_state scm_set_current_dynamic_state;
	da_scm_with_dynamic_state scm_with_dynamic_state;

	//6.22.1 Configuration, Build and Installation
	da_scm_version scm_version;
	da_scm_effective_version scm_effective_version;
	da_scm_major_version scm_major_version;
	da_scm_minor_version scm_minor_version;
	da_scm_micro_version scm_micro_version;
	da_scm_sys_package_data_dir scm_sys_package_data_dir;
	da_scm_sys_library_dir scm_sys_library_dir;
	da_scm_sys_site_dir scm_sys_site_dir;
	da_scm_sys_site_ccache_dir scm_sys_site_ccache_dir;

	//6.22.2.1 Feature Manipulation
	da_scm_add_feature scm_add_feature;

	//6.24.1 Internationalization with Guile
	da_scm_make_locale scm_make_locale;
	da_scm_locale_p scm_locale_p;

	//6.24.2 Text Collation
	da_scm_string_locale_lt scm_string_locale_lt;
	da_scm_string_locale_gt scm_string_locale_gt;
	da_scm_string_locale_ci_lt scm_string_locale_ci_lt;
	da_scm_string_locale_ci_gt scm_string_locale_ci_gt;
	da_scm_string_locale_ci_eq scm_string_locale_ci_eq;
	da_scm_char_locale_lt scm_char_locale_lt;
	da_scm_char_locale_gt scm_char_locale_gt;
	da_scm_char_locale_ci_lt scm_char_locale_ci_lt;
	da_scm_char_locale_ci_gt scm_char_locale_ci_gt;
	da_scm_char_locale_ci_eq scm_char_locale_ci_eq;

	//6.24.3 Character Case Mapping
	da_scm_char_locale_upcase scm_char_locale_upcase;
	da_scm_char_locale_downcase scm_char_locale_downcase;
	da_scm_char_locale_titlecase scm_char_locale_titlecase;
	da_scm_string_locale_upcase scm_string_locale_upcase;
	da_scm_string_locale_downcase scm_string_locale_downcase;
	da_scm_string_locale_titlecase scm_string_locale_titlecase;

	//6.24.4 Number Input and Output
	da_scm_locale_string_to_integer scm_locale_string_to_integer;
	da_scm_locale_string_to_inexact scm_locale_string_to_inexact;

	//6.24.6 Gettext Support
	da_scm_gettext scm_gettext;
	da_scm_ngettext scm_ngettext;
	da_scm_textdomain scm_textdomain;
	da_scm_bindtextdomain scm_bindtextdomain;
	da_scm_bind_textdomain_codeset scm_bind_textdomain_codeset;

	//6.25.1.1 Stack Capture
	da_scm_make_stack scm_make_stack;

	//6.25.1.2 Stacks
	da_scm_stack_p scm_stack_p;
	da_scm_stack_id scm_stack_id;
	da_scm_stack_length scm_stack_length;
	da_scm_stack_ref scm_stack_ref;
	da_scm_display_backtrace_with_highlights scm_display_backtrace_with_highlights;
	da_scm_display_backtrace scm_display_backtrace;

	//6.25.1.3 Frames
	da_scm_frame_p scm_frame_p;
	da_scm_frame_previous scm_frame_previous;
	da_scm_frame_procedure scm_frame_procedure;
	da_scm_frame_arguments scm_frame_arguments;
	da_scm_display_application scm_display_application;

	//6.25.2 Source Properties
	da_scm_supports_source_properties_p scm_supports_source_properties_p;
	da_scm_set_source_properties_x scm_set_source_properties_x;
	da_scm_set_source_property_x scm_set_source_property_x;
	da_scm_source_properties scm_source_properties;
	da_scm_source_property scm_source_property;
	da_scm_cons_source scm_cons_source;

	//6.25.3.3 Pre-Unwind Debugging
	da_scm_backtrace_with_highlights scm_backtrace_with_highlights;
	da_scm_backtrace scm_backtrace;

	//7.2.2 Ports and File Descriptors
	da_scm_port_revealed scm_port_revealed;
	da_scm_set_port_revealed_x scm_set_port_revealed_x;
	da_scm_fileno scm_fileno;
	da_scm_fdopen scm_fdopen;
	da_scm_fdes_to_ports scm_fdes_to_ports;
	da_scm_primitive_move_to_fdes scm_primitive_move_to_fdes;
	da_scm_fsync scm_fsync;
	da_scm_open scm_open;
	da_scm_open_fdes scm_open_fdes;
	da_scm_close scm_close;
	da_scm_close_fdes scm_close_fdes;
	da_scm_pipe scm_pipe;
	da_scm_dup_to_fdes scm_dup_to_fdes;
	da_scm_redirect_port scm_redirect_port;
	da_scm_dup2 scm_dup2;
	da_scm_port_for_each scm_port_for_each;
	da_scm_c_port_for_each scm_c_port_for_each;
	da_scm_setvbuf scm_setvbuf;
	da_scm_fcntl scm_fcntl;
	da_scm_flock scm_flock;
	da_scm_select scm_select;

	//7.2.3 File System
	da_scm_access scm_access;
	da_scm_stat scm_stat;
	da_scm_lstat scm_lstat;
	da_scm_readlink scm_readlink;
	da_scm_chown scm_chown;
	da_scm_chmod scm_chmod;
	da_scm_utime scm_utime;
	da_scm_delete_file scm_delete_file;
	da_scm_copy_file scm_copy_file;
	da_scm_sendfile scm_sendfile;
	da_scm_rename scm_rename;
	da_scm_link scm_link;
	da_scm_symlink scm_symlink;
	da_scm_mkdir scm_mkdir;
	da_scm_rmdir scm_rmdir;
	da_scm_opendir scm_opendir;
	da_scm_directory_stream_p scm_directory_stream_p;
	da_scm_readdir scm_readdir;
	da_scm_rewinddir scm_rewinddir;
	da_scm_closedir scm_closedir;
	da_scm_sync scm_sync;
	da_scm_mknod scm_mknod;
	da_scm_tmpnam scm_tmpnam;
	da_scm_mkstemp scm_mkstemp;
	da_scm_tmpfile scm_tmpfile;
	da_scm_dirname scm_dirname;
	da_scm_basename scm_basename;

	//7.2.4 User Information
	da_scm_setpwent scm_setpwent;
	da_scm_getpwuid scm_getpwuid;
	da_scm_setgrent scm_setgrent;
	da_scm_getgrgid scm_getgrgid;
	da_scm_getlogin scm_getlogin;

	//7.2.5 Time
	da_scm_current_time scm_current_time;
	da_scm_gettimeofday scm_gettimeofday;
	da_scm_localtime scm_localtime;
	da_scm_gmtime scm_gmtime;
	da_scm_mktime scm_mktime;
	da_scm_tzset scm_tzset;
	da_scm_strftime scm_strftime;
	da_scm_strptime scm_strptime;
	da_scm_times scm_times;
	da_scm_get_internal_real_time scm_get_internal_real_time;
	da_scm_get_internal_run_time scm_get_internal_run_time;

	//7.2.6 Runtime Environment
	da_scm_program_arguments scm_program_arguments;
	da_scm_set_program_arguments_scm scm_set_program_arguments_scm;
	da_scm_set_program_arguments scm_set_program_arguments;
	da_scm_getenv scm_getenv;
	da_scm_environ scm_environ;
	da_scm_putenv scm_putenv;

	//7.2.7 Processes
	da_scm_chdir scm_chdir;
	da_scm_getcwd scm_getcwd;
	da_scm_umask scm_umask;
	da_scm_chroot scm_chroot;
	da_scm_getpid scm_getpid;
	da_scm_getgroups scm_getgroups;
	da_scm_getppid scm_getppid;
	da_scm_getuid scm_getuid;
	da_scm_getgid scm_getgid;
	da_scm_geteuid scm_geteuid;
	da_scm_getegid scm_getegid;
	da_scm_setgroups scm_setgroups;
	da_scm_setuid scm_setuid;
	da_scm_setgid scm_setgid;
	da_scm_seteuid scm_seteuid;
	da_scm_setegid scm_setegid;
	da_scm_getpgrp scm_getpgrp;
	da_scm_setpgid scm_setpgid;
	da_scm_setsid scm_setsid;
	da_scm_getsid scm_getsid;
	da_scm_waitpid scm_waitpid;
	da_scm_status_exit_val scm_status_exit_val;
	da_scm_status_term_sig scm_status_term_sig;
	da_scm_status_stop_sig scm_status_stop_sig;
	da_scm_system scm_system;
	da_scm_system_star scm_system_star;
	da_scm_primitive_exit scm_primitive_exit;
	da_scm_primitive__exit scm_primitive__exit;
	da_scm_execl scm_execl;
	da_scm_execlp scm_execlp;
	da_scm_execle scm_execle;
	da_scm_fork scm_fork;
	da_scm_nice scm_nice;
	da_scm_setpriority scm_setpriority;
	da_scm_getpriority scm_getpriority;
	da_scm_getaffinity scm_getaffinity;
	da_scm_setaffinity scm_setaffinity;
	da_scm_total_processor_count scm_total_processor_count;
	da_scm_current_processor_count scm_current_processor_count;

	//7.2.8 Signals
	da_scm_kill scm_kill;
	da_scm_raise scm_raise;
	da_scm_sigaction scm_sigaction;
	da_scm_sigaction_for_thread scm_sigaction_for_thread;
	da_scm_alarm scm_alarm;
	da_scm_pause scm_pause;
	da_scm_sleep scm_sleep;
	da_scm_usleep scm_usleep;
	da_scm_getitimer scm_getitimer;
	da_scm_setitimer scm_setitimer;

	//7.2.9 Terminals and Ptys
	da_scm_isatty_p scm_isatty_p;
	da_scm_ttyname scm_ttyname;
	da_scm_ctermid scm_ctermid;
	da_scm_tcgetpgrp scm_tcgetpgrp;
	da_scm_tcsetpgrp scm_tcsetpgrp;

	//7.2.11.1 Network Address Conversion
	da_scm_inet_aton scm_inet_aton;
	da_scm_inet_ntoa scm_inet_ntoa;
	da_scm_inet_netof scm_inet_netof;
	da_scm_lnaof scm_lnaof;
	da_scm_inet_makeaddr scm_inet_makeaddr;
	da_scm_inet_ntop scm_inet_ntop;
	da_scm_inet_pton scm_inet_pton;

	//7.2.11.2 Network Databases
	da_scm_getaddrinfo scm_getaddrinfo;
	da_scm_gethost scm_gethost;
	da_scm_sethost scm_sethost;
	da_scm_getnet scm_getnet;
	da_scm_setnet scm_setnet;
	da_scm_getproto scm_getproto;
	da_scm_setproto scm_setproto;
	da_scm_getserv scm_getserv;
	da_scm_setserv scm_setserv;

	//7.2.11.3 Network Socket Address
	da_scm_make_socket_address scm_make_socket_address;
	da_scm_c_make_socket_address scm_c_make_socket_address;
	da_scm_from_sockaddr scm_from_sockaddr;
	da_scm_to_sockaddr scm_to_sockaddr;

	//7.2.11.4 Network Sockets and Communication
	da_scm_socket scm_socket;
	da_scm_socketpair scm_socketpair;
	da_scm_getsockopt scm_getsockopt;
	da_scm_setsockopt scm_setsockopt;
	da_scm_shutdown scm_shutdown;
	da_scm_connect scm_connect;
	da_scm_bind scm_bind;
	da_scm_listen scm_listen;
	da_scm_accept scm_accept;
	da_scm_getsockname scm_getsockname;
	da_scm_getpeername scm_getpeername;
	da_scm_recv scm_recv;
	da_scm_send scm_send;
	da_scm_recvfrom scm_recvfrom;
	da_scm_sendto scm_sendto;

	//7.2.12 System Identification
	da_scm_uname scm_uname;
	da_scm_gethostname scm_gethostname;
	da_scm_sethostname scm_sethostname;

	//7.2.13 Locales
	da_scm_setlocale scm_setlocale;

	//7.2.14 Encryption
	da_scm_crypt scm_crypt;
	da_scm_getpass scm_getpass;

	//7.5.5.2 SRFI-4 - API
	da_scm_u8vector_p scm_u8vector_p;
	da_scm_s8vector_p scm_s8vector_p;
	da_scm_u16vector_p scm_u16vector_p;
	da_scm_s16vector_p scm_s16vector_p;
	da_scm_u32vector_p scm_u32vector_p;
	da_scm_s32vector_p scm_s32vector_p;
	da_scm_u64vector_p scm_u64vector_p;
	da_scm_s64vector_p scm_s64vector_p;
	da_scm_f32vector_p scm_f32vector_p;
	da_scm_f64vector_p scm_f64vector_p;
	da_scm_c32vector_p scm_c32vector_p;
	da_scm_c64vector_p scm_c64vector_p;
	da_scm_make_u8vector scm_make_u8vector;
	da_scm_make_s8vector scm_make_s8vector;
	da_scm_make_u16vector scm_make_u16vector;
	da_scm_make_s16vector scm_make_s16vector;
	da_scm_make_u32vector scm_make_u32vector;
	da_scm_make_s32vector scm_make_s32vector;
	da_scm_make_u64vector scm_make_u64vector;
	da_scm_make_s64vector scm_make_s64vector;
	da_scm_make_f32vector scm_make_f32vector;
	da_scm_make_f64vector scm_make_f64vector;
	da_scm_make_c32vector scm_make_c32vector;
	da_scm_make_c64vector scm_make_c64vector;
	da_scm_u8vector scm_u8vector;
	da_scm_s8vector scm_s8vector;
	da_scm_u16vector scm_u16vector;
	da_scm_s16vector scm_s16vector;
	da_scm_u32vector scm_u32vector;
	da_scm_s32vector scm_s32vector;
	da_scm_u64vector scm_u64vector;
	da_scm_s64vector scm_s64vector;
	da_scm_f32vector scm_f32vector;
	da_scm_f64vector scm_f64vector;
	da_scm_c32vector scm_c32vector;
	da_scm_c64vector scm_c64vector;
	da_scm_u8vector_length scm_u8vector_length;
	da_scm_s8vector_length scm_s8vector_length;
	da_scm_u16vector_length scm_u16vector_length;
	da_scm_s16vector_length scm_s16vector_length;
	da_scm_u32vector_length scm_u32vector_length;
	da_scm_s32vector_length scm_s32vector_length;
	da_scm_u64vector_length scm_u64vector_length;
	da_scm_s64vector_length scm_s64vector_length;
	da_scm_f32vector_length scm_f32vector_length;
	da_scm_f64vector_length scm_f64vector_length;
	da_scm_c32vector_length scm_c32vector_length;
	da_scm_c64vector_length scm_c64vector_length;
	da_scm_u8vector_ref scm_u8vector_ref;
	da_scm_s8vector_ref scm_s8vector_ref;
	da_scm_u16vector_ref scm_u16vector_ref;
	da_scm_s16vector_ref scm_s16vector_ref;
	da_scm_u32vector_ref scm_u32vector_ref;
	da_scm_s32vector_ref scm_s32vector_ref;
	da_scm_u64vector_ref scm_u64vector_ref;
	da_scm_s64vector_ref scm_s64vector_ref;
	da_scm_f32vector_ref scm_f32vector_ref;
	da_scm_f64vector_ref scm_f64vector_ref;
	da_scm_c32vector_ref scm_c32vector_ref;
	da_scm_c64vector_ref scm_c64vector_ref;
	da_scm_u8vector_set_x scm_u8vector_set_x;
	da_scm_s8vector_set_x scm_s8vector_set_x;
	da_scm_u16vector_set_x scm_u16vector_set_x;
	da_scm_s16vector_set_x scm_s16vector_set_x;
	da_scm_u32vector_set_x scm_u32vector_set_x;
	da_scm_s32vector_set_x scm_s32vector_set_x;
	da_scm_u64vector_set_x scm_u64vector_set_x;
	da_scm_s64vector_set_x scm_s64vector_set_x;
	da_scm_f32vector_set_x scm_f32vector_set_x;
	da_scm_f64vector_set_x scm_f64vector_set_x;
	da_scm_c32vector_set_x scm_c32vector_set_x;
	da_scm_c64vector_set_x scm_c64vector_set_x;
	da_scm_u8vector_to_list scm_u8vector_to_list;
	da_scm_s8vector_to_list scm_s8vector_to_list;
	da_scm_u16vector_to_list scm_u16vector_to_list;
	da_scm_s16vector_to_list scm_s16vector_to_list;
	da_scm_u32vector_to_list scm_u32vector_to_list;
	da_scm_s32vector_to_list scm_s32vector_to_list;
	da_scm_u64vector_to_list scm_u64vector_to_list;
	da_scm_s64vector_to_list scm_s64vector_to_list;
	da_scm_f32vector_to_list scm_f32vector_to_list;
	da_scm_f64vector_to_list scm_f64vector_to_list;
	da_scm_c32vector_to_list scm_c32vector_to_list;
	da_scm_c64vector_to_list scm_c64vector_to_list;
	da_scm_list_to_u8vector scm_list_to_u8vector;
	da_scm_list_to_s8vector scm_list_to_s8vector;
	da_scm_list_to_u16vector scm_list_to_u16vector;
	da_scm_list_to_s16vector scm_list_to_s16vector;
	da_scm_list_to_u32vector scm_list_to_u32vector;
	da_scm_list_to_s32vector scm_list_to_s32vector;
	da_scm_list_to_u64vector scm_list_to_u64vector;
	da_scm_list_to_s64vector scm_list_to_s64vector;
	da_scm_list_to_f32vector scm_list_to_f32vector;
	da_scm_list_to_f64vector scm_list_to_f64vector;
	da_scm_list_to_c32vector scm_list_to_c32vector;
	da_scm_list_to_c64vector scm_list_to_c64vector;
	da_scm_take_u8vector scm_take_u8vector;
	da_scm_take_s8vector scm_take_s8vector;
	da_scm_take_u16vector scm_take_u16vector;
	da_scm_take_s16vector scm_take_s16vector;
	da_scm_take_u32vector scm_take_u32vector;
	da_scm_take_s32vector scm_take_s32vector;
	da_scm_take_u64vector scm_take_u64vector;
	da_scm_take_s64vector scm_take_s64vector;
	da_scm_take_f32vector scm_take_f32vector;
	da_scm_take_f64vector scm_take_f64vector;
	da_scm_take_c32vector scm_take_c32vector;
	da_scm_take_c64vector scm_take_c64vector;
	da_scm_u8vector_elements scm_u8vector_elements;
	da_scm_s8vector_elements scm_s8vector_elements;
	da_scm_u16vector_elements scm_u16vector_elements;
	da_scm_s16vector_elements scm_s16vector_elements;
	da_scm_u32vector_elements scm_u32vector_elements;
	da_scm_s32vector_elements scm_s32vector_elements;
	da_scm_u64vector_elements scm_u64vector_elements;
	da_scm_s64vector_elements scm_s64vector_elements;
	da_scm_f32vector_elements scm_f32vector_elements;
	da_scm_f64vector_elements scm_f64vector_elements;
	da_scm_c32vector_elements scm_c32vector_elements;
	da_scm_c64vector_elements scm_c64vector_elements;
	da_scm_u8vector_writable_elements scm_u8vector_writable_elements;
	da_scm_s8vector_writable_elements scm_s8vector_writable_elements;
	da_scm_u16vector_writable_elements scm_u16vector_writable_elements;
	da_scm_s16vector_writable_elements scm_s16vector_writable_elements;
	da_scm_u32vector_writable_elements scm_u32vector_writable_elements;
	da_scm_s32vector_writable_elements scm_s32vector_writable_elements;
	da_scm_u64vector_writable_elements scm_u64vector_writable_elements;
	da_scm_s64vector_writable_elements scm_s64vector_writable_elements;
	da_scm_f32vector_writable_elements scm_f32vector_writable_elements;
	da_scm_f64vector_writable_elements scm_f64vector_writable_elements;
	da_scm_c32vector_writable_elements scm_c32vector_writable_elements;
	da_scm_c64vector_writable_elements scm_c64vector_writable_elements;

	//7.5.5.4 SRFI-4 - Guile extensions
	da_scm_any_to_u8vector scm_any_to_u8vector;
	da_scm_any_to_s8vector scm_any_to_s8vector;
	da_scm_any_to_u16vector scm_any_to_u16vector;
	da_scm_any_to_s16vector scm_any_to_s16vector;
	da_scm_any_to_u32vector scm_any_to_u32vector;
	da_scm_any_to_s32vector scm_any_to_s32vector;
	da_scm_any_to_u64vector scm_any_to_u64vector;
	da_scm_any_to_s64vector scm_any_to_s64vector;
	da_scm_any_to_f32vector scm_any_to_f32vector;
	da_scm_any_to_f64vector scm_any_to_f64vector;
	da_scm_any_to_c32vector scm_any_to_c32vector;
	da_scm_any_to_c64vector scm_any_to_c64vector;

	//9.4.6 Bytecode and Objcode
	da_scm_objcode_p scm_objcode_p;
	da_scm_bytecode_to_objcode scm_bytecode_to_objcode;
	da_scm_load_objcode scm_load_objcode;
	da_scm_write_objcode scm_write_objcode;
	da_scm_objcode_to_bytecode scm_objcode_to_bytecode;
	da_scm_make_program scm_make_program;

}

class DerelictGuileLoader : SharedLibLoader {

	public this() {
		super(libNames);
	}

	protected override void loadSymbols() {

		//6.4 Initializing Guile
		bindFunc(cast(void**)&scm_with_guile, "scm_with_guile");
		bindFunc(cast(void**)&scm_init_guile, "scm_init_guile");
		bindFunc(cast(void**)&scm_boot_guile, "scm_boot_guile");
		bindFunc(cast(void**)&scm_shell, "scm_shell");

		//6.6.1 Booleans
		bindFunc(cast(void**)&scm_not, "scm_not");
		bindFunc(cast(void**)&scm_boolean_p, "scm_boolean_p");
		bindFunc(cast(void**)&scm_is_bool, "scm_is_bool");
		bindFunc(cast(void**)&scm_to_bool, "scm_to_bool");

		//6.6.2.1 Scheme’s Numerical “Tower”
		bindFunc(cast(void**)&scm_number_p, "scm_number_p");
		bindFunc(cast(void**)&scm_is_number, "scm_is_number");

		//6.6.2.2 Integers
		bindFunc(cast(void**)&scm_integer_p, "scm_integer_p");
		bindFunc(cast(void**)&scm_is_integer, "scm_is_integer");
		bindFunc(cast(void**)&scm_exact_integer_p, "scm_exact_integer_p");
		bindFunc(cast(void**)&scm_is_exact_integer, "scm_is_exact_integer");
		bindFunc(cast(void**)&scm_is_signed_integer, "scm_is_signed_integer");
		bindFunc(cast(void**)&scm_is_unsigned_integer, "scm_is_unsigned_integer");
		bindFunc(cast(void**)&scm_to_signed_integer, "scm_to_signed_integer");
		bindFunc(cast(void**)&scm_to_unsigned_integer, "scm_to_unsigned_integer");
		bindFunc(cast(void**)&scm_from_signed_integer, "scm_from_signed_integer");
		bindFunc(cast(void**)&scm_from_unsigned_integer, "scm_from_unsigned_integer");
		bindFunc(cast(void**)&scm_to_int8, "scm_to_int8");
		bindFunc(cast(void**)&scm_to_uint8, "scm_to_uint8");
		bindFunc(cast(void**)&scm_to_int16, "scm_to_int16");
		bindFunc(cast(void**)&scm_to_uint16, "scm_to_uint16");
		bindFunc(cast(void**)&scm_to_int32, "scm_to_int32");
		bindFunc(cast(void**)&scm_to_uint32, "scm_to_uint32");
		bindFunc(cast(void**)&scm_to_int64, "scm_to_int64");
		bindFunc(cast(void**)&scm_to_uint64, "scm_to_uint64");
		bindFunc(cast(void**)&scm_from_int8, "scm_from_int8");
		bindFunc(cast(void**)&scm_from_uint8, "scm_from_uint8");
		bindFunc(cast(void**)&scm_from_int16, "scm_from_int16");
		bindFunc(cast(void**)&scm_from_uint16, "scm_from_uint16");
		bindFunc(cast(void**)&scm_from_int32, "scm_from_int32");
		bindFunc(cast(void**)&scm_from_uint32, "scm_from_uint32");
		bindFunc(cast(void**)&scm_from_int64, "scm_from_int64");
		bindFunc(cast(void**)&scm_from_uint64, "scm_from_uint64");

		/* excluded for now
		bindFunc(cast(void**)&scm_to_mpz, "scm_to_mpz");
		bindFunc(cast(void**)&scm_from_mpz, "scm_from_mpz");
		*/

		//6.6.2.3 Real and Rational Numbers
		bindFunc(cast(void**)&scm_real_p, "scm_real_p");
		bindFunc(cast(void**)&scm_rational_p, "scm_rational_p");
		bindFunc(cast(void**)&scm_rationalize, "scm_rationalize");
		bindFunc(cast(void**)&scm_inf_p, "scm_inf_p");
		bindFunc(cast(void**)&scm_nan_p, "scm_nan_p");
		bindFunc(cast(void**)&scm_finite_p, "scm_finite_p");
		bindFunc(cast(void**)&scm_inf, "scm_inf");
		bindFunc(cast(void**)&scm_nan, "scm_nan");
		bindFunc(cast(void**)&scm_numerator, "scm_numerator");
		bindFunc(cast(void**)&scm_denominator, "scm_denominator");
		bindFunc(cast(void**)&scm_is_real, "scm_is_real");
		bindFunc(cast(void**)&scm_is_rational, "scm_is_rational");
		bindFunc(cast(void**)&scm_to_double, "scm_to_double");
		bindFunc(cast(void**)&scm_from_double, "scm_from_double");

		//6.6.2.4 Complex Numbers
		bindFunc(cast(void**)&scm_complex_p, "scm_complex_p");
		bindFunc(cast(void**)&scm_is_complex, "scm_is_complex");

		//6.6.2.5 Exact and Inexact Numbers
		bindFunc(cast(void**)&scm_exact_p, "scm_exact_p");
		bindFunc(cast(void**)&scm_is_exact, "scm_is_exact");
		bindFunc(cast(void**)&scm_inexact_p, "scm_inexact_p");
		bindFunc(cast(void**)&scm_is_inexact, "scm_is_inexact");
		bindFunc(cast(void**)&scm_inexact_to_exact, "scm_inexact_to_exact");
		bindFunc(cast(void**)&scm_exact_to_inexact, "scm_exact_to_inexact");

		//6.6.2.7 Operations on Integer Values
		bindFunc(cast(void**)&scm_odd_p, "scm_odd_p");
		bindFunc(cast(void**)&scm_even_p, "scm_even_p");
		bindFunc(cast(void**)&scm_quotient, "scm_quotient");
		bindFunc(cast(void**)&scm_remainder, "scm_remainder");
		bindFunc(cast(void**)&scm_modulo, "scm_modulo");
		bindFunc(cast(void**)&scm_gcd, "scm_gcd");
		bindFunc(cast(void**)&scm_lcm, "scm_lcm");
		bindFunc(cast(void**)&scm_modulo_expt, "scm_modulo_expt");
		bindFunc(cast(void**)&scm_exact_integer_sqrt, "scm_exact_integer_sqrt");

		//6.6.2.8 Comparison Predicates
		bindFunc(cast(void**)&scm_num_eq_p, "scm_num_eq_p");
		bindFunc(cast(void**)&scm_less_p, "scm_less_p");
		bindFunc(cast(void**)&scm_gr_p, "scm_gr_p");
		bindFunc(cast(void**)&scm_leq_p, "scm_leq_p");
		bindFunc(cast(void**)&scm_geq_p, "scm_geq_p");
		bindFunc(cast(void**)&scm_zero_p, "scm_zero_p");
		bindFunc(cast(void**)&scm_positive_p, "scm_positive_p");
		bindFunc(cast(void**)&scm_negative_p, "scm_negative_p");

		//6.6.2.9 Converting Numbers To and From Strings
		bindFunc(cast(void**)&scm_number_to_string, "scm_number_to_string");
		bindFunc(cast(void**)&scm_string_to_number, "scm_string_to_number");
		bindFunc(cast(void**)&scm_c_locale_stringn_to_number, "scm_c_locale_stringn_to_number");

		//6.6.2.10 Complex Number Operations
		bindFunc(cast(void**)&scm_make_rectangular, "scm_make_rectangular");
		bindFunc(cast(void**)&scm_make_polar, "scm_make_polar");
		bindFunc(cast(void**)&scm_real_part, "scm_real_part");
		bindFunc(cast(void**)&scm_imag_part, "scm_imag_part");
		bindFunc(cast(void**)&scm_magnitude, "scm_magnitude");
		bindFunc(cast(void**)&scm_angle, "scm_angle");
		bindFunc(cast(void**)&scm_c_make_rectangular, "scm_c_make_rectangular");
		bindFunc(cast(void**)&scm_c_make_polar, "scm_c_make_polar");
		bindFunc(cast(void**)&scm_c_real_part, "scm_c_real_part");
		bindFunc(cast(void**)&scm_c_imag_part, "scm_c_imag_part");
		bindFunc(cast(void**)&scm_c_magnitude, "scm_c_magnitude");
		bindFunc(cast(void**)&scm_c_angle, "scm_c_angle");

		//6.6.2.11 Arithmetic Functions
		bindFunc(cast(void**)&scm_sum, "scm_sum");
		bindFunc(cast(void**)&scm_difference, "scm_difference");
		bindFunc(cast(void**)&scm_product, "scm_product");
		bindFunc(cast(void**)&scm_divide, "scm_divide");
		bindFunc(cast(void**)&scm_oneplus, "scm_oneplus");
		bindFunc(cast(void**)&scm_abs, "scm_abs");
		bindFunc(cast(void**)&scm_max, "scm_max");
		bindFunc(cast(void**)&scm_min, "scm_min");
		bindFunc(cast(void**)&scm_truncate_number, "scm_truncate_number");
		bindFunc(cast(void**)&scm_round_number, "scm_round_number");
		bindFunc(cast(void**)&scm_floor, "scm_floor");
		bindFunc(cast(void**)&scm_ceiling, "scm_ceiling");
		bindFunc(cast(void**)&scm_c_truncate, "scm_c_truncate");
		bindFunc(cast(void**)&scm_c_round, "scm_c_round");
		bindFunc(cast(void**)&scm_euclidean_divide, "scm_euclidean_divide");
		bindFunc(cast(void**)&scm_euclidean_quotient, "scm_euclidean_quotient");
		bindFunc(cast(void**)&scm_euclidean_remainder, "scm_euclidean_remainder");
		bindFunc(cast(void**)&scm_floor_divide, "scm_floor_divide");
		bindFunc(cast(void**)&scm_floor_quotient, "scm_floor_quotient");
		bindFunc(cast(void**)&scm_floor_remainder, "scm_floor_remainder");
		bindFunc(cast(void**)&scm_ceiling_divide, "scm_ceiling_divide");
		bindFunc(cast(void**)&scm_ceiling_quotient, "scm_ceiling_quotient");
		bindFunc(cast(void**)&scm_ceiling_remainder, "scm_ceiling_remainder");
		bindFunc(cast(void**)&scm_truncate_divide, "scm_truncate_divide");
		bindFunc(cast(void**)&scm_truncate_quotient, "scm_truncate_quotient");
		bindFunc(cast(void**)&scm_truncate_remainder, "scm_truncate_remainder");
		bindFunc(cast(void**)&scm_centered_divide, "scm_centered_divide");
		bindFunc(cast(void**)&scm_centered_quotient, "scm_centered_quotient");
		bindFunc(cast(void**)&scm_centered_remainder, "scm_centered_remainder");
		bindFunc(cast(void**)&scm_round_divide, "scm_round_divide");
		bindFunc(cast(void**)&scm_round_quotient, "scm_round_quotient");
		bindFunc(cast(void**)&scm_round_remainder, "scm_round_remainder");

		//6.6.2.13 Bitwise Operations
		bindFunc(cast(void**)&scm_logand, "scm_logand");
		bindFunc(cast(void**)&scm_logior, "scm_logior");
		bindFunc(cast(void**)&scm_logxor, "scm_logxor");
		bindFunc(cast(void**)&scm_lognot, "scm_lognot");
		bindFunc(cast(void**)&scm_logtest, "scm_logtest");
		bindFunc(cast(void**)&scm_logbit_p, "scm_logbit_p");
		bindFunc(cast(void**)&scm_ash, "scm_ash");
		bindFunc(cast(void**)&scm_round_ash, "scm_round_ash");
		bindFunc(cast(void**)&scm_logcount, "scm_logcount");
		bindFunc(cast(void**)&scm_integer_length, "scm_integer_length");
		bindFunc(cast(void**)&scm_integer_expt, "scm_integer_expt");
		bindFunc(cast(void**)&scm_bit_extract, "scm_bit_extract");

		//6.6.2.14 Random Number Generation
		bindFunc(cast(void**)&scm_copy_random_state, "scm_copy_random_state");
		bindFunc(cast(void**)&scm_random, "scm_random");
		bindFunc(cast(void**)&scm_random_exp, "scm_random_exp");
		bindFunc(cast(void**)&scm_random_hollow_sphere_x, "scm_random_hollow_sphere_x");
		bindFunc(cast(void**)&scm_random_normal, "scm_random_normal");
		bindFunc(cast(void**)&scm_random_normal_vector_x, "scm_random_normal_vector_x");
		bindFunc(cast(void**)&scm_random_solid_sphere_x, "scm_random_solid_sphere_x");
		bindFunc(cast(void**)&scm_random_uniform, "scm_random_uniform");
		bindFunc(cast(void**)&scm_seed_to_random_state, "scm_seed_to_random_state");
		bindFunc(cast(void**)&scm_datum_to_random_state, "scm_datum_to_random_state");
		bindFunc(cast(void**)&scm_random_state_to_datum, "scm_random_state_to_datum");
		bindFunc(cast(void**)&scm_random_state_from_platform, "scm_random_state_from_platform");

		//6.6.3 Characters
		bindFunc(cast(void**)&scm_char_p, "scm_char_p");
		bindFunc(cast(void**)&scm_char_alphabetic_p, "scm_char_alphabetic_p");
		bindFunc(cast(void**)&scm_char_numeric_p, "scm_char_numeric_p");
		bindFunc(cast(void**)&scm_char_whitespace_p, "scm_char_whitespace_p");
		bindFunc(cast(void**)&scm_char_upper_case_p, "scm_char_upper_case_p");
		bindFunc(cast(void**)&scm_char_lower_case_p, "scm_char_lower_case_p");
		bindFunc(cast(void**)&scm_char_is_both_p, "scm_char_is_both_p");
		bindFunc(cast(void**)&scm_char_general_category, "scm_char_general_category");
		bindFunc(cast(void**)&scm_char_to_integer, "scm_char_to_integer");
		bindFunc(cast(void**)&scm_integer_to_char, "scm_integer_to_char");
		bindFunc(cast(void**)&scm_char_upcase, "scm_char_upcase");
		bindFunc(cast(void**)&scm_char_downcase, "scm_char_downcase");
		bindFunc(cast(void**)&scm_char_titlecase, "scm_char_titlecase");
		bindFunc(cast(void**)&scm_c_upcase, "scm_c_upcase");
		bindFunc(cast(void**)&scm_c_downcase, "scm_c_downcase");
		bindFunc(cast(void**)&scm_c_titlecase, "scm_c_titlecase");

		//6.6.4.1 Character Set Predicates/Comparison
		bindFunc(cast(void**)&scm_char_set_p, "scm_char_set_p");
		bindFunc(cast(void**)&scm_char_set_eq, "scm_char_set_eq");
		bindFunc(cast(void**)&scm_char_set_leq, "scm_char_set_leq");
		bindFunc(cast(void**)&scm_char_set_hash, "scm_char_set_hash");

		//6.6.4.2 Iterating Over Character Sets
		bindFunc(cast(void**)&scm_char_set_cursor, "scm_char_set_cursor");
		bindFunc(cast(void**)&scm_char_set_ref, "scm_char_set_ref");
		bindFunc(cast(void**)&scm_char_set_cursor_next, "scm_char_set_cursor_next");
		bindFunc(cast(void**)&scm_end_of_char_set_p, "scm_end_of_char_set_p");
		bindFunc(cast(void**)&scm_char_set_fold, "scm_char_set_fold");
		bindFunc(cast(void**)&scm_char_set_unfold, "scm_char_set_unfold");
		bindFunc(cast(void**)&scm_char_set_unfold_x, "scm_char_set_unfold_x");
		bindFunc(cast(void**)&scm_char_set_for_each, "scm_char_set_for_each");
		bindFunc(cast(void**)&scm_char_set_map, "scm_char_set_map");

		//6.6.4.3 Creating Character Sets
		bindFunc(cast(void**)&scm_char_set_copy, "scm_char_set_copy");
		bindFunc(cast(void**)&scm_char_set, "scm_char_set");
		bindFunc(cast(void**)&scm_list_to_char_set, "scm_list_to_char_set");
		bindFunc(cast(void**)&scm_list_to_char_set_x, "scm_list_to_char_set_x");
		bindFunc(cast(void**)&scm_string_to_char_set, "scm_string_to_char_set");
		bindFunc(cast(void**)&scm_string_to_char_set_x, "scm_string_to_char_set_x");
		bindFunc(cast(void**)&scm_char_set_filter, "scm_char_set_filter");
		bindFunc(cast(void**)&scm_char_set_filter_x, "scm_char_set_filter_x");
		bindFunc(cast(void**)&scm_ucs_range_to_char_set, "scm_ucs_range_to_char_set");
		bindFunc(cast(void**)&scm_ucs_range_to_char_set_x, "scm_ucs_range_to_char_set_x");
		bindFunc(cast(void**)&scm_to_char_set, "scm_to_char_set");

		//6.6.4.4 Querying Character Sets
		bindFunc(cast(void**)&scm_char_set_size, "scm_char_set_size");
		bindFunc(cast(void**)&scm_char_set_count, "scm_char_set_count");
		bindFunc(cast(void**)&scm_char_set_to_list, "scm_char_set_to_list");
		bindFunc(cast(void**)&scm_char_set_to_string, "scm_char_set_to_string");
		bindFunc(cast(void**)&scm_char_set_contains_p, "scm_char_set_contains_p");
		bindFunc(cast(void**)&scm_char_set_every, "scm_char_set_every");
		bindFunc(cast(void**)&scm_char_set_any, "scm_char_set_any");

		//6.6.4.5 Character-Set Algebra
		bindFunc(cast(void**)&scm_char_set_adjoin, "scm_char_set_adjoin");
		bindFunc(cast(void**)&scm_char_set_delete, "scm_char_set_delete");
		bindFunc(cast(void**)&scm_char_set_adjoin_x, "scm_char_set_adjoin_x");
		bindFunc(cast(void**)&scm_char_set_delete_x, "scm_char_set_delete_x");
		bindFunc(cast(void**)&scm_char_set_complement, "scm_char_set_complement");
		bindFunc(cast(void**)&scm_char_set_union, "scm_char_set_union");
		bindFunc(cast(void**)&scm_char_set_intersection, "scm_char_set_intersection");
		bindFunc(cast(void**)&scm_char_set_difference, "scm_char_set_difference");
		bindFunc(cast(void**)&scm_char_set_xor, "scm_char_set_xor");
		bindFunc(cast(void**)&scm_char_set_diff_plus_intersection, "scm_char_set_diff_plus_intersection");
		bindFunc(cast(void**)&scm_char_set_complement_x, "scm_char_set_complement_x");
		bindFunc(cast(void**)&scm_char_set_union_x, "scm_char_set_union_x");
		bindFunc(cast(void**)&scm_char_set_intersection_x, "scm_char_set_intersection_x");
		bindFunc(cast(void**)&scm_char_set_difference_x, "scm_char_set_difference_x");
		bindFunc(cast(void**)&scm_char_set_xor_x, "scm_char_set_xor_x");
		bindFunc(cast(void**)&scm_char_set_diff_plus_intersection_x, "scm_char_set_diff_plus_intersection_x");

		//6.6.5.2 String Predicates
		bindFunc(cast(void**)&scm_string_p, "scm_string_p");
		bindFunc(cast(void**)&scm_is_string, "scm_is_string");
		bindFunc(cast(void**)&scm_string_null_p, "scm_string_null_p");
		bindFunc(cast(void**)&scm_string_any, "scm_string_any");
		bindFunc(cast(void**)&scm_string_every, "scm_string_every");

		//6.6.5.3 String Constructors
		bindFunc(cast(void**)&scm_string, "scm_string");
		bindFunc(cast(void**)&scm_reverse_list_to_string, "scm_reverse_list_to_string");
		bindFunc(cast(void**)&scm_make_string, "scm_make_string");
		bindFunc(cast(void**)&scm_c_make_string, "scm_c_make_string");
		bindFunc(cast(void**)&scm_string_tabulate, "scm_string_tabulate");
		bindFunc(cast(void**)&scm_string_join, "scm_string_join");

		//6.6.5.4 List/String conversion
		bindFunc(cast(void**)&scm_substring_to_list, "scm_substring_to_list");
		bindFunc(cast(void**)&scm_string_to_list, "scm_string_to_list");
		bindFunc(cast(void**)&scm_string_split, "scm_string_split");

		//6.6.5.5 String Selection
		bindFunc(cast(void**)&scm_string_length, "scm_string_length");
		bindFunc(cast(void**)&scm_c_string_length, "scm_c_string_length");
		bindFunc(cast(void**)&scm_string_ref, "scm_string_ref");
		bindFunc(cast(void**)&scm_c_string_ref, "scm_c_string_ref");
		bindFunc(cast(void**)&scm_substring_copy, "scm_substring_copy");
		bindFunc(cast(void**)&scm_string_copy, "scm_string_copy");
		bindFunc(cast(void**)&scm_substring, "scm_substring");
		bindFunc(cast(void**)&scm_substring_shared, "scm_substring_shared");
		bindFunc(cast(void**)&scm_substring_read_only, "scm_substring_read_only");
		bindFunc(cast(void**)&scm_c_substring, "scm_c_substring");
		bindFunc(cast(void**)&scm_c_substring_shared, "scm_c_substring_shared");
		bindFunc(cast(void**)&scm_c_substring_copy, "scm_c_substring_copy");
		bindFunc(cast(void**)&scm_c_substring_read_only, "scm_c_substring_read_only");
		bindFunc(cast(void**)&scm_string_take, "scm_string_take");
		bindFunc(cast(void**)&scm_string_drop, "scm_string_drop");
		bindFunc(cast(void**)&scm_string_take_right, "scm_string_take_right");
		bindFunc(cast(void**)&scm_string_drop_right, "scm_string_drop_right");
		bindFunc(cast(void**)&scm_string_pad, "scm_string_pad");
		bindFunc(cast(void**)&scm_string_pad_right, "scm_string_pad_right");
		bindFunc(cast(void**)&scm_string_trim, "scm_string_trim");
		bindFunc(cast(void**)&scm_string_trim_right, "scm_string_trim_right");
		bindFunc(cast(void**)&scm_string_trim_both, "scm_string_trim_both");

		//6.6.5.6 String Modification
		bindFunc(cast(void**)&scm_string_set_x, "scm_string_set_x");
		bindFunc(cast(void**)&scm_c_string_set_x, "scm_c_string_set_x");
		bindFunc(cast(void**)&scm_substring_fill_x, "scm_substring_fill_x");
		bindFunc(cast(void**)&scm_string_fill_x, "scm_string_fill_x");
		bindFunc(cast(void**)&scm_substring_fill_x, "scm_substring_fill_x");
		bindFunc(cast(void**)&scm_substring_move_x, "scm_substring_move_x");
		bindFunc(cast(void**)&scm_string_copy_x, "scm_string_copy_x");

		//6.6.5.7 String Comparison
		bindFunc(cast(void**)&scm_string_compare, "scm_string_compare");
		bindFunc(cast(void**)&scm_string_compare_ci, "scm_string_compare_ci");
		bindFunc(cast(void**)&scm_string_eq, "scm_string_eq");
		bindFunc(cast(void**)&scm_string_neq, "scm_string_neq");
		bindFunc(cast(void**)&scm_string_lt, "scm_string_lt");
		bindFunc(cast(void**)&scm_string_gt, "scm_string_gt");
		bindFunc(cast(void**)&scm_string_le, "scm_string_le");
		bindFunc(cast(void**)&scm_string_ge, "scm_string_ge");
		bindFunc(cast(void**)&scm_string_ci_eq, "scm_string_ci_eq");
		bindFunc(cast(void**)&scm_string_ci_neq, "scm_string_ci_neq");
		bindFunc(cast(void**)&scm_string_ci_lt, "scm_string_ci_lt");
		bindFunc(cast(void**)&scm_string_ci_gt, "scm_string_ci_gt");
		bindFunc(cast(void**)&scm_string_ci_le, "scm_string_ci_le");
		bindFunc(cast(void**)&scm_string_ci_ge, "scm_string_ci_ge");
		bindFunc(cast(void**)&scm_substring_hash, "scm_substring_hash");
		bindFunc(cast(void**)&scm_substring_hash_ci, "scm_substring_hash_ci");
		bindFunc(cast(void**)&scm_string_normalize_nfd, "scm_string_normalize_nfd");
		bindFunc(cast(void**)&scm_string_normalize_nfkd, "scm_string_normalize_nfkd");
		bindFunc(cast(void**)&scm_string_normalize_nfc, "scm_string_normalize_nfc");
		bindFunc(cast(void**)&scm_string_normalize_nfkc, "scm_string_normalize_nfkc");

		//6.6.5.8 String Searching
		bindFunc(cast(void**)&scm_string_index, "scm_string_index");
		bindFunc(cast(void**)&scm_string_rindex, "scm_string_rindex");
		bindFunc(cast(void**)&scm_string_prefix_length, "scm_string_prefix_length");
		bindFunc(cast(void**)&scm_string_prefix_length_ci, "scm_string_prefix_length_ci");
		bindFunc(cast(void**)&scm_string_suffix_length, "scm_string_suffix_length");
		bindFunc(cast(void**)&scm_string_suffix_length_ci, "scm_string_suffix_length_ci");
		bindFunc(cast(void**)&scm_string_prefix_p, "scm_string_prefix_p");
		bindFunc(cast(void**)&scm_string_prefix_ci_p, "scm_string_prefix_ci_p");
		bindFunc(cast(void**)&scm_string_suffix_p, "scm_string_suffix_p");
		bindFunc(cast(void**)&scm_string_suffix_ci_p, "scm_string_suffix_ci_p");
		bindFunc(cast(void**)&scm_string_index_right, "scm_string_index_right");
		bindFunc(cast(void**)&scm_string_skip, "scm_string_skip");
		bindFunc(cast(void**)&scm_string_skip_right, "scm_string_skip_right");
		bindFunc(cast(void**)&scm_string_count, "scm_string_count");
		bindFunc(cast(void**)&scm_string_contains, "scm_string_contains");
		bindFunc(cast(void**)&scm_string_contains_ci, "scm_string_contains_ci");

		//6.6.5.9 Alphabetic Case Mapping
		bindFunc(cast(void**)&scm_substring_upcase, "scm_substring_upcase");
		bindFunc(cast(void**)&scm_string_upcase, "scm_string_upcase");
		bindFunc(cast(void**)&scm_substring_upcase_x, "scm_substring_upcase_x");
		bindFunc(cast(void**)&scm_string_upcase_x, "scm_string_upcase_x");
		bindFunc(cast(void**)&scm_substring_downcase, "scm_substring_downcase");
		bindFunc(cast(void**)&scm_string_downcase, "scm_string_downcase");
		bindFunc(cast(void**)&scm_substring_downcase_x, "scm_substring_downcase_x");
		bindFunc(cast(void**)&scm_string_downcase_x, "scm_string_downcase_x");
		bindFunc(cast(void**)&scm_string_capitalize, "scm_string_capitalize");
		bindFunc(cast(void**)&scm_string_capitalize_x, "scm_string_capitalize_x");
		bindFunc(cast(void**)&scm_string_titlecase, "scm_string_titlecase");
		bindFunc(cast(void**)&scm_string_titlecase_x, "scm_string_titlecase_x");

		//6.6.5.10 Reversing and Appending Strings
		bindFunc(cast(void**)&scm_string_reverse, "scm_string_reverse");
		bindFunc(cast(void**)&scm_string_reverse_x, "scm_string_reverse_x");
		bindFunc(cast(void**)&scm_string_append, "scm_string_append");
		bindFunc(cast(void**)&scm_string_append_shared, "scm_string_append_shared");
		bindFunc(cast(void**)&scm_string_concatenate, "scm_string_concatenate");
		bindFunc(cast(void**)&scm_string_concatenate_reverse, "scm_string_concatenate_reverse");
		bindFunc(cast(void**)&scm_string_concatenate_shared, "scm_string_concatenate_shared");
		bindFunc(cast(void**)&scm_string_concatenate_reverse_shared, "scm_string_concatenate_reverse_shared");

		//6.6.5.11 Mapping, Folding, and Unfolding
		bindFunc(cast(void**)&scm_string_map, "scm_string_map");
		bindFunc(cast(void**)&scm_string_map_x, "scm_string_map_x");
		bindFunc(cast(void**)&scm_string_for_each, "scm_string_for_each");
		bindFunc(cast(void**)&scm_string_for_each_index, "scm_string_for_each_index");
		bindFunc(cast(void**)&scm_string_fold, "scm_string_fold");
		bindFunc(cast(void**)&scm_string_fold_right, "scm_string_fold_right");
		bindFunc(cast(void**)&scm_string_unfold, "scm_string_unfold");
		bindFunc(cast(void**)&scm_string_unfold_right, "scm_string_unfold_right");

		//6.6.5.12 Miscellaneous String Operations
		bindFunc(cast(void**)&scm_xsubstring, "scm_xsubstring");
		bindFunc(cast(void**)&scm_string_xcopy_x, "scm_string_xcopy_x");
		bindFunc(cast(void**)&scm_string_replace, "scm_string_replace");
		bindFunc(cast(void**)&scm_string_tokenize, "scm_string_tokenize");
		bindFunc(cast(void**)&scm_string_filter, "scm_string_filter");
		bindFunc(cast(void**)&scm_string_delete, "scm_string_delete");

		//6.6.5.14 Conversion to/from C
		bindFunc(cast(void**)&scm_from_locale_string, "scm_from_locale_string");
		bindFunc(cast(void**)&scm_from_locale_stringn, "scm_from_locale_stringn");
		bindFunc(cast(void**)&scm_take_locale_string, "scm_take_locale_string");
		bindFunc(cast(void**)&scm_take_locale_stringn, "scm_take_locale_stringn");
		bindFunc(cast(void**)&scm_to_locale_string, "scm_to_locale_string");
		bindFunc(cast(void**)&scm_to_locale_stringn, "scm_to_locale_stringn");
		bindFunc(cast(void**)&scm_to_locale_stringbuf, "scm_to_locale_stringbuf");
		bindFunc(cast(void**)&scm_to_stringn, "scm_to_stringn");
		bindFunc(cast(void**)&scm_from_stringn, "scm_from_stringn");
		bindFunc(cast(void**)&scm_from_latin1_string, "scm_from_latin1_string");
		bindFunc(cast(void**)&scm_from_utf8_string, "scm_from_utf8_string");
		bindFunc(cast(void**)&scm_from_utf32_string, "scm_from_utf32_string");
		bindFunc(cast(void**)&scm_from_latin1_stringn, "scm_from_latin1_stringn");
		bindFunc(cast(void**)&scm_from_utf8_stringn, "scm_from_utf8_stringn");
		bindFunc(cast(void**)&scm_from_utf32_stringn, "scm_from_utf32_stringn");

		//6.6.5.15 String Internals
		bindFunc(cast(void**)&scm_string_bytes_per_char, "scm_string_bytes_per_char");
		bindFunc(cast(void**)&scm_sys_string_dump, "scm_sys_string_dump");

		//6.6.6.2 Manipulating Bytevectors
		bindFunc(cast(void**)&scm_make_bytevector, "scm_make_bytevector");
		bindFunc(cast(void**)&scm_c_make_bytevector, "scm_c_make_bytevector");
		bindFunc(cast(void**)&scm_bytevector_p, "scm_bytevector_p");
		bindFunc(cast(void**)&scm_is_bytevector, "scm_is_bytevector");
		bindFunc(cast(void**)&scm_bytevector_length, "scm_bytevector_length");
		bindFunc(cast(void**)&scm_c_bytevector_length, "scm_c_bytevector_length");
		bindFunc(cast(void**)&scm_bytevector_eq_p, "scm_bytevector_eq_p");
		bindFunc(cast(void**)&scm_bytevector_fill_x, "scm_bytevector_fill_x");
		bindFunc(cast(void**)&scm_bytevector_copy_x, "scm_bytevector_copy_x");
		bindFunc(cast(void**)&scm_bytevector_copy, "scm_bytevector_copy");
		bindFunc(cast(void**)&scm_c_bytevector_ref, "scm_c_bytevector_ref");
		bindFunc(cast(void**)&scm_c_bytevector_set_x, "scm_c_bytevector_set_x");

		//6.6.6.3 Interpreting Bytevector Contents as Integers
		bindFunc(cast(void**)&scm_bytevector_uint_ref, "scm_bytevector_uint_ref");
		bindFunc(cast(void**)&scm_bytevector_sint_ref, "scm_bytevector_sint_ref");
		bindFunc(cast(void**)&scm_bytevector_uint_set_x, "scm_bytevector_uint_set_x");
		bindFunc(cast(void**)&scm_bytevector_sint_set_x, "scm_bytevector_sint_set_x");
		bindFunc(cast(void**)&scm_bytevector_u8_ref, "scm_bytevector_u8_ref");
		bindFunc(cast(void**)&scm_bytevector_s8_ref, "scm_bytevector_s8_ref");
		bindFunc(cast(void**)&scm_bytevector_u16_ref, "scm_bytevector_u16_ref");
		bindFunc(cast(void**)&scm_bytevector_s16_ref, "scm_bytevector_s16_ref");
		bindFunc(cast(void**)&scm_bytevector_u32_ref, "scm_bytevector_u32_ref");
		bindFunc(cast(void**)&scm_bytevector_s32_ref, "scm_bytevector_s32_ref");
		bindFunc(cast(void**)&scm_bytevector_u64_ref, "scm_bytevector_u64_ref");
		bindFunc(cast(void**)&scm_bytevector_s64_ref, "scm_bytevector_s64_ref");
		bindFunc(cast(void**)&scm_bytevector_u8_set_x, "scm_bytevector_u8_set_x");
		bindFunc(cast(void**)&scm_bytevector_s8_set_x, "scm_bytevector_s8_set_x");
		bindFunc(cast(void**)&scm_bytevector_u16_set_x, "scm_bytevector_u16_set_x");
		bindFunc(cast(void**)&scm_bytevector_s16_set_x, "scm_bytevector_s16_set_x");
		bindFunc(cast(void**)&scm_bytevector_u32_set_x, "scm_bytevector_u32_set_x");
		bindFunc(cast(void**)&scm_bytevector_s32_set_x, "scm_bytevector_s32_set_x");
		bindFunc(cast(void**)&scm_bytevector_u64_set_x, "scm_bytevector_u64_set_x");
		bindFunc(cast(void**)&scm_bytevector_s64_set_x, "scm_bytevector_s64_set_x");
		bindFunc(cast(void**)&scm_bytevector_u16_native_ref, "scm_bytevector_u16_native_ref");
		bindFunc(cast(void**)&scm_bytevector_s16_native_ref, "scm_bytevector_s16_native_ref");
		bindFunc(cast(void**)&scm_bytevector_u32_native_ref, "scm_bytevector_u32_native_ref");
		bindFunc(cast(void**)&scm_bytevector_s32_native_ref, "scm_bytevector_s32_native_ref");
		bindFunc(cast(void**)&scm_bytevector_u64_native_ref, "scm_bytevector_u64_native_ref");
		bindFunc(cast(void**)&scm_bytevector_s64_native_ref, "scm_bytevector_s64_native_ref");
		bindFunc(cast(void**)&scm_bytevector_u16_native_set_x, "scm_bytevector_u16_native_set_x");
		bindFunc(cast(void**)&scm_bytevector_s16_native_set_x, "scm_bytevector_s16_native_set_x");
		bindFunc(cast(void**)&scm_bytevector_u32_native_set_x, "scm_bytevector_u32_native_set_x");
		bindFunc(cast(void**)&scm_bytevector_s32_native_set_x, "scm_bytevector_s32_native_set_x");
		bindFunc(cast(void**)&scm_bytevector_u64_native_set_x, "scm_bytevector_u64_native_set_x");
		bindFunc(cast(void**)&scm_bytevector_s64_native_set_x, "scm_bytevector_s64_native_set_x");

		//6.6.6.4 Converting Bytevectors to/from Integer Lists
		bindFunc(cast(void**)&scm_bytevector_to_u8_list, "scm_bytevector_to_u8_list");
		bindFunc(cast(void**)&scm_u8_list_to_bytevector, "scm_u8_list_to_bytevector");
		bindFunc(cast(void**)&scm_bytevector_to_uint_list, "scm_bytevector_to_uint_list");
		bindFunc(cast(void**)&scm_bytevector_to_sint_list, "scm_bytevector_to_sint_list");
		bindFunc(cast(void**)&scm_uint_list_to_bytevector, "scm_uint_list_to_bytevector");
		bindFunc(cast(void**)&scm_sint_list_to_bytevector, "scm_sint_list_to_bytevector");

		//6.6.6.5 Interpreting Bytevector Contents as Floating Point Numbers
		bindFunc(cast(void**)&scm_bytevector_ieee_single_ref, "scm_bytevector_ieee_single_ref");
		bindFunc(cast(void**)&scm_bytevector_ieee_double_ref, "scm_bytevector_ieee_double_ref");
		bindFunc(cast(void**)&scm_bytevector_ieee_single_set_x, "scm_bytevector_ieee_single_set_x");
		bindFunc(cast(void**)&scm_bytevector_ieee_double_set_x, "scm_bytevector_ieee_double_set_x");
		bindFunc(cast(void**)&scm_bytevector_ieee_single_native_ref, "scm_bytevector_ieee_single_native_ref");
		bindFunc(cast(void**)&scm_bytevector_ieee_double_native_ref, "scm_bytevector_ieee_double_native_ref");
		bindFunc(cast(void**)&scm_bytevector_ieee_single_native_set_x, "scm_bytevector_ieee_single_native_set_x");
		bindFunc(cast(void**)&scm_bytevector_ieee_double_native_set_x, "scm_bytevector_ieee_double_native_set_x");

		//6.6.6.6 Interpreting Bytevector Contents as Unicode Strings
		bindFunc(cast(void**)&scm_string_to_utf8, "scm_string_to_utf8");
		bindFunc(cast(void**)&scm_string_to_utf16, "scm_string_to_utf16");
		bindFunc(cast(void**)&scm_string_to_utf32, "scm_string_to_utf32");
		bindFunc(cast(void**)&scm_utf8_to_string, "scm_utf8_to_string");
		bindFunc(cast(void**)&scm_utf16_to_string, "scm_utf16_to_string");
		bindFunc(cast(void**)&scm_utf32_to_string, "scm_utf32_to_string");

		//6.6.7.2 Symbols as Lookup Keys
		bindFunc(cast(void**)&scm_symbol_hash, "scm_symbol_hash");

		//6.6.7.4 Operations Related to Symbols
		bindFunc(cast(void**)&scm_symbol_p, "scm_symbol_p");
		bindFunc(cast(void**)&scm_symbol_to_string, "scm_symbol_to_string");
		bindFunc(cast(void**)&scm_string_to_symbol, "scm_string_to_symbol");
		bindFunc(cast(void**)&scm_string_ci_to_symbol, "scm_string_ci_to_symbol");
		bindFunc(cast(void**)&scm_from_latin1_symbol, "scm_from_latin1_symbol");
		bindFunc(cast(void**)&scm_from_utf8_symbol, "scm_from_utf8_symbol");
		bindFunc(cast(void**)&scm_from_locale_symbol, "scm_from_locale_symbol");
		bindFunc(cast(void**)&scm_from_locale_symboln, "scm_from_locale_symboln");
		bindFunc(cast(void**)&scm_take_locale_symbol, "scm_take_locale_symbol");
		bindFunc(cast(void**)&scm_take_locale_symboln, "scm_take_locale_symboln");
		bindFunc(cast(void**)&scm_c_symbol_length, "scm_c_symbol_length");
		bindFunc(cast(void**)&scm_gensym, "scm_gensym");

		//6.6.7.5 Function Slots and Property Lists
		bindFunc(cast(void**)&scm_symbol_fref, "scm_symbol_fref");
		bindFunc(cast(void**)&scm_symbol_fset_x, "scm_symbol_fset_x");
		bindFunc(cast(void**)&scm_symbol_pref, "scm_symbol_pref");
		bindFunc(cast(void**)&scm_symbol_pset_x, "scm_symbol_pset_x");

		//6.6.7.7 Uninterned Symbols
		bindFunc(cast(void**)&scm_make_symbol, "scm_make_symbol");
		bindFunc(cast(void**)&scm_symbol_interned_p, "scm_symbol_interned_p");

		//6.6.8.4 Keyword Procedures
		bindFunc(cast(void**)&scm_keyword_p, "scm_keyword_p");
		bindFunc(cast(void**)&scm_keyword_to_symbol, "scm_keyword_to_symbol");
		bindFunc(cast(void**)&scm_symbol_to_keyword, "scm_symbol_to_keyword");
		bindFunc(cast(void**)&scm_is_keyword, "scm_is_keyword");
		bindFunc(cast(void**)&scm_from_locale_keyword, "scm_from_locale_keyword");
		bindFunc(cast(void**)&scm_from_locale_keywordn, "scm_from_locale_keywordn");
		bindFunc(cast(void**)&scm_from_latin1_keyword, "scm_from_latin1_keyword");
		bindFunc(cast(void**)&scm_from_utf8_keyword, "scm_from_utf8_keyword");
		bindFunc(cast(void**)&scm_c_bind_keyword_arguments, "scm_c_bind_keyword_arguments");

		//6.7.1 Pairs
		bindFunc(cast(void**)&scm_cons, "scm_cons");
		bindFunc(cast(void**)&scm_pair_p, "scm_pair_p");
		bindFunc(cast(void**)&scm_is_pair, "scm_is_pair");
		bindFunc(cast(void**)&scm_car, "scm_car");
		bindFunc(cast(void**)&scm_cdr, "scm_cdr");
		bindFunc(cast(void**)&scm_cddr, "scm_cddr");
		bindFunc(cast(void**)&scm_cdar, "scm_cdar");
		bindFunc(cast(void**)&scm_cadr, "scm_cadr");
		bindFunc(cast(void**)&scm_caar, "scm_caar");
		bindFunc(cast(void**)&scm_cdddr, "scm_cdddr");
		bindFunc(cast(void**)&scm_cddar, "scm_cddar");
		bindFunc(cast(void**)&scm_cdadr, "scm_cdadr");
		bindFunc(cast(void**)&scm_cdaar, "scm_cdaar");
		bindFunc(cast(void**)&scm_caddr, "scm_caddr");
		bindFunc(cast(void**)&scm_cadar, "scm_cadar");
		bindFunc(cast(void**)&scm_caadr, "scm_caadr");
		bindFunc(cast(void**)&scm_caaar, "scm_caaar");
		bindFunc(cast(void**)&scm_cddddr, "scm_cddddr");
		bindFunc(cast(void**)&scm_cdddar, "scm_cdddar");
		bindFunc(cast(void**)&scm_cddadr, "scm_cddadr");
		bindFunc(cast(void**)&scm_cddaar, "scm_cddaar");
		bindFunc(cast(void**)&scm_cdaddr, "scm_cdaddr");
		bindFunc(cast(void**)&scm_cdadar, "scm_cdadar");
		bindFunc(cast(void**)&scm_cdaadr, "scm_cdaadr");
		bindFunc(cast(void**)&scm_cdaaar, "scm_cdaaar");
		bindFunc(cast(void**)&scm_cadddr, "scm_cadddr");
		bindFunc(cast(void**)&scm_caddar, "scm_caddar");
		bindFunc(cast(void**)&scm_cadadr, "scm_cadadr");
		bindFunc(cast(void**)&scm_cadaar, "scm_cadaar");
		bindFunc(cast(void**)&scm_caaddr, "scm_caaddr");
		bindFunc(cast(void**)&scm_caadar, "scm_caadar");
		bindFunc(cast(void**)&scm_caaadr, "scm_caaadr");
		bindFunc(cast(void**)&scm_caaaar, "scm_caaaar");
		bindFunc(cast(void**)&scm_set_car_x, "scm_set_car_x");
		bindFunc(cast(void**)&scm_set_cdr_x, "scm_set_cdr_x");

		//6.7.2.2 List Predicates
		bindFunc(cast(void**)&scm_list_p, "scm_list_p");
		bindFunc(cast(void**)&scm_null_p, "scm_null_p");

		//6.7.2.3 List Constructors
		bindFunc(cast(void**)&scm_list_1, "scm_list_1");
		bindFunc(cast(void**)&scm_list_2, "scm_list_2");
		bindFunc(cast(void**)&scm_list_3, "scm_list_3");
		bindFunc(cast(void**)&scm_list_4, "scm_list_4");
		bindFunc(cast(void**)&scm_list_5, "scm_list_5");
		bindFunc(cast(void**)&scm_list_n, "scm_list_n");
		bindFunc(cast(void**)&scm_list_copy, "scm_list_copy");

		//6.7.2.4 List Selection
		bindFunc(cast(void**)&scm_length, "scm_length");
		bindFunc(cast(void**)&scm_last_pair, "scm_last_pair");
		bindFunc(cast(void**)&scm_list_ref, "scm_list_ref");
		bindFunc(cast(void**)&scm_list_tail, "scm_list_tail");
		bindFunc(cast(void**)&scm_list_head, "scm_list_head");

		//6.7.2.5 Append and Reverse
		bindFunc(cast(void**)&scm_append, "scm_append");
		bindFunc(cast(void**)&scm_append_x, "scm_append_x");
		bindFunc(cast(void**)&scm_reverse, "scm_reverse");
		bindFunc(cast(void**)&scm_reverse_x, "scm_reverse_x");

		//6.7.2.6 List Modification
		bindFunc(cast(void**)&scm_list_set_x, "scm_list_set_x");
		bindFunc(cast(void**)&scm_list_cdr_set_x, "scm_list_cdr_set_x");
		bindFunc(cast(void**)&scm_delq, "scm_delq");
		bindFunc(cast(void**)&scm_delv, "scm_delv");
		bindFunc(cast(void**)&scm_delete, "scm_delete");
		bindFunc(cast(void**)&scm_delq_x, "scm_delq_x");
		bindFunc(cast(void**)&scm_delv_x, "scm_delv_x");
		bindFunc(cast(void**)&scm_delete_x, "scm_delete_x");
		bindFunc(cast(void**)&scm_delq1_x, "scm_delq1_x");
		bindFunc(cast(void**)&scm_delv1_x, "scm_delv1_x");
		bindFunc(cast(void**)&scm_delete1_x, "scm_delete1_x");

		//6.7.2.7 List Searching
		bindFunc(cast(void**)&scm_memq, "scm_memq");
		bindFunc(cast(void**)&scm_memv, "scm_memv");
		bindFunc(cast(void**)&scm_member, "scm_member");

		//6.7.2.8 List Mapping
		bindFunc(cast(void**)&scm_map, "scm_map");

		//6.7.3.2 Dynamic Vector Creation and Validation
		bindFunc(cast(void**)&scm_vector, "scm_vector");
		bindFunc(cast(void**)&scm_vector_to_list, "scm_vector_to_list");
		bindFunc(cast(void**)&scm_make_vector, "scm_make_vector");
		bindFunc(cast(void**)&scm_c_make_vector, "scm_c_make_vector");
		bindFunc(cast(void**)&scm_vector_p, "scm_vector_p");
		bindFunc(cast(void**)&scm_is_vector, "scm_is_vector");

		//6.7.3.3 Accessing and Modifying Vector Contents
		bindFunc(cast(void**)&scm_vector_length, "scm_vector_length");
		bindFunc(cast(void**)&scm_c_vector_length, "scm_c_vector_length");
		bindFunc(cast(void**)&scm_vector_ref, "scm_vector_ref");
		bindFunc(cast(void**)&scm_c_vector_ref, "scm_c_vector_ref");
		bindFunc(cast(void**)&scm_vector_set_x, "scm_vector_set_x");
		bindFunc(cast(void**)&scm_c_vector_set_x, "scm_c_vector_set_x");
		bindFunc(cast(void**)&scm_vector_fill_x, "scm_vector_fill_x");
		bindFunc(cast(void**)&scm_vector_copy, "scm_vector_copy");
		bindFunc(cast(void**)&scm_vector_move_left_x, "scm_vector_move_left_x");
		bindFunc(cast(void**)&scm_vector_move_right_x, "scm_vector_move_right_x");

		//6.7.3.4 Vector Accessing from C
		bindFunc(cast(void**)&scm_is_simple_vector, "scm_is_simple_vector");
		bindFunc(cast(void**)&scm_vector_elements, "scm_vector_elements");
		bindFunc(cast(void**)&scm_vector_writable_elements, "scm_vector_writable_elements");

		//6.7.4 Bit Vectors
		bindFunc(cast(void**)&scm_bitvector_p, "scm_bitvector_p");
		bindFunc(cast(void**)&scm_is_bitvector, "scm_is_bitvector");
		bindFunc(cast(void**)&scm_make_bitvector, "scm_make_bitvector");
		bindFunc(cast(void**)&scm_c_make_bitvector, "scm_c_make_bitvector");
		bindFunc(cast(void**)&scm_bitvector, "scm_bitvector");
		bindFunc(cast(void**)&scm_bitvector_length, "scm_bitvector_length");
		bindFunc(cast(void**)&scm_c_bitvector_length, "scm_c_bitvector_length");
		bindFunc(cast(void**)&scm_bitvector_ref, "scm_bitvector_ref");
		bindFunc(cast(void**)&scm_c_bitvector_ref, "scm_c_bitvector_ref");
		bindFunc(cast(void**)&scm_bitvector_set_x, "scm_bitvector_set_x");
		bindFunc(cast(void**)&scm_c_bitvector_set_x, "scm_c_bitvector_set_x");
		bindFunc(cast(void**)&scm_bitvector_fill_x, "scm_bitvector_fill_x");
		bindFunc(cast(void**)&scm_list_to_bitvector, "scm_list_to_bitvector");
		bindFunc(cast(void**)&scm_bitvector_to_list, "scm_bitvector_to_list");
		bindFunc(cast(void**)&scm_bit_count, "scm_bit_count");
		bindFunc(cast(void**)&scm_bit_position, "scm_bit_position");
		bindFunc(cast(void**)&scm_bit_invert_x, "scm_bit_invert_x");
		bindFunc(cast(void**)&scm_bit_set_star_x, "scm_bit_set_star_x");
		bindFunc(cast(void**)&scm_bit_count_star, "scm_bit_count_star");
		bindFunc(cast(void**)&scm_bitvector_elements, "scm_bitvector_elements");
		bindFunc(cast(void**)&scm_bitvector_writable_elements, "scm_bitvector_writable_elements");

		//6.7.5.2 Array Procedures
		bindFunc(cast(void**)&scm_array_p, "scm_array_p");
		bindFunc(cast(void**)&scm_typed_array_p, "scm_typed_array_p");
		bindFunc(cast(void**)&scm_is_array, "scm_is_array");
		bindFunc(cast(void**)&scm_is_typed_array, "scm_is_typed_array");
		bindFunc(cast(void**)&scm_make_array, "scm_make_array");
		bindFunc(cast(void**)&scm_make_typed_array, "scm_make_typed_array");
		bindFunc(cast(void**)&scm_list_to_typed_array, "scm_list_to_typed_array");
		bindFunc(cast(void**)&scm_array_type, "scm_array_type");
		bindFunc(cast(void**)&scm_array_ref, "scm_array_ref");
		bindFunc(cast(void**)&scm_array_in_bounds_p, "scm_array_in_bounds_p");
		bindFunc(cast(void**)&scm_array_set_x, "scm_array_set_x");
		bindFunc(cast(void**)&scm_array_dimensions, "scm_array_dimensions");
		bindFunc(cast(void**)&scm_array_length, "scm_array_length");
		bindFunc(cast(void**)&scm_c_array_length, "scm_c_array_length");
		bindFunc(cast(void**)&scm_array_rank, "scm_array_rank");
		bindFunc(cast(void**)&scm_c_array_rank, "scm_c_array_rank");
		bindFunc(cast(void**)&scm_array_to_list, "scm_array_to_list");
		bindFunc(cast(void**)&scm_array_copy_x, "scm_array_copy_x");
		bindFunc(cast(void**)&scm_array_fill_x, "scm_array_fill_x");
		bindFunc(cast(void**)&scm_array_map_x, "scm_array_map_x");
		bindFunc(cast(void**)&scm_array_for_each, "scm_array_for_each");
		bindFunc(cast(void**)&scm_array_index_map_x, "scm_array_index_map_x");
		bindFunc(cast(void**)&scm_uniform_array_read_x, "scm_uniform_array_read_x");
		bindFunc(cast(void**)&scm_uniform_array_write, "scm_uniform_array_write");

		//6.7.5.3 Shared Arrays
		bindFunc(cast(void**)&scm_make_shared_array, "scm_make_shared_array");
		bindFunc(cast(void**)&scm_shared_array_increments, "scm_shared_array_increments");
		bindFunc(cast(void**)&scm_shared_array_offset, "scm_shared_array_offset");
		bindFunc(cast(void**)&scm_shared_array_root, "scm_shared_array_root");
		bindFunc(cast(void**)&scm_array_contents, "scm_array_contents");
		bindFunc(cast(void**)&scm_transpose_array, "scm_transpose_array");

		//6.7.5.4 Accessing Arrays from C
		bindFunc(cast(void**)&scm_array_get_handle, "scm_array_get_handle");
		bindFunc(cast(void**)&scm_array_handle_release, "scm_array_handle_release");
		bindFunc(cast(void**)&scm_array_handle_pos, "scm_array_handle_pos");
		bindFunc(cast(void**)&scm_array_handle_ref, "scm_array_handle_ref");
		bindFunc(cast(void**)&scm_array_handle_set, "scm_array_handle_set");
		bindFunc(cast(void**)&scm_array_handle_elements, "scm_array_handle_elements");
		bindFunc(cast(void**)&scm_array_handle_writable_elements, "scm_array_handle_writable_elements");
		bindFunc(cast(void**)&scm_array_handle_uniform_elements, "scm_array_handle_uniform_elements");
		bindFunc(cast(void**)&scm_array_handle_uniform_writable_elements, "scm_array_handle_uniform_writable_elements");
		bindFunc(cast(void**)&scm_array_handle_uniform_element_size, "scm_array_handle_uniform_element_size");
		bindFunc(cast(void**)&scm_array_handle_u8_elements, "scm_array_handle_u8_elements");
		bindFunc(cast(void**)&scm_array_handle_s8_elements, "scm_array_handle_s8_elements");
		bindFunc(cast(void**)&scm_array_handle_u16_elements, "scm_array_handle_u16_elements");
		bindFunc(cast(void**)&scm_array_handle_s16_elements, "scm_array_handle_s16_elements");
		bindFunc(cast(void**)&scm_array_handle_u32_elements, "scm_array_handle_u32_elements");
		bindFunc(cast(void**)&scm_array_handle_s32_elements, "scm_array_handle_s32_elements");
		bindFunc(cast(void**)&scm_array_handle_u64_elements, "scm_array_handle_u64_elements");
		bindFunc(cast(void**)&scm_array_handle_s64_elements, "scm_array_handle_s64_elements");
		bindFunc(cast(void**)&scm_array_handle_f32_elements, "scm_array_handle_f32_elements");
		bindFunc(cast(void**)&scm_array_handle_f64_elements, "scm_array_handle_f64_elements");
		bindFunc(cast(void**)&scm_array_handle_c32_elements, "scm_array_handle_c32_elements");
		bindFunc(cast(void**)&scm_array_handle_c64_elements, "scm_array_handle_c64_elements");
		bindFunc(cast(void**)&scm_array_handle_u8_writable_elements, "scm_array_handle_u8_writable_elements");
		bindFunc(cast(void**)&scm_array_handle_s8_writable_elements, "scm_array_handle_s8_writable_elements");
		bindFunc(cast(void**)&scm_array_handle_u16_writable_elements, "scm_array_handle_u16_writable_elements");
		bindFunc(cast(void**)&scm_array_handle_s16_writable_elements, "scm_array_handle_s16_writable_elements");
		bindFunc(cast(void**)&scm_array_handle_u32_writable_elements, "scm_array_handle_u32_writable_elements");
		bindFunc(cast(void**)&scm_array_handle_s32_writable_elements, "scm_array_handle_s32_writable_elements");
		bindFunc(cast(void**)&scm_array_handle_u64_writable_elements, "scm_array_handle_u64_writable_elements");
		bindFunc(cast(void**)&scm_array_handle_s64_writable_elements, "scm_array_handle_s64_writable_elements");
		bindFunc(cast(void**)&scm_array_handle_f32_writable_elements, "scm_array_handle_f32_writable_elements");
		bindFunc(cast(void**)&scm_array_handle_f64_writable_elements, "scm_array_handle_f64_writable_elements");
		bindFunc(cast(void**)&scm_array_handle_c32_writable_elements, "scm_array_handle_c32_writable_elements");
		bindFunc(cast(void**)&scm_array_handle_c64_writable_elements, "scm_array_handle_c64_writable_elements");
		bindFunc(cast(void**)&scm_array_handle_bit_elements, "scm_array_handle_bit_elements");
		bindFunc(cast(void**)&scm_array_handle_bit_writable_elements, "scm_array_handle_bit_writable_elements");

		//6.7.10.2 Structure Basics
		bindFunc(cast(void**)&scm_make_struct, "scm_make_struct");
		bindFunc(cast(void**)&scm_c_make_struct, "scm_c_make_struct");
		bindFunc(cast(void**)&scm_c_make_structv, "scm_c_make_structv");
		bindFunc(cast(void**)&scm_struct_p, "scm_struct_p");
		bindFunc(cast(void**)&scm_struct_ref, "scm_struct_ref");
		bindFunc(cast(void**)&scm_struct_set_x, "scm_struct_set_x");
		bindFunc(cast(void**)&scm_struct_vtable, "scm_struct_vtable");

		//6.7.10.3 Vtable Contents
		bindFunc(cast(void**)&scm_struct_vtable_name, "scm_struct_vtable_name");
		bindFunc(cast(void**)&scm_set_struct_vtable_name_x, "scm_set_struct_vtable_name_x");

		//6.7.10.4 Meta-Vtables
		bindFunc(cast(void**)&scm_struct_vtable_p, "scm_struct_vtable_p");
		bindFunc(cast(void**)&scm_make_struct_layout, "scm_make_struct_layout");

		//6.7.12.2 Adding or Setting Alist Entries
		bindFunc(cast(void**)&scm_acons, "scm_acons");
		bindFunc(cast(void**)&scm_assq_set_x, "scm_assq_set_x");
		bindFunc(cast(void**)&scm_assv_set_x, "scm_assv_set_x");
		bindFunc(cast(void**)&scm_assoc_set_x, "scm_assoc_set_x");

		//6.7.12.3 Retrieving Alist Entries
		bindFunc(cast(void**)&scm_assq, "scm_assq");
		bindFunc(cast(void**)&scm_assv, "scm_assv");
		bindFunc(cast(void**)&scm_assoc, "scm_assoc");
		bindFunc(cast(void**)&scm_assq_ref, "scm_assq_ref");
		bindFunc(cast(void**)&scm_assv_ref, "scm_assv_ref");
		bindFunc(cast(void**)&scm_assoc_ref, "scm_assoc_ref");

		//6.7.12.4 Removing Alist Entries
		bindFunc(cast(void**)&scm_assq_remove_x, "scm_assq_remove_x");
		bindFunc(cast(void**)&scm_assv_remove_x, "scm_assv_remove_x");
		bindFunc(cast(void**)&scm_assoc_remove_x, "scm_assoc_remove_x");

		//6.7.12.5 Sloppy Alist Functions
		bindFunc(cast(void**)&scm_sloppy_assq, "scm_sloppy_assq");
		bindFunc(cast(void**)&scm_sloppy_assv, "scm_sloppy_assv");
		bindFunc(cast(void**)&scm_sloppy_assoc, "scm_sloppy_assoc");

		//6.7.14.2 Hash Table Reference
		bindFunc(cast(void**)&scm_hash_table_p, "scm_hash_table_p");
		bindFunc(cast(void**)&scm_hash_clear_x, "scm_hash_clear_x");
		bindFunc(cast(void**)&scm_hash_ref, "scm_hash_ref");
		bindFunc(cast(void**)&scm_hashq_ref, "scm_hashq_ref");
		bindFunc(cast(void**)&scm_hashv_ref, "scm_hashv_ref");
		bindFunc(cast(void**)&scm_hashx_ref, "scm_hashx_ref");
		bindFunc(cast(void**)&scm_hash_set_x, "scm_hash_set_x");
		bindFunc(cast(void**)&scm_hashq_set_x, "scm_hashq_set_x");
		bindFunc(cast(void**)&scm_hashv_set_x, "scm_hashv_set_x");
		bindFunc(cast(void**)&scm_hashx_set_x, "scm_hashx_set_x");
		bindFunc(cast(void**)&scm_hash_remove_x, "scm_hash_remove_x");
		bindFunc(cast(void**)&scm_hashq_remove_x, "scm_hashq_remove_x");
		bindFunc(cast(void**)&scm_hashv_remove_x, "scm_hashv_remove_x");
		bindFunc(cast(void**)&scm_hashx_remove_x, "scm_hashx_remove_x");
		bindFunc(cast(void**)&scm_hash, "scm_hash");
		bindFunc(cast(void**)&scm_hashq, "scm_hashq");
		bindFunc(cast(void**)&scm_hashv, "scm_hashv");
		bindFunc(cast(void**)&scm_hash_get_handle, "scm_hash_get_handle");
		bindFunc(cast(void**)&scm_hashq_get_handle, "scm_hashq_get_handle");
		bindFunc(cast(void**)&scm_hashv_get_handle, "scm_hashv_get_handle");
		bindFunc(cast(void**)&scm_hashx_get_handle, "scm_hashx_get_handle");
		bindFunc(cast(void**)&scm_hash_create_handle_x, "scm_hash_create_handle_x");
		bindFunc(cast(void**)&scm_hashq_create_handle_x, "scm_hashq_create_handle_x");
		bindFunc(cast(void**)&scm_hashv_create_handle_x, "scm_hashv_create_handle_x");
		bindFunc(cast(void**)&scm_hashx_create_handle_x, "scm_hashx_create_handle_x");
		bindFunc(cast(void**)&scm_hash_map_to_list, "scm_hash_map_to_list");
		bindFunc(cast(void**)&scm_hash_for_each, "scm_hash_for_each");
		bindFunc(cast(void**)&scm_hash_for_each_handle, "scm_hash_for_each_handle");
		bindFunc(cast(void**)&scm_hash_fold, "scm_hash_fold");
		bindFunc(cast(void**)&scm_hash_count, "scm_hash_count");

		//6.8 Smobs
		bindFunc(cast(void**)&scm_set_smob_free, "scm_set_smob_free");
		bindFunc(cast(void**)&scm_set_smob_mark, "scm_set_smob_mark");
		bindFunc(cast(void**)&scm_set_smob_print, "scm_set_smob_print");
		bindFunc(cast(void**)&scm_set_smob_equalp, "scm_set_smob_equalp");
		bindFunc(cast(void**)&scm_assert_smob_type, "scm_assert_smob_type");
		bindFunc(cast(void**)&scm_new_smob, "scm_new_smob");
		bindFunc(cast(void**)&scm_new_double_smob, "scm_new_double_smob");

		//6.9.3 Compiled Procedures
		bindFunc(cast(void**)&scm_program_p, "scm_program_p");
		bindFunc(cast(void**)&scm_program_objcode, "scm_program_objcode");
		bindFunc(cast(void**)&scm_program_objects, "scm_program_objects");
		bindFunc(cast(void**)&scm_program_module, "scm_program_module");
		bindFunc(cast(void**)&scm_program_meta, "scm_program_meta");
		bindFunc(cast(void**)&scm_program_arities, "scm_program_arities");

		//6.9.7 Procedure Properties and Meta-information
		bindFunc(cast(void**)&scm_procedure_p, "scm_procedure_p");
		bindFunc(cast(void**)&scm_thunk_p, "scm_thunk_p");
		bindFunc(cast(void**)&scm_procedure_name, "scm_procedure_name");
		bindFunc(cast(void**)&scm_procedure_source, "scm_procedure_source");
		bindFunc(cast(void**)&scm_procedure_properties, "scm_procedure_properties");
		bindFunc(cast(void**)&scm_procedure_property, "scm_procedure_property");
		bindFunc(cast(void**)&scm_set_procedure_properties_x, "scm_set_procedure_properties_x");
		bindFunc(cast(void**)&scm_set_procedure_property_x, "scm_set_procedure_property_x");
		bindFunc(cast(void**)&scm_procedure_documentation, "scm_procedure_documentation");

		//6.9.8 Procedures with Setters
		bindFunc(cast(void**)&scm_make_procedure_with_setter, "scm_make_procedure_with_setter");
		bindFunc(cast(void**)&scm_procedure_with_setter_p, "scm_procedure_with_setter_p");
		bindFunc(cast(void**)&scm_procedure, "scm_procedure");

		//6.10.9 Internal Macros
		bindFunc(cast(void**)&scm_macro_p, "scm_macro_p");
		bindFunc(cast(void**)&scm_macro_type, "scm_macro_type");
		bindFunc(cast(void**)&scm_macro_name, "scm_macro_name");
		bindFunc(cast(void**)&scm_macro_binding, "scm_macro_binding");
		bindFunc(cast(void**)&scm_macro_transformer, "scm_macro_transformer");

		//6.11.1 Equality
		bindFunc(cast(void**)&scm_eq_p, "scm_eq_p");
		bindFunc(cast(void**)&scm_eqv_p, "scm_eqv_p");
		bindFunc(cast(void**)&scm_equal_p, "scm_equal_p");

		//6.11.2 Object Properties
		bindFunc(cast(void**)&scm_object_properties, "scm_object_properties");
		bindFunc(cast(void**)&scm_set_object_properties_x, "scm_set_object_properties_x");
		bindFunc(cast(void**)&scm_object_property, "scm_object_property");
		bindFunc(cast(void**)&scm_set_object_property_x, "scm_set_object_property_x");

		//6.11.3 Sorting
		bindFunc(cast(void**)&scm_merge, "scm_merge");
		bindFunc(cast(void**)&scm_merge_x, "scm_merge_x");
		bindFunc(cast(void**)&scm_sorted_p, "scm_sorted_p");
		bindFunc(cast(void**)&scm_sort, "scm_sort");
		bindFunc(cast(void**)&scm_sort_x, "scm_sort_x");
		bindFunc(cast(void**)&scm_stable_sort, "scm_stable_sort");
		bindFunc(cast(void**)&scm_stable_sort_x, "scm_stable_sort_x");
		bindFunc(cast(void**)&scm_sort_list, "scm_sort_list");
		bindFunc(cast(void**)&scm_sort_list_x, "scm_sort_list_x");
		bindFunc(cast(void**)&scm_restricted_vector_sort_x, "scm_restricted_vector_sort_x");

		//6.11.4 Copying Deep Structures
		bindFunc(cast(void**)&scm_copy_tree, "scm_copy_tree");

		//6.11.5 General String Conversion
		bindFunc(cast(void**)&scm_object_to_string, "scm_object_to_string");

		//6.11.6.2 Hook Reference
		bindFunc(cast(void**)&scm_make_hook, "scm_make_hook");
		bindFunc(cast(void**)&scm_hook_p, "scm_hook_p");
		bindFunc(cast(void**)&scm_hook_empty_p, "scm_hook_empty_p");
		bindFunc(cast(void**)&scm_add_hook_x, "scm_add_hook_x");
		bindFunc(cast(void**)&scm_remove_hook_x, "scm_remove_hook_x");
		bindFunc(cast(void**)&scm_reset_hook_x, "scm_reset_hook_x");
		bindFunc(cast(void**)&scm_hook_to_list, "scm_hook_to_list");
		bindFunc(cast(void**)&scm_run_hook, "scm_run_hook");
		bindFunc(cast(void**)&scm_c_run_hook, "scm_c_run_hook");

		//6.11.6.4 Hooks For C Code.
		bindFunc(cast(void**)&scm_c_hook_init, "scm_c_hook_init");
		bindFunc(cast(void**)&scm_c_hook_add, "scm_c_hook_add");
		bindFunc(cast(void**)&scm_c_hook_remove, "scm_c_hook_remove");
		bindFunc(cast(void**)&scm_c_hook_run, "scm_c_hook_run");

		//6.12.1 Top Level Variable Definitions
		bindFunc(cast(void**)&scm_define, "scm_define");
		bindFunc(cast(void**)&scm_c_define, "scm_c_define");

		//6.12.4 Querying variable bindings
		bindFunc(cast(void**)&scm_defined_p, "scm_defined_p");

		//6.13.7 Returning and Accepting Multiple Values
		bindFunc(cast(void**)&scm_values, "scm_values");
		bindFunc(cast(void**)&scm_c_values, "scm_c_values");
		bindFunc(cast(void**)&scm_c_nvalues, "scm_c_nvalues");
		bindFunc(cast(void**)&scm_c_value_ref, "scm_c_value_ref");

		//6.13.8.2 Catching Exceptions
		bindFunc(cast(void**)&scm_catch_with_pre_unwind_handler, "scm_catch_with_pre_unwind_handler");
		bindFunc(cast(void**)&scm_catch, "scm_catch");
		bindFunc(cast(void**)&scm_c_catch, "scm_c_catch");
		bindFunc(cast(void**)&scm_internal_catch, "scm_internal_catch");

		//6.13.8.3 Throw Handlers
		bindFunc(cast(void**)&scm_with_throw_handler, "scm_with_throw_handler");
		bindFunc(cast(void**)&scm_c_with_throw_handler, "scm_c_with_throw_handler");

		//6.13.8.4 Throwing Exceptions
		bindFunc(cast(void**)&scm_throw, "scm_throw");

		//6.13.9 Procedures for Signaling Errors
		bindFunc(cast(void**)&scm_error_scm, "scm_error_scm");
		bindFunc(cast(void**)&scm_strerror, "scm_strerror");

		//6.13.10 Dynamic Wind
		bindFunc(cast(void**)&scm_dynamic_wind, "scm_dynamic_wind");
		bindFunc(cast(void**)&scm_dynwind_begin, "scm_dynwind_begin");
		bindFunc(cast(void**)&scm_dynwind_end, "scm_dynwind_end");
		bindFunc(cast(void**)&scm_dynwind_unwind_handler, "scm_dynwind_unwind_handler");
		bindFunc(cast(void**)&scm_dynwind_unwind_handler_with_scm, "scm_dynwind_unwind_handler_with_scm");
		bindFunc(cast(void**)&scm_dynwind_rewind_handler, "scm_dynwind_rewind_handler");
		bindFunc(cast(void**)&scm_dynwind_rewind_handler_with_scm, "scm_dynwind_rewind_handler_with_scm");
		bindFunc(cast(void**)&scm_dynwind_free, "scm_dynwind_free");

		//6.13.11 How to Handle Errors
		bindFunc(cast(void**)&scm_display_error, "scm_display_error");

		//6.13.11.1 C Support
		bindFunc(cast(void**)&scm_error, "scm_error");
		bindFunc(cast(void**)&scm_syserror, "scm_syserror");
		bindFunc(cast(void**)&scm_syserror_msg, "scm_syserror_msg");
		bindFunc(cast(void**)&scm_num_overflow, "scm_num_overflow");
		bindFunc(cast(void**)&scm_out_of_range, "scm_out_of_range");
		bindFunc(cast(void**)&scm_wrong_num_args, "scm_wrong_num_args");
		bindFunc(cast(void**)&scm_wrong_type_arg, "scm_wrong_type_arg");
		bindFunc(cast(void**)&scm_wrong_type_arg_msg, "scm_wrong_type_arg_msg");
		bindFunc(cast(void**)&scm_memory_error, "scm_memory_error");
		bindFunc(cast(void**)&scm_misc_error, "scm_misc_error");

		//6.13.12 Continuation Barriers
		bindFunc(cast(void**)&scm_with_continuation_barrier, "scm_with_continuation_barrier");
		bindFunc(cast(void**)&scm_c_with_continuation_barrier, "scm_c_with_continuation_barrier");

		//6.14.1 Ports
		bindFunc(cast(void**)&scm_input_port_p, "scm_input_port_p");
		bindFunc(cast(void**)&scm_output_port_p, "scm_output_port_p");
		bindFunc(cast(void**)&scm_port_p, "scm_port_p");
		bindFunc(cast(void**)&scm_set_port_encoding_x, "scm_set_port_encoding_x");
		bindFunc(cast(void**)&scm_port_encoding, "scm_port_encoding");
		bindFunc(cast(void**)&scm_set_port_conversion_strategy_x, "scm_set_port_conversion_strategy_x");
		bindFunc(cast(void**)&scm_port_conversion_strategy, "scm_port_conversion_strategy");

		//6.14.2 Reading
		bindFunc(cast(void**)&scm_char_ready_p, "scm_char_ready_p");
		bindFunc(cast(void**)&scm_read_char, "scm_read_char");
		bindFunc(cast(void**)&scm_c_read, "scm_c_read");
		bindFunc(cast(void**)&scm_peek_char, "scm_peek_char");
		bindFunc(cast(void**)&scm_unread_char, "scm_unread_char");
		bindFunc(cast(void**)&scm_unread_string, "scm_unread_string");
		bindFunc(cast(void**)&scm_drain_input, "scm_drain_input");
		bindFunc(cast(void**)&scm_port_column, "scm_port_column");
		bindFunc(cast(void**)&scm_port_line, "scm_port_line");
		bindFunc(cast(void**)&scm_set_port_column_x, "scm_set_port_column_x");
		bindFunc(cast(void**)&scm_set_port_line_x, "scm_set_port_line_x");

		//6.14.3 Writing
		bindFunc(cast(void**)&scm_get_print_state, "scm_get_print_state");
		bindFunc(cast(void**)&scm_newline, "scm_newline");
		bindFunc(cast(void**)&scm_port_with_print_state, "scm_port_with_print_state");
		bindFunc(cast(void**)&scm_simple_format, "scm_simple_format");
		bindFunc(cast(void**)&scm_write_char, "scm_write_char");
		bindFunc(cast(void**)&scm_c_write, "scm_c_write");
		bindFunc(cast(void**)&scm_force_output, "scm_force_output");
		bindFunc(cast(void**)&scm_flush_all_ports, "scm_flush_all_ports");

		//6.14.4 Closing
		bindFunc(cast(void**)&scm_close_port, "scm_close_port");
		bindFunc(cast(void**)&scm_close_input_port, "scm_close_input_port");
		bindFunc(cast(void**)&scm_close_output_port, "scm_close_output_port");
		bindFunc(cast(void**)&scm_port_closed_p, "scm_port_closed_p");

		//6.14.5 Random Access
		bindFunc(cast(void**)&scm_seek, "scm_seek");
		bindFunc(cast(void**)&scm_ftell, "scm_ftell");
		bindFunc(cast(void**)&scm_truncate_file, "scm_truncate_file");

		//6.14.6 Line Oriented and Delimited Text
		bindFunc(cast(void**)&scm_write_line, "scm_write_line");
		bindFunc(cast(void**)&scm_read_delimited_x, "scm_read_delimited_x");
		bindFunc(cast(void**)&scm_read_line, "scm_read_line");

		//6.14.7 Block reading and writing
		bindFunc(cast(void**)&scm_read_string_x_partial, "scm_read_string_x_partial");
		bindFunc(cast(void**)&scm_write_string_partial, "scm_write_string_partial");

		//6.14.8 Default Ports for Input, Output and Errors
		bindFunc(cast(void**)&scm_current_input_port, "scm_current_input_port");
		bindFunc(cast(void**)&scm_current_output_port, "scm_current_output_port");
		bindFunc(cast(void**)&scm_current_error_port, "scm_current_error_port");
		bindFunc(cast(void**)&scm_set_current_input_port, "scm_set_current_input_port");
		bindFunc(cast(void**)&scm_set_current_output_port, "scm_set_current_output_port");
		bindFunc(cast(void**)&scm_set_current_error_port, "scm_set_current_error_port");
		bindFunc(cast(void**)&scm_dynwind_current_input_port, "scm_dynwind_current_input_port");
		bindFunc(cast(void**)&scm_dynwind_current_output_port, "scm_dynwind_current_output_port");
		bindFunc(cast(void**)&scm_dynwind_current_error_port, "scm_dynwind_current_error_port");

		//6.14.9.1 File Ports
		bindFunc(cast(void**)&scm_open_file_with_encoding, "scm_open_file_with_encoding");
		bindFunc(cast(void**)&scm_open_file, "scm_open_file");
		bindFunc(cast(void**)&scm_port_mode, "scm_port_mode");
		bindFunc(cast(void**)&scm_port_filename, "scm_port_filename");
		bindFunc(cast(void**)&scm_set_port_filename_x, "scm_set_port_filename_x");
		bindFunc(cast(void**)&scm_file_port_p, "scm_file_port_p");

		//6.14.9.2 String Ports
		bindFunc(cast(void**)&scm_call_with_output_string, "scm_call_with_output_string");
		bindFunc(cast(void**)&scm_call_with_input_string, "scm_call_with_input_string");
		bindFunc(cast(void**)&scm_open_input_string, "scm_open_input_string");
		bindFunc(cast(void**)&scm_open_output_string, "scm_open_output_string");
		bindFunc(cast(void**)&scm_get_output_string, "scm_get_output_string");

		//6.14.9.3 Soft Ports
		bindFunc(cast(void**)&scm_make_soft_port, "scm_make_soft_port");

		//6.14.9.4 Void Ports
		bindFunc(cast(void**)&scm_sys_make_void_port, "scm_sys_make_void_port");

		//6.14.10.5 The End-of-File Object
		bindFunc(cast(void**)&scm_eof_object, "scm_eof_object");
		bindFunc(cast(void**)&scm_eof_object_p, "scm_eof_object_p");

		//6.14.10.8 Binary Input
		bindFunc(cast(void**)&scm_open_bytevector_input_port, "scm_open_bytevector_input_port");
		bindFunc(cast(void**)&scm_make_custom_binary_input_port, "scm_make_custom_binary_input_port");
		bindFunc(cast(void**)&scm_get_u8, "scm_get_u8");
		bindFunc(cast(void**)&scm_lookahead_u8, "scm_lookahead_u8");
		bindFunc(cast(void**)&scm_get_bytevector_n, "scm_get_bytevector_n");
		bindFunc(cast(void**)&scm_get_bytevector_n_x, "scm_get_bytevector_n_x");
		bindFunc(cast(void**)&scm_get_bytevector_some, "scm_get_bytevector_some");
		bindFunc(cast(void**)&scm_get_bytevector_all, "scm_get_bytevector_all");
		bindFunc(cast(void**)&scm_unget_bytevector, "scm_unget_bytevector");

		//6.14.10.11 Binary Output
		bindFunc(cast(void**)&scm_open_bytevector_output_port, "scm_open_bytevector_output_port");
		bindFunc(cast(void**)&scm_make_custom_binary_output_port, "scm_make_custom_binary_output_port");
		bindFunc(cast(void**)&scm_put_u8, "scm_put_u8");
		bindFunc(cast(void**)&scm_put_bytevector, "scm_put_bytevector");

		//6.15.1 Regexp Functions
		bindFunc(cast(void**)&scm_make_regexp, "scm_make_regexp");
		bindFunc(cast(void**)&scm_regexp_exec, "scm_regexp_exec");
		bindFunc(cast(void**)&scm_regexp_p, "scm_regexp_p");

		//6.17.1.6 Reader Extensions
		bindFunc(cast(void**)&scm_read_hash_extend, "scm_read_hash_extend");

		//6.17.2 Reading Scheme Code
		bindFunc(cast(void**)&scm_read, "scm_read");

		//6.17.4 Procedures for On the Fly Evaluation
		bindFunc(cast(void**)&scm_eval, "scm_eval");
		bindFunc(cast(void**)&scm_interaction_environment, "scm_interaction_environment");
		bindFunc(cast(void**)&scm_eval_string, "scm_eval_string");
		bindFunc(cast(void**)&scm_eval_string_in_module, "scm_eval_string_in_module");
		bindFunc(cast(void**)&scm_c_eval_string, "scm_c_eval_string");
		bindFunc(cast(void**)&scm_apply_0, "scm_apply_0");
		bindFunc(cast(void**)&scm_apply_1, "scm_apply_1");
		bindFunc(cast(void**)&scm_apply_2, "scm_apply_2");
		bindFunc(cast(void**)&scm_apply_3, "scm_apply_3");
		bindFunc(cast(void**)&scm_apply, "scm_apply");
		bindFunc(cast(void**)&scm_call_0, "scm_call_0");
		bindFunc(cast(void**)&scm_call_1, "scm_call_1");
		bindFunc(cast(void**)&scm_call_2, "scm_call_2");
		bindFunc(cast(void**)&scm_call_3, "scm_call_3");
		bindFunc(cast(void**)&scm_call_4, "scm_call_4");
		bindFunc(cast(void**)&scm_call_5, "scm_call_5");
		bindFunc(cast(void**)&scm_call_6, "scm_call_6");
		bindFunc(cast(void**)&scm_call_7, "scm_call_7");
		bindFunc(cast(void**)&scm_call_8, "scm_call_8");
		bindFunc(cast(void**)&scm_call_9, "scm_call_9");
		bindFunc(cast(void**)&scm_call, "scm_call");
		bindFunc(cast(void**)&scm_call_n, "scm_call_n");
		bindFunc(cast(void**)&scm_nconc2last, "scm_nconc2last");
		bindFunc(cast(void**)&scm_primitive_eval, "scm_primitive_eval");

		//6.17.6 Loading Scheme Code from File
		bindFunc(cast(void**)&scm_primitive_load, "scm_primitive_load");
		bindFunc(cast(void**)&scm_c_primitive_load, "scm_c_primitive_load");
		bindFunc(cast(void**)&scm_current_load_port, "scm_current_load_port");

		//6.17.7 Load Paths
		bindFunc(cast(void**)&scm_primitive_load_path, "scm_primitive_load_path");
		bindFunc(cast(void**)&scm_sys_search_load_path, "scm_sys_search_load_path");
		bindFunc(cast(void**)&scm_parse_path, "scm_parse_path");
		bindFunc(cast(void**)&scm_parse_path_with_ellipsis, "scm_parse_path_with_ellipsis");
		bindFunc(cast(void**)&scm_search_path, "scm_search_path");

		//6.17.8 Character Encoding of Source Files
		bindFunc(cast(void**)&scm_file_encoding, "scm_file_encoding");

		//6.17.9 Delayed Evaluation
		bindFunc(cast(void**)&scm_promise_p, "scm_promise_p");
		bindFunc(cast(void**)&scm_force, "scm_force");

		//6.17.10 Local Evaluation
		bindFunc(cast(void**)&scm_local_eval, "scm_local_eval");

		//6.18.1 Function related to Garbage Collection
		bindFunc(cast(void**)&scm_gc, "scm_gc");
		bindFunc(cast(void**)&scm_gc_protect_object, "scm_gc_protect_object");
		bindFunc(cast(void**)&scm_gc_unprotect_object, "scm_gc_unprotect_object");
		bindFunc(cast(void**)&scm_permanent_object, "scm_permanent_object");
		bindFunc(cast(void**)&scm_gc_stats, "scm_gc_stats");
		bindFunc(cast(void**)&scm_gc_live_object_stats, "scm_gc_live_object_stats");

		//6.18.2 Memory Blocks
		bindFunc(cast(void**)&scm_malloc, "scm_malloc");
		bindFunc(cast(void**)&scm_calloc, "scm_calloc");
		bindFunc(cast(void**)&scm_realloc, "scm_realloc");
		bindFunc(cast(void**)&scm_gc_malloc, "scm_gc_malloc");
		bindFunc(cast(void**)&scm_gc_malloc_pointerless, "scm_gc_malloc_pointerless");
		bindFunc(cast(void**)&scm_gc_realloc, "scm_gc_realloc");
		bindFunc(cast(void**)&scm_gc_calloc, "scm_gc_calloc");
		bindFunc(cast(void**)&scm_gc_free, "scm_gc_free");
		bindFunc(cast(void**)&scm_gc_register_allocation, "scm_gc_register_allocation");
		bindFunc(cast(void**)&scm_dynwind_free, "scm_dynwind_free");

		//6.18.3.1 Weak hash tables
		bindFunc(cast(void**)&scm_make_weak_key_hash_table, "scm_make_weak_key_hash_table");
		bindFunc(cast(void**)&scm_make_weak_value_hash_table, "scm_make_weak_value_hash_table");
		bindFunc(cast(void**)&scm_make_doubly_weak_hash_table, "scm_make_doubly_weak_hash_table");
		bindFunc(cast(void**)&scm_weak_key_hash_table_p, "scm_weak_key_hash_table_p");
		bindFunc(cast(void**)&scm_weak_value_hash_table_p, "scm_weak_value_hash_table_p");
		bindFunc(cast(void**)&scm_doubly_weak_hash_table_p, "scm_doubly_weak_hash_table_p");

		//6.18.3.2 Weak vectors
		bindFunc(cast(void**)&scm_make_weak_vector, "scm_make_weak_vector");
		bindFunc(cast(void**)&scm_weak_vector, "scm_weak_vector");
		bindFunc(cast(void**)&scm_weak_vector_p, "scm_weak_vector_p");
		bindFunc(cast(void**)&scm_weak_vector_ref, "scm_weak_vector_ref");
		bindFunc(cast(void**)&scm_weak_vector_set_x, "scm_weak_vector_set_x");

		//6.18.4 Guardians
		bindFunc(cast(void**)&scm_make_guardian, "scm_make_guardian");

		//6.19.7 Variables
		bindFunc(cast(void**)&scm_make_undefined_variable, "scm_make_undefined_variable");
		bindFunc(cast(void**)&scm_make_variable, "scm_make_variable");
		bindFunc(cast(void**)&scm_variable_bound_p, "scm_variable_bound_p");
		bindFunc(cast(void**)&scm_variable_ref, "scm_variable_ref");
		bindFunc(cast(void**)&scm_variable_set_x, "scm_variable_set_x");
		bindFunc(cast(void**)&scm_variable_unset_x, "scm_variable_unset_x");
		bindFunc(cast(void**)&scm_variable_p, "scm_variable_p");

		//6.19.8 Module System Reflection
		bindFunc(cast(void**)&scm_current_module, "scm_current_module");
		bindFunc(cast(void**)&scm_set_current_module, "scm_set_current_module");
		bindFunc(cast(void**)&scm_resolve_module, "scm_resolve_module");

		//6.19.9 Accessing Modules from C
		bindFunc(cast(void**)&scm_c_call_with_current_module, "scm_c_call_with_current_module");
		bindFunc(cast(void**)&scm_public_variable, "scm_public_variable");
		bindFunc(cast(void**)&scm_c_public_variable, "scm_c_public_variable");
		bindFunc(cast(void**)&scm_private_variable, "scm_private_variable");
		bindFunc(cast(void**)&scm_c_private_variable, "scm_c_private_variable");
		bindFunc(cast(void**)&scm_public_lookup, "scm_public_lookup");
		bindFunc(cast(void**)&scm_c_public_lookup, "scm_c_public_lookup");
		bindFunc(cast(void**)&scm_private_lookup, "scm_private_lookup");
		bindFunc(cast(void**)&scm_c_private_lookup, "scm_c_private_lookup");
		bindFunc(cast(void**)&scm_public_ref, "scm_public_ref");
		bindFunc(cast(void**)&scm_c_public_ref, "scm_c_public_ref");
		bindFunc(cast(void**)&scm_private_ref, "scm_private_ref");
		bindFunc(cast(void**)&scm_c_private_ref, "scm_c_private_ref");
		bindFunc(cast(void**)&scm_c_lookup, "scm_c_lookup");
		bindFunc(cast(void**)&scm_lookup, "scm_lookup");
		bindFunc(cast(void**)&scm_c_module_lookup, "scm_c_module_lookup");
		bindFunc(cast(void**)&scm_module_lookup, "scm_module_lookup");
		bindFunc(cast(void**)&scm_module_variable, "scm_module_variable");
		bindFunc(cast(void**)&scm_c_define, "scm_c_define");
		bindFunc(cast(void**)&scm_define, "scm_define");
		bindFunc(cast(void**)&scm_c_module_define, "scm_c_module_define");
		bindFunc(cast(void**)&scm_module_define, "scm_module_define");
		bindFunc(cast(void**)&scm_module_ensure_local_variable, "scm_module_ensure_local_variable");
		bindFunc(cast(void**)&scm_module_reverse_lookup, "scm_module_reverse_lookup");
		bindFunc(cast(void**)&scm_c_define_module, "scm_c_define_module");
		bindFunc(cast(void**)&scm_c_resolve_module, "scm_c_resolve_module");
		bindFunc(cast(void**)&scm_c_use_module, "scm_c_use_module");
		bindFunc(cast(void**)&scm_c_export, "scm_c_export");

		//6.20.1 Foreign Libraries
		bindFunc(cast(void**)&scm_dynamic_link, "scm_dynamic_link");
		bindFunc(cast(void**)&scm_dynamic_object_p, "scm_dynamic_object_p");
		bindFunc(cast(void**)&scm_dynamic_unlink, "scm_dynamic_unlink");

		//6.20.2 Foreign Functions
		bindFunc(cast(void**)&scm_dynamic_func, "scm_dynamic_func");
		bindFunc(cast(void**)&scm_dynamic_call, "scm_dynamic_call");
		bindFunc(cast(void**)&scm_load_extension, "scm_load_extension");

		//6.20.5.2 Foreign Variables
		bindFunc(cast(void**)&scm_dynamic_pointer, "scm_dynamic_pointer");
		bindFunc(cast(void**)&scm_pointer_address, "scm_pointer_address");
		bindFunc(cast(void**)&scm_from_pointer, "scm_from_pointer");
		bindFunc(cast(void**)&scm_to_pointer, "scm_to_pointer");

		//6.20.5.3 Void Pointers and Byte Access
		bindFunc(cast(void**)&scm_pointer_to_bytevector, "scm_pointer_to_bytevector");
		bindFunc(cast(void**)&scm_bytevector_to_pointer, "scm_bytevector_to_pointer");

		//6.20.5.4 Foreign Structs
		bindFunc(cast(void**)&scm_sizeof, "scm_sizeof");
		bindFunc(cast(void**)&scm_alignof, "scm_alignof");

		//6.20.6 Dynamic FFI
		bindFunc(cast(void**)&scm_procedure_to_pointer, "scm_procedure_to_pointer");

		//6.21.1 Arbiters
		bindFunc(cast(void**)&scm_make_arbiter, "scm_make_arbiter");
		bindFunc(cast(void**)&scm_try_arbiter, "scm_try_arbiter");
		bindFunc(cast(void**)&scm_release_arbiter, "scm_release_arbiter");

		//6.21.2.1 System asyncs
		bindFunc(cast(void**)&scm_system_async_mark, "scm_system_async_mark");
		bindFunc(cast(void**)&scm_system_async_mark_for_thread, "scm_system_async_mark_for_thread");
		bindFunc(cast(void**)&scm_call_with_blocked_asyncs, "scm_call_with_blocked_asyncs");
		bindFunc(cast(void**)&scm_c_call_with_blocked_asyncs, "scm_c_call_with_blocked_asyncs");
		bindFunc(cast(void**)&scm_call_with_unblocked_asyncs, "scm_call_with_unblocked_asyncs");
		bindFunc(cast(void**)&scm_c_call_with_unblocked_asyncs, "scm_c_call_with_unblocked_asyncs");
		bindFunc(cast(void**)&scm_dynwind_block_asyncs, "scm_dynwind_block_asyncs");
		bindFunc(cast(void**)&scm_dynwind_unblock_asyncs, "scm_dynwind_unblock_asyncs");

		//6.21.2.2 User asyncs
		bindFunc(cast(void**)&scm_async, "scm_async");
		bindFunc(cast(void**)&scm_async_mark, "scm_async_mark");
		bindFunc(cast(void**)&scm_run_asyncs, "scm_run_asyncs");

		//6.21.3 Threads
		bindFunc(cast(void**)&scm_all_threads, "scm_all_threads");
		bindFunc(cast(void**)&scm_current_thread, "scm_current_thread");
		bindFunc(cast(void**)&scm_spawn_thread, "scm_spawn_thread");
		bindFunc(cast(void**)&scm_thread_p, "scm_thread_p");
		bindFunc(cast(void**)&scm_join_thread, "scm_join_thread");
		bindFunc(cast(void**)&scm_join_thread_timed, "scm_join_thread_timed");
		bindFunc(cast(void**)&scm_thread_exited_p, "scm_thread_exited_p");
		bindFunc(cast(void**)&scm_cancel_thread, "scm_cancel_thread");
		bindFunc(cast(void**)&scm_set_thread_cleanup_x, "scm_set_thread_cleanup_x");
		bindFunc(cast(void**)&scm_thread_cleanup, "scm_thread_cleanup");

		//6.21.4 Mutexes and Condition Variables
		bindFunc(cast(void**)&scm_make_mutex, "scm_make_mutex");
		bindFunc(cast(void**)&scm_make_mutex_with_flags, "scm_make_mutex_with_flags");
		bindFunc(cast(void**)&scm_mutex_p, "scm_mutex_p");
		bindFunc(cast(void**)&scm_lock_mutex, "scm_lock_mutex");
		bindFunc(cast(void**)&scm_lock_mutex_timed, "scm_lock_mutex_timed");
		bindFunc(cast(void**)&scm_dynwind_lock_mutex, "scm_dynwind_lock_mutex");
		bindFunc(cast(void**)&scm_try_mutex, "scm_try_mutex");
		bindFunc(cast(void**)&scm_unlock_mutex, "scm_unlock_mutex");
		bindFunc(cast(void**)&scm_unlock_mutex_timed, "scm_unlock_mutex_timed");
		bindFunc(cast(void**)&scm_mutex_owner, "scm_mutex_owner");
		bindFunc(cast(void**)&scm_mutex_level, "scm_mutex_level");
		bindFunc(cast(void**)&scm_mutex_locked_p, "scm_mutex_locked_p");
		bindFunc(cast(void**)&scm_make_condition_variable, "scm_make_condition_variable");
		bindFunc(cast(void**)&scm_condition_variable_p, "scm_condition_variable_p");
		bindFunc(cast(void**)&scm_wait_condition_variable, "scm_wait_condition_variable");
		bindFunc(cast(void**)&scm_signal_condition_variable, "scm_signal_condition_variable");
		bindFunc(cast(void**)&scm_broadcast_condition_variable, "scm_broadcast_condition_variable");

		//6.21.5 Blocking in Guile Mode
		/* not included at the moment
		bindFunc(cast(void**)&scm_without_guile, "scm_without_guile");
		bindFunc(cast(void**)&scm_pthread_mutex_lock, "scm_pthread_mutex_lock");
		bindFunc(cast(void**)&scm_pthread_cond_wait, "scm_pthread_cond_wait");
		bindFunc(cast(void**)&scm_pthread_cond_timedwait, "scm_pthread_cond_timedwait");
		bindFunc(cast(void**)&scm_std_select, "scm_std_select");
		bindFunc(cast(void**)&scm_std_sleep, "scm_std_sleep");
		bindFunc(cast(void**)&scm_std_usleep, "scm_std_usleep");
		*/

		//6.21.6 Critical Sections
		bindFunc(cast(void**)&scm_dynwind_critical_section, "scm_dynwind_critical_section");

		//6.21.7 Fluids and Dynamic States
		bindFunc(cast(void**)&scm_make_fluid, "scm_make_fluid");
		bindFunc(cast(void**)&scm_make_fluid_with_default, "scm_make_fluid_with_default");
		bindFunc(cast(void**)&scm_make_unbound_fluid, "scm_make_unbound_fluid");
		bindFunc(cast(void**)&scm_fluid_p, "scm_fluid_p");
		bindFunc(cast(void**)&scm_fluid_ref, "scm_fluid_ref");
		bindFunc(cast(void**)&scm_fluid_set_x, "scm_fluid_set_x");
		bindFunc(cast(void**)&scm_fluid_unset_x, "scm_fluid_unset_x");
		bindFunc(cast(void**)&scm_fluid_bound_p, "scm_fluid_bound_p");
		bindFunc(cast(void**)&scm_with_fluid, "scm_with_fluid");
		bindFunc(cast(void**)&scm_with_fluids, "scm_with_fluids");
		bindFunc(cast(void**)&scm_c_with_fluids, "scm_c_with_fluids");
		bindFunc(cast(void**)&scm_c_with_fluid, "scm_c_with_fluid");
		bindFunc(cast(void**)&scm_dynwind_fluid, "scm_dynwind_fluid");
		bindFunc(cast(void**)&scm_make_dynamic_state, "scm_make_dynamic_state");
		bindFunc(cast(void**)&scm_dynamic_state_p, "scm_dynamic_state_p");
		bindFunc(cast(void**)&scm_current_dynamic_state, "scm_current_dynamic_state");
		bindFunc(cast(void**)&scm_set_current_dynamic_state, "scm_set_current_dynamic_state");
		bindFunc(cast(void**)&scm_with_dynamic_state, "scm_with_dynamic_state");

		//6.22.1 Configuration, Build and Installation
		bindFunc(cast(void**)&scm_version, "scm_version");
		bindFunc(cast(void**)&scm_effective_version, "scm_effective_version");
		bindFunc(cast(void**)&scm_major_version, "scm_major_version");
		bindFunc(cast(void**)&scm_minor_version, "scm_minor_version");
		bindFunc(cast(void**)&scm_micro_version, "scm_micro_version");
		bindFunc(cast(void**)&scm_sys_package_data_dir, "scm_sys_package_data_dir");
		bindFunc(cast(void**)&scm_sys_library_dir, "scm_sys_library_dir");
		bindFunc(cast(void**)&scm_sys_site_dir, "scm_sys_site_dir");
		bindFunc(cast(void**)&scm_sys_site_ccache_dir, "scm_sys_site_ccache_dir");

		//6.22.2.1 Feature Manipulation
		bindFunc(cast(void**)&scm_add_feature, "scm_add_feature");

		//6.24.1 Internationalization with Guile
		bindFunc(cast(void**)&scm_make_locale, "scm_make_locale");
		bindFunc(cast(void**)&scm_locale_p, "scm_locale_p");

		//6.24.2 Text Collation
		bindFunc(cast(void**)&scm_string_locale_lt, "scm_string_locale_lt");
		bindFunc(cast(void**)&scm_string_locale_gt, "scm_string_locale_gt");
		bindFunc(cast(void**)&scm_string_locale_ci_lt, "scm_string_locale_ci_lt");
		bindFunc(cast(void**)&scm_string_locale_ci_gt, "scm_string_locale_ci_gt");
		bindFunc(cast(void**)&scm_string_locale_ci_eq, "scm_string_locale_ci_eq");
		bindFunc(cast(void**)&scm_char_locale_lt, "scm_char_locale_lt");
		bindFunc(cast(void**)&scm_char_locale_gt, "scm_char_locale_gt");
		bindFunc(cast(void**)&scm_char_locale_ci_lt, "scm_char_locale_ci_lt");
		bindFunc(cast(void**)&scm_char_locale_ci_gt, "scm_char_locale_ci_gt");
		bindFunc(cast(void**)&scm_char_locale_ci_eq, "scm_char_locale_ci_eq");

		//6.24.3 Character Case Mapping
		bindFunc(cast(void**)&scm_char_locale_upcase, "scm_char_locale_upcase");
		bindFunc(cast(void**)&scm_char_locale_downcase, "scm_char_locale_downcase");
		bindFunc(cast(void**)&scm_char_locale_titlecase, "scm_char_locale_titlecase");
		bindFunc(cast(void**)&scm_string_locale_upcase, "scm_string_locale_upcase");
		bindFunc(cast(void**)&scm_string_locale_downcase, "scm_string_locale_downcase");
		bindFunc(cast(void**)&scm_string_locale_titlecase, "scm_string_locale_titlecase");

		//6.24.4 Number Input and Output
		bindFunc(cast(void**)&scm_locale_string_to_integer, "scm_locale_string_to_integer");
		bindFunc(cast(void**)&scm_locale_string_to_inexact, "scm_locale_string_to_inexact");

		//6.24.6 Gettext Support
		bindFunc(cast(void**)&scm_gettext, "scm_gettext");
		bindFunc(cast(void**)&scm_ngettext, "scm_ngettext");
		bindFunc(cast(void**)&scm_textdomain, "scm_textdomain");
		bindFunc(cast(void**)&scm_bindtextdomain, "scm_bindtextdomain");
		bindFunc(cast(void**)&scm_bind_textdomain_codeset, "scm_bind_textdomain_codeset");

		//6.25.1.1 Stack Capture
		bindFunc(cast(void**)&scm_make_stack, "scm_make_stack");

		//6.25.1.2 Stacks
		bindFunc(cast(void**)&scm_stack_p, "scm_stack_p");
		bindFunc(cast(void**)&scm_stack_id, "scm_stack_id");
		bindFunc(cast(void**)&scm_stack_length, "scm_stack_length");
		bindFunc(cast(void**)&scm_stack_ref, "scm_stack_ref");
		bindFunc(cast(void**)&scm_display_backtrace_with_highlights, "scm_display_backtrace_with_highlights");
		bindFunc(cast(void**)&scm_display_backtrace, "scm_display_backtrace");

		//6.25.1.3 Frames
		bindFunc(cast(void**)&scm_frame_p, "scm_frame_p");
		bindFunc(cast(void**)&scm_frame_previous, "scm_frame_previous");
		bindFunc(cast(void**)&scm_frame_procedure, "scm_frame_procedure");
		bindFunc(cast(void**)&scm_frame_arguments, "scm_frame_arguments");
		bindFunc(cast(void**)&scm_display_application, "scm_display_application");

		//6.25.2 Source Properties
		bindFunc(cast(void**)&scm_supports_source_properties_p, "scm_supports_source_properties_p");
		bindFunc(cast(void**)&scm_set_source_properties_x, "scm_set_source_properties_x");
		bindFunc(cast(void**)&scm_set_source_property_x, "scm_set_source_property_x");
		bindFunc(cast(void**)&scm_source_properties, "scm_source_properties");
		bindFunc(cast(void**)&scm_source_property, "scm_source_property");
		bindFunc(cast(void**)&scm_cons_source, "scm_cons_source");

		//6.25.3.3 Pre-Unwind Debugging
		bindFunc(cast(void**)&scm_backtrace_with_highlights, "scm_backtrace_with_highlights");
		bindFunc(cast(void**)&scm_backtrace, "scm_backtrace");

		//7.2.2 Ports and File Descriptors
		bindFunc(cast(void**)&scm_port_revealed, "scm_port_revealed");
		bindFunc(cast(void**)&scm_set_port_revealed_x, "scm_set_port_revealed_x");
		bindFunc(cast(void**)&scm_fileno, "scm_fileno");
		bindFunc(cast(void**)&scm_fdopen, "scm_fdopen");
		bindFunc(cast(void**)&scm_fdes_to_ports, "scm_fdes_to_ports");
		bindFunc(cast(void**)&scm_primitive_move_to_fdes, "scm_primitive_move_to_fdes");
		bindFunc(cast(void**)&scm_fsync, "scm_fsync");
		bindFunc(cast(void**)&scm_open, "scm_open");
		bindFunc(cast(void**)&scm_open_fdes, "scm_open_fdes");
		bindFunc(cast(void**)&scm_close, "scm_close");
		bindFunc(cast(void**)&scm_close_fdes, "scm_close_fdes");
		bindFunc(cast(void**)&scm_pipe, "scm_pipe");
		bindFunc(cast(void**)&scm_dup_to_fdes, "scm_dup_to_fdes");
		bindFunc(cast(void**)&scm_redirect_port, "scm_redirect_port");
		bindFunc(cast(void**)&scm_dup2, "scm_dup2");
		bindFunc(cast(void**)&scm_port_for_each, "scm_port_for_each");
		bindFunc(cast(void**)&scm_c_port_for_each, "scm_c_port_for_each");
		bindFunc(cast(void**)&scm_setvbuf, "scm_setvbuf");
		bindFunc(cast(void**)&scm_fcntl, "scm_fcntl");
		bindFunc(cast(void**)&scm_flock, "scm_flock");
		bindFunc(cast(void**)&scm_select, "scm_select");

		//7.2.3 File System
		bindFunc(cast(void**)&scm_access, "scm_access");
		bindFunc(cast(void**)&scm_stat, "scm_stat");
		bindFunc(cast(void**)&scm_lstat, "scm_lstat");
		bindFunc(cast(void**)&scm_readlink, "scm_readlink");
		bindFunc(cast(void**)&scm_chown, "scm_chown");
		bindFunc(cast(void**)&scm_chmod, "scm_chmod");
		bindFunc(cast(void**)&scm_utime, "scm_utime");
		bindFunc(cast(void**)&scm_delete_file, "scm_delete_file");
		bindFunc(cast(void**)&scm_copy_file, "scm_copy_file");
		bindFunc(cast(void**)&scm_sendfile, "scm_sendfile");
		bindFunc(cast(void**)&scm_rename, "scm_rename");
		bindFunc(cast(void**)&scm_link, "scm_link");
		bindFunc(cast(void**)&scm_symlink, "scm_symlink");
		bindFunc(cast(void**)&scm_mkdir, "scm_mkdir");
		bindFunc(cast(void**)&scm_rmdir, "scm_rmdir");
		bindFunc(cast(void**)&scm_opendir, "scm_opendir");
		bindFunc(cast(void**)&scm_directory_stream_p, "scm_directory_stream_p");
		bindFunc(cast(void**)&scm_readdir, "scm_readdir");
		bindFunc(cast(void**)&scm_rewinddir, "scm_rewinddir");
		bindFunc(cast(void**)&scm_closedir, "scm_closedir");
		bindFunc(cast(void**)&scm_sync, "scm_sync");
		bindFunc(cast(void**)&scm_mknod, "scm_mknod");
		bindFunc(cast(void**)&scm_tmpnam, "scm_tmpnam");
		bindFunc(cast(void**)&scm_mkstemp, "scm_mkstemp");
		bindFunc(cast(void**)&scm_tmpfile, "scm_tmpfile");
		bindFunc(cast(void**)&scm_dirname, "scm_dirname");
		bindFunc(cast(void**)&scm_basename, "scm_basename");

		//7.2.4 User Information
		bindFunc(cast(void**)&scm_setpwent, "scm_setpwent");
		bindFunc(cast(void**)&scm_getpwuid, "scm_getpwuid");
		bindFunc(cast(void**)&scm_setgrent, "scm_setgrent");
		bindFunc(cast(void**)&scm_getgrgid, "scm_getgrgid");
		bindFunc(cast(void**)&scm_getlogin, "scm_getlogin");

		//7.2.5 Time
		bindFunc(cast(void**)&scm_current_time, "scm_current_time");
		bindFunc(cast(void**)&scm_gettimeofday, "scm_gettimeofday");
		bindFunc(cast(void**)&scm_localtime, "scm_localtime");
		bindFunc(cast(void**)&scm_gmtime, "scm_gmtime");
		bindFunc(cast(void**)&scm_mktime, "scm_mktime");
		bindFunc(cast(void**)&scm_tzset, "scm_tzset");
		bindFunc(cast(void**)&scm_strftime, "scm_strftime");
		bindFunc(cast(void**)&scm_strptime, "scm_strptime");
		bindFunc(cast(void**)&scm_times, "scm_times");
		bindFunc(cast(void**)&scm_get_internal_real_time, "scm_get_internal_real_time");
		bindFunc(cast(void**)&scm_get_internal_run_time, "scm_get_internal_run_time");

		//7.2.6 Runtime Environment
		bindFunc(cast(void**)&scm_program_arguments, "scm_program_arguments");
		bindFunc(cast(void**)&scm_set_program_arguments_scm, "scm_set_program_arguments_scm");
		bindFunc(cast(void**)&scm_set_program_arguments, "scm_set_program_arguments");
		bindFunc(cast(void**)&scm_getenv, "scm_getenv");
		bindFunc(cast(void**)&scm_environ, "scm_environ");
		bindFunc(cast(void**)&scm_putenv, "scm_putenv");

		//7.2.7 Processes
		bindFunc(cast(void**)&scm_chdir, "scm_chdir");
		bindFunc(cast(void**)&scm_getcwd, "scm_getcwd");
		bindFunc(cast(void**)&scm_umask, "scm_umask");
		bindFunc(cast(void**)&scm_chroot, "scm_chroot");
		bindFunc(cast(void**)&scm_getpid, "scm_getpid");
		bindFunc(cast(void**)&scm_getgroups, "scm_getgroups");
		bindFunc(cast(void**)&scm_getppid, "scm_getppid");
		bindFunc(cast(void**)&scm_getuid, "scm_getuid");
		bindFunc(cast(void**)&scm_getgid, "scm_getgid");
		bindFunc(cast(void**)&scm_geteuid, "scm_geteuid");
		bindFunc(cast(void**)&scm_getegid, "scm_getegid");
		bindFunc(cast(void**)&scm_setgroups, "scm_setgroups");
		bindFunc(cast(void**)&scm_setuid, "scm_setuid");
		bindFunc(cast(void**)&scm_setgid, "scm_setgid");
		bindFunc(cast(void**)&scm_seteuid, "scm_seteuid");
		bindFunc(cast(void**)&scm_setegid, "scm_setegid");
		bindFunc(cast(void**)&scm_getpgrp, "scm_getpgrp");
		bindFunc(cast(void**)&scm_setpgid, "scm_setpgid");
		bindFunc(cast(void**)&scm_setsid, "scm_setsid");
		bindFunc(cast(void**)&scm_getsid, "scm_getsid");
		bindFunc(cast(void**)&scm_waitpid, "scm_waitpid");
		bindFunc(cast(void**)&scm_status_exit_val, "scm_status_exit_val");
		bindFunc(cast(void**)&scm_status_term_sig, "scm_status_term_sig");
		bindFunc(cast(void**)&scm_status_stop_sig, "scm_status_stop_sig");
		bindFunc(cast(void**)&scm_system, "scm_system");
		bindFunc(cast(void**)&scm_system_star, "scm_system_star");
		bindFunc(cast(void**)&scm_primitive_exit, "scm_primitive_exit");
		bindFunc(cast(void**)&scm_primitive__exit, "scm_primitive__exit");
		bindFunc(cast(void**)&scm_execl, "scm_execl");
		bindFunc(cast(void**)&scm_execlp, "scm_execlp");
		bindFunc(cast(void**)&scm_execle, "scm_execle");
		bindFunc(cast(void**)&scm_fork, "scm_fork");
		bindFunc(cast(void**)&scm_nice, "scm_nice");
		bindFunc(cast(void**)&scm_setpriority, "scm_setpriority");
		bindFunc(cast(void**)&scm_getpriority, "scm_getpriority");
		bindFunc(cast(void**)&scm_getaffinity, "scm_getaffinity");
		bindFunc(cast(void**)&scm_setaffinity, "scm_setaffinity");
		bindFunc(cast(void**)&scm_total_processor_count, "scm_total_processor_count");
		bindFunc(cast(void**)&scm_current_processor_count, "scm_current_processor_count");

		//7.2.8 Signals
		bindFunc(cast(void**)&scm_kill, "scm_kill");
		bindFunc(cast(void**)&scm_raise, "scm_raise");
		bindFunc(cast(void**)&scm_sigaction, "scm_sigaction");
		bindFunc(cast(void**)&scm_sigaction_for_thread, "scm_sigaction_for_thread");
		bindFunc(cast(void**)&scm_alarm, "scm_alarm");
		bindFunc(cast(void**)&scm_pause, "scm_pause");
		bindFunc(cast(void**)&scm_sleep, "scm_sleep");
		bindFunc(cast(void**)&scm_usleep, "scm_usleep");
		bindFunc(cast(void**)&scm_getitimer, "scm_getitimer");
		bindFunc(cast(void**)&scm_setitimer, "scm_setitimer");

		//7.2.9 Terminals and Ptys
		bindFunc(cast(void**)&scm_isatty_p, "scm_isatty_p");
		bindFunc(cast(void**)&scm_ttyname, "scm_ttyname");
		bindFunc(cast(void**)&scm_ctermid, "scm_ctermid");
		bindFunc(cast(void**)&scm_tcgetpgrp, "scm_tcgetpgrp");
		bindFunc(cast(void**)&scm_tcsetpgrp, "scm_tcsetpgrp");

		//7.2.11.1 Network Address Conversion
		bindFunc(cast(void**)&scm_inet_aton, "scm_inet_aton");
		bindFunc(cast(void**)&scm_inet_ntoa, "scm_inet_ntoa");
		bindFunc(cast(void**)&scm_inet_netof, "scm_inet_netof");
		bindFunc(cast(void**)&scm_lnaof, "scm_lnaof");
		bindFunc(cast(void**)&scm_inet_makeaddr, "scm_inet_makeaddr");
		bindFunc(cast(void**)&scm_inet_ntop, "scm_inet_ntop");
		bindFunc(cast(void**)&scm_inet_pton, "scm_inet_pton");

		//7.2.11.2 Network Databases
		bindFunc(cast(void**)&scm_getaddrinfo, "scm_getaddrinfo");
		bindFunc(cast(void**)&scm_gethost, "scm_gethost");
		bindFunc(cast(void**)&scm_sethost, "scm_sethost");
		bindFunc(cast(void**)&scm_getnet, "scm_getnet");
		bindFunc(cast(void**)&scm_setnet, "scm_setnet");
		bindFunc(cast(void**)&scm_getproto, "scm_getproto");
		bindFunc(cast(void**)&scm_setproto, "scm_setproto");
		bindFunc(cast(void**)&scm_getserv, "scm_getserv");
		bindFunc(cast(void**)&scm_setserv, "scm_setserv");

		//7.2.11.3 Network Socket Address
		bindFunc(cast(void**)&scm_make_socket_address, "scm_make_socket_address");
		bindFunc(cast(void**)&scm_c_make_socket_address, "scm_c_make_socket_address");
		bindFunc(cast(void**)&scm_from_sockaddr, "scm_from_sockaddr");
		bindFunc(cast(void**)&scm_to_sockaddr, "scm_to_sockaddr");

		//7.2.11.4 Network Sockets and Communication
		bindFunc(cast(void**)&scm_socket, "scm_socket");
		bindFunc(cast(void**)&scm_socketpair, "scm_socketpair");
		bindFunc(cast(void**)&scm_getsockopt, "scm_getsockopt");
		bindFunc(cast(void**)&scm_setsockopt, "scm_setsockopt");
		bindFunc(cast(void**)&scm_shutdown, "scm_shutdown");
		bindFunc(cast(void**)&scm_connect, "scm_connect");
		bindFunc(cast(void**)&scm_bind, "scm_bind");
		bindFunc(cast(void**)&scm_listen, "scm_listen");
		bindFunc(cast(void**)&scm_accept, "scm_accept");
		bindFunc(cast(void**)&scm_getsockname, "scm_getsockname");
		bindFunc(cast(void**)&scm_getpeername, "scm_getpeername");
		bindFunc(cast(void**)&scm_recv, "scm_recv");
		bindFunc(cast(void**)&scm_send, "scm_send");
		bindFunc(cast(void**)&scm_recvfrom, "scm_recvfrom");
		bindFunc(cast(void**)&scm_sendto, "scm_sendto");

		//7.2.12 System Identification
		bindFunc(cast(void**)&scm_uname, "scm_uname");
		bindFunc(cast(void**)&scm_gethostname, "scm_gethostname");
		bindFunc(cast(void**)&scm_sethostname, "scm_sethostname");

		//7.2.13 Locales
		bindFunc(cast(void**)&scm_setlocale, "scm_setlocale");

		//7.2.14 Encryption
		bindFunc(cast(void**)&scm_crypt, "scm_crypt");
		bindFunc(cast(void**)&scm_getpass, "scm_getpass");

		//7.5.5.2 SRFI-4 - API
		bindFunc(cast(void**)&scm_u8vector_p, "scm_u8vector_p");
		bindFunc(cast(void**)&scm_s8vector_p, "scm_s8vector_p");
		bindFunc(cast(void**)&scm_u16vector_p, "scm_u16vector_p");
		bindFunc(cast(void**)&scm_s16vector_p, "scm_s16vector_p");
		bindFunc(cast(void**)&scm_u32vector_p, "scm_u32vector_p");
		bindFunc(cast(void**)&scm_s32vector_p, "scm_s32vector_p");
		bindFunc(cast(void**)&scm_u64vector_p, "scm_u64vector_p");
		bindFunc(cast(void**)&scm_s64vector_p, "scm_s64vector_p");
		bindFunc(cast(void**)&scm_f32vector_p, "scm_f32vector_p");
		bindFunc(cast(void**)&scm_f64vector_p, "scm_f64vector_p");
		bindFunc(cast(void**)&scm_c32vector_p, "scm_c32vector_p");
		bindFunc(cast(void**)&scm_c64vector_p, "scm_c64vector_p");
		bindFunc(cast(void**)&scm_make_u8vector, "scm_make_u8vector");
		bindFunc(cast(void**)&scm_make_s8vector, "scm_make_s8vector");
		bindFunc(cast(void**)&scm_make_u16vector, "scm_make_u16vector");
		bindFunc(cast(void**)&scm_make_s16vector, "scm_make_s16vector");
		bindFunc(cast(void**)&scm_make_u32vector, "scm_make_u32vector");
		bindFunc(cast(void**)&scm_make_s32vector, "scm_make_s32vector");
		bindFunc(cast(void**)&scm_make_u64vector, "scm_make_u64vector");
		bindFunc(cast(void**)&scm_make_s64vector, "scm_make_s64vector");
		bindFunc(cast(void**)&scm_make_f32vector, "scm_make_f32vector");
		bindFunc(cast(void**)&scm_make_f64vector, "scm_make_f64vector");
		bindFunc(cast(void**)&scm_make_c32vector, "scm_make_c32vector");
		bindFunc(cast(void**)&scm_make_c64vector, "scm_make_c64vector");
		bindFunc(cast(void**)&scm_u8vector, "scm_u8vector");
		bindFunc(cast(void**)&scm_s8vector, "scm_s8vector");
		bindFunc(cast(void**)&scm_u16vector, "scm_u16vector");
		bindFunc(cast(void**)&scm_s16vector, "scm_s16vector");
		bindFunc(cast(void**)&scm_u32vector, "scm_u32vector");
		bindFunc(cast(void**)&scm_s32vector, "scm_s32vector");
		bindFunc(cast(void**)&scm_u64vector, "scm_u64vector");
		bindFunc(cast(void**)&scm_s64vector, "scm_s64vector");
		bindFunc(cast(void**)&scm_f32vector, "scm_f32vector");
		bindFunc(cast(void**)&scm_f64vector, "scm_f64vector");
		bindFunc(cast(void**)&scm_c32vector, "scm_c32vector");
		bindFunc(cast(void**)&scm_c64vector, "scm_c64vector");
		bindFunc(cast(void**)&scm_u8vector_length, "scm_u8vector_length");
		bindFunc(cast(void**)&scm_s8vector_length, "scm_s8vector_length");
		bindFunc(cast(void**)&scm_u16vector_length, "scm_u16vector_length");
		bindFunc(cast(void**)&scm_s16vector_length, "scm_s16vector_length");
		bindFunc(cast(void**)&scm_u32vector_length, "scm_u32vector_length");
		bindFunc(cast(void**)&scm_s32vector_length, "scm_s32vector_length");
		bindFunc(cast(void**)&scm_u64vector_length, "scm_u64vector_length");
		bindFunc(cast(void**)&scm_s64vector_length, "scm_s64vector_length");
		bindFunc(cast(void**)&scm_f32vector_length, "scm_f32vector_length");
		bindFunc(cast(void**)&scm_f64vector_length, "scm_f64vector_length");
		bindFunc(cast(void**)&scm_c32vector_length, "scm_c32vector_length");
		bindFunc(cast(void**)&scm_c64vector_length, "scm_c64vector_length");
		bindFunc(cast(void**)&scm_u8vector_ref, "scm_u8vector_ref");
		bindFunc(cast(void**)&scm_s8vector_ref, "scm_s8vector_ref");
		bindFunc(cast(void**)&scm_u16vector_ref, "scm_u16vector_ref");
		bindFunc(cast(void**)&scm_s16vector_ref, "scm_s16vector_ref");
		bindFunc(cast(void**)&scm_u32vector_ref, "scm_u32vector_ref");
		bindFunc(cast(void**)&scm_s32vector_ref, "scm_s32vector_ref");
		bindFunc(cast(void**)&scm_u64vector_ref, "scm_u64vector_ref");
		bindFunc(cast(void**)&scm_s64vector_ref, "scm_s64vector_ref");
		bindFunc(cast(void**)&scm_f32vector_ref, "scm_f32vector_ref");
		bindFunc(cast(void**)&scm_f64vector_ref, "scm_f64vector_ref");
		bindFunc(cast(void**)&scm_c32vector_ref, "scm_c32vector_ref");
		bindFunc(cast(void**)&scm_c64vector_ref, "scm_c64vector_ref");
		bindFunc(cast(void**)&scm_u8vector_set_x, "scm_u8vector_set_x");
		bindFunc(cast(void**)&scm_s8vector_set_x, "scm_s8vector_set_x");
		bindFunc(cast(void**)&scm_u16vector_set_x, "scm_u16vector_set_x");
		bindFunc(cast(void**)&scm_s16vector_set_x, "scm_s16vector_set_x");
		bindFunc(cast(void**)&scm_u32vector_set_x, "scm_u32vector_set_x");
		bindFunc(cast(void**)&scm_s32vector_set_x, "scm_s32vector_set_x");
		bindFunc(cast(void**)&scm_u64vector_set_x, "scm_u64vector_set_x");
		bindFunc(cast(void**)&scm_s64vector_set_x, "scm_s64vector_set_x");
		bindFunc(cast(void**)&scm_f32vector_set_x, "scm_f32vector_set_x");
		bindFunc(cast(void**)&scm_f64vector_set_x, "scm_f64vector_set_x");
		bindFunc(cast(void**)&scm_c32vector_set_x, "scm_c32vector_set_x");
		bindFunc(cast(void**)&scm_c64vector_set_x, "scm_c64vector_set_x");
		bindFunc(cast(void**)&scm_u8vector_to_list, "scm_u8vector_to_list");
		bindFunc(cast(void**)&scm_s8vector_to_list, "scm_s8vector_to_list");
		bindFunc(cast(void**)&scm_u16vector_to_list, "scm_u16vector_to_list");
		bindFunc(cast(void**)&scm_s16vector_to_list, "scm_s16vector_to_list");
		bindFunc(cast(void**)&scm_u32vector_to_list, "scm_u32vector_to_list");
		bindFunc(cast(void**)&scm_s32vector_to_list, "scm_s32vector_to_list");
		bindFunc(cast(void**)&scm_u64vector_to_list, "scm_u64vector_to_list");
		bindFunc(cast(void**)&scm_s64vector_to_list, "scm_s64vector_to_list");
		bindFunc(cast(void**)&scm_f32vector_to_list, "scm_f32vector_to_list");
		bindFunc(cast(void**)&scm_f64vector_to_list, "scm_f64vector_to_list");
		bindFunc(cast(void**)&scm_c32vector_to_list, "scm_c32vector_to_list");
		bindFunc(cast(void**)&scm_c64vector_to_list, "scm_c64vector_to_list");
		bindFunc(cast(void**)&scm_list_to_u8vector, "scm_list_to_u8vector");
		bindFunc(cast(void**)&scm_list_to_s8vector, "scm_list_to_s8vector");
		bindFunc(cast(void**)&scm_list_to_u16vector, "scm_list_to_u16vector");
		bindFunc(cast(void**)&scm_list_to_s16vector, "scm_list_to_s16vector");
		bindFunc(cast(void**)&scm_list_to_u32vector, "scm_list_to_u32vector");
		bindFunc(cast(void**)&scm_list_to_s32vector, "scm_list_to_s32vector");
		bindFunc(cast(void**)&scm_list_to_u64vector, "scm_list_to_u64vector");
		bindFunc(cast(void**)&scm_list_to_s64vector, "scm_list_to_s64vector");
		bindFunc(cast(void**)&scm_list_to_f32vector, "scm_list_to_f32vector");
		bindFunc(cast(void**)&scm_list_to_f64vector, "scm_list_to_f64vector");
		bindFunc(cast(void**)&scm_list_to_c32vector, "scm_list_to_c32vector");
		bindFunc(cast(void**)&scm_list_to_c64vector, "scm_list_to_c64vector");
		bindFunc(cast(void**)&scm_take_u8vector, "scm_take_u8vector");
		bindFunc(cast(void**)&scm_take_s8vector, "scm_take_s8vector");
		bindFunc(cast(void**)&scm_take_u16vector, "scm_take_u16vector");
		bindFunc(cast(void**)&scm_take_s16vector, "scm_take_s16vector");
		bindFunc(cast(void**)&scm_take_u32vector, "scm_take_u32vector");
		bindFunc(cast(void**)&scm_take_s32vector, "scm_take_s32vector");
		bindFunc(cast(void**)&scm_take_u64vector, "scm_take_u64vector");
		bindFunc(cast(void**)&scm_take_s64vector, "scm_take_s64vector");
		bindFunc(cast(void**)&scm_take_f32vector, "scm_take_f32vector");
		bindFunc(cast(void**)&scm_take_f64vector, "scm_take_f64vector");
		bindFunc(cast(void**)&scm_take_c32vector, "scm_take_c32vector");
		bindFunc(cast(void**)&scm_take_c64vector, "scm_take_c64vector");
		bindFunc(cast(void**)&scm_u8vector_elements, "scm_u8vector_elements");
		bindFunc(cast(void**)&scm_s8vector_elements, "scm_s8vector_elements");
		bindFunc(cast(void**)&scm_u16vector_elements, "scm_u16vector_elements");
		bindFunc(cast(void**)&scm_s16vector_elements, "scm_s16vector_elements");
		bindFunc(cast(void**)&scm_u32vector_elements, "scm_u32vector_elements");
		bindFunc(cast(void**)&scm_s32vector_elements, "scm_s32vector_elements");
		bindFunc(cast(void**)&scm_u64vector_elements, "scm_u64vector_elements");
		bindFunc(cast(void**)&scm_s64vector_elements, "scm_s64vector_elements");
		bindFunc(cast(void**)&scm_f32vector_elements, "scm_f32vector_elements");
		bindFunc(cast(void**)&scm_f64vector_elements, "scm_f64vector_elements");
		bindFunc(cast(void**)&scm_c32vector_elements, "scm_c32vector_elements");
		bindFunc(cast(void**)&scm_c64vector_elements, "scm_c64vector_elements");
		bindFunc(cast(void**)&scm_u8vector_writable_elements, "scm_u8vector_writable_elements");
		bindFunc(cast(void**)&scm_s8vector_writable_elements, "scm_s8vector_writable_elements");
		bindFunc(cast(void**)&scm_u16vector_writable_elements, "scm_u16vector_writable_elements");
		bindFunc(cast(void**)&scm_s16vector_writable_elements, "scm_s16vector_writable_elements");
		bindFunc(cast(void**)&scm_u32vector_writable_elements, "scm_u32vector_writable_elements");
		bindFunc(cast(void**)&scm_s32vector_writable_elements, "scm_s32vector_writable_elements");
		bindFunc(cast(void**)&scm_u64vector_writable_elements, "scm_u64vector_writable_elements");
		bindFunc(cast(void**)&scm_s64vector_writable_elements, "scm_s64vector_writable_elements");
		bindFunc(cast(void**)&scm_f32vector_writable_elements, "scm_f32vector_writable_elements");
		bindFunc(cast(void**)&scm_f64vector_writable_elements, "scm_f64vector_writable_elements");
		bindFunc(cast(void**)&scm_c32vector_writable_elements, "scm_c32vector_writable_elements");
		bindFunc(cast(void**)&scm_c64vector_writable_elements, "scm_c64vector_writable_elements");

		//7.5.5.4 SRFI-4 - Guile extensions
		bindFunc(cast(void**)&scm_any_to_u8vector, "scm_any_to_u8vector");
		bindFunc(cast(void**)&scm_any_to_s8vector, "scm_any_to_s8vector");
		bindFunc(cast(void**)&scm_any_to_u16vector, "scm_any_to_u16vector");
		bindFunc(cast(void**)&scm_any_to_s16vector, "scm_any_to_s16vector");
		bindFunc(cast(void**)&scm_any_to_u32vector, "scm_any_to_u32vector");
		bindFunc(cast(void**)&scm_any_to_s32vector, "scm_any_to_s32vector");
		bindFunc(cast(void**)&scm_any_to_u64vector, "scm_any_to_u64vector");
		bindFunc(cast(void**)&scm_any_to_s64vector, "scm_any_to_s64vector");
		bindFunc(cast(void**)&scm_any_to_f32vector, "scm_any_to_f32vector");
		bindFunc(cast(void**)&scm_any_to_f64vector, "scm_any_to_f64vector");
		bindFunc(cast(void**)&scm_any_to_c32vector, "scm_any_to_c32vector");
		bindFunc(cast(void**)&scm_any_to_c64vector, "scm_any_to_c64vector");

		//9.4.6 Bytecode and Objcode
		bindFunc(cast(void**)&scm_objcode_p, "scm_objcode_p");
		bindFunc(cast(void**)&scm_bytecode_to_objcode, "scm_bytecode_to_objcode");
		bindFunc(cast(void**)&scm_load_objcode, "scm_load_objcode");
		bindFunc(cast(void**)&scm_write_objcode, "scm_write_objcode");
		bindFunc(cast(void**)&scm_objcode_to_bytecode, "scm_objcode_to_bytecode");
		bindFunc(cast(void**)&scm_make_program, "scm_make_program");

	}

}

__gshared DerelictGuileLoader DerelictGuile;

shared static this() {
	DerelictGuile = new DerelictGuileLoader();
}
