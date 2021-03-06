(*
	Include:
	1. variable binding & function binding
	2. pair, tuple, list
	3. option type
	4. record
	5. datatype definition & polymorphic datatype
	6. pattern match
	7. type synonyms
	8. anonymous function
*)

(*---------------------------------------------------*)
(*	
	Attention:
	-在命令行中输入 use "filename.sml"; 来加载代码文件
	
	-sml 不允许赋值操作,所有数据都是immutable的
	 但可以重复定义同命变量或函数,后定义的会将之前定义的shadow掉
	 但之前定义的依然还在，不会受影响
	
	-sml中负号用~而不是－来表示
	 如：－123应写成：~123
*)


(*variable binding*)
val x = 34		(* x:int *)

val y = 17

val re = 1.234	(* re:real *)

val z = x + y + 1

val str1 = "hahaha"

val str2 = "hahaha" ^ "hihihi"	(* sml 中的字符串链接用^ *)

val li1 = [1,2,3,4]

val li2 = [1,2,3] @ [4,5,6] (*@ is append in sml*)

(* if-else 也是表达式级别的*)
val abs_of_z = if z > 0 then z else 0-z

val simpl_abs_z = abs(z)


(*function binding*)
fun pow(x:int, y:int) = 	(* int*int -> int *)
	if y = 0
	then 1
	else x*pow(x,y-1)

fun cube(x:int) = 			(* int -> int *)
	pow(x,3)


(*前面定义的会被hidden掉(也叫shadow掉)*)
fun cube(x:int) = 
	x * x * x


(* pair *)
val pa = (1,2)				(* int*int *)
val pb = (3,true)			(* int*bool *)

val pa1 = #1 pa
val pa2 = #2 pa


(* tuple *)
val tpa = (1,2,true,3.4)	(* int*int*bool*real *)
val tp1 = #1 tpa
val tp2 = #2 tpa
val tp3 = #3 tpa
val tp4 = #4 tpa


(* list *)
val la = []					(* 'a list *)
val lb = [1,2,3]			(* int list *)
val lc = [true,false,true]	(* bool list *)
val ld = 2::[1,2,3]

val flag = null la  (*flag = true*)
val flag2 = null lb (*flag2 = false*)

val hlb = hd lb		(* hlb = 1 *)
val tlb = tl lb		(* tlb = [2,3] *)




(* binding in local: let expression *)
(*--------------------------------------------------*)
(*
	syntex:
	let b1 b2 b3 ... in exp end

	-let是表达式级别，可以多重嵌套
*)

val aa = let 
			val x = 1
		 in
		 	(let val x = 2 in x+1 end) + 
		 	(let val y = x + 2 in y + 1 end)
		 end



fun countup_from1 (x:int) = 
	let fun count (from:int, to:int) =
			if from = to
			then to::[]
			else from::count(from+1,to)
	in
		count(1,x)
	end



(* option type *)
(* similar in Coq *)
(*
	NONE		: a' option
	SOME 12		: int option
	SOME true	: bool option

	valOf (SOME 5)	返回5
	valOf NONE 		导致异常

	isSome NONE	: false
	isSome SOME 5 : true
*)
fun max_of_list (l:int list) =
	if l = []
	then NONE
	else let val h = hd l val t = tl l val ret = max_of_list t
		 in 
			if isSome ret
		 	then if h > valOf ret then SOME h
		 		 else ret
		 	else SOME h
		 end


(* bool expression *)
val b1 = true andalso false
val b2 = true orelse false
val b3 = not true

val b4 = (x = 55)
val b5 = 23<54 andalso 43>54
val b6 = 12<>13



(* record *)
(*---------------------------------------------------*)
val red1 = {name = "wll", age = 22, height = 170, likeCat = true}

(*tuple is a special record*)
(* acturally it is the syntex suger of the special record *)
val red2 = {1 = "wll", 2 = 22, 3 = 170, 4 = true} 	(*by name*)

val red3 = ("wll", 22, 170, true)					(*by position*)
(*red2 will become red3 when run in the repl*)












(* datatype binding *)
(*---------------------------------------------------*)
(*自定义数据类型*)
(* similar in Coq *)
datatype mytype = 
	  Pizza 
	| Str of string
	| TwoInt of int * int

datatype days = 
	  Monday
	| Tuesday
	| Wensday
	| Thusday
	| Friday
	| Saterday
	| Sunday

datatype mylist = 
	  Nil
	| Cons of int * mylist


(* polymorphic datatype *)
datatype 'a polylist = 
	  PolyNil
	| PolyCons of 'a * 'a polylist


datatype 'a myoption = 
	  MyNone
	| MySome of 'a

(*多态二叉树*)
datatype ('a, 'b) tree =
	  NilTree
	| Leaf of 'b
	| Node of 'a * ('a, 'b) tree * ('a, 'b) tree











(* pattern match *)
(*---------------------------------------------------*)
fun pm x = 
	case x of
	  Pizza => 3
	| TwoInt (x1,x2) => x1 + x2
	| Str s => String.size s


exception BadLengthUnEqual

fun myzip (l1, l2) = 
	case (l1,l2) of
	  ([],[]) => []
	| (x::xl,y::yl) => (x,y)::myzip (xl,yl)
	| (_,_) => raise BadLengthUnEqual

(* example of expression *)

datatype exp = 
	  Constant of int
	| Add of exp * exp 
	| Mul of exp * exp
	| Neg of exp

val tta = Add (Constant 5, Mul (Constant 2, Neg (Constant 4)))

fun eval e = 	(* exp的解释器 *)
	case e of
	  Constant x => x
	| Neg x => ~ (eval x)
	| Mul (x,y) => (eval x) * (eval y)
	| Add (x,y) => (eval x) + (eval y)


val ans1 = eval tta (* retuen ~3 *)


(* other kinds of pattern match *)

(* variable definition *)
val (ax,ay) = (123,true)
val thd::ttl = [1,2,3,4,5]



(* function parameter *)
(*
	in sml every function actually has only one parameter,
	the way we written like "(a,b,c)", does not mean three 
	parameter but a pattern match for a tuple, so it is actually
	just one parameter. 
*)

fun addthree (a,b,c) = 
	a + b + c

val ans2 = addthree (1,2,3) (*get 6*)

val test = (1,2,3)

val ans3 = addthree test	(* 这说明了addthree实际只有一个tuple类型的参数 *)



(* haskell style pattern match *)

fun   eval2 (Constant x) 	= x
	| eval2 (Neg x) 		= ~ (eval2 x)
	| eval2 (Mul (x,y)) 	= (eval2 x) * (eval2 y)
	| eval2 (Add (x,y)) 	= (eval2 x) + (eval2 y)












(* type synonyms *)
(* 为类型起别名 *)
(*---------------------------------------------------*)

type foo = int * int

(* foo will be the same as int * int *)

(* 在某些情况下才有用: eg: *)
type stu_type = 
	{
	name:string,
	id:int,
	sex:string,
	height:int
	}







(* anonymous function *)
(*--------------------------------------------------*)

fun n_times (f,n,x) = 
	if n = 0
	then x
	else f (n_times(f,n-1,x))


fun triple_n_times(n,x) = n_times((fn x => 3 * x), n, x)

















