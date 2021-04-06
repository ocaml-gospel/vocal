type 'a t = {
  mutable len: int;
  mutable first: 'a SinglyLL.cell;
  mutable last: 'a SinglyLL.cell;
  }

exception Empty

let create : type a. unit ->  (a t) =
  fun _ -> { len = 0; first = SinglyLL.Nil ; last = SinglyLL.Nil  }

let clear : type a. (a t) ->  unit =
  fun q -> q.first <- SinglyLL.Nil ; q.last <- SinglyLL.Nil ; q.len <- 0

let is_empty : type a. (a t) ->  (bool) =
  fun q -> ((q.first) == (SinglyLL.Nil ))

let length : type a. (a t) ->  (int) = fun q -> q.len

let add : type a. a -> (a t) ->  unit =
  fun x q -> let c = (SinglyLL.Cons { content = x; next = (SinglyLL.Nil ) }) in
             if ((q.last) == (SinglyLL.Nil ))
             then begin q.first <- c; q.last <- c; q.len <- 1 end
             else
               begin
                 (SinglyLL.set_next (q.last) c);
                 q.last <- c;
                 q.len <- q.len + 1
               end

let push : type xi. xi -> (xi t) ->  unit = fun x q -> add x q

let take_opt : type a. (a t) ->  (a option) =
  fun q -> if ((q.first) == (SinglyLL.Nil ))
           then None 
           else
             begin
               let next = (SinglyLL.get_next (q.first)) in
               let content = (SinglyLL.get_content (q.first)) in
               if (next == (SinglyLL.Nil ))
               then begin clear q; Some content end
               else
                 begin q.len <- q.len - 1; q.first <- next; Some content end end

let take : type a. (a t) ->  a =
  fun q -> if ((q.first) == (SinglyLL.Nil ))
           then raise Empty
           else
             begin
               let next = (SinglyLL.get_next (q.first)) in
               let content = (SinglyLL.get_content (q.first)) in
               if (next == (SinglyLL.Nil ))
               then begin clear q; content end
               else begin q.len <- q.len - 1; q.first <- next; content end end

let pop : type xi1. (xi1 t) ->  xi1 = fun q -> take q

let peek : type a. (a t) ->  a =
  fun q -> if ((q.first) == (SinglyLL.Nil ))
           then raise Empty
           else (SinglyLL.get_content (q.first))

let peek_opt : type a. (a t) ->  (a option) =
  fun q -> if ((q.first) == (SinglyLL.Nil ))
           then None 
           else Some (SinglyLL.get_content (q.first))

let top : type xi2. (xi2 t) ->  xi2 = fun q -> peek q

let copy : type a. (a t) ->  (a t) =
  fun q -> let q_res = ref (create ()) in
           let cell = ref q.first in
           while not (!cell == (SinglyLL.Nil )) do
             let contents = (SinglyLL.get_content !cell) in
             push contents !q_res; cell := (SinglyLL.get_next !cell)
           done;
           !q_res

let transfer : type a. (a t) -> (a t) ->  unit =
  fun q1 q2 -> if not (is_empty q1)
               then begin
                 if is_empty q2
                 then
                   begin
                     (let result = q1.len in
                      begin q2.len <- result; q1.len <- 0 end);
                     begin q2.first <- q1.first; q2.last <- q1.last end;
                     begin q1.first <- SinglyLL.Nil ;
                     q1.last <- SinglyLL.Nil  end
                   end
                 else
                   begin
                     let len = q2.len + q1.len in
                     begin q2.len <- len; q1.len <- 0 end;
                     (SinglyLL.set_next (q2.last) (q1.first));
                     q2.last <- q1.last;
                     begin q1.first <- SinglyLL.Nil ;
                     q1.last <- SinglyLL.Nil  end end end

let fold : type a b. (b -> (a -> b)) -> b -> (a t) ->  b =
  fun f start q -> let rec aux (f1: b -> a -> b) (acc: b)
                               (cell: a SinglyLL.cell) : b =
                     if (cell == (SinglyLL.Nil ))
                     then acc
                     else
                       begin
                         let x = (SinglyLL.get_content cell) in
                         let next = (SinglyLL.get_next cell) in
                         aux f1 (f1 acc x) next end in
                   aux f start q.first

let iter : type a. (a -> unit) -> (a t) ->  unit =
  fun f q -> fold (fun (_: unit) (x: a) -> f x) () q

