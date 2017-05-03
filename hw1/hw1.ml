let rec within a b = match b with
  |[] -> false
  |h::t -> if a = h then true else within a t;;

  (* #1 *)
let rec subset c d = match c with
  |[] -> true
  |h::t -> if (within h d) then (subset t d) else false;;
(* #2 *)
let equal_sets a b = if (subset a b) then (subset b a) else false ;;

(* #3 *)
let rec set_union a b = match a with
  |[] -> b
  |h::t -> if within h b then set_union t b else set_union t (h::b);;

  (* #4 *)
let rec set_intersection a b = match a with
  |[] -> []
  |h::t -> if within h b then (h::(set_intersection t b)) else set_intersection
  t b;;

  (* #5 *)
let rec set_diff a b = match a with
  |[] -> []
  |h::t -> if (within h b) then (set_diff t b) else (h::(set_diff t b));;

 (* #6 *)
let rec computed_fixed_point eq f x =  
        if (eq (f x) x) 
        then x 
        else computed_fixed_point eq f (f x);;

 (* #7 *)
let rec cal_point f p x =
        match p with
        |1 -> f x
        |_ -> cal_point f (p-1) (f x);; 


let rec computed_periodic_point eq f p x =
        match p with
        |0 -> x 
        |_ -> if eq (cal_point f p x) x
              then x
              else computed_periodic_point eq f p (f x);;



(* #8 *)
let rec while_away s p x =
        let test = p x in match test with 
        | false -> []
        | true -> x :: while_away s p (s x) ;; 

(* #9 *)

let rec decode (n,m) = 
        match n with
        |0 -> []
        |_ -> m::decode ((n-1),m);;

let rec rle_decode lp = 
        match lp with
        |[] -> []
        |(n,m)::t -> (decode (n,m))@rle_decode t;;

(* #10 *)
type ('nonterminal, 'terminal) symbol =
        |N of 'nonterminal
        |T of 'terminal;;

let good_sym  symbol termsym =  
        match symbol with
        |T c -> true
        |N c -> within c termsym;;

let rec good_rule rule termsym =
        match rule with
        |[] -> true
        |h::t -> if good_sym h termsym then
                good_rule t termsym
        else false;;

(*select the term syms *)
let rec select_termsym rules termsym = 
        match rules with
        |[] -> termsym
        |(sym, rule)::t -> if good_rule rule termsym then
                match within sym termsym with
                |true -> select_termsym t termsym
                |false -> select_termsym t (sym::termsym)
        else select_termsym t termsym;;

let rec select_rules rules termsym =
       match rules with
       |[] -> []
       |(sym,rule)::t -> if good_rule rule termsym then
               [(sym,rule)]@select_rules t termsym
       else select_rules t termsym;;


let final_termsym rules termsym = 
        let newfun = (select_termsym rules) 
        in computed_fixed_point (=) newfun termsym;;

let filter_blind_alleys g =
        match g with 
        |s,[] -> s,[]
        |s,t -> let termsym = final_termsym t []
        in s,select_rules t termsym;;
























                



