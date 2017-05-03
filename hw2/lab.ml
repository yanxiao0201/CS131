let rec empty1 = []
(*puts key, vaule pair in list on the left hand side*)
let rec put1 k v l = 
        (k,v):: l


let rec get1 k l = 
        match l with
        | [] -> None
        | (a,b) :: t -> if a=k then
                                Some b
                                else 
                                  get1 k t

type ('a,'b) dict3 = ('a -> 'b option)

let empty3 = (function x -> None)

let put3 k v l = 
        function x -> 
           if x=k then
              Some v
           else
               (l x)

let get3 k l = l k 

let max_int int_list = 
        List.fold_left (fun acc x -> 
                if acc > x
                   x
                else
                   acc
        ) 0 int_list

let is_sorted_list l = 
     snd ( List.fold_left (fun (acc ,flag) x ->
                if flag then
                        if x > acc then
                                (x, true)
                        else
                                (x, false)
                else
                   (x, flag)
                 ) (0, true) l)   

 
let merged_list a b =
       List.map (fun x,y =-> if x > y x else y ) (zip a b)

let rec range from till step = 
   if from <= till then
       from :: (range (from+step) till step)
       else [];;

let slice list from till =  
        let l1 = (List.map (fun idx x 
        List.filter
        (fun (idx,x) -> idx >= form then


let map f list = ?
      List.fold_right (fun x acc -> 
                     (f x):: acc)
                   list []

let rec is_binary_st tree = 
        match tree with
          Leaf -> []
        | Node (v,l,r) -> 
                        (is_binary_st l)[v]@( is_binary_st r)
 


