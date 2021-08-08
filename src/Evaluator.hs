{-# LANGUAGE OverloadedStrings, OverloadedLabels #-}

module Evaluator
  (eval
  ) where

import Parser (Window (..), Layout (..), Label (..), Widget (..))

import qualified GI.Gtk as Gtk
import Data.GI.Base
import Data.Text (pack)


eval :: Window -> IO ()
eval (Window (Label label) lyt) = do
  win <- new Gtk.Window [ #title := pack label ]
  on win #destroy Gtk.mainQuit

  base_box <- new Gtk.Box [ #orientation := Gtk.OrientationVertical ]

  populateWindow base_box lyt
  
  #add win base_box

  #showAll win
  return ()


populateWindow :: Gtk.Box -> Maybe Layout -> IO ()
populateWindow box Nothing                 = return ()
populateWindow box (Just (Vertical verts)) = mapM_ (populateWindowLine box) verts
populateWindow _   _                       = error "Top level layout is supposed to be vertical."


populateWindowLine :: Gtk.Box -> Layout -> IO ()
populateWindowLine box (Horizontal horz) = do
  h_box <- new Gtk.Box [ #orientation := Gtk.OrientationHorizontal ]

  mapM_ (populateWindowRow h_box) horz

  #add box h_box
  return ()
populateWindowLine _   _                 = error "Rows needs an Horizontal layout."


populateWindowRow :: Gtk.Box -> Layout -> IO ()
populateWindowRow box (Unit (Button (Label label))) = do
  button <- new Gtk.Button [ #label := pack label ]

  #add box button
  return ()
populateWindowRow box (Unit (CheckBox (Label label))) = do
  checkbox <- new Gtk.CheckButton [ #label := pack label ]

  #add box checkbox
  return ()
populateWindowRow box (Unit (Text (Label label))) = do
  label <- new Gtk.Label [ #label := pack label ]

  #add box label
  return ()
populateWindowRow _ _ = error "Rows can only be populated by widgets."
