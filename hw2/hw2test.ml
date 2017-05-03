
type nonterminal = 
        |Yufa
        |Shuzi
        |Yunsuan
        |Zimu
        |Yuqi

let mandarin_grammar =
       (Yufa,
       function
          |Shuzi -> [[T"1"];[T"2"];[T"3"];[T"4"];[T"5"]]
          |Yunsuan -> [[T"+"];[T"-"];[T"*"];[T"/"]]
          |Zimu -> [[T"A"];[T"B"];[T"C"];[T"D"]]
          |Yuqi -> [[T"!"]]
          |Yufa -> [[N Shuzi; N Yunsuan; N
          Shuzi];[N Zimu; N Yuqi]])

let rec accept_number5 derivation = function
        |[] -> None
        |head::tail -> if head = "5" then Some (derivation)
        else accept_number5 derivation tail
let accept_null derivation = function
		|_ -> None

let test_1 = (parse_prefix mandarin_grammar accept_number5
["3";"+";"5";"+";"5"]= Some [(Yufa, [N Shuzi; N Yunsuan; N Shuzi]); (Shuzi, [T "3"]);
    (Yunsuan, [T "+"]); (Shuzi, [T "5"])]) 
 
let test_2 = (parse_prefix mandarin_grammar accept_null ["3";"+";"5"] = None)
