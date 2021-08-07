{-# LANGUAGE TemplateHaskell #-}
module GtkQuoter
  ( gtk
  ) where

import Lexer (lexe)
import Parser (parse)

import Language.Haskell.TH.Quote (QuasiQuoter (..), quoteExp)
import Language.Haskell.TH

gtk :: QuasiQuoter
gtk = QuasiQuoter {
      quoteExp  = \s -> [| parse $ lexe s |],
      quotePat  = error "GtkQuoter has no quote Pattern",
      quoteType = error "GtkQuoter has no quote Type",
      quoteDec  = error "GtkQuoter has no quote Declaration" 
    }
