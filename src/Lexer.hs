module Lexer
  ( lexe,
    Token (..),
  ) where

data Token = Word String
           | ButtonConstructor
           | CheckBoxConstructor
           | TextConstructor
           | ConstructorEnd deriving (Eq)

type Lines = [String]
type Words = [String]


lexe :: String -> [[Token]]
lexe = map (luthor . words) . lines

luthor :: Words -> [Token]
luthor []           = []
luthor ("<t:" : xs) = TextConstructor     : luthor xs
luthor ("<b:" : xs) = ButtonConstructor   : luthor xs
luthor ("<?:" : xs) = CheckBoxConstructor : luthor xs
luthor (":>"  : xs) = ConstructorEnd      : luthor xs
luthor (l     : xs) = Word l              : luthor xs

