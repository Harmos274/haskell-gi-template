module Main where

import Lib (createWindow, createQQWindow)

import qualified GI.Gtk as Gtk (init, main)

main :: IO ()
main = Gtk.init Nothing >> createWindow >> createQQWindow >> Gtk.main
