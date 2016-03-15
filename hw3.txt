(* Coursera Programming Languages, Homework 3, Provided Code *)

exception NoAnswer

datatype pattern = Wildcard
		 | Variable of string
		 | UnitP
		 | ConstP of int
		 | TupleP of pattern list
		 | ConstructorP of string * pattern

datatype valu = Const of int
	      | Unit
	      | Tuple of valu list
	      | Constructor of string * valu

fun g f1 f2 p =
    let 
	val r = g f1 f2 
    in
	case p of
	    Wildcard          => f1 ()
	  | Variable x        => f2 x
	  | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps
	  | ConstructorP(_,p) => r p
	  | _                 => 0
    end

(**** for the challenge problem only ****)

datatype typ = Anything
	     | UnitT
	     | IntT
	     | TupleT of typ list
	     | Datatype of string

(**** you can put all your code here ****)

fun only_capitals lst = 
	List.filter (fn s => Char.isUpper(String.sub(s, 0))) lst

fun longest_string1 lst = 
	foldl (fn (s, acc) => 
					if String.size(s) > String.size(acc) then s else acc) "" lst

fun longest_string2 lst = 
	foldl (fn (s, acc) => 
					if String.size(s) >= String.size(acc) then s else acc) "" lst

fun longest_string_helper f lst = 
	foldl (fn (s, acc) => 
					if f(String.size(s),String.size(acc)) then s else acc) "" lst

val longest_string3 = longest_string_helper (fn (x,y) => x > y)
val longest_string4 = longest_string_helper (fn (x,y) => x >= y)

val longest_capitalized = longest_string1 o only_capitals

val rev_string = String.implode o rev o String.explode 

fun first_answer f lst = 
	case lst of
		[] => raise NoAnswer
		| x::xs => case f(x) of
								SOME v => v
								| _ => first_answer f xs

fun all_answers f lst = 
	let fun aux (lst, acc) = 
				case lst of
					[] => SOME acc
					| x::xs => case f(x) of
											SOME v => aux(xs, acc@v)
											| _ => NONE
	in aux(lst, []) end

val count_wildcards = g (fn _ => 1) (fn x => 0)

val count_wild_and_variable_lengths = g (fn _ => 1) (fn s => String.size(s))

fun count_some_var (s,p) = 
	g (fn _ => 0) (fn x => if x=s then 1 else 0) p

fun check_pat p =
	let fun get_var p = 
				case p of
					Variable x => [x]
					| TupleP ps => foldl (fn (p,i) => (get_var p)@i) [] ps
					| ConstructorP (_,p) => get_var p
					| _ => []
			fun has_dup lst = 
				case lst of 
					[] => false
					| x::xs => if List.exists (fn s => x=s) xs then true
										else has_dup xs
	in not (has_dup(get_var p)) end

fun match (v, p) = 
	case p of
		Wildcard => SOME []
		| Variable x => SOME [(x,v)]
		| UnitP => (case v of
									Unit => SOME []
									| _ => NONE)
		| ConstP x => (case v of
										Const c => if c=x then SOME [] else NONE
										| _ => NONE)
		| TupleP ps => ((case v of 
											Tuple vs => all_answers match (ListPair.zipEq(vs,ps))
											| _ => NONE) handle UnequalLengths => NONE)
		| ConstructorP (s1, p') => (case v of
																	Constructor(s2, v') => if s1=s2 then match(v',p') else NONE
																	| _ => NONE)

fun first_match v ps = 
	(SOME (first_answer (fn p => match(v, p)) ps)) 
	handle NoAnswer => NONE


