Mes notes sur une explication de [Christophe Thibaut](https://twitter.com/tof_).

"L'objectif de ce kata n'est pas de terminer, d'écrire un programme. Le but est
d'illustrer un concept et de répondre à toutes les questions".

Pour éditer, faire `ghci Main.hs`, ça lance le prélude et charge les fonctions. Ensuite, dans le prélude, taper `:e` pour éditer le fichier dans Vim et le recharger quand Vim quitte.

Exemple de problème : `getLine` renvoie une IO String, je ne peux pas l'utiliser avec les fonctions qui travaillent sur les String. Par exemple je ne peux pas faire `getLine ++ "!!"`

`import System.IO.Unsafe` permet de transformer une fonction en une fonction sans IO. Mais c'est unsafe.

    > (unsafePerformIO getLine) ++ "!!!"
    "coucou
    coucou!!!"

    > let uGetInt = (read (unsafePerformIO getLine)) :: Integer

Attention, ça casse le prélude. `unsafeDupablePerformIO` peut résoudre le problème mais on ne peut pas entrer là dedans.

    > :type (++"!!!")
    (++"!!!") :: [Char] -> [Char]

    > (++"!!!") "hello"
    "hello!!!"

    > :type fmap (++"!!!") getline
    fmap (++"!!!") getLine :: IO [Char]

    > fmap (++"!!!") getLine
    Hello Coucou
    "Hello Coucou!!!"

    > let getInt = fmap read getLine :: IO Integer
    > :type getInt
    getInt :: IO Integer

    > getInt
    17
    17

    > fmap (*1000) getInt
    42
    42000

    > :type fmap (*1000) getInt
    fmap (*1000) getInt :: IO Integer

    > let putInt x = (putStrLn (show x))
    :type putInt
    putInt :: Show a => a -> IO ()

    > putInt 42
    42

    > :type (>>=)
    (>>=) :: Monad m => m a -> (a -> m b) -> m b)

    > :type getInt >>= putInt
    getInt >>= putInt :: IO()
    > getInt >>= putInt
    42
    42000

Une monade est une computation, un bout de code qui s'exécute dans un contexte donné.

    > let carre = [x * x]
    > carre 3
    [9]
    > :type carre
    carre :: Num a => a -> [a]

    > :type (>>=)
    (>>=) :: Monad m => m a -> (a -> m b) -> m

    > [1, 2, 3] >>= carre
    [1,4,9]

    > :type return
    return :: Monad m => a -> m

    > return 4 :: Maybe Int
    Just 4

    > return 4 :: [Int]
    [4]

Je peux réimplémenter `carre` pour qu'il fonctionne avec tout type de monade.

    > let carre x = return (x*x)
    > carre 4 :: Maybe Int
    Just 16
    > carre 4 :: [Int]
    [4]

    > :type carre
    carre :: (Monad m, Num a) => a -> m a
    > [1..10] >>= carre
    [1,4,9,16,25,36,49,64,81,100]

    > getInt >>= carre
    42
    1764

Une monade n'a pas nécessairement d'effet de bord. Je peux concevoir et tester mon code avec une monade qui n'a pas d'effet de bord, et ensuite au run brancher une monade qui a des effets de bord.
