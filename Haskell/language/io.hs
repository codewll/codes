{-
    content:
    1. compile a source file
    2. mian & IO actions
    3.
-}

-- compile a source file
--------------------------------------------------------
{-
    在终端下输入 ghc --make filename
    就能进行编译了m之后会生成可执行文件, 输入 ./filename 就能执行了
-}





-- mian & IO actions
--------------------------------------------------------
{-
    haskell 将 pure 的代码和具有 side effect 的代码分隔开了,
    所有具有side effect的代码必须写到 main 的后面，它是一个类似
    于命令式的编程环境。

    !!!而且每个文件中main只能出现一次!!!
-}
-- main = putStrLn "hello world"
-- or:
main = do
    putStrLn "hello, what is your name?"
    name <- getLine
    putStrLn ("hey " ++ name)

{-
    aa <- getLine
    the operator <- is a syntex suger, which take the
    value out of the box "IO xxx", and set aa with
    the fitched value obviously the value should have the type xxx.

    <- can mutate a variable, so it is impure.
-}

{-
    I/O actions will only be performed when they are given a
    name of main or when they're inside a bigger I/O action
    that we composed with a do block. We can also use a do block
    to glue together a few I/O actions and then use that I/O
    action in another do block and so on. Either way, they'll
    be performed only if they eventually fall into main.
-}


// to "Remember let bindings"
