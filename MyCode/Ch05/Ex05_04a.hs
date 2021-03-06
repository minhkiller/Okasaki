{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses #-}

module Ex05_04a (module Heap, SplayHeap, toList, printHeap) where

import Heap


data SplayHeap a = E |
                   T (SplayHeap a) a (SplayHeap a)
                 deriving (Eq, Show)


bigger pivot E = E
bigger pivot (T a x b) =
  if x <= pivot then bigger pivot b
  else T (bigger pivot a) x b

smaller pivot E = E
smaller pivot (T a x b) =
  if x > pivot then smaller pivot a
  else T a x (smaller pivot b)


instance Ord a => Heap SplayHeap a where
  empty = E
  
  isEmpty E = True
  isEmpty _ = False
  
  insert x t = T a x b
    where (a, b) = (smaller x t, bigger x t)
  
  merge E t = t
  merge (T a x b) t = T (merge ta a) x (merge tb b)
    where (ta, tb) = (smaller x t, bigger x t)
  
  findMin E = error "SplayHeap.findMin: empty heap"
  findMin (T E x b) = x
  findMin (T a x b) = findMin a
  
  deleteMin E = error "SplayHeap.deleteMin: empty heap"
  deleteMin (T E x b) = b
  deleteMin (T (T E x b) y c) = T b y c
  deleteMin (T (T a x b) y c) = T (deleteMin a) x (T b y c)


-- Helpers
toList :: SplayHeap a -> [a]
toList E = []
toList (T a x b) = toList a ++ x : toList b

printHeap :: Ord a => (a -> String) -> SplayHeap a -> IO ()
printHeap showF = printHeap' 0
  where printHeap' _ E = return ()
        printHeap' n (T a x b) = do printHeap' (n + 1) b
                                    putStrLn $ (replicate (1*n) ' ') ++ showF x
                                    printHeap' (n + 1) a
