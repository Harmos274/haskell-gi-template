{-# LANGUAGE TemplateHaskell, QuasiQuotes #-}
module Main where

import GtkQuoter (gtk)
import Evaluator (eval)

import qualified GI.Gtk as Gtk (init, main)

main :: IO ()
main = Gtk.init Nothing >> gtkWindow >> Gtk.main

gtkWindow = eval [gtk| My window

                       <t: greetings :>
                       <b: button :> <?: checkbox :>
                 |]

