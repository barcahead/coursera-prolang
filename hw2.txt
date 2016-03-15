(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* put your solutions for problem 1 here *)
fun all_except_option (s, lst) = 
  case lst of 
    [] => NONE
    | x::xs => case all_except_option(s, xs) of
      NONE => if same_string(x, s) then SOME (xs) else NONE
      | SOME xs' => SOME (x::xs')

fun get_substitutions1 (subs, s) =
  case subs of
    [] => []
    | x::xs => let val r = get_substitutions1(xs, s)
      in case all_except_option(s, x) of
      NONE => r
      | SOME xs' => xs' @ r end

fun get_substitutions2 (subs, s) =
  let fun aux (subs, s, acc) =
        case subs of
          [] => acc
          | x::xs => case all_except_option(s, x) of
                      NONE => aux(xs, s, acc) 
                      | SOME xs' => aux(xs, s, acc@xs') 
  in aux(subs, s, []) end

fun similar_names (subs, name) = 
  let val {first=xn, middle=yn, last=zn} = name
      fun aux (lst, acc) =
        case lst of
        [] => name::acc
        | x::xs => aux(xs, {first=x, middle=yn, last=zn}::acc)
  in aux(get_substitutions2(subs, xn), []) end 

  
(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(* put your solutions for problem 2 here *)
fun card_color (c) = 
  case c of 
    (Clubs, _) => Black
    | (Spades, _) => Black
    | _ => Red

fun card_value (v) =
  case v of
    (_, Num x) => x
    | (_, Ace) => 11
    | _ => 10

fun remove_card (cs, c, e) = 
  let fun aux (xs, acc, n) =
        case xs of
          [] => if n = 0 then raise e else acc
          | x::xs' => if x = c andalso n < 1 then aux(xs', acc, n+1) 
                      else aux(xs', x::acc, n)
  in aux(cs, [], 0) end

fun all_same_color cs = 
  case cs of
    [] => true
    | x::xs => case xs of
                [] => true
                | y::_ => card_color(x) = card_color(y) 
                          andalso all_same_color(xs)
    
fun sum_cards cs = 
  let fun aux (cs, acc) =
        case cs of
          [] => acc
          | x::xs => aux(xs, acc+card_value(x)) 
  in aux(cs, 0) end

fun score (cs, g) = 
  let val sum = sum_cards cs
      val d = if all_same_color cs then 2 else 1
  in if sum > g then 3*(sum-g) div d else (g-sum) div d end

fun officiate (cl, ml, g) =
  let fun aux (cl, ml, hl) = 
        case ml of
          [] => score(hl, g)
          | x::xs => 
              case x of
                Discard c => aux(cl, xs, remove_card(hl, c, IllegalMove))
                | _ => case cl of
                        [] => aux(cl, [], hl)
                        | x'::xs' => if sum_cards(hl) + card_value(x') > g then aux(xs', [], x'::hl) 
                                     else aux(xs', xs, x'::hl)
  in aux(cl, ml, []) end