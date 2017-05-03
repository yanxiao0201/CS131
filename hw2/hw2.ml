let rec generate_lists list keyword = 
      match list with
      |[] -> []
      |(key, r):: t -> if key = keyword then 
                            r::generate_lists t keyword 
                       else    
                            generate_lists t keyword;;

let return_fun gram1 =
        match gram1 with
        |(word,list) -> generate_lists list;;

let covert_grammar gram1 =
        match gram1 with
        |(word,_)->(word,return_fun gram1);;

type ('nonterminal, 'terminal) symbol = 
        |N of 'nonterminal
        |T of 'terminal

let rec match_one_rule rule rule_fun accept derivation frag =
        match rule with
        |[] -> accept derivation frag
        |(T b)::tail ->( match frag with
                        |[] -> None
                        |first::rest -> if first = b
                                        then match_one_rule tail rule_fun accept derivation rest
                                        else None)

        |(N c)::left -> match_nonterminal (rule_fun c) rule_fun c
        (match_one_rule left rule_fun accept) derivation frag


and match_nonterminal rules rule_fun c accept derivation frag =
        match rules with
        |[] -> None
        |head::tail -> let result =  match_one_rule head rule_fun accept
        (derivation@[(c,head)]) frag
                       in
                       match result with
                       |None -> match_nonterminal tail rule_fun c accept derivation
                       frag   
                       |ok -> ok

                    
                                        
let parse_prefix gram accept frag =
        match gram with
        |(keyword, rule_fun) -> match_nonterminal (rule_fun keyword) rule_fun keyword
        accept [] frag



                             


