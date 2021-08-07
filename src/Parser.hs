module Parser
  ( parse,
    Window (..),
    Layout (..),
    Widget (..),
  ) where

import Data.List (unwords)

import Lexer (Token (..))


data Window = Window Label (Maybe Layout) deriving Show

data Layout = Horizontal [Layout] 
            | Vertical [Layout] 
            | Unit Widget deriving Show

data Widget = Button Label 
            | CheckBox Label 
            | Text Label deriving Show

class Wordable a where
  fromWords :: Words -> a

newtype Words = Words String deriving Show
newtype Label = Label String deriving Show

instance Wordable Label where
  fromWords (Words w) = Label w


parse :: [[Token]] -> Window
parse []     = error "Empty window description model."
parse (l:xs) = Window (parseWindowLabel l) (parseLayout xs)

parseWindowLabel :: [Token] -> Label
parseWindowLabel [] = error "A window needs a label."
parseWindowLabel tk = parseWindowLabel' tk

parseWindowLabel' :: [Token] -> Label
parseWindowLabel' = fromWords . groupWords

parseLayout :: [[Token]] -> Maybe Layout
parseLayout []        = Nothing
parseLayout verticals = Just $ Vertical $ map parseLayoutLines verticals

parseLayoutLines :: [Token] -> Layout
parseLayoutLines = Horizontal . map Unit . getWidgets

getWidgets :: [Token] -> [Widget]
getWidgets []                         = []
getWidgets (ButtonConstructor   : xs) = let (words, xss) = span (/= ConstructorEnd) xs in createButton   words : getWidgets (tail xss)
getWidgets (CheckBoxConstructor : xs) = let (words, xss) = span (/= ConstructorEnd) xs in createCheckBox words : getWidgets (tail xss)
getWidgets (TextConstructor     : xs) = let (words, xss) = span (/= ConstructorEnd) xs in createText     words : getWidgets (tail xss)
getWidgets _                          = error "Invalid syntax."

createButton :: [Token] -> Widget
createButton = Button . fromWords . groupWords

createCheckBox :: [Token] -> Widget
createCheckBox = CheckBox . fromWords . groupWords

createText :: [Token] -> Widget
createText = Text . fromWords . groupWords

groupWords :: [Token] -> Words
groupWords = Words . unwords . map extractWord
  where extractWord :: Token -> String
        extractWord (Word w) = w
        extractWord _        = error "Invalid syntax."

