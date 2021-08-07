{-# LANGUAGE OverloadedStrings, OverloadedLabels, TemplateHaskell, QuasiQuotes #-}
module Lib
    ( createWindow,
      createQQWindow,
    ) where


import qualified GI.Gtk as Gtk
import Data.GI.Base
import GtkQuoter (gtk)
import Lexer (lexe)
import Parser (parse, Window)

createWindow :: IO ()
createWindow = do
  win <- new Gtk.Window [ #title := "Hi there" ]
  on win #destroy Gtk.mainQuit

  base_box <- new Gtk.Box         [ #orientation := Gtk.OrientationVertical ]
  button   <- new Gtk.Button      [ #label := "Click me" ]
  checkbox <- new Gtk.CheckButton [ #label := "check bro" ]
  lbutton  <- new Gtk.Button      [ #label := "Left" ]
  text     <- new Gtk.Label       [ #label := "toto" ]
  -- rbutton <- new Gtk.Button [ #label := "RRRRRRRR" ]

  v_box <- new Gtk.Box [#orientation := Gtk.OrientationHorizontal]
  #add v_box lbutton
  #add v_box text
  -- #add v_box rbutton

  #add base_box button
  #add base_box checkbox
  #add base_box v_box

  #add win base_box

  #showAll win
  return ()

createQQWindow :: IO ()
createQQWindow = print [gtk| My window

                             <t: greetings :>
                             <b: button :> <?: checkbox :>
                       |]
