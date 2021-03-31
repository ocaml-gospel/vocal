(**************************************************************************)
(*                                                                        *)
(*  VOCaL -- A Verified OCaml Library                                     *)
(*                                                                        *)
(*  Copyright (c) 2020 The VOCaL Project                                  *)
(*                                                                        *)
(*  This software is free software, distributed under the MIT license     *)
(*  (as described in file LICENSE enclosed).                              *)
(**************************************************************************)

type 'a t
(** The type of queues containing elements of type 'a. *)
(*@ mutable model view: 'a seq *)

exception Empty
(** Raised when {!Queue.take} or {!Queue.peek} is applied to an empty queue. *)

val create : unit -> 'a t
(** Return a new queue, initially empty. *)
(*@ q = create ()
      ensures q.view = Seq.empty *)

val add : 'a -> 'a t -> unit
(** [add x q] adds the element [x] at the end of the queue [q]. *)
(*@ add x q
      requires Seq.length q.view < max_int
      modifies q.view
      ensures  q.view = Seq.snoc (old q.view) x *)

val push : 'a -> 'a t -> unit
(** [push] is a synonym for [add]. *)
(*@ push x q
      requires Seq.length q.view < max_int
      modifies q
      ensures  q.view = Seq.snoc (old q.view) x *)

val take : 'a t -> 'a
(** [take q] removes and returns the first element in queue [q],
    or raises {!Empty} if the queue is empty. *)
(*@ r = take q
      modifies q
      ensures  old q.view = Seq.cons r q.view
      raises   Empty -> (old q.view) = Seq.empty *)

val take_opt: 'a t -> 'a option
(** [take_opt q] removes and returns the first element in queue [q],
    or returns [None] if the queue is empty. *)
(*@ r = take_opt q
      modifies q
      ensures  old q.view = Seq.empty -> r = None && q.view = old q.view
      ensures  not (old q.view = Seq.empty) ->
               r = Some (old q.view[0])
               && old q.view = Seq.cons (old q.view[0]) q.view *)

val pop : 'a t -> 'a
(** [pop] is a synonym for [take]. *)
(*@ r = pop q
      ensures  old q.view = Seq.cons r q.view
      raises   Empty -> (old q.view) = Seq.empty *)

val peek : 'a t -> 'a
(** [peek q] returns the first element in queue q, without removing
    it from the queue, or raises {!Empty} if the queue is empty. *)
(*@ r = peek q
      ensures  r = q.view[0]
      raises   Empty -> q.view = Seq.empty *)

val peek_opt : 'a t -> 'a option
(** [peek_opt q] returns the first element in queue q, without removing
    it from the queue, or returns [None] if the queue is empty. *)
(*@ r = peek_opt q
      ensures  q.view = Seq.empty -> r = None
      ensures  not (q.view = Seq.empty) -> r = Some (q.view[0]) *)

val top : 'a t -> 'a
(** [top] is a synonym for [peek]. *)
(*@ r = top q
      ensures  r = q.view[0]
      raises   Empty -> q.view = Seq.empty *)

val clear : 'a t -> unit
(** Discard all elements from a queue. *)
(*@ clear q
      modifies q
      ensures q.view = Seq.empty *)

val copy : 'a t -> 'a t
(** Return a copy of the given queue. *)
(*@ q2 = copy q1
       ensures q2.view = q1.view *)

val is_empty : 'a t -> bool
(** Return [true] if the given queue is empty, [false] otherwise. *)
(*@ b = is_empty q
      ensures b <-> q.view = Seq.empty *)

val length : 'a t -> int
(** Return the number of elements in a queue. *)
(*@ n = length a
      ensures n = Seq.length a.view *)

val fold : ('b -> 'a -> 'b) -> 'b -> 'a t -> 'b
(** [fold f accu q] is equivalent to [List.fold_left f accu l], where
    l is the list of q's elements. The queue remains unchanged. *)
(* r = fold f acc q
      ensures r = Seq.fold_left f q.view acc *)

val iter : ('a -> unit) -> 'a t -> unit
(** [iter f q] applies f in turn to all elements of q, from the least recently
    entered to the most recently entered. The queue itself is unchanged.
    This function is not verified. *)

val transfer : 'a t -> 'a t -> unit
(** [transfer q1 q2] adds all of [q1]'s elements at the end of
    the queue [q2], then clears [q1]. *)
(*@ transfer q1 q2
      requires Seq.length q1.view + Seq.length q2.view <= max_int
      modifies q1.view, q2.view
      ensures  q1.view = Seq.empty
      ensures  q2.view = old q2.view ++ old q1.view *)
