defmodule Algae.Reader do
  # newtype Reader e a = Reader { runReader :: (e -> a) }
  # data R e a = R (e -> a)

  # instance Functor (R e) where
  # fmap f (R x) = R $ \e -> (f . x) e
end
