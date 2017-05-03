
%signal_morse／2: first arg: List of 0s and 1s, second arg: List of - and '.'
signal_morse([],[]).
signal_morse([0],[]).
signal_morse([0,0],[]).
signal_morse([0,0],['^']).
signal_morse([0,0,0],['^']).
signal_morse([0,0,0,0],['^']).
signal_morse([0,0,0,0,0],['^']).
signal_morse([0,0,0,0,0],['#']).
signal_morse([0,0,0,0,0,0,0],['#']).
signal_morse([1],['.']).
signal_morse([1,1],['.']).
signal_morse([1,1],['-']).
signal_morse([1,1,1],['-']).
signal_morse([0,0,0,0,0,0,0|T],['#'|M]):- prefix([1],T),signal_morse(T,M).
signal_morse([0,0,0,0,0,0|T],['#'|M]):- prefix([1],T),signal_morse(T,M).
signal_morse([0,0,0,0,0|T],['^'|M]):- prefix([1],T),signal_morse(T,M).
signal_morse([0,0,0,0,0|T],['#'|M]):- prefix([1],T),signal_morse(T,M).
signal_morse([0,0,0,0|T],['^'|M]):- prefix([1],T),signal_morse(T,M).
signal_morse([0,0,0|T],['^'|M]):- prefix([1],T),signal_morse(T,M).
signal_morse([0,0|T],M):- prefix([1],T),signal_morse(T,M).
signal_morse([0,0|T],['^'|M]):- prefix([1],T),signal_morse(T,M).
signal_morse([0|T],M):- prefix([1],T),signal_morse(T,M).
signal_morse([1,1,1|T],['-'|M]):- prefix([0],T),signal_morse(T,M).
signal_morse([1,1|T],['.'|M]):- prefix([0],T),signal_morse(T,M).
signal_morse([1,1|T],['-'|M]):- prefix([0],T),signal_morse(T,M).
signal_morse([1|T],['.'|M]):- prefix([0],T),signal_morse(T,M).
signal_morse([1,1,1|[1|T]],M):- signal_morse([1,1,1|T],M).
signal_morse([0,0,0,0,0,0,0|[0|T]],M):- signal_morse([0,0,0,0,0,0,0|T],M).

morse(a, [.,-]).          
morse(b, [-,.,.,.]).	  
morse(c, [-,.,-,.]).	  
morse(d, [-,.,.]).	 
morse(e, [.]).		 
morse('e''', [.,.,-,.,.]). 
morse(f, [.,.,-,.]).	 
morse(g, [-,-,.]).	  
morse(h, [.,.,.,.]).	  
morse(i, [.,.]).	
morse(j, [.,-,-,-]).	  
morse(k, [-,.,-]).	   
morse(l, [.,-,.,.]).	  
morse(m, [-,-]).	  
morse(n, [-,.]).	   
morse(o, [-,-,-]).	   
morse(p, [.,-,-,.]).	 
morse(q, [-,-,.,-]).	 
morse(r, [.,-,.]).	   
morse(s, [.,.,.]).	   
morse(t, [-]).	 	   
morse(u, [.,.,-]).	   
morse(v, [.,.,.,-]).	 
morse(w, [.,-,-]).	  
morse(x, [-,.,.,-]).	   
morse(y, [-,.,-,-]).
morse(z, [-,-,.,.]).	
morse(0, [-,-,-,-,-]).	 
morse(1, [.,-,-,-,-]).	
morse(2, [.,.,-,-,-]).
morse(3, [.,.,.,-,-]).
morse(4, [.,.,.,.,-]).
morse(5, [.,.,.,.,.]).
morse(6, [-,.,.,.,.]).
morse(7, [-,-,.,.,.]).
morse(8, [-,-,-,.,.]).
morse(9, [-,-,-,-,.]).
morse(., [.,-,.,-,.,-]).  
morse(',', [-,-,.,.,-,-]). 
morse(:, [-,-,-,.,.,.]).   
morse(?, [.,.,-,-,.,.]).   
morse('''',[.,-,-,-,-,.]). 
morse(-, [-,.,.,.,.,-]).   
morse(/, [-,.,.,-,.]).    
morse('(', [-,.,-,-,.]).  
morse(')', [-,.,-,-,.,-]). 
morse('"', [.,-,.,.,-,.]).
morse(=, [-,.,.,.,-]).    
morse(+, [.,-,.,-,.]).    
morse(@, [.,-,-,.,-,.]).  

morse(error, [.,.,.,.,.,.,.,.]). 

morse(as, [.,-,.,.,.]).         
morse(ct, [-,.,-,.,-]).         
morse(sk, [.,.,.,-,.,-]).        
morse(sn, [.,.,.,-,.]).         


%morse_char/2: first arg: List of letters based on morse, second arg: List of - and '.'
morse_char([],[]).
morse_char([M], List):- \+ sublist([^],List),morse(M,List).
morse_char(M,List):- \+ sublist(['#'],List),prefix(X,List),append(Y,[^],X),append(X,Z,List),morse(M1,Y),morse_char(M2,Z),append([M1],M2,M).
morse_char(M,List):-prefix(X,List),append(Y,['#'],X),!,append(X,Z,List),morse_char(M1,Y),morse_char(M2,Z),append(M1,['#'],M3),append(M3,M2,M).


%morse_special/2: first arg: List of letters dealt with special case, second arg: List of letters with special case
morse_special([],[]).
morse_special(List, List):- \+ sublist(['error'],List).     
morse_special([error|M], [error|List]):- morse_special(M, List).

morse_special(M, List):- \+prefix([error],List),prefix(X,List),append(Y,[error],X),append(X,Z,List),\+ sublist(['#'],Y),morse_special(M,Z).

morse_special(M, List):- \+prefix([error],List),prefix(X,List),append(Y,[error],X),append(X,Z,List), suffix(['#'],Y),morse_special(M1,Z),append(X,M1,M).

morse_special(M, List):- \+prefix([error],List),prefix(X,List),append(Y,[error],X),append(X,Z,List),!,prefix(A,Y),\+suffix(['#'],Y),prefix(A,Y),suffix(['#'],A),append(A,B,Y), morse_special(M1,Z),append(A,M1,M).

%signal_message/2: first arg: a list of 0s and 1s, second arg: list of letters without special case
signal_message(L,M):- signal_morse(L,A),morse_char(B,A),morse_special(M,B).













